import 'package:dbf_reader/src/column_structure.dart';
import 'package:dbf_reader/src/utils.dart';

/// A representation of the first binary part of the dbase file,
/// it contains the column structure, quantity of columns, etc
class Header {
  /// The bytes to read
  final Iterable<String> _bytes;

  /// The columns
  late Iterable<ColumnStructure> _columns;

  /// The constructor creates the columns
  Header({
    required Iterable<String> bytes,
  }) : _bytes = bytes {
    List<ColumnStructure> c = [];
    int offset = 32;

    int position = 0;
    for (int i = 0, l = _bytes.length; i + offset < l; i += offset) {
      String name =
          _bytes.skip(i).take(11).map((e) => mapToAscii(e)).join().trim();
      if (name.isEmpty) {
        continue;
      }
      String dataType = mapToAscii(_bytes.elementAt(i + 11));
      int length = intParse(_bytes.elementAt(i + 16));
      int decimalCount = intParse(_bytes.elementAt(i + 17));
      c.add(ColumnStructure(
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

  /// Returns the columns length
  int get length => _columns.length;

  /// Returns the columns
  Iterable<ColumnStructure> getStructure() {
    return _columns;
  }

  /// Return a column based on it index
  ColumnStructure get(int index) {
    return _columns.elementAt(index);
  }

  /// Prints in console the table structure
  void showStructure() {
    print(_columns.join("\n"));
  }

  /// Returns a String
  @override
  String toString() {
    return "| ${_columns.map((e) => e.name).join(" | ")} |";
  }
}
