import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/database.dart';
import '../models/models.dart';
import 'event_repository.dart';

class DriftEventRepository implements EventRepository {
  final AppDatabase _database;

  DriftEventRepository(this._database);

  // Event operations
  @override
  Future<List<Event>> getAllEvents() async {
    final events = await _database.select(_database.events).get();
    return events.map(_eventFromData).toList();
  }

  @override
  Future<Event?> getEventById(String id) async {
    final event = await (_database.select(_database.events)
          ..where((e) => e.id.equals(id)))
        .getSingleOrNull();
    return event != null ? _eventFromData(event) : null;
  }

  @override
  Future<String> createEvent(Event event) async {
    await _database.into(_database.events).insert(_eventToData(event));
    return event.id;
  }

  @override
  Future<void> updateEvent(Event event) async {
    await (_database.update(_database.events)
          ..where((e) => e.id.equals(event.id)))
        .write(_eventToData(event));
  }

  @override
  Future<void> deleteEvent(String id) async {
    await (_database.delete(_database.events)..where((e) => e.id.equals(id)))
        .go();
  }

  // Column operations
  @override
  Future<List<EventColumn>> getEventColumns(String eventId) async {
    final columns = await (_database.select(_database.columns)
          ..where((c) => c.eventId.equals(eventId))
          ..orderBy([(c) => OrderingTerm.asc(c.position)]))
        .get();
    return columns.map(_columnFromData).toList();
  }

  @override
  Future<String> createColumn(EventColumn column) async {
    await _database.into(_database.columns).insert(_columnToData(column));
    return column.id;
  }

  @override
  Future<void> updateColumn(EventColumn column) async {
    await (_database.update(_database.columns)
          ..where((c) => c.id.equals(column.id)))
        .write(_columnToData(column));
  }

  @override
  Future<void> deleteColumn(String columnId) async {
    await (_database.delete(_database.columns)
          ..where((c) => c.id.equals(columnId)))
        .go();
  }

  @override
  Future<void> reorderColumns(String eventId, List<String> columnIds) async {
    await _database.transaction(() async {
      for (int i = 0; i < columnIds.length; i++) {
        await (_database.update(_database.columns)
              ..where((c) => c.id.equals(columnIds[i])))
            .write(ColumnsCompanion(position: Value(i)));
      }
    });
  }

  // Row operations
  @override
  Future<List<EventRow>> getEventRows(String eventId) async {
    final rows = await (_database.select(_database.rows)
          ..where((r) => r.eventId.equals(eventId))
          ..orderBy([(r) => OrderingTerm.asc(r.position)]))
        .get();
    return rows.map(_rowFromData).toList();
  }

  @override
  Future<String> createRow(EventRow row) async {
    await _database.into(_database.rows).insert(_rowToData(row));
    return row.id;
  }

  @override
  Future<void> updateRow(EventRow row) async {
    await (_database.update(_database.rows)..where((r) => r.id.equals(row.id)))
        .write(_rowToData(row));
  }

  @override
  Future<void> deleteRow(String rowId) async {
    await (_database.delete(_database.rows)..where((r) => r.id.equals(rowId)))
        .go();
  }

  @override
  Future<void> insertRowAtPosition(EventRow row, int position) async {
    await _database.transaction(() async {
      // Shift existing rows down
      await _database.customUpdate(
        'UPDATE rows SET position = position + 1 WHERE event_id = ? AND position >= ?',
        variables: [Variable.withString(row.eventId), Variable.withInt(position)],
      );
      
      // Insert new row
      await _database.into(_database.rows).insert(_rowToData(row.copyWith(position: position)));
    });
  }

  @override
  Future<void> reorderRows(String eventId, List<String> rowIds) async {
    await _database.transaction(() async {
      for (int i = 0; i < rowIds.length; i++) {
        await (_database.update(_database.rows)
              ..where((r) => r.id.equals(rowIds[i])))
            .write(RowsCompanion(position: Value(i + 1))); // 1-based indexing
      }
    });
  }

  // Cell operations
  @override
  Future<List<Cell>> getEventCells(String eventId) async {
    final query = _database.select(_database.cells).join([
      leftOuterJoin(_database.rows, _database.rows.id.equalsExp(_database.cells.rowId)),
    ])..where(_database.rows.eventId.equals(eventId));
    
    final results = await query.get();
    return results.map((row) => _cellFromData(row.readTable(_database.cells))).toList();
  }

  @override
  Future<List<Cell>> getRowCells(String rowId) async {
    final cells = await (_database.select(_database.cells)
          ..where((c) => c.rowId.equals(rowId)))
        .get();
    return cells.map(_cellFromData).toList();
  }

  @override
  Future<Cell?> getCell(String rowId, String columnId) async {
    final cell = await (_database.select(_database.cells)
          ..where((c) => c.rowId.equals(rowId) & c.columnId.equals(columnId)))
        .getSingleOrNull();
    return cell != null ? _cellFromData(cell) : null;
  }

