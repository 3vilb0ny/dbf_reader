import 'package:dbf_reader/src/cell_structure.dart';
import 'package:dbf_reader/src/utils.dart';

class Header {
  final List<String> _bytes;
  late List<CellStructure> _columns;

  Header({
    required List<String> bytes,
  }) : _bytes = bytes {
    List<CellStructure> c = [];
    int offset = 32;

    for (var i = 0, l = _bytes.length; i + offset < l; i += offset) {
      String name =
          _bytes.getRange(i, i + 11).map((e) => fromCharCode(e)).join();
      String dataType = fromCharCode(_bytes[i + 11]);
      int length = intParse(_bytes[i + 16]);
      int decimalCount = intParse(_bytes[i + 17]);
      c.add(CellStructure(
        name: name,
        dataType: dataType,
        length: length,
        decimalPlaces: decimalCount,
      ));
    }
    _columns = c;
  }

  int get length => _columns.length;

  List<CellStructure> getStructure() {
    return this._columns;
  }

  CellStructure get(int index) {
    return this._columns[index];
  }

  void showStructure() {
    String s = "";
    for (CellStructure cellStructure in _columns) {
      s += cellStructure.toString() + "\n";
    }
    print(s);
  }
}
