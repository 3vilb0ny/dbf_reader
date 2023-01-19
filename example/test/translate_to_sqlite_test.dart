import 'dart:io';

import 'package:test/test.dart';
import 'package:translate_to_sqlite/main.dart' as ttsql;

/// The test to check the translation
void main() {
  test("Check translation", () async {
    await ttsql.main(const <String>[]);
    File f = File("./example.sqlite");
    expect(f.existsSync(), true);
  });
}