  @override
  Future<String> createCell(Cell cell) async {
    await _database.into(_database.cells).insert(_cellToData(cell));
    return cell.id;
  }

  @override
  Future<void> updateCell(Cell cell) async {
    await (_database.update(_database.cells)..where((c) => c.id.equals(cell.id)))
        .write(_cellToData(cell));
  }

  @override
  Future<void> deleteCell(String cellId) async {
    await (_database.delete(_database.cells)..where((c) => c.id.equals(cellId)))
        .go();
  }

  // Totals operations
  @override
  Future<EventTotals?> getEventTotals(String eventId) async {
    final totals = await (_database.select(_database.eventTotalsTable)
          ..where((t) => t.eventId.equals(eventId)))
        .getSingleOrNull();
    return totals != null ? _totalsFromData(totals) : null;
  }

  @override
  Future<void> updateEventTotals(EventTotals totals) async {
    await _database.into(_database.eventTotalsTable).insertOnConflictUpdate(_totalsToData(totals));
  }

  @override
  Future<EventTotals> calculateEventTotals(String eventId) async {
    // Get amount column
    final amountColumn = await (_database.select(_database.columns)
          ..where((c) => c.eventId.equals(eventId) & c.key.equals('amount')))
        .getSingleOrNull();
    
    if (amountColumn == null) {
      return EventTotals.empty(eventId);
    }

    // Get online column
    final onlineColumn = await (_database.select(_database.columns)
          ..where((c) => c.eventId.equals(eventId) & c.key.equals('online')))
        .getSingleOrNull();

    if (onlineColumn == null) {
      return EventTotals.empty(eventId);
    }

    // Calculate totals
    final query = '''
      SELECT 
        SUM(CASE WHEN online_cells.value_bool = 1 THEN amount_cells.value_number ELSE 0 END) as online_total,
        SUM(CASE WHEN online_cells.value_bool = 0 OR online_cells.value_bool IS NULL THEN amount_cells.value_number ELSE 0 END) as offline_total
      FROM rows 
      LEFT JOIN cells amount_cells ON rows.id = amount_cells.row_id AND amount_cells.column_id = ?
      LEFT JOIN cells online_cells ON rows.id = online_cells.row_id AND online_cells.column_id = ?
      WHERE rows.event_id = ?
    ''';

    final result = await _database.customSelect(
      query,
      variables: [
        Variable.withString(amountColumn.id),
        Variable.withString(onlineColumn.id),
        Variable.withString(eventId),
      ],
    ).getSingle();

    final onlineTotal = result.data['online_total'] as double? ?? 0.0;
    final offlineTotal = result.data['offline_total'] as double? ?? 0.0;

    final totals = EventTotals(
      eventId: eventId,
      onlineTotal: onlineTotal,
      offlineTotal: offlineTotal,
    );

    await updateEventTotals(totals);
    return totals;
  }

  // Bulk operations
  @override
  Future<void> createEventWithDefaults(Event event) async {
    await _database.transaction(() async {
      // Create event
      await createEvent(event);

      // Create default columns
      final defaultColumns = [
        EventColumn.serial(eventId: event.id, position: 0),
        EventColumn.room(eventId: event.id, position: 1),
        EventColumn.amount(eventId: event.id, position: 2),
        EventColumn.online(eventId: event.id, position: 3),
        EventColumn.addColumn(eventId: event.id, position: 4),
      ];

      for (final column in defaultColumns) {
        await createColumn(column);
      }

      // Create default rows (5 empty rows)
      for (int i = 1; i <= 5; i++) {
        final row = EventRow(eventId: event.id, position: i);
        await createRow(row);
      }

      // Initialize totals
      await updateEventTotals(EventTotals.empty(event.id));
    });
  }

  @override
  Future<ExportData> exportEvents(List<String> eventIds) async {
    final List<EventExportData> eventExports = [];

    for (final eventId in eventIds) {
      final event = await getEventById(eventId);
      if (event == null) continue;

      final columns = await getEventColumns(eventId);
      final rows = await getEventRows(eventId);
      final cells = await getEventCells(eventId);
      final totals = await getEventTotals(eventId);

      eventExports.add(EventExportData(
        event: event,
        columns: columns,
        rows: rows,
        cells: cells,
        totals: totals,
      ));
    }

    return ExportData(events: eventExports);
  }

