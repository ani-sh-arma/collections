import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../core/models/models.dart';
import '../../../core/repositories/event_repository.dart';
import '../../../core/utils/debouncer.dart';
import '../../../core/constants/app_constants.dart';
import 'event_detail_state.dart';

class EventDetailCubit extends Cubit<EventDetailState> {
  final EventRepository _repository;
  final Debouncer _debouncer;
  String? _currentEventId;

  EventDetailCubit({required EventRepository repository})
      : _repository = repository,
        _debouncer = Debouncer(delay: AppConstants.autosaveDelay),
        super(const EventDetailInitial());

  @override
  Future<void> close() {
    _debouncer.dispose();
    return super.close();
  }

  Future<void> loadEventDetail(String eventId) async {
    try {
      emit(const EventDetailLoading());
      _currentEventId = eventId;

      final eventData = await _repository.getEventById(eventId);
      if (eventData == null) {
        emit(const EventDetailError('Event not found'));
        return;
      }

      final columns = await _repository.getEventColumns(eventId);
      final rows = await _repository.getEventRows(eventId);
      final cells = await _repository.getEventCells(eventId);
      final totals = await _repository.getEventTotals(eventId);

      emit(
        EventDetailLoaded(
          event: eventData,
          columns: columns,
          rows: rows,
          cells: cells,
          totals: totals,
        ),
      );
    } catch (e) {
      emit(EventDetailError('Failed to load event details: ${e.toString()}'));
    }
  }

  Future<void> updateEventInfo(Event event) async {
    final currentState = state;
    if (currentState is! EventDetailLoaded) return;

    try {
      emit(const EventDetailSaving('Updating event info'));

      final updatedEvent = event.copyWith(updatedAt: DateTime.now());
      await _repository.updateEvent(updatedEvent);

      emit(currentState.copyWith(event: updatedEvent));
    } catch (e) {
      emit(EventDetailError('Failed to update event info: ${e.toString()}'));
    }
  }

