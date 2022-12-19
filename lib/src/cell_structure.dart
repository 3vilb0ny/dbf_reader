class CellStructure {
  final String name;
  final String dataType;
  final int length;
  final int decimalPlaces;

  CellStructure({
    required this.name,
    required this.dataType,
    required this.length,
    required this.decimalPlaces,
  });

  @override
  String toString() {
    return """
    {
      Column Name:\t$name
      Data Type:\t$dataType (${_translateDataType()})
      Column Lenght:\t$length
      Decimal Places:\t$decimalPlaces
    }
    """;
  }

  String _translateDataType() {
    // C	Character, padded with spaces if shorter than the field length
    // D	Date stored as string in YYYYMMDD format
    // F	Floating point number, stored as string, padded with spaces if shorter than the field length
    // N	Floating point number, stored as string, padded with spaces if shorter than the field length
    // L	Boolean value, stored as one of YyNnTtFf. May be set to ? if not initialized
    switch (dataType) {
      case "C":
        return "Char";
      case "D":
        return "DateTime";
      case "F":
        return "Double";
      case "N":
        return "Double";
      case "L":
        return "bool";
      default:
        return "Unrecognized";
    }
  }
}
