import 'package:translate_to_sqlite/dbf_to_sql.dart';

/// The main function of the program
Future<void> main(List<String> arguments) async {
  // The dBase file name
  String dbNameGroups = './Tcambio.dbf';

  // Mapping the table
  TableMapper groupMapper = TableMapper(
    tableName: "QUOTATION",
    columnMapper: {
      "MO_CODIGO": "code",
      "TC_FECHA": "date",
      "TC_COTIZ": "value",
    },
  );

  /// Creating the object to manage the transaltion
  DBFtoSQL dbfGroups =
      DBFtoSQL(fileName: dbNameGroups, tableMapper: groupMapper);

  final dbfsToTranslate = [
    dbfGroups,
  ];

  // Transalte it and store the data
  for (DBFtoSQL dbf in dbfsToTranslate) {
    DateTime start = DateTime.now();
    print("Creating table ${dbf.getTableName()}");
    dbf.createTable();
    print("Inserting data to ${dbf.getTableName()}");
    await dbf.insertInto();
    print("Data into ${dbf.getTableName()} inserted");
    DateTime end = DateTime.now();
    print("Excecution time: ${end.difference(start).inSeconds}s");
  }
}
