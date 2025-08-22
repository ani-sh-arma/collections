import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../core/models/models.dart';
import '../../../core/repositories/event_repository.dart';
import '../../../core/utils/gradient_generator.dart';
import 'events_state.dart';

class EventsCubit extends Cubit<EventsState> {
  final EventRepository _repository;

  EventsCubit({required EventRepository repository})
      : _repository = repository,
        super(const EventsInitial());

  Future<void> loadEvents() async {
    try {
      emit(const EventsLoading());
      final events = await _repository.getAllEvents();
      emit(EventsLoaded(events));
    } catch (e) {
      emit(EventsError('Failed to load events: ${e.toString()}'));
    }
  }

  Future<void> createEvent(Event event) async {
    try {
      emit(const EventCreating());

      // Generate gradient colors if not provided
      Event eventToCreate = event;
      if (eventToCreate.gradientColorA.isEmpty || eventToCreate.gradientColorB.isEmpty) {
        final gradientHex = GradientGenerator.getRandomGradientHex();
        eventToCreate = eventToCreate.copyWith(
          gradientColorA: gradientHex['colorA']!,
          gradientColorB: gradientHex['colorB']!,
        );
      }

      await _repository.createEventWithDefaults(eventToCreate);
      emit(EventCreated(eventToCreate));

      // Reload events to show the new one
      await loadEvents();
    } catch (e) {
      emit(EventsError('Failed to create event: ${e.toString()}'));
    }
  }

  Future<void> updateEvent(Event event) async {
    try {
      emit(EventUpdating(event.id));

      final updatedEvent = event.copyWith(updatedAt: DateTime.now());
      await _repository.updateEvent(updatedEvent);
      emit(EventUpdated(updatedEvent));

      // Reload events to show the updated one
      await loadEvents();
    } catch (e) {
      emit(EventsError('Failed to update event: ${e.toString()}'));
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      emit(EventDeleting(eventId));
      await _repository.deleteEvent(eventId);
      emit(EventDeleted(eventId));

      // Reload events to remove the deleted one
      await loadEvents();
    } catch (e) {
      emit(EventsError('Failed to delete event: ${e.toString()}'));
    }
  }

  Future<void> copyEvent(String eventId) async {
    try {
      emit(const EventCreating());

      // Get the original event
      final originalEvent = await _repository.getEventById(eventId);
      if (originalEvent == null) {
        emit(const EventsError('Event not found'));
        return;
      }

      // Export the original event data
      final exportData = await _repository.exportEvents([eventId]);
      if (exportData.events.isEmpty) {
        emit(const EventsError('Failed to copy event data'));
        return;
      }

      // Create a copy with new ID and modified title
      final originalEventData = exportData.events.first;
      final gradientHex = GradientGenerator.getRandomGradientHex();

      final copiedEvent = originalEventData.event.copyWith(
        id: const Uuid().v4(),
        title: '${originalEventData.event.title} (Copy)',
        gradientColorA: gradientHex['colorA']!,
        gradientColorB: gradientHex['colorB']!,
        locked: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Create the copied event with all its data
      await _repository.createEventWithDefaults(copiedEvent);

      // Import the original data structure (columns, rows, cells)
      final modifiedExportData = ExportData(
        events: [
          EventExportData(
            event: copiedEvent,
            columns: originalEventData.columns,
            rows: originalEventData.rows,
            cells: originalEventData.cells,
            totals: originalEventData.totals,
          ),
        ],
      );

      await _repository.importEvents(modifiedExportData);
      emit(EventCreated(copiedEvent));

      // Reload events to show the new copy
      await loadEvents();
    } catch (e) {
      emit(EventsError('Failed to copy event: ${e.toString()}'));
    }
  }

  Future<void> toggleEventLock(String eventId) async {
    try {
      emit(EventUpdating(eventId));

      final existingEvent = await _repository.getEventById(eventId);
      if (existingEvent == null) {
        emit(const EventsError('Event not found'));
        return;
      }

      final updatedEvent = existingEvent.copyWith(
        locked: !existingEvent.locked,
        updatedAt: DateTime.now(),
      );

      await _repository.updateEvent(updatedEvent);
      emit(EventUpdated(updatedEvent));

      // Reload events to show the updated lock status
      await loadEvents();
    } catch (e) {
      emit(EventsError('Failed to toggle event lock: ${e.toString()}'));
    }
  }

  Future<void> refreshEvents() async {
    await loadEvents();
  }
}

