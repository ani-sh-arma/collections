import 'package:equatable/equatable.dart';
import '../../../core/models/models.dart';

abstract class EventDetailState extends Equatable {
  const EventDetailState();

  @override
  List<Object?> get props => [];
}

class EventDetailInitial extends EventDetailState {
  const EventDetailInitial();
}

class EventDetailLoading extends EventDetailState {
  const EventDetailLoading();
}

class EventDetailLoaded extends EventDetailState {
  final Event event;
  final List<EventColumn> columns;
  final List<EventRow> rows;
  final List<Cell> cells;
  final EventTotals? totals;

  const EventDetailLoaded({
    required this.event,
    required this.columns,
    required this.rows,
    required this.cells,
    this.totals,
  });

  @override
  List<Object?> get props => [event, columns, rows, cells, totals];

  EventDetailLoaded copyWith({
    Event? event,
    List<EventColumn>? columns,
    List<EventRow>? rows,
    List<Cell>? cells,
    EventTotals? totals,
  }) {
    return EventDetailLoaded(
      event: event ?? this.event,
      columns: columns ?? this.columns,
      rows: rows ?? this.rows,
      cells: cells ?? this.cells,
      totals: totals ?? this.totals,
    );
  }

  // Helper methods to get data by ID
  EventColumn? getColumnById(String columnId) {
    try {
      return columns.firstWhere((col) => col.id == columnId);
    } catch (e) {
      return null;
    }
  }

  EventRow? getRowById(String rowId) {
    try {
      return rows.firstWhere((row) => row.id == rowId);
    } catch (e) {
      return null;
    }
  }

  Cell? getCell(String rowId, String columnId) {
    try {
      return cells.firstWhere(
        (cell) => cell.rowId == rowId && cell.columnId == columnId,
      );
    } catch (e) {
      return null;
    }
  }

  List<Cell> getCellsForRow(String rowId) {
    return cells.where((cell) => cell.rowId == rowId).toList();
  }

  List<Cell> getCellsForColumn(String columnId) {
    return cells.where((cell) => cell.columnId == columnId).toList();
  }

  // Helper to check if event is locked
  bool get isLocked => event.locked;

  // Helper to get sorted columns
  List<EventColumn> get sortedColumns {
    final sorted = List<EventColumn>.from(columns);
    sorted.sort((a, b) => a.position.compareTo(b.position));
    return sorted;
  }

  // Helper to get sorted rows
  List<EventRow> get sortedRows {
    final sorted = List<EventRow>.from(rows);
    sorted.sort((a, b) => a.position.compareTo(b.position));
    return sorted;
  }
}

class EventDetailError extends EventDetailState {
  final String message;

  const EventDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

class EventDetailSaving extends EventDetailState {
  final String operation;

  const EventDetailSaving(this.operation);

  @override
  List<Object?> get props => [operation];
}

class EventDetailOperationSuccess extends EventDetailState {
  final String message;

  const EventDetailOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
