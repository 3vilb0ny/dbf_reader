class FileNotFoundException implements Exception {
  late String _message;

  FileNotFoundException([String message = "File not found"]) {
    _message = message;
  }

  @override
  String toString() {
    return _message;
  }
}
