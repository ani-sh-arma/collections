import 'package:uuid/uuid.dart';

class Cell {
  final String id;
  final String rowId;
  final String columnId;
  final String? valueText;
  final double? valueNumber;
  final bool? valueBool;

  Cell({
    String? id,
    required this.rowId,
    required this.columnId,
    this.valueText,
    this.valueNumber,
    this.valueBool,
  }) : id = id ?? const Uuid().v4();

  Cell copyWith({
    String? id,
    String? rowId,
    String? columnId,
    String? valueText,
    double? valueNumber,
    bool? valueBool,
  }) {
    return Cell(
      id: id ?? this.id,
      rowId: rowId ?? this.rowId,
      columnId: columnId ?? this.columnId,
      valueText: valueText ?? this.valueText,
      valueNumber: valueNumber ?? this.valueNumber,
      valueBool: valueBool ?? this.valueBool,
    );
  }

  // Helper methods to get typed values
  String get textValue => valueText ?? '';
  double get numberValue => valueNumber ?? 0.0;
  bool get boolValue => valueBool ?? false;

  // Helper method to get display value
  String get displayValue {
    if (valueText != null) return valueText!;
    if (valueNumber != null) return valueNumber!.toString();
    if (valueBool != null) return valueBool! ? 'Yes' : 'No';
    return '';
  }

  // Helper methods to set values with type safety
  Cell withTextValue(String value) {
    return copyWith(
      valueText: value,
      valueNumber: null,
      valueBool: null,
    );
  }

  Cell withNumberValue(double value) {
    return copyWith(
      valueText: null,
      valueNumber: value,
      valueBool: null,
    );
  }

  Cell withBoolValue(bool value) {
    return copyWith(
      valueText: null,
      valueNumber: null,
      valueBool: value,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rowId': rowId,
      'columnId': columnId,
      'valueText': valueText,
      'valueNumber': valueNumber,
      'valueBool': valueBool,
    };
  }

  factory Cell.fromJson(Map<String, dynamic> json) {
    return Cell(
      id: json['id'],
      rowId: json['rowId'],
      columnId: json['columnId'],
      valueText: json['valueText'],
      valueNumber: json['valueNumber']?.toDouble(),
      valueBool: json['valueBool'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Cell && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Cell(id: $id, rowId: $rowId, columnId: $columnId, value: $displayValue)';
  }
}
