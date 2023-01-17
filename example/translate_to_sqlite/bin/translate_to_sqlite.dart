import 'package:dotenv/dotenv.dart';
import 'package:translate_to_sqlite/dbf_to_sql.dart';

void main(List<String> arguments) async {

  DotEnv env = DotEnv(includePlatformEnvironment: true)..load();
  
  String dbNameGroups = '${env['DBF_PATH']!}/groups.dbf';
  
  TableMapper groupMapper = TableMapper(
    tableName: "GROUP",
    columnMapper: {
      "JQ_CODIGO": "code",
      "JQ_NOMBRE": "name",
    },
  );
  
  DBFtoSQL dbfGroups =
      DBFtoSQL(fileName: dbNameGroups, tableMapper: groupMapper);
  
  final dbfsToTranslate = [dbfGroups,];

  for (DBFtoSQL dbf in dbfsToTranslate) {
    print("Creating table ${dbf.getTableName()}");
    dbf.createTable();
    print("Inserting data to ${dbf.getTableName()}");
    await dbf.insertInto();
    print("Done!");
  }

}
