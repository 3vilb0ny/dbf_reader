/// A structure to represent the data to store
class DataPacket {
  /// The Object value
  final Object value;

  /// The constructor
  DataPacket({required this.value});

  /// Returns the [value] as String
  String getString() {
    return value.toString();
  }

  /// Returns the [value] as int
  int getInt() {
    return int.parse(value.toString());
  }

  /// Returns the [value] as double, if it is empty, returns 0.0
  double getDouble() {
    return value.toString().isEmpty ? 0.0 : double.parse(value.toString());
  }

  /// Returns the [value] as DateTime
  DateTime getDateTime() {
    String y = value.toString().substring(0, 4);
    String m = value.toString().substring(4, 6);
    String d = value.toString().substring(6, 8);

    return DateTime(int.parse(y), int.parse(m), int.parse(d));
  }

  /// Object String representation
  @override
  String toString() {
    return value.toString();
  }
}
