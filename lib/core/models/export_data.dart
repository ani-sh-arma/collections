import 'event.dart';
import 'column.dart';
import 'row.dart';
import 'cell.dart';
import 'event_totals.dart';

class ExportData {
  final String version;
  final DateTime exportedAt;
  final List<EventExportData> events;

  ExportData({
    this.version = '1.0.0',
    DateTime? exportedAt,
    required this.events,
  }) : exportedAt = exportedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'exportedAt': exportedAt.millisecondsSinceEpoch,
      'events': events.map((e) => e.toJson()).toList(),
    };
  }

  factory ExportData.fromJson(Map<String, dynamic> json) {
    return ExportData(
      version: json['version'] ?? '1.0.0',
      exportedAt: DateTime.fromMillisecondsSinceEpoch(json['exportedAt']),
      events: (json['events'] as List)
          .map((e) => EventExportData.fromJson(e))
          .toList(),
    );
  }
}

class EventExportData {
  final Event event;
  final List<EventColumn> columns;
  final List<EventRow> rows;
  final List<Cell> cells;
  final EventTotals? totals;

  EventExportData({
    required this.event,
    required this.columns,
    required this.rows,
    required this.cells,
    this.totals,
  });

  Map<String, dynamic> toJson() {
    return {
      'event': event.toJson(),
      'columns': columns.map((c) => c.toJson()).toList(),
      'rows': rows.map((r) => r.toJson()).toList(),
      'cells': cells.map((c) => c.toJson()).toList(),
      'totals': totals?.toJson(),
    };
  }

  factory EventExportData.fromJson(Map<String, dynamic> json) {
    return EventExportData(
      event: Event.fromJson(json['event']),
      columns: (json['columns'] as List)
          .map((c) => EventColumn.fromJson(c))
          .toList(),
      rows: (json['rows'] as List)
          .map((r) => EventRow.fromJson(r))
          .toList(),
      cells: (json['cells'] as List)
          .map((c) => Cell.fromJson(c))
          .toList(),
      totals: json['totals'] != null 
          ? EventTotals.fromJson(json['totals'])
          : null,
    );
  }
}
