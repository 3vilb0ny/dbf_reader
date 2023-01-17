import 'package:dotenv/dotenv.dart';
import 'package:sqlite3/sqlite3.dart';

class DBConnection {
  static DBConnection? _instance;

  late final Database db;

  DBConnection() {
    DotEnv env = DotEnv(includePlatformEnvironment: true)..load();

    db = sqlite3.open(env["DB_NAME"]!);
  }

  static Database get instance {
    _instance ??= DBConnection();
    return _instance!.db;
  }

  static void closeDB() {
    DBConnection.instance.dispose();
  }
}
