import 'package:sqlite3/sqlite3.dart';

class DBConnection {
  static DBConnection? _instance;

  late final Database db;

  DBConnection() {
    db = sqlite3.open("example.sqlite");
  }

  static Database get instance {
    _instance ??= DBConnection();
    return _instance!.db;
  }

  static void closeDB() {
    DBConnection.instance.dispose();
  }
}
