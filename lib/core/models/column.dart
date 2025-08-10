import 'package:uuid/uuid.dart';

enum ColumnType {
  serial,
  text,
  number,
  boolean,
  action,
}

class EventColumn {
  final String id;
  final String eventId;
  final String key; // semantic key like 'serial', 'room', 'amount', 'online', 'addcol'
  final String label;
  final ColumnType type;
  final int position;
  final bool fixed; // whether this column can be deleted

  EventColumn({
    String? id,
    required this.eventId,
    required this.key,
    required this.label,
    required this.type,
    required this.position,
    this.fixed = false,
  }) : id = id ?? const Uuid().v4();

  EventColumn copyWith({
    String? id,
    String? eventId,
    String? key,
    String? label,
    ColumnType? type,
    int? position,
    bool? fixed,
  }) {
    return EventColumn(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      key: key ?? this.key,
      label: label ?? this.label,
      type: type ?? this.type,
      position: position ?? this.position,
      fixed: fixed ?? this.fixed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'key': key,
      'label': label,
      'type': type.name,
      'position': position,
      'fixed': fixed,
    };
  }

  factory EventColumn.fromJson(Map<String, dynamic> json) {
    return EventColumn(
      id: json['id'],
      eventId: json['eventId'],
      key: json['key'],
      label: json['label'],
      type: ColumnType.values.firstWhere((e) => e.name == json['type']),
      position: json['position'],
      fixed: json['fixed'] ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventColumn && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'EventColumn(id: $id, key: $key, label: $label, type: $type, position: $position)';
  }

  // Factory methods for default columns
  static EventColumn serial({
    required String eventId,
    int position = 0,
  }) {
    return EventColumn(
      eventId: eventId,
      key: 'serial',
      label: 'No.',
      type: ColumnType.serial,
      position: position,
      fixed: true,
    );
  }

  static EventColumn room({
    required String eventId,
    int position = 1,
  }) {
    return EventColumn(
      eventId: eventId,
      key: 'room',
      label: 'Room',
      type: ColumnType.text,
      position: position,
      fixed: true,
    );
  }

  static EventColumn amount({
    required String eventId,
    int position = 2,
  }) {
    return EventColumn(
      eventId: eventId,
      key: 'amount',
      label: 'Amount',
      type: ColumnType.number,
      position: position,
      fixed: true,
    );
  }

  static EventColumn online({
    required String eventId,
    int position = 3,
  }) {
    return EventColumn(
      eventId: eventId,
      key: 'online',
      label: 'Online',
      type: ColumnType.boolean,
      position: position,
      fixed: true,
    );
  }

  static EventColumn addColumn({
    required String eventId,
    int position = 4,
  }) {
    return EventColumn(
      eventId: eventId,
      key: 'addcol',
      label: '+',
      type: ColumnType.action,
      position: position,
      fixed: true,
    );
  }
}
