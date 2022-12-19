
This is a package to read DBF files (dBase) and retrieves data into memory lists.


## Features

* Read DBF data
* Get DBF version
* Print in console the DB structure
* Get number of rows
* Get last updated date 


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

Select all records and store in a list of *`<Row>`*

```dart
final dbf = DBF(fileName: "./file.dbf");
List<Row> rows = dbf.select();
```

Select all records whith a condition and store in a list of *`<Row>`*

```dart
final dbf = DBF(fileName: "./file.dbf");
// This is equivalent in SQL as: SELECT * FROM TABLE WHERE first_column != "";
List<Row> rows = dbf.select(condition: (Row r) => r.get(0).value != "");
```

## Additional information
If you have any contribution to this package, feel free to let me know via email b0nyh4ck3r@gmail.com
