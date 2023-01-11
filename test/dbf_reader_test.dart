import 'package:dbf_reader/dbf_reader.dart';
import 'package:dbf_reader/src/row.dart';
import 'package:test/test.dart';

void main() {
  final dbf = DBF(fileName: "./file.dbf");
  test('DBF version', () {
    expect(dbf.version, isNonZero);
  });

  test('Last updated', () {
    expect(dbf.lastUpdated, isNotEmpty);
  });

  test('Show structure', () {
    dbf.showStructre();
  });

  test('Total records', () {
    expect(dbf.totalRecords, isNonZero);
  });

  test('Read first row seccond column', () {
    expect(dbf.select().first.get(1).getString(), isNotNull);
  });

  test('SELECT * FROM', () {
    List<Row> rows = dbf.select();
    expect(rows.length, dbf.totalRecords);
  });

  test('SELECT * FROM TABLE WHERE first_column != ""', () {
    List<Row> rows = dbf.select(condition: (Row r) => r.get(0).value != "");
    expect(rows, isNotEmpty);
  });

  test(
    'Async read',
    () async {
      expect(await dbf.getRowsAsync().length, isNonZero);
    },
  );
}
