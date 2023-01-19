import 'package:sqlite3/sqlite3.dart';

/// A sqlite3 connection management following the Singleton pattern
class DBConnection {
  /// The instance of this object
  static DBConnection? _instance;

  /// The instance of sqlite connection
  late final Database db;

  DBConnection() {
    db = sqlite3.open("example.sqlite");
  }

  /// Returns the instance, if it is null, creates it and returns it
  static Database get instance {
    _instance ??= DBConnection();
    return _instance!.db;
  }

  /// Method to close the connection
  static void closeDB() {
    DBConnection.instance.dispose();
  }
}
