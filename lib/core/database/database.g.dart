// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $EventsTable extends Events with TableInfo<$EventsTable, EventData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<int> date = GeneratedColumn<int>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lockedMeta = const VerificationMeta('locked');
  @override
  late final GeneratedColumn<bool> locked = GeneratedColumn<bool>(
    'locked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("locked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _gradientColorAMeta = const VerificationMeta(
    'gradientColorA',
  );
  @override
  late final GeneratedColumn<String> gradientColorA = GeneratedColumn<String>(
    'gradient_color_a',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gradientColorBMeta = const VerificationMeta(
    'gradientColorB',
  );
  @override
  late final GeneratedColumn<String> gradientColorB = GeneratedColumn<String>(
    'gradient_color_b',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    date,
    locked,
    gradientColorA,
    gradientColorB,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'events';
  @override
  VerificationContext validateIntegrity(
    Insertable<EventData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('locked')) {
      context.handle(
        _lockedMeta,
        locked.isAcceptableOrUnknown(data['locked']!, _lockedMeta),
      );
    }
    if (data.containsKey('gradient_color_a')) {
      context.handle(
        _gradientColorAMeta,
        gradientColorA.isAcceptableOrUnknown(
          data['gradient_color_a']!,
          _gradientColorAMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_gradientColorAMeta);
    }
    if (data.containsKey('gradient_color_b')) {
      context.handle(
        _gradientColorBMeta,
        gradientColorB.isAcceptableOrUnknown(
          data['gradient_color_b']!,
          _gradientColorBMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_gradientColorBMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      title:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}title'],
          )!,
      description:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}description'],
          )!,
      date:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}date'],
          )!,
      locked:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}locked'],
          )!,
      gradientColorA:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}gradient_color_a'],
          )!,
      gradientColorB:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}gradient_color_b'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(attachedDatabase, alias);
  }
}

