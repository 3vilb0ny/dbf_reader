
This is a package to read DBF files (dBase) and retrieves data into memory lists or streams.


## Features

* Get DBF version
* Print in console the DB structure
* Get number of rows
* Get last updated date
* Load data into memory
* Stream data


## Getting started

* Install the package using pub get dbf_reader.

## Usage

DBF Version

```dart
final dbf = DBF(fileName: "./file.dbf");
log(dbf.version);
```


Get last updated date

```dart
final dbf = DBF(fileName: "./file.dbf");
log(dbf.lastUpdated);
```

View structure

```dart
final dbf = DBF(fileName: "./file.dbf");
log(dbf.showStructure);
```

View total number of records

```dart
final dbf = DBF(fileName: "./file.dbf");
log(dbf.totalRecords);
```

Select all records and store in a list of *`<Row>`*, take care that is an async function so it returns a future

```dart
final dbf = DBF(fileName: "./file.dbf");
List<Row> rows = await dbf.select();
```

Select all records whith a condition and store in a list of *`<Row>`*

```dart
final dbf = DBF(fileName: "./file.dbf");
// This is equivalent in SQL as: SELECT * FROM TABLE WHERE first_column != "";
List<Row> rows = await dbf.select(condition: (Row r) => r.get(0).value != "");
```

Get all records using stream version
```dart
final dbf = DBF(fileName: "./file.dbf");
// Stream data example;
void useStream () async {
    // Using await for
    await for (Row row in dbf.getRowsAsync()) {
        print(row.toString());
    }

    // Using Stream.listen
    dbf.getRowsAsync().listen((Row r) {
        print(r.toString());
    });
}
```

## Example
* Translate to SQLite with table mapping in: https://github.com/3vilb0ny/dbf_reader/tree/develop/example


## Additional information
If you have any contribution to this package, feel free to let me know via email 3vilb0ny@gmail.com
