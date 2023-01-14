class CellStructure {
  final String name;
  final String dataType;
  final int length;
  final int decimalPlaces;
  final int position;

  CellStructure({
    required this.name,
    required this.dataType,
    required this.length,
    required this.decimalPlaces,
    required this.position,
  });

  @override
  String toString() {
    return """
    {
      Column Name:\t$name
      Data Type:\t$dataType (${_translateDataType()})
      Column Lenght:\t$length
      Decimal Places:\t$decimalPlaces
      Position:\t$position
    }
    """;
  }

  String _translateDataType() {
    /**
     * https://www.dbase.com/Knowledgebase/INT/db7_file_fmt.htm
     * 
     * C	Character, padded with spaces if shorter than the field length
     * D	Date stored as string in YYYYMMDD format
     * F	Floating point number, stored as string, padded with spaces if shorter than the field length
     * N	Floating point number, stored as string, padded with spaces if shorter than the field length
     * L	Boolean value, stored as one of YyNnTtFf. May be set to ? if not initialized
     * M  Memo, a string - 10 digits (bytes) representing a .DBT block number. The number is stored as a string, right justified and padded with blanks
     * @  Timestamp - The date is the number of days since  01/01/4713 BC. Time is hours * 3600000L + minutes * 60000L + Seconds * 1000L
     * l  Long
     * +  Long autoincrement
     * O  Double
     * G  OLE
     */
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
      case "M":
        return "String";
      case "@":
        return "Double";
      case "l":
        return "Double";
      case "+":
        return "Double";
      case "O":
        return "Double";
      case "G":
        return "OLE";
      default:
        return "Unrecognized";
    }
  }
}
