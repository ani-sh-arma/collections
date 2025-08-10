import 'package:uuid/uuid.dart';

class EventRow {
  final String id;
  final String eventId;
  final int position; // 1-based index
  final DateTime createdAt;
  final DateTime updatedAt;

  EventRow({
    String? id,
    required this.eventId,
    required this.position,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  EventRow copyWith({
    String? id,
    String? eventId,
    int? position,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EventRow(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'position': position,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory EventRow.fromJson(Map<String, dynamic> json) {
    return EventRow(
      id: json['id'],
      eventId: json['eventId'],
      position: json['position'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventRow && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'EventRow(id: $id, eventId: $eventId, position: $position)';
  }
}
