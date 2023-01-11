library dbf_reader;

import 'dart:async';
import 'dart:io';

import 'package:dbf_reader/src/Exceptions/file_not_found_exception.dart';
import 'package:dbf_reader/src/cell_structure.dart';
import 'package:dbf_reader/src/data_packet.dart';
import 'package:dbf_reader/src/header.dart';
import 'package:dbf_reader/src/row.dart';
import 'package:dbf_reader/src/utils.dart';

class DBF {
  final String fileName;

  late final Header _header;
  late final int _headerByteSize;
  late final int _recordByteSize;

  DBF({required this.fileName}) {
    if (!File(fileName).existsSync()) {
      throw FileNotFoundException();
    }
    Iterable<String> bytes = _readBytes(end: 256);
    _headerByteSize = intParse(lsbHexFromByteArray(bytes, 8, 10));
    _recordByteSize = intParse(lsbHexFromByteArray(bytes, 10, 12));
    _header = Header(bytes: bytes.skip(32).take(_headerByteSize - 32));
  }

  int get version {
    return intParse(_readBytes(end: 1).elementAt(0));
  }

  String get lastUpdated {
    return _readBytes(end: 4).skip(1).take(3).map((e) => intParse(e)).join("-");
  }

  int get totalRecords {
    return intParse(lsbHexFromByteArray(_readBytes(end: 9), 4, 8));
  }

  List<Row> get rowsSync {
    List<Row> r = [];
    Iterable<String> binaryRows = _readBytes(start: _headerByteSize);

    for (int i = 0, l = binaryRows.length;
        i + _recordByteSize < l;
        i += _recordByteSize) {
      r.add(Row(
          cells: _extractRow(
              binaryRows.skip(i).take(_recordByteSize).toList(), _header)));
    }
    return r;
  }

  Header get header => _header;

  Stream<Iterable<String>> asyncRead() {
    File f = File(fileName);
    return f
        .openRead()
        .map((event) => event.map((e) => e.toRadixString(16).padLeft(2, "0")));
  }

  Stream<Row> getRowsAsync() async* {
    await for (Iterable<String> lines in asyncRead()) {
      Iterable<String> restLines = lines.skip(_headerByteSize);
      for (int i = 0, l = restLines.length;
          i + _recordByteSize < l;
          i += _recordByteSize) {
        yield Row(
          cells: _extractRow(
            restLines.skip(i).take(_recordByteSize).toList(),
            _header,
          ),
        );
      }
    }
  }

  List<Row> select({
    List<int> columnPositions = const [],
    bool Function(Row)? condition,
  }) {
    List<Row> rows = [];
    for (Row row in rowsSync) {
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

  void showStructre() {
    _header.showStructure();
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

  Iterable<String> _readBytes({
    int start = 0,
    int end = 0,
  }) {
    File f = File(fileName);
    Iterable<int> s = f.readAsBytesSync();
    if (end > start) s = s.skip(start).take(end - start);
    if (end < start) s = s.skip(start);
    return s.map((e) => e.toRadixString(16).padLeft(2, "0"));
  }
}
