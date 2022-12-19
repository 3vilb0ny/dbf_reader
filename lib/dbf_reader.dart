library dbf_reader;

import 'dart:io';

import 'package:dbf_reader/src/cell_structure.dart';
import 'package:dbf_reader/src/data_packet.dart';
import 'package:dbf_reader/src/header.dart';
import 'package:dbf_reader/src/row.dart';
import 'package:dbf_reader/src/utils.dart';

class DBF {
  final String fileName;

  late final List<String> _bytes;
  late final Header _header;
  late final List<Row> _rows;

  DBF({required this.fileName}) {
    File f = File(fileName);
    _bytes = f
        .readAsBytesSync()
        .map((e) => e.toRadixString(16).padLeft(2, "0"))
        .toList();
    int headerByteSize = intParse(lsbHexFromByteArray(_bytes, 8, 10));
    int recordByteSize = intParse(lsbHexFromByteArray(_bytes, 10, 12));

    _header = Header(bytes: _bytes.getRange(32, headerByteSize).toList());

    List<Row> r = [];
    List<String> binaryRows =
        _bytes.getRange(headerByteSize, _bytes.length).toList();

    for (int i = 0, l = binaryRows.length;
        i + recordByteSize < l;
        i += recordByteSize) {
      r.add(Row(
          cells: _extractRow(
              binaryRows.getRange(i, i + recordByteSize).toList(), _header)));
    }
    _rows = r;
  }

  int get version {
    return intParse(_bytes[0]);
  }

  String get lastUpdated {
    return _bytes.getRange(1, 4).map((e) => intParse(e)).join("-");
  }

  int get totalRecords {
    return intParse(lsbHexFromByteArray(_bytes, 4, 8));
  }

  void showStructre() {
    this._header.showStructure();
  }

  List<Row> select({
    List<int> columnPositions = const [],
    bool Function(Row)? condition,
  }) {
    List<Row> rows = [];
    for (Row row in _rows) {
      if (condition == null || condition(row)) {
        List<DataPacket> selectedCells = [];
        for (int columnIndex = 0,
                l = columnPositions.isEmpty
                    ? row.length
                    : columnPositions.length;
            columnIndex < l;
            columnIndex++) {
          selectedCells.add(row.get(columnIndex));
        }
        rows.add(Row(cells: selectedCells));
      }
    }
    return rows;
  }

  List<DataPacket> _extractRow(List<String> bytes, Header header) {
    List<DataPacket> ret = [];
    int l = header.length;
    int offset = 1;
    for (int i = 0; i < l; i++) {
      CellStructure cell = header.get(i);
      int endOffset = cell.length + offset;
      ret.add(DataPacket(
          value: fromCharCodes(bytes.getRange(offset, endOffset).join())));
      offset = endOffset;
    }
    return ret;
  }
}
