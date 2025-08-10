import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../core/models/models.dart';
import '../../../core/repositories/event_repository.dart';
import '../../../core/utils/debouncer.dart';
import '../../../core/constants/app_constants.dart';
import 'event_detail_event.dart';
import 'event_detail_state.dart';

class EventDetailBloc extends Bloc<EventDetailEvent, EventDetailState> {
  final EventRepository _repository;
  final Debouncer _debouncer;
  String? _currentEventId;

  EventDetailBloc({required EventRepository repository})
      : _repository = repository,
        _debouncer = Debouncer(delay: AppConstants.autosaveDelay),
        super(const EventDetailInitial()) {
    on<LoadEventDetail>(_onLoadEventDetail);
    on<UpdateEventInfo>(_onUpdateEventInfo);
    on<ToggleEventLock>(_onToggleEventLock);

    // Column operations
    on<AddColumn>(_onAddColumn);
    on<UpdateColumn>(_onUpdateColumn);
    on<DeleteColumn>(_onDeleteColumn);
    on<ReorderColumns>(_onReorderColumns);

    // Row operations
    on<AddRow>(_onAddRow);
    on<InsertRowAtPosition>(_onInsertRowAtPosition);
    on<DeleteRow>(_onDeleteRow);
    on<ReorderRows>(_onReorderRows);

    // Cell operations
    on<UpdateCell>(_onUpdateCell);
    on<UpdateCellText>(_onUpdateCellText);
    on<UpdateCellNumber>(_onUpdateCellNumber);
    on<UpdateCellBool>(_onUpdateCellBool);

    // Totals operations
    on<RecalculateTotals>(_onRecalculateTotals);
    on<RefreshEventDetail>(_onRefreshEventDetail);
  }

  @override
  Future<void> close() {
    _debouncer.dispose();
    return super.close();
  }

