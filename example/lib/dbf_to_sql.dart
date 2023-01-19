import 'dart:developer';

import 'package:dbf_reader/dbf_reader.dart';
import 'package:translate_to_sqlite/db_connection.dart';

/// Mapper for the dBase table to SQLite3 table
class TableMapper {
  /// The column name
  final String? tableName;

  /// The column map
  final Map<String, String>? columnMapper;

  /// The constuctor
  TableMapper({
    this.tableName,
    this.columnMapper,
  });
}

/// Extension for the [ColumnStructure]
extension CellStructureSQL on ColumnStructure {
  /// Map the dBase column datatypes to SQLite3/MySQL datatypes
  String translateDataTypeSQL() {
    switch (dataType) {
      case "C":
        return "VARCHAR ($length)";
      case "D":
        return "INTEGER";
      case "F":
        return "DECIMAL ($length, $decimalPlaces)";
      case "N":
        return "DECIMAL ($length, $decimalPlaces)";
      case "L":
        return "INTEGER";
      case "M":
        return "VARCHAR ($length)";
      case "@":
        return "DECIMAL ($length, $decimalPlaces)";
      case "l":
        return "DECIMAL ($length, $decimalPlaces)";
      case "+":
        return "DECIMAL ($length, $decimalPlaces)";
      case "O":
        return "DECIMAL ($length, $decimalPlaces)";
      case "G":
        return "VARCHAR ($length)";
      default:
        return "VARCHAR (255)";
    }
  }
}

/// An extension to [DataPacket]
extension DataPacketSQL on DataPacket {
  /// Returns the [DataPacket] value in the correspond datatype
  dynamic getAsSQLValue(String dataType) {
    String v = getString().replaceAll("\"", "").replaceAll("'", "");

    switch (dataType) {
      case "C":
        return v.isEmpty ? "NULL" : "\"$v\"";
      case "D":
        return getDateTime().millisecondsSinceEpoch / 1000;
      case "F":
        return getDouble();
      case "N":
        return getDouble();
      case "L":
        return getInt();
      case "M":
        return v.isEmpty ? "NULL" : "\"$v\"";
      case "@":
        return getDouble();
      case "l":
        return getDouble();
      case "+":
        return getDouble();
      case "O":
        return getDouble();
      case "G":
        return v.isEmpty ? "NULL" : "\"$v\"";
      default:
        return v.isEmpty ? "NULL" : "\"$v\"";
    }
  }
}

/// A transaltor from DBF to SQLite3
class DBFtoSQL extends DBF {
  /// The table mapper
  final TableMapper? _tableMapper;

  /// The constuctor
  DBFtoSQL({required String fileName, TableMapper? tableMapper})
      : _tableMapper = tableMapper,
        super(fileName: fileName);

  /// Returns the table name based on the table mapper or the file name
  String getTableName() {
    String tableName = _tableMapper == null ||
            _tableMapper?.tableName == null ||
            _tableMapper!.tableName!.isEmpty
        ? RegExp(r'[ \w-]+?(?=\.)').stringMatch(fileName)!.toUpperCase()
        : _tableMapper!.tableName!;

    return tableName.trim().toUpperCase().replaceAll(" ", "_");
  }

  /// Creates the SQL and execute it over the [DBConnection]
  /// Returns [this] to chain methods
  DBFtoSQL createTable() {
    String query = "CREATE TABLE IF NOT EXISTS ";
    query += "`${getTableName()}` (`id` INTEGER PRIMARY KEY";

    for (ColumnStructure cell in header.getStructure()) {
      if (_tableMapper == null ||
          _tableMapper?.columnMapper == null ||
          _tableMapper!.columnMapper!.isEmpty) {
        query +=
            ", `${cell.name.toLowerCase()}` ${cell.translateDataTypeSQL()}";
      } else {
        if (_tableMapper!.columnMapper!.keys.contains(cell.name)) {
          query +=
              ", `${_tableMapper!.columnMapper![cell.name]}` ${cell.translateDataTypeSQL()}";
        }
      }
    }

    query += ");";

    DBConnection.instance.execute(query);

    return this;
  }

  /// Creates the SQL and inserts the data asynchronously over the [DBConnection]
  /// the data is stored 50 rows at time
  /// Returns [this] as [Future] to chain methods
  Future<DBFtoSQL> insertInto() async {
    DBConnection.instance.execute("DELETE FROM `${getTableName()}`;");

    String baseQuery = "INSERT INTO `${getTableName()}` (";

    Iterable<ColumnStructure> validColumns =
        (_tableMapper == null || _tableMapper?.columnMapper == null
            ? header.getStructure()
            : header.getStructure().where((ColumnStructure cell) =>
                _tableMapper!.columnMapper!.keys.contains(cell.name)));

    baseQuery += validColumns
        .map((ColumnStructure cs) =>
            (_tableMapper == null || _tableMapper?.columnMapper == null)
                ? "`${cs.name}`"
                : "`${_tableMapper!.columnMapper![cs.name]}`")
        .join(",");

    baseQuery += ") VALUES ";

    Iterable<int> validPositions = validColumns.map((cs) => cs.position);

    String fiftyRows = baseQuery;

    int i = 0;
    await for (Row row in getRowsAsync()) {
      String query = "(";

      List<DataPacket> validColumnsInRow = [];

      for (int vp in validPositions) {
        validColumnsInRow.add(row.cells[vp]);
      }

      query += validColumnsInRow
          .map((DataPacket d) => d.getAsSQLValue(
              validColumns.elementAt(validColumnsInRow.indexOf(d)).dataType))
          .join(",");

      query += ")";
      fiftyRows += query;

      if (i == 50) {
        fiftyRows += ";";
        try {
          DBConnection.instance.execute(fiftyRows);
        } catch (e) {
          log(e.toString());
        }
        fiftyRows = baseQuery;
        i = 0;
      } else {
        fiftyRows += ",";
      }
      i++;
    }

    // Last rows not enought to complete fifty
    if (fiftyRows.length != baseQuery.length) {
      try {
        DBConnection.instance
            .execute("${fiftyRows.substring(0, fiftyRows.length - 1)};");
      } catch (e) {
        log(e.toString());
      }
    }

    return this;
  }
}
