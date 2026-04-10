import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../core/models/models.dart';
import '../../../core/repositories/event_repository.dart';
import '../../../constants/app_constants.dart';
import 'event_detail_state.dart';

class EventDetailCubit extends Cubit<EventDetailState> {
  final EventRepository _repository;
  String? _currentEventId;

  /// Cached copy of the most recent [EventDetailLoaded] state.
  /// Used by [updateCell] so cell edits are never dropped while a structural
  /// save has temporarily moved the state to [EventDetailSaving].
  EventDetailLoaded? _lastLoaded;

  /// Serialises background totals-persist calls so that a slower earlier
  /// write can never overwrite the result of a faster later write.
  Future<void> _totalsPersistFuture = Future.value();

  /// Per-cell debounce timers for background DB writes, keyed by 'rowId_columnId'.
  /// In-memory state updates are always immediate; only the DB write is deferred.
  final Map<String, Timer> _cellPersistTimers = {};

  EventDetailCubit({required EventRepository repository})
      : _repository = repository,
        super(const EventDetailInitial());

  @override
  Future<void> close() {
    for (final timer in _cellPersistTimers.values) {
      timer.cancel();
    }
    _cellPersistTimers.clear();
    return super.close();
  }

  /// Initial full load — shows a loading indicator and fetches all data.
  Future<void> loadEventDetail(String eventId) async {
    try {
      emit(const EventDetailLoading());
      _currentEventId = eventId;
      await _fetchAndEmitLoaded(eventId);
    } catch (e) {
      emit(EventDetailError('Failed to load event details: ${e.toString()}'));
    }
  }

  /// Quiet refresh — fetches fresh data and updates state WITHOUT going through
  /// [EventDetailLoading], so the table stays visible and there's no UI flash.
  Future<void> _quietRefresh() async {
    if (_currentEventId == null) return;
    try {
      await _fetchAndEmitLoaded(_currentEventId!);
    } catch (e) {
      emit(EventDetailError('Failed to refresh: ${e.toString()}'));
    }
  }

  /// Shared logic: fetch all event data and emit [EventDetailLoaded].
  Future<void> _fetchAndEmitLoaded(String eventId) async {
    final eventData = await _repository.getEventById(eventId);
    if (eventData == null) {
      emit(const EventDetailError('Event not found'));
      return;
    }

    final columns = await _repository.getEventColumns(eventId);
    final rows = await _repository.getEventRows(eventId);
    final cells = await _repository.getEventCells(eventId);
    final totals = await _repository.getEventTotals(eventId);

    final loaded = EventDetailLoaded(
        event: eventData,
        columns: columns,
        rows: rows,
        cells: cells,
        totals: totals,
      );
    _lastLoaded = loaded;
    emit(loaded);
  }

  Future<void> updateEventInfo(Event event) async {
    final currentState = state;
    if (currentState is! EventDetailLoaded) return;

    try {
      final updatedEvent = event.copyWith(updatedAt: DateTime.now());
      await _repository.updateEvent(updatedEvent);
      emit(currentState.copyWith(event: updatedEvent));
    } catch (e) {
      emit(EventDetailError('Failed to update event info: ${e.toString()}'));
    }
  }

