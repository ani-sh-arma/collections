import 'package:equatable/equatable.dart';
import '../../../core/models/models.dart';

abstract class EventsState extends Equatable {
  const EventsState();

  @override
  List<Object?> get props => [];
}

class EventsInitial extends EventsState {
  const EventsInitial();
}

class EventsLoading extends EventsState {
  const EventsLoading();
}

class EventsLoaded extends EventsState {
  final List<Event> events;

  const EventsLoaded(this.events);

  @override
  List<Object?> get props => [events];
}

class EventsError extends EventsState {
  final String message;

  const EventsError(this.message);

  @override
  List<Object?> get props => [message];
}

class EventCreating extends EventsState {
  const EventCreating();
}

class EventCreated extends EventsState {
  final Event event;

  const EventCreated(this.event);

  @override
  List<Object?> get props => [event];
}

class EventUpdating extends EventsState {
  final String eventId;

  const EventUpdating(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

class EventUpdated extends EventsState {
  final Event event;

  const EventUpdated(this.event);

  @override
  List<Object?> get props => [event];
}

class EventDeleting extends EventsState {
  final String eventId;

  const EventDeleting(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

class EventDeleted extends EventsState {
  final String eventId;

  const EventDeleted(this.eventId);

  @override
  List<Object?> get props => [eventId];
}