  @override
  Future<List<String>> importEvents(ExportData exportData) async {
    final List<String> importedEventIds = [];

    await _database.transaction(() async {
      for (final eventData in exportData.events) {
        // Generate new IDs to avoid conflicts
        final newEventId = const Uuid().v4();
        final event = eventData.event.copyWith(id: newEventId);
        
        await createEvent(event);
        importedEventIds.add(newEventId);

        // Import columns with new IDs
        final columnIdMap = <String, String>{};
        for (final column in eventData.columns) {
          final newColumnId = const Uuid().v4();
          columnIdMap[column.id] = newColumnId;
          await createColumn(column.copyWith(id: newColumnId, eventId: newEventId));
        }

        // Import rows with new IDs
        final rowIdMap = <String, String>{};
        for (final row in eventData.rows) {
          final newRowId = const Uuid().v4();
          rowIdMap[row.id] = newRowId;
          await createRow(row.copyWith(id: newRowId, eventId: newEventId));
        }

        // Import cells with new IDs
        for (final cell in eventData.cells) {
          final newRowId = rowIdMap[cell.rowId];
          final newColumnId = columnIdMap[cell.columnId];
          if (newRowId != null && newColumnId != null) {
            await createCell(cell.copyWith(
              id: const Uuid().v4(),
              rowId: newRowId,
              columnId: newColumnId,
            ));
          }
        }

        // Import totals
        if (eventData.totals != null) {
          await updateEventTotals(eventData.totals!.copyWith(eventId: newEventId));
        }
      }
    });

    return importedEventIds;
  }

  @override
  Future<void> clearAllData() async {
    await _database.transaction(() async {
      await _database.delete(_database.cells).go();
      await _database.delete(_database.rows).go();
      await _database.delete(_database.columns).go();
      await _database.delete(_database.eventTotalsTable).go();
      await _database.delete(_database.events).go();
    });
  }

  @override
  Future<int> getEventCount() async {
    final result = await _database.customSelect('SELECT COUNT(*) as count FROM events').getSingle();
    return result.data['count'] as int;
  }

  // Helper methods for data conversion
  Event _eventFromData(EventData data) {
    return Event(
      id: data.id,
      title: data.title,
      description: data.description,
      date: DateTime.fromMillisecondsSinceEpoch(data.date),
      locked: data.locked,
      gradientColorA: data.gradientColorA,
      gradientColorB: data.gradientColorB,
      createdAt: DateTime.fromMillisecondsSinceEpoch(data.createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(data.updatedAt),
    );
  }

  EventsCompanion _eventToData(Event event) {
    return EventsCompanion(
      id: Value(event.id),
      title: Value(event.title),
      description: Value(event.description),
      date: Value(event.date.millisecondsSinceEpoch),
      locked: Value(event.locked),
      gradientColorA: Value(event.gradientColorA),
      gradientColorB: Value(event.gradientColorB),
      createdAt: Value(event.createdAt.millisecondsSinceEpoch),
      updatedAt: Value(event.updatedAt.millisecondsSinceEpoch),
    );
  }

  EventColumn _columnFromData(ColumnData data) {
    return EventColumn(
      id: data.id,
      eventId: data.eventId,
      key: data.key,
      label: data.label,
      type: ColumnType.values.firstWhere((e) => e.name == data.type),
      position: data.position,
      fixed: data.fixed,
    );
  }

  ColumnsCompanion _columnToData(EventColumn column) {
    return ColumnsCompanion(
      id: Value(column.id),
      eventId: Value(column.eventId),
      key: Value(column.key),
      label: Value(column.label),
      type: Value(column.type.name),
      position: Value(column.position),
      fixed: Value(column.fixed),
    );
  }

  EventRow _rowFromData(RowData data) {
    return EventRow(
      id: data.id,
      eventId: data.eventId,
      position: data.position,
      createdAt: DateTime.fromMillisecondsSinceEpoch(data.createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(data.updatedAt),
    );
  }

  RowsCompanion _rowToData(EventRow row) {
    return RowsCompanion(
      id: Value(row.id),
      eventId: Value(row.eventId),
      position: Value(row.position),
      createdAt: Value(row.createdAt.millisecondsSinceEpoch),
      updatedAt: Value(row.updatedAt.millisecondsSinceEpoch),
    );
  }

  Cell _cellFromData(CellData data) {
    return Cell(
      id: data.id,
      rowId: data.rowId,
      columnId: data.columnId,
      valueText: data.valueText,
      valueNumber: data.valueNumber,
      valueBool: data.valueBool,
    );
  }

  CellsCompanion _cellToData(Cell cell) {
    return CellsCompanion(
      id: Value(cell.id),
      rowId: Value(cell.rowId),
      columnId: Value(cell.columnId),
      valueText: Value(cell.valueText),
      valueNumber: Value(cell.valueNumber),
      valueBool: Value(cell.valueBool),
    );
  }

  EventTotals _totalsFromData(EventTotalsData data) {
    return EventTotals(
      eventId: data.eventId,
      onlineTotal: data.onlineTotal,
      offlineTotal: data.offlineTotal,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(data.updatedAt),
    );
  }

  EventTotalsTableCompanion _totalsToData(EventTotals totals) {
    return EventTotalsTableCompanion(
      eventId: Value(totals.eventId),
      onlineTotal: Value(totals.onlineTotal),
      offlineTotal: Value(totals.offlineTotal),
      grandTotal: Value(totals.grandTotal),
      updatedAt: Value(totals.updatedAt.millisecondsSinceEpoch),
    );
  }
}
