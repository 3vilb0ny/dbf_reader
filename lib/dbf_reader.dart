library dbf_reader;

import 'dart:async';
import 'dart:io';

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
    // First 32 bytes, content description
    Iterable<String> bytes = _readBytes(end: 32);
    _headerByteSize = intParse(lsbHexFromByteArray(bytes, start: 8, end: 10));
    _recordByteSize = intParse(lsbHexFromByteArray(bytes, start: 10, end: 12));
    // From 32 to header size, field descriptors
    _header = Header(bytes: _readBytes(start: 32, end: _headerByteSize));
  }

  int get version {
    return intParse(_readBytes(end: 1).elementAt(0));
  }

  String get lastUpdated {
    return _readBytes(end: 4).skip(1).map((e) => intParse(e)).join("-");
  }

  int get totalRecords {
    return intParse(lsbHexFromByteArray(_readBytes(start: 4, end: 8)));
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
    Iterable<String> complete = [];
    bool firstTime = true;
    await for (Iterable<String> lines in asyncRead()) {
      if (firstTime) {
        Iterable<String> restLines = lines.skip(_headerByteSize);
        complete = restLines;
        firstTime = false;
      } else {
        complete = [...complete, ...lines];
      }

      for (int i = 0, l = complete.length;
          i + _recordByteSize < l;
          i += _recordByteSize) {
        Iterable<String> aux = complete.take(_recordByteSize);
        if (aux.length < _recordByteSize) {
          complete = aux;
          continue;
        }

        yield Row(
          cells: _extractRow(
            aux.toList(),
            _header,
          ),
        );
        complete = complete.skip(_recordByteSize);
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
