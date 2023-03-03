
This is a package to read DBF files (dBase) and retrieves data into memory lists or streams.


## Features

* Get DBF version
* Print in console the DB structure
* Get number of rows
* Get last updated date
* Load data into memory
* Stream data


## Getting started

* First of all you need to add the fl_chart in your project.
* Option 1: command line
```bash
    pub get dbf_reader
```
* Option 2: Add dbf_reader in dependencies in pubspec.yaml

## Usage

DBF Version

```dart
import 'package:dbf_reader/dbf_reader.dart';

final dbf = DBF(fileName: "./file.dbf");
print(dbf.version.toString());
```


Get last updated date

```dart
import 'package:dbf_reader/dbf_reader.dart';

final dbf = DBF(fileName: "./file.dbf");
print(dbf.lastUpdated);
```

View structure

```dart
import 'package:dbf_reader/dbf_reader.dart';

final dbf = DBF(fileName: "./file.dbf");
dbf.showStructure();
```

View total number of records

```dart
import 'package:dbf_reader/dbf_reader.dart';

final dbf = DBF(fileName: "./file.dbf");
print(dbf.totalRecords.toString());
```

Select all records and store in a list of *`<Row>`*, take care that is an async function so it returns a future

```dart
import 'package:dbf_reader/dbf_reader.dart';

final dbf = DBF(fileName: "./file.dbf");
List<Row> rows = await dbf.select();
```

Select all records whith a condition and store in a list of *`<Row>`*

```dart
import 'package:dbf_reader/dbf_reader.dart';

final dbf = DBF(fileName: "./file.dbf");
// This is equivalent in SQL as: SELECT * FROM TABLE WHERE first_column != "";
List<Row> rows = await dbf.select(condition: (Row r) => r.get(0).value != "");
```

Get all records using stream version
```dart
import 'package:dbf_reader/dbf_reader.dart';

final dbf = DBF(fileName: "./file.dbf");
// Stream data example;
void useStream () async {
    // Using await for
    await for (Row row in dbf.getRowsAsync()) {
        print(row.toString() + "\n")
    }

    // Using Stream.listen
    dbf.getRowsAsync().listen((Row row) {
        print(row.toString() + "\n")
    });
}
```

## Example
* Translate to SQLite with table mapping in: https://github.com/3vilb0ny/dbf_reader/tree/develop/example


## Additional information
If you have any contribution to this package, feel free to let me know via email 3vilb0ny@gmail.com
