import 'package:dbf_reader/dbf_reader.dart';
import 'package:test/test.dart';

void main() {
  final dbf = DBF(fileName: "./test/Tcambio.dbf");
  test('DBF version', () {
    expect(dbf.version, isNonZero);
  });

  test('Last updated', () {
    expect(dbf.lastUpdated, isNotEmpty);
  });

  test('Total records', () {
    expect(dbf.totalRecords, isNonZero);
  });

  test('Show structure', () {
    dbf.showStructure();
  });

  test('Read first row seccond column', () async {
    expect((await dbf.select()).first.get(1).getString(), isNotNull);
  });

  test('SELECT * FROM', () async {
    List<Row> rows = await dbf.select();
    expect(rows.length, dbf.totalRecords);
  });

  test('SELECT * FROM TABLE WHERE first_column != ""', () async {
    List<Row> rows =
        await dbf.select(condition: (Row r) => r.get(0).value != "");
    expect(rows, isNotEmpty);
  });

  test(
    'Async read',
    () async {
      expect(await dbf.getRowsAsync().length, isNonZero);
    },
  );

  test('Test deleted records', () async {
    int lenNotDeleted = 0;
    int lenDeleted = 0;
    await for (Row row in dbf.getRowsAsync()) {
      if (row.isDeleted) {
        lenDeleted++;
      } else {
        lenNotDeleted++;
      }
    }
    expect(lenDeleted + lenNotDeleted, dbf.totalRecords);
  });
}
