class EventTotals {
  final String eventId;
  final double onlineTotal;
  final double offlineTotal;
  final double grandTotal;
  final DateTime updatedAt;

  EventTotals({
    required this.eventId,
    required this.onlineTotal,
    required this.offlineTotal,
    DateTime? updatedAt,
  })  : grandTotal = onlineTotal + offlineTotal,
        updatedAt = updatedAt ?? DateTime.now();

  EventTotals copyWith({
    String? eventId,
    double? onlineTotal,
    double? offlineTotal,
    DateTime? updatedAt,
  }) {
    return EventTotals(
      eventId: eventId ?? this.eventId,
      onlineTotal: onlineTotal ?? this.onlineTotal,
      offlineTotal: offlineTotal ?? this.offlineTotal,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'onlineTotal': onlineTotal,
      'offlineTotal': offlineTotal,
      'grandTotal': grandTotal,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory EventTotals.fromJson(Map<String, dynamic> json) {
    return EventTotals(
      eventId: json['eventId'],
      onlineTotal: json['onlineTotal']?.toDouble() ?? 0.0,
      offlineTotal: json['offlineTotal']?.toDouble() ?? 0.0,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventTotals && other.eventId == eventId;
  }

  @override
  int get hashCode => eventId.hashCode;

  @override
  String toString() {
    return 'EventTotals(eventId: $eventId, online: $onlineTotal, offline: $offlineTotal, total: $grandTotal)';
  }

  // Factory method for empty totals
  static EventTotals empty(String eventId) {
    return EventTotals(
      eventId: eventId,
      onlineTotal: 0.0,
      offlineTotal: 0.0,
    );
  }
}
