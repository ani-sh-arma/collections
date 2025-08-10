import 'package:uuid/uuid.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final bool locked;
  final String gradientColorA;
  final String gradientColorB;
  final DateTime createdAt;
  final DateTime updatedAt;

  Event({
    String? id,
    required this.title,
    required this.description,
    required this.date,
    this.locked = false,
    required this.gradientColorA,
    required this.gradientColorB,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    bool? locked,
    String? gradientColorA,
    String? gradientColorB,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      locked: locked ?? this.locked,
      gradientColorA: gradientColorA ?? this.gradientColorA,
      gradientColorB: gradientColorB ?? this.gradientColorB,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.millisecondsSinceEpoch,
      'locked': locked,
      'gradientColorA': gradientColorA,
      'gradientColorB': gradientColorB,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      locked: json['locked'] ?? false,
      gradientColorA: json['gradientColorA'],
      gradientColorB: json['gradientColorB'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Event && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Event(id: $id, title: $title, date: $date, locked: $locked)';
  }
}