  Future<void> _onLoadEventDetail(LoadEventDetail event, Emitter<EventDetailState> emit) async {
    try {
      emit(const EventDetailLoading());
      _currentEventId = event.eventId;

      // Load all event data
      final eventData = await _repository.getEventById(event.eventId);
      if (eventData == null) {
        emit(const EventDetailError('Event not found'));
        return;
      }

      final columns = await _repository.getEventColumns(event.eventId);
      final rows = await _repository.getEventRows(event.eventId);
      final cells = await _repository.getEventCells(event.eventId);
      final totals = await _repository.getEventTotals(event.eventId);

      emit(EventDetailLoaded(
        event: eventData,
        columns: columns,
        rows: rows,
        cells: cells,
        totals: totals,
      ));
    } catch (e) {
      emit(EventDetailError('Failed to load event details: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateEventInfo(UpdateEventInfo event, Emitter<EventDetailState> emit) async {
    final currentState = state;
    if (currentState is! EventDetailLoaded) return;

    try {
      emit(const EventDetailSaving('Updating event info'));

      final updatedEvent = event.event.copyWith(updatedAt: DateTime.now());
      await _repository.updateEvent(updatedEvent);

      emit(currentState.copyWith(event: updatedEvent));
    } catch (e) {
      emit(EventDetailError('Failed to update event info: ${e.toString()}'));
    }
  }

  Future<void> _onToggleEventLock(ToggleEventLock event, Emitter<EventDetailState> emit) async {
    final currentState = state;
    if (currentState is! EventDetailLoaded) return;

    try {
      emit(const EventDetailSaving('Toggling lock'));

      final updatedEvent = currentState.event.copyWith(
        locked: !currentState.event.locked,
        updatedAt: DateTime.now(),
      );

      await _repository.updateEvent(updatedEvent);
      emit(currentState.copyWith(event: updatedEvent));
    } catch (e) {
      emit(EventDetailError('Failed to toggle lock: ${e.toString()}'));
    }
  }

  Future<void> _onAddColumn(AddColumn event, Emitter<EventDetailState> emit) async {
    final currentState = state;
    if (currentState is! EventDetailLoaded || _currentEventId == null) return;

    try {
      emit(const EventDetailSaving('Adding column'));

      // Find the position for the new column (before the add column button)
      final addColumnIndex = currentState.columns
          .indexWhere((col) => col.key == AppConstants.addColumnKey);
      final newPosition = addColumnIndex >= 0 ? addColumnIndex : currentState.columns.length;

      // Create new column
      final newColumn = EventColumn(
        eventId: _currentEventId!,
        key: const Uuid().v4(),
        label: event.label,
        type: event.type,
        position: newPosition,
        fixed: false,
      );

      await _repository.createColumn(newColumn);

      // Shift add column to the right if it exists
      if (addColumnIndex >= 0) {
        final addColumn = currentState.columns[addColumnIndex];
        await _repository.updateColumn(
          addColumn.copyWith(position: newPosition + 1),
        );
      }

      // Reload data
      add(const RefreshEventDetail());
    } catch (e) {
      emit(EventDetailError('Failed to add column: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateColumn(UpdateColumn event, Emitter<EventDetailState> emit) async {
    final currentState = state;
    if (currentState is! EventDetailLoaded) return;

    try {
      await _repository.updateColumn(event.column);

      // Update the column in current state
      final updatedColumns = currentState.columns.map((col) {
        return col.id == event.column.id ? event.column : col;
      }).toList();

      emit(currentState.copyWith(columns: updatedColumns));
    } catch (e) {
      emit(EventDetailError('Failed to update column: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteColumn(DeleteColumn event, Emitter<EventDetailState> emit) async {
    final currentState = state;
    if (currentState is! EventDetailLoaded) return;

    try {
      emit(const EventDetailSaving('Deleting column'));

      await _repository.deleteColumn(event.columnId);

      // Reload data to reflect changes
      add(const RefreshEventDetail());
    } catch (e) {
      emit(EventDetailError('Failed to delete column: ${e.toString()}'));
    }
  }

  Future<void> _onReorderColumns(ReorderColumns event, Emitter<EventDetailState> emit) async {
    final currentState = state;
    if (currentState is! EventDetailLoaded || _currentEventId == null) return;

    try {
      await _repository.reorderColumns(_currentEventId!, event.columnIds);

      // Reload data to reflect new order
      add(const RefreshEventDetail());
    } catch (e) {
      emit(EventDetailError('Failed to reorder columns: ${e.toString()}'));
    }
  }

  Future<void> _onAddRow(AddRow event, Emitter<EventDetailState> emit) async {
    final currentState = state;
    if (currentState is! EventDetailLoaded || _currentEventId == null) return;

    try {
      emit(const EventDetailSaving('Adding row'));

      // Find the next position
      final maxPosition = currentState.rows.isEmpty
          ? 0
          : currentState.rows.map((r) => r.position).reduce((a, b) => a > b ? a : b);

      final newRow = EventRow(
        eventId: _currentEventId!,
        position: maxPosition + 1,
      );

      await _repository.createRow(newRow);

      // Reload data
      add(const RefreshEventDetail());
    } catch (e) {
      emit(EventDetailError('Failed to add row: ${e.toString()}'));
    }
  }

  Future<void> _onInsertRowAtPosition(InsertRowAtPosition event, Emitter<EventDetailState> emit) async {
    final currentState = state;
    if (currentState is! EventDetailLoaded || _currentEventId == null) return;

    try {
      emit(const EventDetailSaving('Inserting row'));

      final newRow = EventRow(
        eventId: _currentEventId!,
        position: event.position,
      );

      await _repository.insertRowAtPosition(newRow, event.position);

      // Reload data
      add(const RefreshEventDetail());
    } catch (e) {
      emit(EventDetailError('Failed to insert row: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteRow(DeleteRow event, Emitter<EventDetailState> emit) async {
    final currentState = state;
    if (currentState is! EventDetailLoaded) return;

    try {
      emit(const EventDetailSaving('Deleting row'));

      await _repository.deleteRow(event.rowId);

      // Reload data and recalculate totals
      add(const RefreshEventDetail());
      add(const RecalculateTotals());
    } catch (e) {
      emit(EventDetailError('Failed to delete row: ${e.toString()}'));
    }
  }

  Future<void> _onReorderRows(ReorderRows event, Emitter<EventDetailState> emit) async {
    final currentState = state;
    if (currentState is! EventDetailLoaded || _currentEventId == null) return;

    try {
      await _repository.reorderRows(_currentEventId!, event.rowIds);

      // Reload data to reflect new order
      add(const RefreshEventDetail());
    } catch (e) {
      emit(EventDetailError('Failed to reorder rows: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateCell(UpdateCell event, Emitter<EventDetailState> emit) async {
    final currentState = state;
    if (currentState is! EventDetailLoaded) return;

    try {
      // Check if cell exists
      final existingCell = await _repository.getCell(event.cell.rowId, event.cell.columnId);

      if (existingCell != null) {
        await _repository.updateCell(event.cell);
      } else {
        await _repository.createCell(event.cell);
      }

      // Update the cell in current state
      final updatedCells = currentState.cells.where((cell) =>
          !(cell.rowId == event.cell.rowId && cell.columnId == event.cell.columnId)
      ).toList();
      updatedCells.add(event.cell);

      emit(currentState.copyWith(cells: updatedCells));

      // Recalculate totals if this affects amount or online columns
      final column = currentState.getColumnById(event.cell.columnId);
      if (column != null && (column.key == AppConstants.amountColumnKey || column.key == AppConstants.onlineColumnKey)) {
        add(const RecalculateTotals());
      }
    } catch (e) {
      emit(EventDetailError('Failed to update cell: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateCellText(UpdateCellText event, Emitter<EventDetailState> emit) async {
    final cell = Cell(
      rowId: event.rowId,
      columnId: event.columnId,
    ).withTextValue(event.value);

    add(UpdateCell(cell));
  }

  Future<void> _onUpdateCellNumber(UpdateCellNumber event, Emitter<EventDetailState> emit) async {
    final cell = Cell(
      rowId: event.rowId,
      columnId: event.columnId,
    ).withNumberValue(event.value);

    add(UpdateCell(cell));
  }

  Future<void> _onUpdateCellBool(UpdateCellBool event, Emitter<EventDetailState> emit) async {
    final cell = Cell(
      rowId: event.rowId,
      columnId: event.columnId,
    ).withBoolValue(event.value);

    add(UpdateCell(cell));
  }

  Future<void> _onRecalculateTotals(RecalculateTotals event, Emitter<EventDetailState> emit) async {
    final currentState = state;
    if (currentState is! EventDetailLoaded || _currentEventId == null) return;

    try {
      final totals = await _repository.calculateEventTotals(_currentEventId!);
      emit(currentState.copyWith(totals: totals));
    } catch (e) {
      // Don't emit error for totals calculation failure, just log it
      log('Failed to calculate totals: $e');
    }
  }

  Future<void> _onRefreshEventDetail(RefreshEventDetail event, Emitter<EventDetailState> emit) async {
    if (_currentEventId != null) {
      add(LoadEventDetail(_currentEventId!));
    }
  }
}