  Future<void> toggleEventLock() async {
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

  Future<void> addColumn({required String label, required ColumnType type}) async {
    final currentState = state;
    if (currentState is! EventDetailLoaded || _currentEventId == null) return;

    try {
      emit(const EventDetailSaving('Adding column'));

      final addColumnIndex = currentState.columns.indexWhere(
        (col) => col.key == AppConstants.addColumnKey,
      );
      final newPosition =
          addColumnIndex >= 0 ? addColumnIndex : currentState.columns.length;

      final newColumn = EventColumn(
        eventId: _currentEventId!,
        key: const Uuid().v4(),
        label: label,
        type: type,
        position: newPosition,
        fixed: false,
      );

      await _repository.createColumn(newColumn);

      if (addColumnIndex >= 0) {
        final addColumn = currentState.columns[addColumnIndex];
        await _repository.updateColumn(
          addColumn.copyWith(position: newPosition + 1),
        );
      }

      await refreshEventDetail();
    } catch (e) {
      emit(EventDetailError('Failed to add column: ${e.toString()}'));
    }
  }

  Future<void> updateColumn(EventColumn column) async {
    final currentState = state;
    if (currentState is! EventDetailLoaded) return;

    try {
      await _repository.updateColumn(column);

      final updatedColumns = currentState.columns.map((col) {
        return col.id == column.id ? column : col;
      }).toList();

      emit(currentState.copyWith(columns: updatedColumns));
      await refreshEventDetail();
    } catch (e) {
      emit(EventDetailError('Failed to update column: ${e.toString()}'));
    }
  }

  Future<void> deleteColumn(String columnId) async {
    final currentState = state;
    if (currentState is! EventDetailLoaded) return;

    try {
      emit(const EventDetailSaving('Deleting column'));

      await _repository.deleteColumn(columnId);

      await refreshEventDetail();
    } catch (e) {
      emit(EventDetailError('Failed to delete column: ${e.toString()}'));
    }
  }

  Future<void> reorderColumns(List<String> columnIds) async {
    final currentState = state;
    if (currentState is! EventDetailLoaded || _currentEventId == null) return;

    try {
      await _repository.reorderColumns(_currentEventId!, columnIds);

      await refreshEventDetail();
    } catch (e) {
      emit(EventDetailError('Failed to reorder columns: ${e.toString()}'));
    }
  }

  Future<void> addRow() async {
    final currentState = state;
    if (currentState is! EventDetailLoaded || _currentEventId == null) return;

    try {
      emit(const EventDetailSaving('Adding row'));

      final maxPosition = currentState.rows.isEmpty
          ? 0
          : currentState.rows.map((r) => r.position).reduce((a, b) => a > b ? a : b);

      final newRow = EventRow(
        eventId: _currentEventId!,
        position: maxPosition + 1,
      );

      await _repository.createRow(newRow);

      await refreshEventDetail();
    } catch (e) {
      emit(EventDetailError('Failed to add row: ${e.toString()}'));
    }
  }

  Future<void> insertRowAtPosition(int position) async {
    final currentState = state;
    if (currentState is! EventDetailLoaded || _currentEventId == null) return;

    try {
      emit(const EventDetailSaving('Inserting row'));

      final newRow = EventRow(
        eventId: _currentEventId!,
        position: position,
      );

      await _repository.insertRowAtPosition(newRow, position);

      await refreshEventDetail();
    } catch (e) {
      emit(EventDetailError('Failed to insert row: ${e.toString()}'));
    }
  }

  Future<void> deleteRow(String rowId) async {
    final currentState = state;
    if (currentState is! EventDetailLoaded) return;

    try {
      emit(const EventDetailSaving('Deleting row'));

      await _repository.deleteRow(rowId);

      await refreshEventDetail();
      await recalculateTotals();
    } catch (e) {
      emit(EventDetailError('Failed to delete row: ${e.toString()}'));
    }
  }

  Future<void> reorderRows(List<String> rowIds) async {
    final currentState = state;
    if (currentState is! EventDetailLoaded || _currentEventId == null) return;

    try {
      await _repository.reorderRows(_currentEventId!, rowIds);

      await refreshEventDetail();
    } catch (e) {
      emit(EventDetailError('Failed to reorder rows: ${e.toString()}'));
    }
  }

  Future<void> updateCell(Cell cell) async {
    final currentState = state;
    if (currentState is! EventDetailLoaded) return;

    try {
      final existingCell = await _repository.getCell(cell.rowId, cell.columnId);

      if (existingCell != null) {
        await _repository.updateCell(cell);
      } else {
        await _repository.createCell(cell);
      }

      final updatedCells = currentState.cells
          .where((c) => !(c.rowId == cell.rowId && c.columnId == cell.columnId))
          .toList();
      updatedCells.add(cell);

      emit(currentState.copyWith(cells: updatedCells));

      final column = currentState.getColumnById(cell.columnId);
      if (column != null &&
          (column.key == AppConstants.amountColumnKey ||
              column.key == AppConstants.onlineColumnKey)) {
        await recalculateTotals();
      }
    } catch (e) {
      emit(EventDetailError('Failed to update cell: ${e.toString()}'));
    }
  }

  Future<void> updateCellText({required String rowId, required String columnId, required String value}) async {
    final cell = Cell(rowId: rowId, columnId: columnId).withTextValue(value);
    await updateCell(cell);
  }

  Future<void> updateCellNumber({required String rowId, required String columnId, required double value}) async {
    final cell = Cell(rowId: rowId, columnId: columnId).withNumberValue(value);
    await updateCell(cell);
  }

  Future<void> updateCellBool({required String rowId, required String columnId, required bool value}) async {
    final cell = Cell(rowId: rowId, columnId: columnId).withBoolValue(value);
    await updateCell(cell);
  }

  Future<void> recalculateTotals() async {
    final currentState = state;
    if (currentState is! EventDetailLoaded || _currentEventId == null) return;

    try {
      final totals = await _repository.calculateEventTotals(_currentEventId!);
      emit(currentState.copyWith(totals: totals));
    } catch (e) {
      log('Failed to calculate totals: $e');
    }
  }

  Future<void> refreshEventDetail() async {
    if (_currentEventId != null) {
      await loadEventDetail(_currentEventId!);
    }
  }
}

