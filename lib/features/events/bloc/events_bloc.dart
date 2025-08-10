import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../core/models/models.dart';
import '../../../core/repositories/event_repository.dart';
import '../../../core/utils/gradient_generator.dart';
import 'events_event.dart';
import 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final EventRepository _repository;

  EventsBloc({required EventRepository repository})
      : _repository = repository,
        super(const EventsInitial()) {
    on<LoadEvents>(_onLoadEvents);
    on<CreateEvent>(_onCreateEvent);
    on<UpdateEvent>(_onUpdateEvent);
    on<DeleteEvent>(_onDeleteEvent);
    on<CopyEvent>(_onCopyEvent);
    on<ToggleEventLock>(_onToggleEventLock);
    on<RefreshEvents>(_onRefreshEvents);
  }

  Future<void> _onLoadEvents(LoadEvents event, Emitter<EventsState> emit) async {
    try {
      emit(const EventsLoading());
      final events = await _repository.getAllEvents();
      emit(EventsLoaded(events));
    } catch (e) {
      emit(EventsError('Failed to load events: ${e.toString()}'));
    }
  }

  Future<void> _onCreateEvent(CreateEvent event, Emitter<EventsState> emit) async {
    try {
      emit(const EventCreating());
      
      // Generate gradient colors if not provided
      Event eventToCreate = event.event;
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
      add(const LoadEvents());
    } catch (e) {
      emit(EventsError('Failed to create event: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateEvent(UpdateEvent event, Emitter<EventsState> emit) async {
    try {
      emit(EventUpdating(event.event.id));
      
      final updatedEvent = event.event.copyWith(updatedAt: DateTime.now());
      await _repository.updateEvent(updatedEvent);
      emit(EventUpdated(updatedEvent));
      
      // Reload events to show the updated one
      add(const LoadEvents());
    } catch (e) {
      emit(EventsError('Failed to update event: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteEvent(DeleteEvent event, Emitter<EventsState> emit) async {
    try {
      emit(EventDeleting(event.eventId));
      await _repository.deleteEvent(event.eventId);
      emit(EventDeleted(event.eventId));
      
      // Reload events to remove the deleted one
      add(const LoadEvents());
    } catch (e) {
      emit(EventsError('Failed to delete event: ${e.toString()}'));
    }
  }

  Future<void> _onCopyEvent(CopyEvent event, Emitter<EventsState> emit) async {
    try {
      emit(const EventCreating());
      
      // Get the original event
      final originalEvent = await _repository.getEventById(event.eventId);
      if (originalEvent == null) {
        emit(const EventsError('Event not found'));
        return;
      }

      // Export the original event data
      final exportData = await _repository.exportEvents([event.eventId]);
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
      add(const LoadEvents());
    } catch (e) {
      emit(EventsError('Failed to copy event: ${e.toString()}'));
    }
  }

  Future<void> _onToggleEventLock(ToggleEventLock event, Emitter<EventsState> emit) async {
    try {
      emit(EventUpdating(event.eventId));
      
      final existingEvent = await _repository.getEventById(event.eventId);
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
      add(const LoadEvents());
    } catch (e) {
      emit(EventsError('Failed to toggle event lock: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshEvents(RefreshEvents event, Emitter<EventsState> emit) async {
    add(const LoadEvents());
  }
}
