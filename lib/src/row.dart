import 'package:dbf_reader/src/data_packet.dart';

/// A table row
class Row {
  /// The cells part of the row
  final List<DataPacket> _cells;

  /// The flag which determines if is a deleted record
  final bool isDeleted;

  /// The constructor
  Row({
    required List<DataPacket> cells,
    this.isDeleted = false,
  }) : _cells = cells;

  /// Returns the row length
  int get length => _cells.length;

  /// Returns the [_cells]
  List<DataPacket> get cells => _cells;

  /// Returns the cell based on it index
  DataPacket get(int index) {
    return _cells[index];
  }

  /// Returns the string representation of the row
  @override
  String toString() {
    String s = "|";
    for (DataPacket d in _cells) {
      s += " $d |";
    }
    return s;
  }
}
