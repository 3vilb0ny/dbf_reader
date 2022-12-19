class DataPacket {
  final Object value;

  DataPacket({required this.value});

  String getString() {
    return value.toString();
  }

  int getInt() {
    return int.parse(value.toString());
  }

  double getDouble() {
    return double.parse(value.toString());
  }

  DateTime getDateTime() {
    String y = value.toString().substring(0, 4);
    String m = value.toString().substring(4, 6);
    String d = value.toString().substring(6, 8);

    return DateTime(int.parse(y), int.parse(m), int.parse(d));
  }

  @override
  String toString() {
    return value.toString();
  }
}
