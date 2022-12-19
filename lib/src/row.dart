import 'package:dbf_reader/src/data_packet.dart';

class Row {
  final List<DataPacket> _cells;

  Row({
    required List<DataPacket> cells,
  }) : _cells = cells;

  get length => _cells.length;
  get cells => _cells;

  DataPacket get(int index) {
    return _cells[index];
  }

  @override
  String toString() {
    String s = "|";
    for (DataPacket d in _cells) {
      s += " $d |";
    }
    return s;
  }
}
