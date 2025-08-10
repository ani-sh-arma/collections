import 'package:equatable/equatable.dart';
import '../../../core/models/models.dart';

abstract class EventDetailEvent extends Equatable {
  const EventDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadEventDetail extends EventDetailEvent {
  final String eventId;

  const LoadEventDetail(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

class UpdateEventInfo extends EventDetailEvent {
  final Event event;

  const UpdateEventInfo(this.event);

  @override
  List<Object?> get props => [event];
}

class ToggleEventLock extends EventDetailEvent {
  const ToggleEventLock();
}

// Column operations
class AddColumn extends EventDetailEvent {
  final String label;
  final ColumnType type;

  const AddColumn({required this.label, required this.type});

  @override
  List<Object?> get props => [label, type];
}

class UpdateColumn extends EventDetailEvent {
  final EventColumn column;

  const UpdateColumn(this.column);

  @override
  List<Object?> get props => [column];
}

class DeleteColumn extends EventDetailEvent {
  final String columnId;

  const DeleteColumn(this.columnId);

  @override
  List<Object?> get props => [columnId];
}

class ReorderColumns extends EventDetailEvent {
  final List<String> columnIds;

  const ReorderColumns(this.columnIds);

  @override
  List<Object?> get props => [columnIds];
}

// Row operations
class AddRow extends EventDetailEvent {
  const AddRow();
}

class InsertRowAtPosition extends EventDetailEvent {
  final int position;

  const InsertRowAtPosition(this.position);

  @override
  List<Object?> get props => [position];
}

class DeleteRow extends EventDetailEvent {
  final String rowId;

  const DeleteRow(this.rowId);

  @override
  List<Object?> get props => [rowId];
}

class ReorderRows extends EventDetailEvent {
  final List<String> rowIds;

  const ReorderRows(this.rowIds);

  @override
  List<Object?> get props => [rowIds];
}

// Cell operations
class UpdateCell extends EventDetailEvent {
  final Cell cell;

  const UpdateCell(this.cell);

  @override
  List<Object?> get props => [cell];
}

class UpdateCellText extends EventDetailEvent {
  final String rowId;
  final String columnId;
  final String value;

  const UpdateCellText({
    required this.rowId,
    required this.columnId,
    required this.value,
  });

  @override
  List<Object?> get props => [rowId, columnId, value];
}

class UpdateCellNumber extends EventDetailEvent {
  final String rowId;
  final String columnId;
  final double value;

  const UpdateCellNumber({
    required this.rowId,
    required this.columnId,
    required this.value,
  });

  @override
  List<Object?> get props => [rowId, columnId, value];
}

class UpdateCellBool extends EventDetailEvent {
  final String rowId;
  final String columnId;
  final bool value;

  const UpdateCellBool({
    required this.rowId,
    required this.columnId,
    required this.value,
  });

  @override
  List<Object?> get props => [rowId, columnId, value];
}

// Totals operations
class RecalculateTotals extends EventDetailEvent {
  const RecalculateTotals();
}

class RefreshEventDetail extends EventDetailEvent {
  const RefreshEventDetail();
}
