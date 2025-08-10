import 'package:drift/drift.dart';

@DataClassName('EventData')
class Events extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  IntColumn get date => integer()(); // epoch millis
  BoolColumn get locked => boolean().withDefault(const Constant(false))();
  TextColumn get gradientColorA => text()();
  TextColumn get gradientColorB => text()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ColumnData')
class Columns extends Table {
  TextColumn get id => text()();
  TextColumn get eventId => text().references(Events, #id, onDelete: KeyAction.cascade)();
  TextColumn get key => text()(); // semantic key
  TextColumn get label => text()();
  TextColumn get type => text()(); // ColumnType enum as string
  IntColumn get position => integer()();
  BoolColumn get fixed => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('RowData')
class Rows extends Table {
  TextColumn get id => text()();
  TextColumn get eventId => text().references(Events, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()(); // 1-based index
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CellData')
class Cells extends Table {
  TextColumn get id => text()();
  TextColumn get rowId => text().references(Rows, #id, onDelete: KeyAction.cascade)();
  TextColumn get columnId => text().references(Columns, #id, onDelete: KeyAction.cascade)();
  TextColumn get valueText => text().nullable()();
  RealColumn get valueNumber => real().nullable()();
  BoolColumn get valueBool => boolean().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('EventTotalsData')
class EventTotalsTable extends Table {
  @override
  String get tableName => 'event_totals';
  
  TextColumn get eventId => text().references(Events, #id, onDelete: KeyAction.cascade)();
  RealColumn get onlineTotal => real().withDefault(const Constant(0.0))();
  RealColumn get offlineTotal => real().withDefault(const Constant(0.0))();
  RealColumn get grandTotal => real().withDefault(const Constant(0.0))();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {eventId};
}
