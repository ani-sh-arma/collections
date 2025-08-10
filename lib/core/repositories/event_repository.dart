import '../models/models.dart';

abstract class EventRepository {
  // Event operations
  Future<List<Event>> getAllEvents();
  Future<Event?> getEventById(String id);
  Future<String> createEvent(Event event);
  Future<void> updateEvent(Event event);
  Future<void> deleteEvent(String id);

  // Column operations
  Future<List<EventColumn>> getEventColumns(String eventId);
  Future<String> createColumn(EventColumn column);
  Future<void> updateColumn(EventColumn column);
  Future<void> deleteColumn(String columnId);
  Future<void> reorderColumns(String eventId, List<String> columnIds);

  // Row operations
  Future<List<EventRow>> getEventRows(String eventId);
  Future<String> createRow(EventRow row);
  Future<void> updateRow(EventRow row);
  Future<void> deleteRow(String rowId);
  Future<void> insertRowAtPosition(EventRow row, int position);
  Future<void> reorderRows(String eventId, List<String> rowIds);

  // Cell operations
  Future<List<Cell>> getEventCells(String eventId);
  Future<List<Cell>> getRowCells(String rowId);
  Future<Cell?> getCell(String rowId, String columnId);
  Future<String> createCell(Cell cell);
  Future<void> updateCell(Cell cell);
  Future<void> deleteCell(String cellId);

  // Totals operations
  Future<EventTotals?> getEventTotals(String eventId);
  Future<void> updateEventTotals(EventTotals totals);
  Future<EventTotals> calculateEventTotals(String eventId);

  // Bulk operations
  Future<void> createEventWithDefaults(Event event);
  Future<ExportData> exportEvents(List<String> eventIds);
  Future<List<String>> importEvents(ExportData exportData);

  // Utility operations
  Future<void> clearAllData();
  Future<int> getEventCount();
}