class EventData extends DataClass implements Insertable<EventData> {
  final String id;
  final String title;
  final String description;
  final int date;
  final bool locked;
  final String gradientColorA;
  final String gradientColorB;
  final int createdAt;
  final int updatedAt;
  const EventData({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.locked,
    required this.gradientColorA,
    required this.gradientColorB,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['date'] = Variable<int>(date);
    map['locked'] = Variable<bool>(locked);
    map['gradient_color_a'] = Variable<String>(gradientColorA);
    map['gradient_color_b'] = Variable<String>(gradientColorB);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      date: Value(date),
      locked: Value(locked),
      gradientColorA: Value(gradientColorA),
      gradientColorB: Value(gradientColorB),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory EventData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      date: serializer.fromJson<int>(json['date']),
      locked: serializer.fromJson<bool>(json['locked']),
      gradientColorA: serializer.fromJson<String>(json['gradientColorA']),
      gradientColorB: serializer.fromJson<String>(json['gradientColorB']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'date': serializer.toJson<int>(date),
      'locked': serializer.toJson<bool>(locked),
      'gradientColorA': serializer.toJson<String>(gradientColorA),
      'gradientColorB': serializer.toJson<String>(gradientColorB),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  EventData copyWith({
    String? id,
    String? title,
    String? description,
    int? date,
    bool? locked,
    String? gradientColorA,
    String? gradientColorB,
    int? createdAt,
    int? updatedAt,
  }) => EventData(
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
  EventData copyWithCompanion(EventsCompanion data) {
    return EventData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      date: data.date.present ? data.date.value : this.date,
      locked: data.locked.present ? data.locked.value : this.locked,
      gradientColorA:
          data.gradientColorA.present
              ? data.gradientColorA.value
              : this.gradientColorA,
      gradientColorB:
          data.gradientColorB.present
              ? data.gradientColorB.value
              : this.gradientColorB,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('locked: $locked, ')
          ..write('gradientColorA: $gradientColorA, ')
          ..write('gradientColorB: $gradientColorB, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    date,
    locked,
    gradientColorA,
    gradientColorB,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventData &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.date == this.date &&
          other.locked == this.locked &&
          other.gradientColorA == this.gradientColorA &&
          other.gradientColorB == this.gradientColorB &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EventsCompanion extends UpdateCompanion<EventData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<int> date;
  final Value<bool> locked;
  final Value<String> gradientColorA;
  final Value<String> gradientColorB;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.date = const Value.absent(),
    this.locked = const Value.absent(),
    this.gradientColorA = const Value.absent(),
    this.gradientColorB = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventsCompanion.insert({
    required String id,
    required String title,
    required String description,
    required int date,
    this.locked = const Value.absent(),
    required String gradientColorA,
    required String gradientColorB,
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       description = Value(description),
       date = Value(date),
       gradientColorA = Value(gradientColorA),
       gradientColorB = Value(gradientColorB),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<EventData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? date,
    Expression<bool>? locked,
    Expression<String>? gradientColorA,
    Expression<String>? gradientColorB,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (date != null) 'date': date,
      if (locked != null) 'locked': locked,
      if (gradientColorA != null) 'gradient_color_a': gradientColorA,
      if (gradientColorB != null) 'gradient_color_b': gradientColorB,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? description,
    Value<int>? date,
    Value<bool>? locked,
    Value<String>? gradientColorA,
    Value<String>? gradientColorB,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return EventsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      locked: locked ?? this.locked,
      gradientColorA: gradientColorA ?? this.gradientColorA,
      gradientColorB: gradientColorB ?? this.gradientColorB,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (locked.present) {
      map['locked'] = Variable<bool>(locked.value);
    }
    if (gradientColorA.present) {
      map['gradient_color_a'] = Variable<String>(gradientColorA.value);
    }
    if (gradientColorB.present) {
      map['gradient_color_b'] = Variable<String>(gradientColorB.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('locked: $locked, ')
          ..write('gradientColorA: $gradientColorA, ')
          ..write('gradientColorB: $gradientColorB, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ColumnsTable extends Columns with TableInfo<$ColumnsTable, ColumnData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ColumnsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES events (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fixedMeta = const VerificationMeta('fixed');
  @override
  late final GeneratedColumn<bool> fixed = GeneratedColumn<bool>(
    'fixed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("fixed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    eventId,
    key,
    label,
    type,
    position,
    fixed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'columns';
  @override
  VerificationContext validateIntegrity(
    Insertable<ColumnData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('fixed')) {
      context.handle(
        _fixedMeta,
        fixed.isAcceptableOrUnknown(data['fixed']!, _fixedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ColumnData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ColumnData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      eventId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}event_id'],
          )!,
      key:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}key'],
          )!,
      label:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}label'],
          )!,
      type:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}type'],
          )!,
      position:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}position'],
          )!,
      fixed:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}fixed'],
          )!,
    );
  }

  @override
  $ColumnsTable createAlias(String alias) {
    return $ColumnsTable(attachedDatabase, alias);
  }
}

class ColumnData extends DataClass implements Insertable<ColumnData> {
  final String id;
  final String eventId;
  final String key;
  final String label;
  final String type;
  final int position;
  final bool fixed;
  const ColumnData({
    required this.id,
    required this.eventId,
    required this.key,
    required this.label,
    required this.type,
    required this.position,
    required this.fixed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['event_id'] = Variable<String>(eventId);
    map['key'] = Variable<String>(key);
    map['label'] = Variable<String>(label);
    map['type'] = Variable<String>(type);
    map['position'] = Variable<int>(position);
    map['fixed'] = Variable<bool>(fixed);
    return map;
  }

  ColumnsCompanion toCompanion(bool nullToAbsent) {
    return ColumnsCompanion(
      id: Value(id),
      eventId: Value(eventId),
      key: Value(key),
      label: Value(label),
      type: Value(type),
      position: Value(position),
      fixed: Value(fixed),
    );
  }

  factory ColumnData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ColumnData(
      id: serializer.fromJson<String>(json['id']),
      eventId: serializer.fromJson<String>(json['eventId']),
      key: serializer.fromJson<String>(json['key']),
      label: serializer.fromJson<String>(json['label']),
      type: serializer.fromJson<String>(json['type']),
      position: serializer.fromJson<int>(json['position']),
      fixed: serializer.fromJson<bool>(json['fixed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'eventId': serializer.toJson<String>(eventId),
      'key': serializer.toJson<String>(key),
      'label': serializer.toJson<String>(label),
      'type': serializer.toJson<String>(type),
      'position': serializer.toJson<int>(position),
      'fixed': serializer.toJson<bool>(fixed),
    };
  }

  ColumnData copyWith({
    String? id,
    String? eventId,
    String? key,
    String? label,
    String? type,
    int? position,
    bool? fixed,
  }) => ColumnData(
    id: id ?? this.id,
    eventId: eventId ?? this.eventId,
    key: key ?? this.key,
    label: label ?? this.label,
    type: type ?? this.type,
    position: position ?? this.position,
    fixed: fixed ?? this.fixed,
  );
  ColumnData copyWithCompanion(ColumnsCompanion data) {
    return ColumnData(
      id: data.id.present ? data.id.value : this.id,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      key: data.key.present ? data.key.value : this.key,
      label: data.label.present ? data.label.value : this.label,
      type: data.type.present ? data.type.value : this.type,
      position: data.position.present ? data.position.value : this.position,
      fixed: data.fixed.present ? data.fixed.value : this.fixed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ColumnData(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('key: $key, ')
          ..write('label: $label, ')
          ..write('type: $type, ')
          ..write('position: $position, ')
          ..write('fixed: $fixed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, eventId, key, label, type, position, fixed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ColumnData &&
          other.id == this.id &&
          other.eventId == this.eventId &&
          other.key == this.key &&
          other.label == this.label &&
          other.type == this.type &&
          other.position == this.position &&
          other.fixed == this.fixed);
}

class ColumnsCompanion extends UpdateCompanion<ColumnData> {
  final Value<String> id;
  final Value<String> eventId;
  final Value<String> key;
  final Value<String> label;
  final Value<String> type;
  final Value<int> position;
  final Value<bool> fixed;
  final Value<int> rowid;
  const ColumnsCompanion({
    this.id = const Value.absent(),
    this.eventId = const Value.absent(),
    this.key = const Value.absent(),
    this.label = const Value.absent(),
    this.type = const Value.absent(),
    this.position = const Value.absent(),
    this.fixed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ColumnsCompanion.insert({
    required String id,
    required String eventId,
    required String key,
    required String label,
    required String type,
    required int position,
    this.fixed = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       eventId = Value(eventId),
       key = Value(key),
       label = Value(label),
       type = Value(type),
       position = Value(position);
  static Insertable<ColumnData> custom({
    Expression<String>? id,
    Expression<String>? eventId,
    Expression<String>? key,
    Expression<String>? label,
    Expression<String>? type,
    Expression<int>? position,
    Expression<bool>? fixed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventId != null) 'event_id': eventId,
      if (key != null) 'key': key,
      if (label != null) 'label': label,
      if (type != null) 'type': type,
      if (position != null) 'position': position,
      if (fixed != null) 'fixed': fixed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ColumnsCompanion copyWith({
    Value<String>? id,
    Value<String>? eventId,
    Value<String>? key,
    Value<String>? label,
    Value<String>? type,
    Value<int>? position,
    Value<bool>? fixed,
    Value<int>? rowid,
  }) {
    return ColumnsCompanion(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      key: key ?? this.key,
      label: label ?? this.label,
      type: type ?? this.type,
      position: position ?? this.position,
      fixed: fixed ?? this.fixed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (fixed.present) {
      map['fixed'] = Variable<bool>(fixed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ColumnsCompanion(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('key: $key, ')
          ..write('label: $label, ')
          ..write('type: $type, ')
          ..write('position: $position, ')
          ..write('fixed: $fixed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RowsTable extends Rows with TableInfo<$RowsTable, RowData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES events (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    eventId,
    position,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<RowData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RowData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RowData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      eventId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}event_id'],
          )!,
      position:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}position'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $RowsTable createAlias(String alias) {
    return $RowsTable(attachedDatabase, alias);
  }
}

class RowData extends DataClass implements Insertable<RowData> {
  final String id;
  final String eventId;
  final int position;
  final int createdAt;
  final int updatedAt;
  const RowData({
    required this.id,
    required this.eventId,
    required this.position,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['event_id'] = Variable<String>(eventId);
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  RowsCompanion toCompanion(bool nullToAbsent) {
    return RowsCompanion(
      id: Value(id),
      eventId: Value(eventId),
      position: Value(position),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RowData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RowData(
      id: serializer.fromJson<String>(json['id']),
      eventId: serializer.fromJson<String>(json['eventId']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'eventId': serializer.toJson<String>(eventId),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  RowData copyWith({
    String? id,
    String? eventId,
    int? position,
    int? createdAt,
    int? updatedAt,
  }) => RowData(
    id: id ?? this.id,
    eventId: eventId ?? this.eventId,
    position: position ?? this.position,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RowData copyWithCompanion(RowsCompanion data) {
    return RowData(
      id: data.id.present ? data.id.value : this.id,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      position: data.position.present ? data.position.value : this.position,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RowData(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, eventId, position, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RowData &&
          other.id == this.id &&
          other.eventId == this.eventId &&
          other.position == this.position &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RowsCompanion extends UpdateCompanion<RowData> {
  final Value<String> id;
  final Value<String> eventId;
  final Value<int> position;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const RowsCompanion({
    this.id = const Value.absent(),
    this.eventId = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RowsCompanion.insert({
    required String id,
    required String eventId,
    required int position,
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       eventId = Value(eventId),
       position = Value(position),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<RowData> custom({
    Expression<String>? id,
    Expression<String>? eventId,
    Expression<int>? position,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventId != null) 'event_id': eventId,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RowsCompanion copyWith({
    Value<String>? id,
    Value<String>? eventId,
    Value<int>? position,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return RowsCompanion(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RowsCompanion(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CellsTable extends Cells with TableInfo<$CellsTable, CellData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CellsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<String> rowId = GeneratedColumn<String>(
    'row_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "rows" (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _columnIdMeta = const VerificationMeta(
    'columnId',
  );
  @override
  late final GeneratedColumn<String> columnId = GeneratedColumn<String>(
    'column_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES columns (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _valueTextMeta = const VerificationMeta(
    'valueText',
  );
  @override
  late final GeneratedColumn<String> valueText = GeneratedColumn<String>(
    'value_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _valueNumberMeta = const VerificationMeta(
    'valueNumber',
  );
  @override
  late final GeneratedColumn<double> valueNumber = GeneratedColumn<double>(
    'value_number',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _valueBoolMeta = const VerificationMeta(
    'valueBool',
  );
  @override
  late final GeneratedColumn<bool> valueBool = GeneratedColumn<bool>(
    'value_bool',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("value_bool" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    rowId,
    columnId,
    valueText,
    valueNumber,
    valueBool,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cells';
  @override
  VerificationContext validateIntegrity(
    Insertable<CellData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rowIdMeta);
    }
    if (data.containsKey('column_id')) {
      context.handle(
        _columnIdMeta,
        columnId.isAcceptableOrUnknown(data['column_id']!, _columnIdMeta),
      );
    } else if (isInserting) {
      context.missing(_columnIdMeta);
    }
    if (data.containsKey('value_text')) {
      context.handle(
        _valueTextMeta,
        valueText.isAcceptableOrUnknown(data['value_text']!, _valueTextMeta),
      );
    }
    if (data.containsKey('value_number')) {
      context.handle(
        _valueNumberMeta,
        valueNumber.isAcceptableOrUnknown(
          data['value_number']!,
          _valueNumberMeta,
        ),
      );
    }
    if (data.containsKey('value_bool')) {
      context.handle(
        _valueBoolMeta,
        valueBool.isAcceptableOrUnknown(data['value_bool']!, _valueBoolMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CellData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CellData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      rowId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}row_id'],
          )!,
      columnId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}column_id'],
          )!,
      valueText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value_text'],
      ),
      valueNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value_number'],
      ),
      valueBool: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}value_bool'],
      ),
    );
  }

  @override
  $CellsTable createAlias(String alias) {
    return $CellsTable(attachedDatabase, alias);
  }
}

class CellData extends DataClass implements Insertable<CellData> {
  final String id;
  final String rowId;
  final String columnId;
  final String? valueText;
  final double? valueNumber;
  final bool? valueBool;
  const CellData({
    required this.id,
    required this.rowId,
    required this.columnId,
    this.valueText,
    this.valueNumber,
    this.valueBool,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['row_id'] = Variable<String>(rowId);
    map['column_id'] = Variable<String>(columnId);
    if (!nullToAbsent || valueText != null) {
      map['value_text'] = Variable<String>(valueText);
    }
    if (!nullToAbsent || valueNumber != null) {
      map['value_number'] = Variable<double>(valueNumber);
    }
    if (!nullToAbsent || valueBool != null) {
      map['value_bool'] = Variable<bool>(valueBool);
    }
    return map;
  }

  CellsCompanion toCompanion(bool nullToAbsent) {
    return CellsCompanion(
      id: Value(id),
      rowId: Value(rowId),
      columnId: Value(columnId),
      valueText:
          valueText == null && nullToAbsent
              ? const Value.absent()
              : Value(valueText),
      valueNumber:
          valueNumber == null && nullToAbsent
              ? const Value.absent()
              : Value(valueNumber),
      valueBool:
          valueBool == null && nullToAbsent
              ? const Value.absent()
              : Value(valueBool),
    );
  }

  factory CellData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CellData(
      id: serializer.fromJson<String>(json['id']),
      rowId: serializer.fromJson<String>(json['rowId']),
      columnId: serializer.fromJson<String>(json['columnId']),
      valueText: serializer.fromJson<String?>(json['valueText']),
      valueNumber: serializer.fromJson<double?>(json['valueNumber']),
      valueBool: serializer.fromJson<bool?>(json['valueBool']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'rowId': serializer.toJson<String>(rowId),
      'columnId': serializer.toJson<String>(columnId),
      'valueText': serializer.toJson<String?>(valueText),
      'valueNumber': serializer.toJson<double?>(valueNumber),
      'valueBool': serializer.toJson<bool?>(valueBool),
    };
  }

  CellData copyWith({
    String? id,
    String? rowId,
    String? columnId,
    Value<String?> valueText = const Value.absent(),
    Value<double?> valueNumber = const Value.absent(),
    Value<bool?> valueBool = const Value.absent(),
  }) => CellData(
    id: id ?? this.id,
    rowId: rowId ?? this.rowId,
    columnId: columnId ?? this.columnId,
    valueText: valueText.present ? valueText.value : this.valueText,
    valueNumber: valueNumber.present ? valueNumber.value : this.valueNumber,
    valueBool: valueBool.present ? valueBool.value : this.valueBool,
  );
  CellData copyWithCompanion(CellsCompanion data) {
    return CellData(
      id: data.id.present ? data.id.value : this.id,
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      columnId: data.columnId.present ? data.columnId.value : this.columnId,
      valueText: data.valueText.present ? data.valueText.value : this.valueText,
      valueNumber:
          data.valueNumber.present ? data.valueNumber.value : this.valueNumber,
      valueBool: data.valueBool.present ? data.valueBool.value : this.valueBool,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CellData(')
          ..write('id: $id, ')
          ..write('rowId: $rowId, ')
          ..write('columnId: $columnId, ')
          ..write('valueText: $valueText, ')
          ..write('valueNumber: $valueNumber, ')
          ..write('valueBool: $valueBool')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, rowId, columnId, valueText, valueNumber, valueBool);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CellData &&
          other.id == this.id &&
          other.rowId == this.rowId &&
          other.columnId == this.columnId &&
          other.valueText == this.valueText &&
          other.valueNumber == this.valueNumber &&
          other.valueBool == this.valueBool);
}

class CellsCompanion extends UpdateCompanion<CellData> {
  final Value<String> id;
  final Value<String> rowId;
  final Value<String> columnId;
  final Value<String?> valueText;
  final Value<double?> valueNumber;
  final Value<bool?> valueBool;
  final Value<int> rowid;
  const CellsCompanion({
    this.id = const Value.absent(),
    this.rowId = const Value.absent(),
    this.columnId = const Value.absent(),
    this.valueText = const Value.absent(),
    this.valueNumber = const Value.absent(),
    this.valueBool = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CellsCompanion.insert({
    required String id,
    required String rowId,
    required String columnId,
    this.valueText = const Value.absent(),
    this.valueNumber = const Value.absent(),
    this.valueBool = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       rowId = Value(rowId),
       columnId = Value(columnId);
  static Insertable<CellData> custom({
    Expression<String>? id,
    Expression<String>? rowId,
    Expression<String>? columnId,
    Expression<String>? valueText,
    Expression<double>? valueNumber,
    Expression<bool>? valueBool,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rowId != null) 'row_id': rowId,
      if (columnId != null) 'column_id': columnId,
      if (valueText != null) 'value_text': valueText,
      if (valueNumber != null) 'value_number': valueNumber,
      if (valueBool != null) 'value_bool': valueBool,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CellsCompanion copyWith({
    Value<String>? id,
    Value<String>? rowId,
    Value<String>? columnId,
    Value<String?>? valueText,
    Value<double?>? valueNumber,
    Value<bool?>? valueBool,
    Value<int>? rowid,
  }) {
    return CellsCompanion(
      id: id ?? this.id,
      rowId: rowId ?? this.rowId,
      columnId: columnId ?? this.columnId,
      valueText: valueText ?? this.valueText,
      valueNumber: valueNumber ?? this.valueNumber,
      valueBool: valueBool ?? this.valueBool,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (rowId.present) {
      map['row_id'] = Variable<String>(rowId.value);
    }
    if (columnId.present) {
      map['column_id'] = Variable<String>(columnId.value);
    }
    if (valueText.present) {
      map['value_text'] = Variable<String>(valueText.value);
    }
    if (valueNumber.present) {
      map['value_number'] = Variable<double>(valueNumber.value);
    }
    if (valueBool.present) {
      map['value_bool'] = Variable<bool>(valueBool.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CellsCompanion(')
          ..write('id: $id, ')
          ..write('rowId: $rowId, ')
          ..write('columnId: $columnId, ')
          ..write('valueText: $valueText, ')
          ..write('valueNumber: $valueNumber, ')
          ..write('valueBool: $valueBool, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EventTotalsTableTable extends EventTotalsTable
    with TableInfo<$EventTotalsTableTable, EventTotalsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventTotalsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES events (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _onlineTotalMeta = const VerificationMeta(
    'onlineTotal',
  );
  @override
  late final GeneratedColumn<double> onlineTotal = GeneratedColumn<double>(
    'online_total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _offlineTotalMeta = const VerificationMeta(
    'offlineTotal',
  );
  @override
  late final GeneratedColumn<double> offlineTotal = GeneratedColumn<double>(
    'offline_total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _grandTotalMeta = const VerificationMeta(
    'grandTotal',
  );
  @override
  late final GeneratedColumn<double> grandTotal = GeneratedColumn<double>(
    'grand_total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    eventId,
    onlineTotal,
    offlineTotal,
    grandTotal,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'event_totals';
  @override
  VerificationContext validateIntegrity(
    Insertable<EventTotalsData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('online_total')) {
      context.handle(
        _onlineTotalMeta,
        onlineTotal.isAcceptableOrUnknown(
          data['online_total']!,
          _onlineTotalMeta,
        ),
      );
    }
    if (data.containsKey('offline_total')) {
      context.handle(
        _offlineTotalMeta,
        offlineTotal.isAcceptableOrUnknown(
          data['offline_total']!,
          _offlineTotalMeta,
        ),
      );
    }
    if (data.containsKey('grand_total')) {
      context.handle(
        _grandTotalMeta,
        grandTotal.isAcceptableOrUnknown(data['grand_total']!, _grandTotalMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {eventId};
  @override
  EventTotalsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventTotalsData(
      eventId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}event_id'],
          )!,
      onlineTotal:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}online_total'],
          )!,
      offlineTotal:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}offline_total'],
          )!,
      grandTotal:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}grand_total'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $EventTotalsTableTable createAlias(String alias) {
    return $EventTotalsTableTable(attachedDatabase, alias);
  }
}

class EventTotalsData extends DataClass implements Insertable<EventTotalsData> {
  final String eventId;
  final double onlineTotal;
  final double offlineTotal;
  final double grandTotal;
  final int updatedAt;
  const EventTotalsData({
    required this.eventId,
    required this.onlineTotal,
    required this.offlineTotal,
    required this.grandTotal,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['event_id'] = Variable<String>(eventId);
    map['online_total'] = Variable<double>(onlineTotal);
    map['offline_total'] = Variable<double>(offlineTotal);
    map['grand_total'] = Variable<double>(grandTotal);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  EventTotalsTableCompanion toCompanion(bool nullToAbsent) {
    return EventTotalsTableCompanion(
      eventId: Value(eventId),
      onlineTotal: Value(onlineTotal),
      offlineTotal: Value(offlineTotal),
      grandTotal: Value(grandTotal),
      updatedAt: Value(updatedAt),
    );
  }

  factory EventTotalsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventTotalsData(
      eventId: serializer.fromJson<String>(json['eventId']),
      onlineTotal: serializer.fromJson<double>(json['onlineTotal']),
      offlineTotal: serializer.fromJson<double>(json['offlineTotal']),
      grandTotal: serializer.fromJson<double>(json['grandTotal']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'eventId': serializer.toJson<String>(eventId),
      'onlineTotal': serializer.toJson<double>(onlineTotal),
      'offlineTotal': serializer.toJson<double>(offlineTotal),
      'grandTotal': serializer.toJson<double>(grandTotal),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  EventTotalsData copyWith({
    String? eventId,
    double? onlineTotal,
    double? offlineTotal,
    double? grandTotal,
    int? updatedAt,
  }) => EventTotalsData(
    eventId: eventId ?? this.eventId,
    onlineTotal: onlineTotal ?? this.onlineTotal,
    offlineTotal: offlineTotal ?? this.offlineTotal,
    grandTotal: grandTotal ?? this.grandTotal,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  EventTotalsData copyWithCompanion(EventTotalsTableCompanion data) {
    return EventTotalsData(
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      onlineTotal:
          data.onlineTotal.present ? data.onlineTotal.value : this.onlineTotal,
      offlineTotal:
          data.offlineTotal.present
              ? data.offlineTotal.value
              : this.offlineTotal,
      grandTotal:
          data.grandTotal.present ? data.grandTotal.value : this.grandTotal,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventTotalsData(')
          ..write('eventId: $eventId, ')
          ..write('onlineTotal: $onlineTotal, ')
          ..write('offlineTotal: $offlineTotal, ')
          ..write('grandTotal: $grandTotal, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(eventId, onlineTotal, offlineTotal, grandTotal, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventTotalsData &&
          other.eventId == this.eventId &&
          other.onlineTotal == this.onlineTotal &&
          other.offlineTotal == this.offlineTotal &&
          other.grandTotal == this.grandTotal &&
          other.updatedAt == this.updatedAt);
}

class EventTotalsTableCompanion extends UpdateCompanion<EventTotalsData> {
  final Value<String> eventId;
  final Value<double> onlineTotal;
  final Value<double> offlineTotal;
  final Value<double> grandTotal;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const EventTotalsTableCompanion({
    this.eventId = const Value.absent(),
    this.onlineTotal = const Value.absent(),
    this.offlineTotal = const Value.absent(),
    this.grandTotal = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventTotalsTableCompanion.insert({
    required String eventId,
    this.onlineTotal = const Value.absent(),
    this.offlineTotal = const Value.absent(),
    this.grandTotal = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : eventId = Value(eventId),
       updatedAt = Value(updatedAt);
  static Insertable<EventTotalsData> custom({
    Expression<String>? eventId,
    Expression<double>? onlineTotal,
    Expression<double>? offlineTotal,
    Expression<double>? grandTotal,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (eventId != null) 'event_id': eventId,
      if (onlineTotal != null) 'online_total': onlineTotal,
      if (offlineTotal != null) 'offline_total': offlineTotal,
      if (grandTotal != null) 'grand_total': grandTotal,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventTotalsTableCompanion copyWith({
    Value<String>? eventId,
    Value<double>? onlineTotal,
    Value<double>? offlineTotal,
    Value<double>? grandTotal,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return EventTotalsTableCompanion(
      eventId: eventId ?? this.eventId,
      onlineTotal: onlineTotal ?? this.onlineTotal,
      offlineTotal: offlineTotal ?? this.offlineTotal,
      grandTotal: grandTotal ?? this.grandTotal,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (onlineTotal.present) {
      map['online_total'] = Variable<double>(onlineTotal.value);
    }
    if (offlineTotal.present) {
      map['offline_total'] = Variable<double>(offlineTotal.value);
    }
    if (grandTotal.present) {
      map['grand_total'] = Variable<double>(grandTotal.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventTotalsTableCompanion(')
          ..write('eventId: $eventId, ')
          ..write('onlineTotal: $onlineTotal, ')
          ..write('offlineTotal: $offlineTotal, ')
          ..write('grandTotal: $grandTotal, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EventsTable events = $EventsTable(this);
  late final $ColumnsTable columns = $ColumnsTable(this);
  late final $RowsTable rows = $RowsTable(this);
  late final $CellsTable cells = $CellsTable(this);
  late final $EventTotalsTableTable eventTotalsTable = $EventTotalsTableTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    events,
    columns,
    rows,
    cells,
    eventTotalsTable,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'events',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('columns', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'events',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('rows', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'rows',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('cells', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'columns',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('cells', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'events',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('event_totals', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$EventsTableCreateCompanionBuilder =
    EventsCompanion Function({
      required String id,
      required String title,
      required String description,
      required int date,
      Value<bool> locked,
      required String gradientColorA,
      required String gradientColorB,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$EventsTableUpdateCompanionBuilder =
    EventsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> description,
      Value<int> date,
      Value<bool> locked,
      Value<String> gradientColorA,
      Value<String> gradientColorB,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$EventsTableReferences
    extends BaseReferences<_$AppDatabase, $EventsTable, EventData> {
  $$EventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ColumnsTable, List<ColumnData>> _columnsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.columns,
    aliasName: $_aliasNameGenerator(db.events.id, db.columns.eventId),
  );

  $$ColumnsTableProcessedTableManager get columnsRefs {
    final manager = $$ColumnsTableTableManager(
      $_db,
      $_db.columns,
    ).filter((f) => f.eventId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_columnsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RowsTable, List<RowData>> _rowsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.rows,
    aliasName: $_aliasNameGenerator(db.events.id, db.rows.eventId),
  );

  $$RowsTableProcessedTableManager get rowsRefs {
    final manager = $$RowsTableTableManager(
      $_db,
      $_db.rows,
    ).filter((f) => f.eventId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_rowsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EventTotalsTableTable, List<EventTotalsData>>
  _eventTotalsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.eventTotalsTable,
    aliasName: $_aliasNameGenerator(db.events.id, db.eventTotalsTable.eventId),
  );

  $$EventTotalsTableTableProcessedTableManager get eventTotalsTableRefs {
    final manager = $$EventTotalsTableTableTableManager(
      $_db,
      $_db.eventTotalsTable,
    ).filter((f) => f.eventId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _eventTotalsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EventsTableFilterComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get locked => $composableBuilder(
    column: $table.locked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gradientColorA => $composableBuilder(
    column: $table.gradientColorA,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gradientColorB => $composableBuilder(
    column: $table.gradientColorB,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> columnsRefs(
    Expression<bool> Function($$ColumnsTableFilterComposer f) f,
  ) {
    final $$ColumnsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.columns,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ColumnsTableFilterComposer(
            $db: $db,
            $table: $db.columns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> rowsRefs(
    Expression<bool> Function($$RowsTableFilterComposer f) f,
  ) {
    final $$RowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rows,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RowsTableFilterComposer(
            $db: $db,
            $table: $db.rows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> eventTotalsTableRefs(
    Expression<bool> Function($$EventTotalsTableTableFilterComposer f) f,
  ) {
    final $$EventTotalsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.eventTotalsTable,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventTotalsTableTableFilterComposer(
            $db: $db,
            $table: $db.eventTotalsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EventsTableOrderingComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get locked => $composableBuilder(
    column: $table.locked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gradientColorA => $composableBuilder(
    column: $table.gradientColorA,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gradientColorB => $composableBuilder(
    column: $table.gradientColorB,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get locked =>
      $composableBuilder(column: $table.locked, builder: (column) => column);

  GeneratedColumn<String> get gradientColorA => $composableBuilder(
    column: $table.gradientColorA,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gradientColorB => $composableBuilder(
    column: $table.gradientColorB,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> columnsRefs<T extends Object>(
    Expression<T> Function($$ColumnsTableAnnotationComposer a) f,
  ) {
    final $$ColumnsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.columns,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ColumnsTableAnnotationComposer(
            $db: $db,
            $table: $db.columns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> rowsRefs<T extends Object>(
    Expression<T> Function($$RowsTableAnnotationComposer a) f,
  ) {
    final $$RowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rows,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RowsTableAnnotationComposer(
            $db: $db,
            $table: $db.rows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> eventTotalsTableRefs<T extends Object>(
    Expression<T> Function($$EventTotalsTableTableAnnotationComposer a) f,
  ) {
    final $$EventTotalsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.eventTotalsTable,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventTotalsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.eventTotalsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EventsTable,
          EventData,
          $$EventsTableFilterComposer,
          $$EventsTableOrderingComposer,
          $$EventsTableAnnotationComposer,
          $$EventsTableCreateCompanionBuilder,
          $$EventsTableUpdateCompanionBuilder,
          (EventData, $$EventsTableReferences),
          EventData,
          PrefetchHooks Function({
            bool columnsRefs,
            bool rowsRefs,
            bool eventTotalsTableRefs,
          })
        > {
  $$EventsTableTableManager(_$AppDatabase db, $EventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$EventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$EventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$EventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> date = const Value.absent(),
                Value<bool> locked = const Value.absent(),
                Value<String> gradientColorA = const Value.absent(),
                Value<String> gradientColorB = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventsCompanion(
                id: id,
                title: title,
                description: description,
                date: date,
                locked: locked,
                gradientColorA: gradientColorA,
                gradientColorB: gradientColorB,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String description,
                required int date,
                Value<bool> locked = const Value.absent(),
                required String gradientColorA,
                required String gradientColorB,
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => EventsCompanion.insert(
                id: id,
                title: title,
                description: description,
                date: date,
                locked: locked,
                gradientColorA: gradientColorA,
                gradientColorB: gradientColorB,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$EventsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            columnsRefs = false,
            rowsRefs = false,
            eventTotalsTableRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (columnsRefs) db.columns,
                if (rowsRefs) db.rows,
                if (eventTotalsTableRefs) db.eventTotalsTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (columnsRefs)
                    await $_getPrefetchedData<
                      EventData,
                      $EventsTable,
                      ColumnData
                    >(
                      currentTable: table,
                      referencedTable: $$EventsTableReferences
                          ._columnsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$EventsTableReferences(
                                db,
                                table,
                                p0,
                              ).columnsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.eventId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (rowsRefs)
                    await $_getPrefetchedData<EventData, $EventsTable, RowData>(
                      currentTable: table,
                      referencedTable: $$EventsTableReferences._rowsRefsTable(
                        db,
                      ),
                      managerFromTypedResult:
                          (p0) =>
                              $$EventsTableReferences(db, table, p0).rowsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.eventId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (eventTotalsTableRefs)
                    await $_getPrefetchedData<
                      EventData,
                      $EventsTable,
                      EventTotalsData
                    >(
                      currentTable: table,
                      referencedTable: $$EventsTableReferences
                          ._eventTotalsTableRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$EventsTableReferences(
                                db,
                                table,
                                p0,
                              ).eventTotalsTableRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.eventId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$EventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EventsTable,
      EventData,
      $$EventsTableFilterComposer,
      $$EventsTableOrderingComposer,
      $$EventsTableAnnotationComposer,
      $$EventsTableCreateCompanionBuilder,
      $$EventsTableUpdateCompanionBuilder,
      (EventData, $$EventsTableReferences),
      EventData,
      PrefetchHooks Function({
        bool columnsRefs,
        bool rowsRefs,
        bool eventTotalsTableRefs,
      })
    >;
typedef $$ColumnsTableCreateCompanionBuilder =
    ColumnsCompanion Function({
      required String id,
      required String eventId,
      required String key,
      required String label,
      required String type,
      required int position,
      Value<bool> fixed,
      Value<int> rowid,
    });
typedef $$ColumnsTableUpdateCompanionBuilder =
    ColumnsCompanion Function({
      Value<String> id,
      Value<String> eventId,
      Value<String> key,
      Value<String> label,
      Value<String> type,
      Value<int> position,
      Value<bool> fixed,
      Value<int> rowid,
    });

final class $$ColumnsTableReferences
    extends BaseReferences<_$AppDatabase, $ColumnsTable, ColumnData> {
  $$ColumnsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EventsTable _eventIdTable(_$AppDatabase db) => db.events.createAlias(
    $_aliasNameGenerator(db.columns.eventId, db.events.id),
  );

  $$EventsTableProcessedTableManager get eventId {
    final $_column = $_itemColumn<String>('event_id')!;

    final manager = $$EventsTableTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CellsTable, List<CellData>> _cellsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.cells,
    aliasName: $_aliasNameGenerator(db.columns.id, db.cells.columnId),
  );

  $$CellsTableProcessedTableManager get cellsRefs {
    final manager = $$CellsTableTableManager(
      $_db,
      $_db.cells,
    ).filter((f) => f.columnId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_cellsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ColumnsTableFilterComposer
    extends Composer<_$AppDatabase, $ColumnsTable> {
  $$ColumnsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get fixed => $composableBuilder(
    column: $table.fixed,
    builder: (column) => ColumnFilters(column),
  );

  $$EventsTableFilterComposer get eventId {
    final $$EventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> cellsRefs(
    Expression<bool> Function($$CellsTableFilterComposer f) f,
  ) {
    final $$CellsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cells,
      getReferencedColumn: (t) => t.columnId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CellsTableFilterComposer(
            $db: $db,
            $table: $db.cells,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ColumnsTableOrderingComposer
    extends Composer<_$AppDatabase, $ColumnsTable> {
  $$ColumnsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get fixed => $composableBuilder(
    column: $table.fixed,
    builder: (column) => ColumnOrderings(column),
  );

  $$EventsTableOrderingComposer get eventId {
    final $$EventsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableOrderingComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ColumnsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ColumnsTable> {
  $$ColumnsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<bool> get fixed =>
      $composableBuilder(column: $table.fixed, builder: (column) => column);

  $$EventsTableAnnotationComposer get eventId {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> cellsRefs<T extends Object>(
    Expression<T> Function($$CellsTableAnnotationComposer a) f,
  ) {
    final $$CellsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cells,
      getReferencedColumn: (t) => t.columnId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CellsTableAnnotationComposer(
            $db: $db,
            $table: $db.cells,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ColumnsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ColumnsTable,
          ColumnData,
          $$ColumnsTableFilterComposer,
          $$ColumnsTableOrderingComposer,
          $$ColumnsTableAnnotationComposer,
          $$ColumnsTableCreateCompanionBuilder,
          $$ColumnsTableUpdateCompanionBuilder,
          (ColumnData, $$ColumnsTableReferences),
          ColumnData,
          PrefetchHooks Function({bool eventId, bool cellsRefs})
        > {
  $$ColumnsTableTableManager(_$AppDatabase db, $ColumnsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ColumnsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ColumnsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ColumnsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> eventId = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<bool> fixed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ColumnsCompanion(
                id: id,
                eventId: eventId,
                key: key,
                label: label,
                type: type,
                position: position,
                fixed: fixed,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String eventId,
                required String key,
                required String label,
                required String type,
                required int position,
                Value<bool> fixed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ColumnsCompanion.insert(
                id: id,
                eventId: eventId,
                key: key,
                label: label,
                type: type,
                position: position,
                fixed: fixed,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$ColumnsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({eventId = false, cellsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (cellsRefs) db.cells],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (eventId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.eventId,
                            referencedTable: $$ColumnsTableReferences
                                ._eventIdTable(db),
                            referencedColumn:
                                $$ColumnsTableReferences._eventIdTable(db).id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (cellsRefs)
                    await $_getPrefetchedData<
                      ColumnData,
                      $ColumnsTable,
                      CellData
                    >(
                      currentTable: table,
                      referencedTable: $$ColumnsTableReferences._cellsRefsTable(
                        db,
                      ),
                      managerFromTypedResult:
                          (p0) =>
                              $$ColumnsTableReferences(db, table, p0).cellsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.columnId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ColumnsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ColumnsTable,
      ColumnData,
      $$ColumnsTableFilterComposer,
      $$ColumnsTableOrderingComposer,
      $$ColumnsTableAnnotationComposer,
      $$ColumnsTableCreateCompanionBuilder,
      $$ColumnsTableUpdateCompanionBuilder,
      (ColumnData, $$ColumnsTableReferences),
      ColumnData,
      PrefetchHooks Function({bool eventId, bool cellsRefs})
    >;
typedef $$RowsTableCreateCompanionBuilder =
    RowsCompanion Function({
      required String id,
      required String eventId,
      required int position,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$RowsTableUpdateCompanionBuilder =
    RowsCompanion Function({
      Value<String> id,
      Value<String> eventId,
      Value<int> position,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$RowsTableReferences
    extends BaseReferences<_$AppDatabase, $RowsTable, RowData> {
  $$RowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EventsTable _eventIdTable(_$AppDatabase db) => db.events.createAlias(
    $_aliasNameGenerator(db.rows.eventId, db.events.id),
  );

  $$EventsTableProcessedTableManager get eventId {
    final $_column = $_itemColumn<String>('event_id')!;

    final manager = $$EventsTableTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CellsTable, List<CellData>> _cellsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.cells,
    aliasName: $_aliasNameGenerator(db.rows.id, db.cells.rowId),
  );

  $$CellsTableProcessedTableManager get cellsRefs {
    final manager = $$CellsTableTableManager(
      $_db,
      $_db.cells,
    ).filter((f) => f.rowId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_cellsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RowsTableFilterComposer extends Composer<_$AppDatabase, $RowsTable> {
  $$RowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EventsTableFilterComposer get eventId {
    final $$EventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> cellsRefs(
    Expression<bool> Function($$CellsTableFilterComposer f) f,
  ) {
    final $$CellsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cells,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CellsTableFilterComposer(
            $db: $db,
            $table: $db.cells,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RowsTableOrderingComposer extends Composer<_$AppDatabase, $RowsTable> {
  $$RowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EventsTableOrderingComposer get eventId {
    final $$EventsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableOrderingComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RowsTable> {
  $$RowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$EventsTableAnnotationComposer get eventId {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> cellsRefs<T extends Object>(
    Expression<T> Function($$CellsTableAnnotationComposer a) f,
  ) {
    final $$CellsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cells,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CellsTableAnnotationComposer(
            $db: $db,
            $table: $db.cells,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RowsTable,
          RowData,
          $$RowsTableFilterComposer,
          $$RowsTableOrderingComposer,
          $$RowsTableAnnotationComposer,
          $$RowsTableCreateCompanionBuilder,
          $$RowsTableUpdateCompanionBuilder,
          (RowData, $$RowsTableReferences),
          RowData,
          PrefetchHooks Function({bool eventId, bool cellsRefs})
        > {
  $$RowsTableTableManager(_$AppDatabase db, $RowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$RowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$RowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$RowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> eventId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RowsCompanion(
                id: id,
                eventId: eventId,
                position: position,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String eventId,
                required int position,
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RowsCompanion.insert(
                id: id,
                eventId: eventId,
                position: position,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$RowsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({eventId = false, cellsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (cellsRefs) db.cells],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (eventId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.eventId,
                            referencedTable: $$RowsTableReferences
                                ._eventIdTable(db),
                            referencedColumn:
                                $$RowsTableReferences._eventIdTable(db).id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (cellsRefs)
                    await $_getPrefetchedData<RowData, $RowsTable, CellData>(
                      currentTable: table,
                      referencedTable: $$RowsTableReferences._cellsRefsTable(
                        db,
                      ),
                      managerFromTypedResult:
                          (p0) =>
                              $$RowsTableReferences(db, table, p0).cellsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.rowId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RowsTable,
      RowData,
      $$RowsTableFilterComposer,
      $$RowsTableOrderingComposer,
      $$RowsTableAnnotationComposer,
      $$RowsTableCreateCompanionBuilder,
      $$RowsTableUpdateCompanionBuilder,
      (RowData, $$RowsTableReferences),
      RowData,
      PrefetchHooks Function({bool eventId, bool cellsRefs})
    >;
typedef $$CellsTableCreateCompanionBuilder =
    CellsCompanion Function({
      required String id,
      required String rowId,
      required String columnId,
      Value<String?> valueText,
      Value<double?> valueNumber,
      Value<bool?> valueBool,
      Value<int> rowid,
    });
typedef $$CellsTableUpdateCompanionBuilder =
    CellsCompanion Function({
      Value<String> id,
      Value<String> rowId,
      Value<String> columnId,
      Value<String?> valueText,
      Value<double?> valueNumber,
      Value<bool?> valueBool,
      Value<int> rowid,
    });

final class $$CellsTableReferences
    extends BaseReferences<_$AppDatabase, $CellsTable, CellData> {
  $$CellsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RowsTable _rowIdTable(_$AppDatabase db) =>
      db.rows.createAlias($_aliasNameGenerator(db.cells.rowId, db.rows.id));

  $$RowsTableProcessedTableManager get rowId {
    final $_column = $_itemColumn<String>('row_id')!;

    final manager = $$RowsTableTableManager(
      $_db,
      $_db.rows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_rowIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ColumnsTable _columnIdTable(_$AppDatabase db) => db.columns
      .createAlias($_aliasNameGenerator(db.cells.columnId, db.columns.id));

  $$ColumnsTableProcessedTableManager get columnId {
    final $_column = $_itemColumn<String>('column_id')!;

    final manager = $$ColumnsTableTableManager(
      $_db,
      $_db.columns,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_columnIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CellsTableFilterComposer extends Composer<_$AppDatabase, $CellsTable> {
  $$CellsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valueText => $composableBuilder(
    column: $table.valueText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get valueNumber => $composableBuilder(
    column: $table.valueNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get valueBool => $composableBuilder(
    column: $table.valueBool,
    builder: (column) => ColumnFilters(column),
  );

  $$RowsTableFilterComposer get rowId {
    final $$RowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.rows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RowsTableFilterComposer(
            $db: $db,
            $table: $db.rows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ColumnsTableFilterComposer get columnId {
    final $$ColumnsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.columnId,
      referencedTable: $db.columns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ColumnsTableFilterComposer(
            $db: $db,
            $table: $db.columns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CellsTableOrderingComposer
    extends Composer<_$AppDatabase, $CellsTable> {
  $$CellsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueText => $composableBuilder(
    column: $table.valueText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valueNumber => $composableBuilder(
    column: $table.valueNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get valueBool => $composableBuilder(
    column: $table.valueBool,
    builder: (column) => ColumnOrderings(column),
  );

  $$RowsTableOrderingComposer get rowId {
    final $$RowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.rows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RowsTableOrderingComposer(
            $db: $db,
            $table: $db.rows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ColumnsTableOrderingComposer get columnId {
    final $$ColumnsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.columnId,
      referencedTable: $db.columns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ColumnsTableOrderingComposer(
            $db: $db,
            $table: $db.columns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CellsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CellsTable> {
  $$CellsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get valueText =>
      $composableBuilder(column: $table.valueText, builder: (column) => column);

  GeneratedColumn<double> get valueNumber => $composableBuilder(
    column: $table.valueNumber,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get valueBool =>
      $composableBuilder(column: $table.valueBool, builder: (column) => column);

  $$RowsTableAnnotationComposer get rowId {
    final $$RowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.rows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RowsTableAnnotationComposer(
            $db: $db,
            $table: $db.rows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ColumnsTableAnnotationComposer get columnId {
    final $$ColumnsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.columnId,
      referencedTable: $db.columns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ColumnsTableAnnotationComposer(
            $db: $db,
            $table: $db.columns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CellsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CellsTable,
          CellData,
          $$CellsTableFilterComposer,
          $$CellsTableOrderingComposer,
          $$CellsTableAnnotationComposer,
          $$CellsTableCreateCompanionBuilder,
          $$CellsTableUpdateCompanionBuilder,
          (CellData, $$CellsTableReferences),
          CellData,
          PrefetchHooks Function({bool rowId, bool columnId})
        > {
  $$CellsTableTableManager(_$AppDatabase db, $CellsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$CellsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$CellsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$CellsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> rowId = const Value.absent(),
                Value<String> columnId = const Value.absent(),
                Value<String?> valueText = const Value.absent(),
                Value<double?> valueNumber = const Value.absent(),
                Value<bool?> valueBool = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CellsCompanion(
                id: id,
                rowId: rowId,
                columnId: columnId,
                valueText: valueText,
                valueNumber: valueNumber,
                valueBool: valueBool,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String rowId,
                required String columnId,
                Value<String?> valueText = const Value.absent(),
                Value<double?> valueNumber = const Value.absent(),
                Value<bool?> valueBool = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CellsCompanion.insert(
                id: id,
                rowId: rowId,
                columnId: columnId,
                valueText: valueText,
                valueNumber: valueNumber,
                valueBool: valueBool,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$CellsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({rowId = false, columnId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (rowId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.rowId,
                            referencedTable: $$CellsTableReferences._rowIdTable(
                              db,
                            ),
                            referencedColumn:
                                $$CellsTableReferences._rowIdTable(db).id,
                          )
                          as T;
                }
                if (columnId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.columnId,
                            referencedTable: $$CellsTableReferences
                                ._columnIdTable(db),
                            referencedColumn:
                                $$CellsTableReferences._columnIdTable(db).id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CellsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CellsTable,
      CellData,
      $$CellsTableFilterComposer,
      $$CellsTableOrderingComposer,
      $$CellsTableAnnotationComposer,
      $$CellsTableCreateCompanionBuilder,
      $$CellsTableUpdateCompanionBuilder,
      (CellData, $$CellsTableReferences),
      CellData,
      PrefetchHooks Function({bool rowId, bool columnId})
    >;
typedef $$EventTotalsTableTableCreateCompanionBuilder =
    EventTotalsTableCompanion Function({
      required String eventId,
      Value<double> onlineTotal,
      Value<double> offlineTotal,
      Value<double> grandTotal,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$EventTotalsTableTableUpdateCompanionBuilder =
    EventTotalsTableCompanion Function({
      Value<String> eventId,
      Value<double> onlineTotal,
      Value<double> offlineTotal,
      Value<double> grandTotal,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$EventTotalsTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $EventTotalsTableTable, EventTotalsData> {
  $$EventTotalsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EventsTable _eventIdTable(_$AppDatabase db) => db.events.createAlias(
    $_aliasNameGenerator(db.eventTotalsTable.eventId, db.events.id),
  );

  $$EventsTableProcessedTableManager get eventId {
    final $_column = $_itemColumn<String>('event_id')!;

    final manager = $$EventsTableTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EventTotalsTableTableFilterComposer
    extends Composer<_$AppDatabase, $EventTotalsTableTable> {
  $$EventTotalsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<double> get onlineTotal => $composableBuilder(
    column: $table.onlineTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get offlineTotal => $composableBuilder(
    column: $table.offlineTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get grandTotal => $composableBuilder(
    column: $table.grandTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EventsTableFilterComposer get eventId {
    final $$EventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventTotalsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EventTotalsTableTable> {
  $$EventTotalsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<double> get onlineTotal => $composableBuilder(
    column: $table.onlineTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get offlineTotal => $composableBuilder(
    column: $table.offlineTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get grandTotal => $composableBuilder(
    column: $table.grandTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EventsTableOrderingComposer get eventId {
    final $$EventsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableOrderingComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventTotalsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventTotalsTableTable> {
  $$EventTotalsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<double> get onlineTotal => $composableBuilder(
    column: $table.onlineTotal,
    builder: (column) => column,
  );

  GeneratedColumn<double> get offlineTotal => $composableBuilder(
    column: $table.offlineTotal,
    builder: (column) => column,
  );

  GeneratedColumn<double> get grandTotal => $composableBuilder(
    column: $table.grandTotal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$EventsTableAnnotationComposer get eventId {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventTotalsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EventTotalsTableTable,
          EventTotalsData,
          $$EventTotalsTableTableFilterComposer,
          $$EventTotalsTableTableOrderingComposer,
          $$EventTotalsTableTableAnnotationComposer,
          $$EventTotalsTableTableCreateCompanionBuilder,
          $$EventTotalsTableTableUpdateCompanionBuilder,
          (EventTotalsData, $$EventTotalsTableTableReferences),
          EventTotalsData,
          PrefetchHooks Function({bool eventId})
        > {
  $$EventTotalsTableTableTableManager(
    _$AppDatabase db,
    $EventTotalsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$EventTotalsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$EventTotalsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$EventTotalsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> eventId = const Value.absent(),
                Value<double> onlineTotal = const Value.absent(),
                Value<double> offlineTotal = const Value.absent(),
                Value<double> grandTotal = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventTotalsTableCompanion(
                eventId: eventId,
                onlineTotal: onlineTotal,
                offlineTotal: offlineTotal,
                grandTotal: grandTotal,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String eventId,
                Value<double> onlineTotal = const Value.absent(),
                Value<double> offlineTotal = const Value.absent(),
                Value<double> grandTotal = const Value.absent(),
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => EventTotalsTableCompanion.insert(
                eventId: eventId,
                onlineTotal: onlineTotal,
                offlineTotal: offlineTotal,
                grandTotal: grandTotal,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$EventTotalsTableTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({eventId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (eventId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.eventId,
                            referencedTable: $$EventTotalsTableTableReferences
                                ._eventIdTable(db),
                            referencedColumn:
                                $$EventTotalsTableTableReferences
                                    ._eventIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EventTotalsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EventTotalsTableTable,
      EventTotalsData,
      $$EventTotalsTableTableFilterComposer,
      $$EventTotalsTableTableOrderingComposer,
      $$EventTotalsTableTableAnnotationComposer,
      $$EventTotalsTableTableCreateCompanionBuilder,
      $$EventTotalsTableTableUpdateCompanionBuilder,
      (EventTotalsData, $$EventTotalsTableTableReferences),
      EventTotalsData,
      PrefetchHooks Function({bool eventId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db, _db.events);
  $$ColumnsTableTableManager get columns =>
      $$ColumnsTableTableManager(_db, _db.columns);
  $$RowsTableTableManager get rows => $$RowsTableTableManager(_db, _db.rows);
  $$CellsTableTableManager get cells =>
      $$CellsTableTableManager(_db, _db.cells);
  $$EventTotalsTableTableTableManager get eventTotalsTable =>
      $$EventTotalsTableTableTableManager(_db, _db.eventTotalsTable);
}
