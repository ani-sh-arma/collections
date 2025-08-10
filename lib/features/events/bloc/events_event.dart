import 'package:equatable/equatable.dart';
import '../../../core/models/models.dart';

abstract class EventsEvent extends Equatable {
  const EventsEvent();

  @override
  List<Object?> get props => [];
}

class LoadEvents extends EventsEvent {
  const LoadEvents();
}

class CreateEvent extends EventsEvent {
  final Event event;

  const CreateEvent(this.event);

  @override
  List<Object?> get props => [event];
}

class UpdateEvent extends EventsEvent {
  final Event event;

  const UpdateEvent(this.event);

  @override
  List<Object?> get props => [event];
}

class DeleteEvent extends EventsEvent {
  final String eventId;

  const DeleteEvent(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

class CopyEvent extends EventsEvent {
  final String eventId;

  const CopyEvent(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

class ToggleEventLock extends EventsEvent {
  final String eventId;

  const ToggleEventLock(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

class RefreshEvents extends EventsEvent {
  const RefreshEvents();
}
