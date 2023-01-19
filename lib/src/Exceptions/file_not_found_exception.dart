/// An exception for dbf file not found
class FileNotFoundException implements Exception {
  /// The message to display
  late String _message;

  /// The Constructor
  FileNotFoundException([String message = "File not found"]) {
    _message = message;
  }

  /// Object String representation
  @override
  String toString() {
    return _message;
  }
}