  Future<void> toggleEventLock() async {
    final currentState = state;
    final loadedState = currentState is EventDetailLoaded
        ? currentState
        : _lastLoaded;
    if (loadedState == null) return;

    try {
      final updatedEvent = loadedState.event.copyWith(
        locked: !loadedState.event.locked,
        updatedAt: DateTime.now(),
      );

      await _repository.updateEvent(updatedEvent);
      final updatedLoaded = loadedState.copyWith(event: updatedEvent);
      _lastLoaded = updatedLoaded;
      emit(updatedLoaded);
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
        final addCol = currentState.columns[addColumnIndex];
        await _repository.updateColumn(
          addCol.copyWith(position: newPosition + 1),
        );
      }

      await _quietRefresh();
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
      await _quietRefresh();
    } catch (e) {
      emit(EventDetailError('Failed to delete column: ${e.toString()}'));
    }
  }

  Future<void> reorderColumns(List<String> columnIds) async {
    final currentState = state;
    if (currentState is! EventDetailLoaded || _currentEventId == null) return;

    try {
      await _repository.reorderColumns(_currentEventId!, columnIds);
      await _quietRefresh();
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
      await _quietRefresh();
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
      await _quietRefresh();
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
      await _quietRefresh();
      // Recalculate after the quiet refresh so totals reflect the deleted row.
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
      await _quietRefresh();
    } catch (e) {
      emit(EventDetailError('Failed to reorder rows: ${e.toString()}'));
    }
  }

  Future<void> updateCell(Cell cell) async {
    final currentState = state;
    // Also allow cell edits while a structural save is in progress by falling
    // back to the cached loaded state so edits are never silently dropped.
    final loadedState = currentState is EventDetailLoaded
        ? currentState
        : _lastLoaded;
    if (loadedState == null) return;

    // ── STEP 1 (IMMEDIATE): Optimistic in-memory update ─────────────────────
    // Compute the updated cell list and totals right now so the UI reflects
    // the new value without waiting for any DB round-trip.
    final optimisticCells = [
      for (final c in loadedState.cells)
        if (c.rowId != cell.rowId || c.columnId != cell.columnId) c,
      cell,
    ];

    final column = loadedState.getColumnById(cell.columnId);
    final affectsTotals = column != null &&
        (column.key == AppConstants.amountColumnKey ||
            column.key == AppConstants.onlineColumnKey);

    EventTotals? optimisticTotals = loadedState.totals;
    if (affectsTotals) {
      optimisticTotals = _computeTotalsFromCells(
        optimisticCells,
        loadedState.columns,
        loadedState.event.id,
      );
    }

    final optimisticLoaded = loadedState.copyWith(
      cells: optimisticCells,
      totals: optimisticTotals,
    );
    _lastLoaded = optimisticLoaded;
    if (currentState is EventDetailLoaded) {
      emit(optimisticLoaded);
    }

    // ── STEP 2 (DEBOUNCED): Persist to DB ───────────────────────────────────
    // Cancel any pending write for this cell and schedule a fresh one.
    final persistKey = '${cell.rowId}_${cell.columnId}';
    _cellPersistTimers[persistKey]?.cancel();
    _cellPersistTimers[persistKey] = Timer(AppConstants.autosaveDelay, () {
      _persistCell(cell, affectsTotals: affectsTotals);
    });
  }

  /// Writes [cell] to the database after fetching/assigning the correct row ID.
  /// Uses the most recent in-memory value from [_lastLoaded] so that rapid
  /// successive edits are coalesced into a single write with the latest value.
  Future<void> _persistCell(Cell cell, {required bool affectsTotals}) async {
    try {
      // Use the latest in-memory value for this cell, not the snapshot we
      // captured when the timer was scheduled, to avoid stale writes.
      final latestLoaded = _lastLoaded;
      final latestCell = latestLoaded?.cells.firstWhere(
        (c) => c.rowId == cell.rowId && c.columnId == cell.columnId,
        orElse: () => cell,
      ) ?? cell;

      final existingCell = await _repository.getCell(cell.rowId, cell.columnId);
      final Cell cellToSave;
      if (existingCell != null) {
        cellToSave = Cell(
          id: existingCell.id,
          rowId: latestCell.rowId,
          columnId: latestCell.columnId,
          valueText: latestCell.valueText,
          valueNumber: latestCell.valueNumber,
          valueBool: latestCell.valueBool,
        );
        await _repository.updateCell(cellToSave);
      } else {
        cellToSave = latestCell;
        await _repository.createCell(cellToSave);
      }

      // Sync the DB-assigned id back into _lastLoaded so future DB operations
      // use the correct primary key (avoids duplicate-insert bugs).
      final loaded = _lastLoaded;
      if (loaded != null) {
        final fixedCells = [
          for (final c in loaded.cells)
            if (c.rowId != cellToSave.rowId || c.columnId != cellToSave.columnId) c,
          cellToSave,
        ];
        _lastLoaded = loaded.copyWith(cells: fixedCells);
      }

      // Persist totals in background if this cell affected them.
      if (affectsTotals) {
        final currentTotals = _lastLoaded?.totals;
        if (currentTotals != null) {
          final totalsToSave = currentTotals;
          _totalsPersistFuture = _totalsPersistFuture.whenComplete(
            () => _repository
                .updateEventTotals(totalsToSave)
                .catchError((Object e) => log('Background totals persist failed: $e')),
          );
        }
      }
    } catch (e) {
      log('Failed to persist cell: $e');
    }
  }

  /// Immediately updates the in-memory state for a number cell without a DB
  /// write. Use this on every [onChanged] keystroke for instant totals preview;
  /// the actual DB write is handled by the debounced [updateCellNumber].
  void previewCellNumber({
    required String rowId,
    required String columnId,
    required double value,
  }) {
    _applyPreview(
      Cell(rowId: rowId, columnId: columnId).withNumberValue(value),
    );
  }

  /// Immediately updates the in-memory state for a boolean cell without a DB
  /// write. Use this for instant totals preview when toggling online/offline.
  void previewCellBool({
    required String rowId,
    required String columnId,
    required bool value,
  }) {
    _applyPreview(
      Cell(rowId: rowId, columnId: columnId).withBoolValue(value),
    );
  }

  /// Core logic for [previewCellNumber] / [previewCellBool].
  void _applyPreview(Cell cell) {
    final loadedState = state is EventDetailLoaded
        ? state as EventDetailLoaded
        : _lastLoaded;
    if (loadedState == null) return;

    final column = loadedState.getColumnById(cell.columnId);
    final affectsTotals = column != null &&
        (column.key == AppConstants.amountColumnKey ||
            column.key == AppConstants.onlineColumnKey);
    if (!affectsTotals) return; // Only bother for totals-affecting columns

    // Preserve the existing in-memory cell's id (avoid UUID churn).
    final existing = loadedState.cells.firstWhere(
      (c) => c.rowId == cell.rowId && c.columnId == cell.columnId,
      orElse: () => cell,
    );
    // Use the new cell's values but keep the existing id to avoid UUID churn.
    final previewCell = Cell(
      id: existing.id,
      rowId: cell.rowId,
      columnId: cell.columnId,
      valueText: cell.valueText,
      valueNumber: cell.valueNumber,
      valueBool: cell.valueBool,
    );

    final updatedCells = [
      for (final c in loadedState.cells)
        if (c.rowId != cell.rowId || c.columnId != cell.columnId) c,
      previewCell,
    ];

    final updatedTotals = _computeTotalsFromCells(
      updatedCells,
      loadedState.columns,
      loadedState.event.id,
    );

    final updatedLoaded = loadedState.copyWith(
      cells: updatedCells,
      totals: updatedTotals,
    );
    _lastLoaded = updatedLoaded;
    if (state is EventDetailLoaded) emit(updatedLoaded);
  }

  Future<void> updateCellText({
    required String rowId,
    required String columnId,
    required String value,
  }) async {
    final cell = Cell(rowId: rowId, columnId: columnId).withTextValue(value);
    await updateCell(cell);
  }

  Future<void> updateCellNumber({
    required String rowId,
    required String columnId,
    required double value,
  }) async {
    final cell = Cell(rowId: rowId, columnId: columnId).withNumberValue(value);
    await updateCell(cell);
  }

  Future<void> updateCellBool({
    required String rowId,
    required String columnId,
    required bool value,
  }) async {
    final cell = Cell(rowId: rowId, columnId: columnId).withBoolValue(value);
    await updateCell(cell);
  }

  /// Computes totals directly from the in-memory [cells] and [columns] lists,
  /// avoiding a database roundtrip for an instant UI update.
  /// Uses an O(n) lookup map keyed by 'rowId_columnId' for efficiency.
  EventTotals _computeTotalsFromCells(
    List<Cell> cells,
    List<EventColumn> columns,
    String eventId,
  ) {
    EventColumn? amountCol;
    EventColumn? onlineCol;
    for (final col in columns) {
      if (col.key == AppConstants.amountColumnKey) amountCol = col;
      if (col.key == AppConstants.onlineColumnKey) onlineCol = col;
    }

    if (amountCol == null || onlineCol == null) {
      return EventTotals.empty(eventId);
    }

    // Build a map for O(1) cell lookups keyed by 'rowId_columnId'.
    final cellMap = <String, Cell>{
      for (final c in cells) '${c.rowId}_${c.columnId}': c,
    };

    double onlineTotal = 0;
    double offlineTotal = 0;

    for (final amountCell in cells.where((c) => c.columnId == amountCol!.id)) {
      final amount = amountCell.valueNumber ?? 0.0;
      if (amount == 0.0) continue;
      final onlineCell = cellMap['${amountCell.rowId}_${onlineCol.id}'];
      final isOnline = onlineCell?.boolValue ?? false;
      if (isOnline) {
        onlineTotal += amount;
      } else {
        offlineTotal += amount;
      }
    }

    return EventTotals(
      eventId: eventId,
      onlineTotal: onlineTotal,
      offlineTotal: offlineTotal,
    );
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

  /// Public refresh — uses the quiet path so the table stays visible.
  Future<void> refreshEventDetail() async {
    await _quietRefresh();
  }
}

