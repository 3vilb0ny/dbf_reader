import 'package:dbf_reader/src/cell_structure.dart';
import 'package:dbf_reader/src/utils.dart';

class Header {
  final Iterable<String> _bytes;
  late Iterable<CellStructure> _columns;

  Header({
    required Iterable<String> bytes,
  }) : _bytes = bytes {
    List<CellStructure> c = [];
    int offset = 32;

    int position = 0;
    for (int i = 0, l = _bytes.length; i + offset < l; i += offset) {
      String name = _bytes.skip(i).take(11).map((e) => fromCharCode(e)).join();
      String dataType = fromCharCode(_bytes.elementAt(i + 11));
      int length = intParse(_bytes.elementAt(i + 16));
      int decimalCount = intParse(_bytes.elementAt(i + 17));
      c.add(CellStructure(
        name: name,
        dataType: dataType,
        length: length,
        decimalPlaces: decimalCount,
        position: position,
      ));
      position++;
    }
    _columns = c;
  }

  int get length => _columns.length;

  Iterable<CellStructure> getStructure() {
    return _columns;
  }

  CellStructure get(int index) {
    return _columns.elementAt(index);
  }

  void showStructure() {
    String s = "";
    for (CellStructure cellStructure in _columns) {
      s += "$cellStructure\n";
    }
    print(s);
  }
}
