// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ShortcutsTable extends Shortcuts
    with TableInfo<$ShortcutsTable, ShortcutRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShortcutsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
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
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('bolt'),
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(defaultShortcutColor),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    icon,
    color,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shortcuts';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShortcutRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
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
  ShortcutRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShortcutRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ShortcutsTable createAlias(String alias) {
    return $ShortcutsTable(attachedDatabase, alias);
  }
}

class ShortcutRow extends DataClass implements Insertable<ShortcutRow> {
  final int id;
  final String name;
  final String description;
  final String icon;
  final int color;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ShortcutRow({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['icon'] = Variable<String>(icon);
    map['color'] = Variable<int>(color);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ShortcutsCompanion toCompanion(bool nullToAbsent) {
    return ShortcutsCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      icon: Value(icon),
      color: Value(color),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ShortcutRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShortcutRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      icon: serializer.fromJson<String>(json['icon']),
      color: serializer.fromJson<int>(json['color']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'icon': serializer.toJson<String>(icon),
      'color': serializer.toJson<int>(color),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ShortcutRow copyWith({
    int? id,
    String? name,
    String? description,
    String? icon,
    int? color,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ShortcutRow(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    icon: icon ?? this.icon,
    color: color ?? this.color,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ShortcutRow copyWithCompanion(ShortcutsCompanion data) {
    return ShortcutRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShortcutRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, description, icon, color, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShortcutRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ShortcutsCompanion extends UpdateCompanion<ShortcutRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String> icon;
  final Value<int> color;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ShortcutsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ShortcutsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ShortcutRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? icon,
    Expression<int>? color,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ShortcutsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? description,
    Value<String>? icon,
    Value<int>? color,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ShortcutsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShortcutsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $RequestStepsTable extends RequestSteps
    with TableInfo<$RequestStepsTable, RequestStepRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RequestStepsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _shortcutIdMeta = const VerificationMeta(
    'shortcutId',
  );
  @override
  late final GeneratedColumn<int> shortcutId = GeneratedColumn<int>(
    'shortcut_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shortcuts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _stepKeyMeta = const VerificationMeta(
    'stepKey',
  );
  @override
  late final GeneratedColumn<String> stepKey = GeneratedColumn<String>(
    'step_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _requestJsonMeta = const VerificationMeta(
    'requestJson',
  );
  @override
  late final GeneratedColumn<String> requestJson = GeneratedColumn<String>(
    'request_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    shortcutId,
    stepKey,
    name,
    sortOrder,
    requestJson,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'request_steps';
  @override
  VerificationContext validateIntegrity(
    Insertable<RequestStepRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('shortcut_id')) {
      context.handle(
        _shortcutIdMeta,
        shortcutId.isAcceptableOrUnknown(data['shortcut_id']!, _shortcutIdMeta),
      );
    } else if (isInserting) {
      context.missing(_shortcutIdMeta);
    }
    if (data.containsKey('step_key')) {
      context.handle(
        _stepKeyMeta,
        stepKey.isAcceptableOrUnknown(data['step_key']!, _stepKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_stepKeyMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('request_json')) {
      context.handle(
        _requestJsonMeta,
        requestJson.isAcceptableOrUnknown(
          data['request_json']!,
          _requestJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requestJsonMeta);
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
  RequestStepRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RequestStepRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      shortcutId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shortcut_id'],
      )!,
      stepKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}step_key'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      requestJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}request_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RequestStepsTable createAlias(String alias) {
    return $RequestStepsTable(attachedDatabase, alias);
  }
}

class RequestStepRow extends DataClass implements Insertable<RequestStepRow> {
  final int id;
  final int shortcutId;
  final String stepKey;
  final String name;
  final int sortOrder;
  final String requestJson;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RequestStepRow({
    required this.id,
    required this.shortcutId,
    required this.stepKey,
    required this.name,
    required this.sortOrder,
    required this.requestJson,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['shortcut_id'] = Variable<int>(shortcutId);
    map['step_key'] = Variable<String>(stepKey);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    map['request_json'] = Variable<String>(requestJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RequestStepsCompanion toCompanion(bool nullToAbsent) {
    return RequestStepsCompanion(
      id: Value(id),
      shortcutId: Value(shortcutId),
      stepKey: Value(stepKey),
      name: Value(name),
      sortOrder: Value(sortOrder),
      requestJson: Value(requestJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RequestStepRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RequestStepRow(
      id: serializer.fromJson<int>(json['id']),
      shortcutId: serializer.fromJson<int>(json['shortcutId']),
      stepKey: serializer.fromJson<String>(json['stepKey']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      requestJson: serializer.fromJson<String>(json['requestJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'shortcutId': serializer.toJson<int>(shortcutId),
      'stepKey': serializer.toJson<String>(stepKey),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'requestJson': serializer.toJson<String>(requestJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RequestStepRow copyWith({
    int? id,
    int? shortcutId,
    String? stepKey,
    String? name,
    int? sortOrder,
    String? requestJson,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => RequestStepRow(
    id: id ?? this.id,
    shortcutId: shortcutId ?? this.shortcutId,
    stepKey: stepKey ?? this.stepKey,
    name: name ?? this.name,
    sortOrder: sortOrder ?? this.sortOrder,
    requestJson: requestJson ?? this.requestJson,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RequestStepRow copyWithCompanion(RequestStepsCompanion data) {
    return RequestStepRow(
      id: data.id.present ? data.id.value : this.id,
      shortcutId: data.shortcutId.present
          ? data.shortcutId.value
          : this.shortcutId,
      stepKey: data.stepKey.present ? data.stepKey.value : this.stepKey,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      requestJson: data.requestJson.present
          ? data.requestJson.value
          : this.requestJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RequestStepRow(')
          ..write('id: $id, ')
          ..write('shortcutId: $shortcutId, ')
          ..write('stepKey: $stepKey, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('requestJson: $requestJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    shortcutId,
    stepKey,
    name,
    sortOrder,
    requestJson,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestStepRow &&
          other.id == this.id &&
          other.shortcutId == this.shortcutId &&
          other.stepKey == this.stepKey &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder &&
          other.requestJson == this.requestJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RequestStepsCompanion extends UpdateCompanion<RequestStepRow> {
  final Value<int> id;
  final Value<int> shortcutId;
  final Value<String> stepKey;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<String> requestJson;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const RequestStepsCompanion({
    this.id = const Value.absent(),
    this.shortcutId = const Value.absent(),
    this.stepKey = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.requestJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  RequestStepsCompanion.insert({
    this.id = const Value.absent(),
    required int shortcutId,
    required String stepKey,
    required String name,
    required int sortOrder,
    required String requestJson,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : shortcutId = Value(shortcutId),
       stepKey = Value(stepKey),
       name = Value(name),
       sortOrder = Value(sortOrder),
       requestJson = Value(requestJson),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<RequestStepRow> custom({
    Expression<int>? id,
    Expression<int>? shortcutId,
    Expression<String>? stepKey,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<String>? requestJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shortcutId != null) 'shortcut_id': shortcutId,
      if (stepKey != null) 'step_key': stepKey,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (requestJson != null) 'request_json': requestJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  RequestStepsCompanion copyWith({
    Value<int>? id,
    Value<int>? shortcutId,
    Value<String>? stepKey,
    Value<String>? name,
    Value<int>? sortOrder,
    Value<String>? requestJson,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return RequestStepsCompanion(
      id: id ?? this.id,
      shortcutId: shortcutId ?? this.shortcutId,
      stepKey: stepKey ?? this.stepKey,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      requestJson: requestJson ?? this.requestJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (shortcutId.present) {
      map['shortcut_id'] = Variable<int>(shortcutId.value);
    }
    if (stepKey.present) {
      map['step_key'] = Variable<String>(stepKey.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (requestJson.present) {
      map['request_json'] = Variable<String>(requestJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RequestStepsCompanion(')
          ..write('id: $id, ')
          ..write('shortcutId: $shortcutId, ')
          ..write('stepKey: $stepKey, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('requestJson: $requestJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ExecutionRunsTable extends ExecutionRuns
    with TableInfo<$ExecutionRunsTable, ExecutionRunRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExecutionRunsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _shortcutIdMeta = const VerificationMeta(
    'shortcutId',
  );
  @override
  late final GeneratedColumn<int> shortcutId = GeneratedColumn<int>(
    'shortcut_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shortcuts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finishedAtMeta = const VerificationMeta(
    'finishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
    'finished_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _errorMeta = const VerificationMeta('error');
  @override
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
    'error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    shortcutId,
    status,
    startedAt,
    finishedAt,
    durationMs,
    error,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'execution_runs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExecutionRunRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('shortcut_id')) {
      context.handle(
        _shortcutIdMeta,
        shortcutId.isAcceptableOrUnknown(data['shortcut_id']!, _shortcutIdMeta),
      );
    } else if (isInserting) {
      context.missing(_shortcutIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('finished_at')) {
      context.handle(
        _finishedAtMeta,
        finishedAt.isAcceptableOrUnknown(data['finished_at']!, _finishedAtMeta),
      );
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    if (data.containsKey('error')) {
      context.handle(
        _errorMeta,
        error.isAcceptableOrUnknown(data['error']!, _errorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExecutionRunRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExecutionRunRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      shortcutId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shortcut_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      finishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finished_at'],
      ),
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      ),
      error: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error'],
      ),
    );
  }

  @override
  $ExecutionRunsTable createAlias(String alias) {
    return $ExecutionRunsTable(attachedDatabase, alias);
  }
}

class ExecutionRunRow extends DataClass implements Insertable<ExecutionRunRow> {
  final int id;
  final int shortcutId;
  final String status;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final int? durationMs;
  final String? error;
  const ExecutionRunRow({
    required this.id,
    required this.shortcutId,
    required this.status,
    required this.startedAt,
    this.finishedAt,
    this.durationMs,
    this.error,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['shortcut_id'] = Variable<int>(shortcutId);
    map['status'] = Variable<String>(status);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || finishedAt != null) {
      map['finished_at'] = Variable<DateTime>(finishedAt);
    }
    if (!nullToAbsent || durationMs != null) {
      map['duration_ms'] = Variable<int>(durationMs);
    }
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    return map;
  }

  ExecutionRunsCompanion toCompanion(bool nullToAbsent) {
    return ExecutionRunsCompanion(
      id: Value(id),
      shortcutId: Value(shortcutId),
      status: Value(status),
      startedAt: Value(startedAt),
      finishedAt: finishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedAt),
      durationMs: durationMs == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMs),
      error: error == null && nullToAbsent
          ? const Value.absent()
          : Value(error),
    );
  }

  factory ExecutionRunRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExecutionRunRow(
      id: serializer.fromJson<int>(json['id']),
      shortcutId: serializer.fromJson<int>(json['shortcutId']),
      status: serializer.fromJson<String>(json['status']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      finishedAt: serializer.fromJson<DateTime?>(json['finishedAt']),
      durationMs: serializer.fromJson<int?>(json['durationMs']),
      error: serializer.fromJson<String?>(json['error']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'shortcutId': serializer.toJson<int>(shortcutId),
      'status': serializer.toJson<String>(status),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'finishedAt': serializer.toJson<DateTime?>(finishedAt),
      'durationMs': serializer.toJson<int?>(durationMs),
      'error': serializer.toJson<String?>(error),
    };
  }

  ExecutionRunRow copyWith({
    int? id,
    int? shortcutId,
    String? status,
    DateTime? startedAt,
    Value<DateTime?> finishedAt = const Value.absent(),
    Value<int?> durationMs = const Value.absent(),
    Value<String?> error = const Value.absent(),
  }) => ExecutionRunRow(
    id: id ?? this.id,
    shortcutId: shortcutId ?? this.shortcutId,
    status: status ?? this.status,
    startedAt: startedAt ?? this.startedAt,
    finishedAt: finishedAt.present ? finishedAt.value : this.finishedAt,
    durationMs: durationMs.present ? durationMs.value : this.durationMs,
    error: error.present ? error.value : this.error,
  );
  ExecutionRunRow copyWithCompanion(ExecutionRunsCompanion data) {
    return ExecutionRunRow(
      id: data.id.present ? data.id.value : this.id,
      shortcutId: data.shortcutId.present
          ? data.shortcutId.value
          : this.shortcutId,
      status: data.status.present ? data.status.value : this.status,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      finishedAt: data.finishedAt.present
          ? data.finishedAt.value
          : this.finishedAt,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      error: data.error.present ? data.error.value : this.error,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExecutionRunRow(')
          ..write('id: $id, ')
          ..write('shortcutId: $shortcutId, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('durationMs: $durationMs, ')
          ..write('error: $error')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    shortcutId,
    status,
    startedAt,
    finishedAt,
    durationMs,
    error,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExecutionRunRow &&
          other.id == this.id &&
          other.shortcutId == this.shortcutId &&
          other.status == this.status &&
          other.startedAt == this.startedAt &&
          other.finishedAt == this.finishedAt &&
          other.durationMs == this.durationMs &&
          other.error == this.error);
}

class ExecutionRunsCompanion extends UpdateCompanion<ExecutionRunRow> {
  final Value<int> id;
  final Value<int> shortcutId;
  final Value<String> status;
  final Value<DateTime> startedAt;
  final Value<DateTime?> finishedAt;
  final Value<int?> durationMs;
  final Value<String?> error;
  const ExecutionRunsCompanion({
    this.id = const Value.absent(),
    this.shortcutId = const Value.absent(),
    this.status = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.error = const Value.absent(),
  });
  ExecutionRunsCompanion.insert({
    this.id = const Value.absent(),
    required int shortcutId,
    required String status,
    required DateTime startedAt,
    this.finishedAt = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.error = const Value.absent(),
  }) : shortcutId = Value(shortcutId),
       status = Value(status),
       startedAt = Value(startedAt);
  static Insertable<ExecutionRunRow> custom({
    Expression<int>? id,
    Expression<int>? shortcutId,
    Expression<String>? status,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? finishedAt,
    Expression<int>? durationMs,
    Expression<String>? error,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shortcutId != null) 'shortcut_id': shortcutId,
      if (status != null) 'status': status,
      if (startedAt != null) 'started_at': startedAt,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (durationMs != null) 'duration_ms': durationMs,
      if (error != null) 'error': error,
    });
  }

  ExecutionRunsCompanion copyWith({
    Value<int>? id,
    Value<int>? shortcutId,
    Value<String>? status,
    Value<DateTime>? startedAt,
    Value<DateTime?>? finishedAt,
    Value<int?>? durationMs,
    Value<String?>? error,
  }) {
    return ExecutionRunsCompanion(
      id: id ?? this.id,
      shortcutId: shortcutId ?? this.shortcutId,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      durationMs: durationMs ?? this.durationMs,
      error: error ?? this.error,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (shortcutId.present) {
      map['shortcut_id'] = Variable<int>(shortcutId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExecutionRunsCompanion(')
          ..write('id: $id, ')
          ..write('shortcutId: $shortcutId, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('durationMs: $durationMs, ')
          ..write('error: $error')
          ..write(')'))
        .toString();
  }
}

class $RequestLogsTable extends RequestLogs
    with TableInfo<$RequestLogsTable, RequestLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RequestLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _shortcutIdMeta = const VerificationMeta(
    'shortcutId',
  );
  @override
  late final GeneratedColumn<int> shortcutId = GeneratedColumn<int>(
    'shortcut_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shortcuts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _runIdMeta = const VerificationMeta('runId');
  @override
  late final GeneratedColumn<int> runId = GeneratedColumn<int>(
    'run_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES execution_runs (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _stepIdMeta = const VerificationMeta('stepId');
  @override
  late final GeneratedColumn<int> stepId = GeneratedColumn<int>(
    'step_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES request_steps (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _stepKeyMeta = const VerificationMeta(
    'stepKey',
  );
  @override
  late final GeneratedColumn<String> stepKey = GeneratedColumn<String>(
    'step_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stepNameMeta = const VerificationMeta(
    'stepName',
  );
  @override
  late final GeneratedColumn<String> stepName = GeneratedColumn<String>(
    'step_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusCodeMeta = const VerificationMeta(
    'statusCode',
  );
  @override
  late final GeneratedColumn<int> statusCode = GeneratedColumn<int>(
    'status_code',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _successMeta = const VerificationMeta(
    'success',
  );
  @override
  late final GeneratedColumn<bool> success = GeneratedColumn<bool>(
    'success',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("success" IN (0, 1))',
    ),
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _requestHeadersJsonMeta =
      const VerificationMeta('requestHeadersJson');
  @override
  late final GeneratedColumn<String> requestHeadersJson =
      GeneratedColumn<String>(
        'request_headers_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _requestBodyMeta = const VerificationMeta(
    'requestBody',
  );
  @override
  late final GeneratedColumn<String> requestBody = GeneratedColumn<String>(
    'request_body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _responseHeadersJsonMeta =
      const VerificationMeta('responseHeadersJson');
  @override
  late final GeneratedColumn<String> responseHeadersJson =
      GeneratedColumn<String>(
        'response_headers_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _responseBodyMeta = const VerificationMeta(
    'responseBody',
  );
  @override
  late final GeneratedColumn<String> responseBody = GeneratedColumn<String>(
    'response_body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _responseTruncatedMeta = const VerificationMeta(
    'responseTruncated',
  );
  @override
  late final GeneratedColumn<bool> responseTruncated = GeneratedColumn<bool>(
    'response_truncated',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("response_truncated" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _errorMeta = const VerificationMeta('error');
  @override
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
    'error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    shortcutId,
    runId,
    stepId,
    stepKey,
    stepName,
    method,
    url,
    statusCode,
    success,
    durationMs,
    requestHeadersJson,
    requestBody,
    responseHeadersJson,
    responseBody,
    responseTruncated,
    error,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'request_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<RequestLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('shortcut_id')) {
      context.handle(
        _shortcutIdMeta,
        shortcutId.isAcceptableOrUnknown(data['shortcut_id']!, _shortcutIdMeta),
      );
    } else if (isInserting) {
      context.missing(_shortcutIdMeta);
    }
    if (data.containsKey('run_id')) {
      context.handle(
        _runIdMeta,
        runId.isAcceptableOrUnknown(data['run_id']!, _runIdMeta),
      );
    }
    if (data.containsKey('step_id')) {
      context.handle(
        _stepIdMeta,
        stepId.isAcceptableOrUnknown(data['step_id']!, _stepIdMeta),
      );
    }
    if (data.containsKey('step_key')) {
      context.handle(
        _stepKeyMeta,
        stepKey.isAcceptableOrUnknown(data['step_key']!, _stepKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_stepKeyMeta);
    }
    if (data.containsKey('step_name')) {
      context.handle(
        _stepNameMeta,
        stepName.isAcceptableOrUnknown(data['step_name']!, _stepNameMeta),
      );
    } else if (isInserting) {
      context.missing(_stepNameMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('status_code')) {
      context.handle(
        _statusCodeMeta,
        statusCode.isAcceptableOrUnknown(data['status_code']!, _statusCodeMeta),
      );
    }
    if (data.containsKey('success')) {
      context.handle(
        _successMeta,
        success.isAcceptableOrUnknown(data['success']!, _successMeta),
      );
    } else if (isInserting) {
      context.missing(_successMeta);
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    } else if (isInserting) {
      context.missing(_durationMsMeta);
    }
    if (data.containsKey('request_headers_json')) {
      context.handle(
        _requestHeadersJsonMeta,
        requestHeadersJson.isAcceptableOrUnknown(
          data['request_headers_json']!,
          _requestHeadersJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requestHeadersJsonMeta);
    }
    if (data.containsKey('request_body')) {
      context.handle(
        _requestBodyMeta,
        requestBody.isAcceptableOrUnknown(
          data['request_body']!,
          _requestBodyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requestBodyMeta);
    }
    if (data.containsKey('response_headers_json')) {
      context.handle(
        _responseHeadersJsonMeta,
        responseHeadersJson.isAcceptableOrUnknown(
          data['response_headers_json']!,
          _responseHeadersJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_responseHeadersJsonMeta);
    }
    if (data.containsKey('response_body')) {
      context.handle(
        _responseBodyMeta,
        responseBody.isAcceptableOrUnknown(
          data['response_body']!,
          _responseBodyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_responseBodyMeta);
    }
    if (data.containsKey('response_truncated')) {
      context.handle(
        _responseTruncatedMeta,
        responseTruncated.isAcceptableOrUnknown(
          data['response_truncated']!,
          _responseTruncatedMeta,
        ),
      );
    }
    if (data.containsKey('error')) {
      context.handle(
        _errorMeta,
        error.isAcceptableOrUnknown(data['error']!, _errorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RequestLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RequestLogRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      shortcutId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shortcut_id'],
      )!,
      runId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}run_id'],
      ),
      stepId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}step_id'],
      ),
      stepKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}step_key'],
      )!,
      stepName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}step_name'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      statusCode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status_code'],
      ),
      success: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}success'],
      )!,
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      )!,
      requestHeadersJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}request_headers_json'],
      )!,
      requestBody: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}request_body'],
      )!,
      responseHeadersJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}response_headers_json'],
      )!,
      responseBody: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}response_body'],
      )!,
      responseTruncated: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}response_truncated'],
      )!,
      error: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RequestLogsTable createAlias(String alias) {
    return $RequestLogsTable(attachedDatabase, alias);
  }
}

class RequestLogRow extends DataClass implements Insertable<RequestLogRow> {
  final int id;
  final int shortcutId;
  final int? runId;
  final int? stepId;
  final String stepKey;
  final String stepName;
  final String method;
  final String url;
  final int? statusCode;
  final bool success;
  final int durationMs;
  final String requestHeadersJson;
  final String requestBody;
  final String responseHeadersJson;
  final String responseBody;
  final bool responseTruncated;
  final String? error;
  final DateTime createdAt;
  const RequestLogRow({
    required this.id,
    required this.shortcutId,
    this.runId,
    this.stepId,
    required this.stepKey,
    required this.stepName,
    required this.method,
    required this.url,
    this.statusCode,
    required this.success,
    required this.durationMs,
    required this.requestHeadersJson,
    required this.requestBody,
    required this.responseHeadersJson,
    required this.responseBody,
    required this.responseTruncated,
    this.error,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['shortcut_id'] = Variable<int>(shortcutId);
    if (!nullToAbsent || runId != null) {
      map['run_id'] = Variable<int>(runId);
    }
    if (!nullToAbsent || stepId != null) {
      map['step_id'] = Variable<int>(stepId);
    }
    map['step_key'] = Variable<String>(stepKey);
    map['step_name'] = Variable<String>(stepName);
    map['method'] = Variable<String>(method);
    map['url'] = Variable<String>(url);
    if (!nullToAbsent || statusCode != null) {
      map['status_code'] = Variable<int>(statusCode);
    }
    map['success'] = Variable<bool>(success);
    map['duration_ms'] = Variable<int>(durationMs);
    map['request_headers_json'] = Variable<String>(requestHeadersJson);
    map['request_body'] = Variable<String>(requestBody);
    map['response_headers_json'] = Variable<String>(responseHeadersJson);
    map['response_body'] = Variable<String>(responseBody);
    map['response_truncated'] = Variable<bool>(responseTruncated);
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RequestLogsCompanion toCompanion(bool nullToAbsent) {
    return RequestLogsCompanion(
      id: Value(id),
      shortcutId: Value(shortcutId),
      runId: runId == null && nullToAbsent
          ? const Value.absent()
          : Value(runId),
      stepId: stepId == null && nullToAbsent
          ? const Value.absent()
          : Value(stepId),
      stepKey: Value(stepKey),
      stepName: Value(stepName),
      method: Value(method),
      url: Value(url),
      statusCode: statusCode == null && nullToAbsent
          ? const Value.absent()
          : Value(statusCode),
      success: Value(success),
      durationMs: Value(durationMs),
      requestHeadersJson: Value(requestHeadersJson),
      requestBody: Value(requestBody),
      responseHeadersJson: Value(responseHeadersJson),
      responseBody: Value(responseBody),
      responseTruncated: Value(responseTruncated),
      error: error == null && nullToAbsent
          ? const Value.absent()
          : Value(error),
      createdAt: Value(createdAt),
    );
  }

  factory RequestLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RequestLogRow(
      id: serializer.fromJson<int>(json['id']),
      shortcutId: serializer.fromJson<int>(json['shortcutId']),
      runId: serializer.fromJson<int?>(json['runId']),
      stepId: serializer.fromJson<int?>(json['stepId']),
      stepKey: serializer.fromJson<String>(json['stepKey']),
      stepName: serializer.fromJson<String>(json['stepName']),
      method: serializer.fromJson<String>(json['method']),
      url: serializer.fromJson<String>(json['url']),
      statusCode: serializer.fromJson<int?>(json['statusCode']),
      success: serializer.fromJson<bool>(json['success']),
      durationMs: serializer.fromJson<int>(json['durationMs']),
      requestHeadersJson: serializer.fromJson<String>(
        json['requestHeadersJson'],
      ),
      requestBody: serializer.fromJson<String>(json['requestBody']),
      responseHeadersJson: serializer.fromJson<String>(
        json['responseHeadersJson'],
      ),
      responseBody: serializer.fromJson<String>(json['responseBody']),
      responseTruncated: serializer.fromJson<bool>(json['responseTruncated']),
      error: serializer.fromJson<String?>(json['error']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'shortcutId': serializer.toJson<int>(shortcutId),
      'runId': serializer.toJson<int?>(runId),
      'stepId': serializer.toJson<int?>(stepId),
      'stepKey': serializer.toJson<String>(stepKey),
      'stepName': serializer.toJson<String>(stepName),
      'method': serializer.toJson<String>(method),
      'url': serializer.toJson<String>(url),
      'statusCode': serializer.toJson<int?>(statusCode),
      'success': serializer.toJson<bool>(success),
      'durationMs': serializer.toJson<int>(durationMs),
      'requestHeadersJson': serializer.toJson<String>(requestHeadersJson),
      'requestBody': serializer.toJson<String>(requestBody),
      'responseHeadersJson': serializer.toJson<String>(responseHeadersJson),
      'responseBody': serializer.toJson<String>(responseBody),
      'responseTruncated': serializer.toJson<bool>(responseTruncated),
      'error': serializer.toJson<String?>(error),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RequestLogRow copyWith({
    int? id,
    int? shortcutId,
    Value<int?> runId = const Value.absent(),
    Value<int?> stepId = const Value.absent(),
    String? stepKey,
    String? stepName,
    String? method,
    String? url,
    Value<int?> statusCode = const Value.absent(),
    bool? success,
    int? durationMs,
    String? requestHeadersJson,
    String? requestBody,
    String? responseHeadersJson,
    String? responseBody,
    bool? responseTruncated,
    Value<String?> error = const Value.absent(),
    DateTime? createdAt,
  }) => RequestLogRow(
    id: id ?? this.id,
    shortcutId: shortcutId ?? this.shortcutId,
    runId: runId.present ? runId.value : this.runId,
    stepId: stepId.present ? stepId.value : this.stepId,
    stepKey: stepKey ?? this.stepKey,
    stepName: stepName ?? this.stepName,
    method: method ?? this.method,
    url: url ?? this.url,
    statusCode: statusCode.present ? statusCode.value : this.statusCode,
    success: success ?? this.success,
    durationMs: durationMs ?? this.durationMs,
    requestHeadersJson: requestHeadersJson ?? this.requestHeadersJson,
    requestBody: requestBody ?? this.requestBody,
    responseHeadersJson: responseHeadersJson ?? this.responseHeadersJson,
    responseBody: responseBody ?? this.responseBody,
    responseTruncated: responseTruncated ?? this.responseTruncated,
    error: error.present ? error.value : this.error,
    createdAt: createdAt ?? this.createdAt,
  );
  RequestLogRow copyWithCompanion(RequestLogsCompanion data) {
    return RequestLogRow(
      id: data.id.present ? data.id.value : this.id,
      shortcutId: data.shortcutId.present
          ? data.shortcutId.value
          : this.shortcutId,
      runId: data.runId.present ? data.runId.value : this.runId,
      stepId: data.stepId.present ? data.stepId.value : this.stepId,
      stepKey: data.stepKey.present ? data.stepKey.value : this.stepKey,
      stepName: data.stepName.present ? data.stepName.value : this.stepName,
      method: data.method.present ? data.method.value : this.method,
      url: data.url.present ? data.url.value : this.url,
      statusCode: data.statusCode.present
          ? data.statusCode.value
          : this.statusCode,
      success: data.success.present ? data.success.value : this.success,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      requestHeadersJson: data.requestHeadersJson.present
          ? data.requestHeadersJson.value
          : this.requestHeadersJson,
      requestBody: data.requestBody.present
          ? data.requestBody.value
          : this.requestBody,
      responseHeadersJson: data.responseHeadersJson.present
          ? data.responseHeadersJson.value
          : this.responseHeadersJson,
      responseBody: data.responseBody.present
          ? data.responseBody.value
          : this.responseBody,
      responseTruncated: data.responseTruncated.present
          ? data.responseTruncated.value
          : this.responseTruncated,
      error: data.error.present ? data.error.value : this.error,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RequestLogRow(')
          ..write('id: $id, ')
          ..write('shortcutId: $shortcutId, ')
          ..write('runId: $runId, ')
          ..write('stepId: $stepId, ')
          ..write('stepKey: $stepKey, ')
          ..write('stepName: $stepName, ')
          ..write('method: $method, ')
          ..write('url: $url, ')
          ..write('statusCode: $statusCode, ')
          ..write('success: $success, ')
          ..write('durationMs: $durationMs, ')
          ..write('requestHeadersJson: $requestHeadersJson, ')
          ..write('requestBody: $requestBody, ')
          ..write('responseHeadersJson: $responseHeadersJson, ')
          ..write('responseBody: $responseBody, ')
          ..write('responseTruncated: $responseTruncated, ')
          ..write('error: $error, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    shortcutId,
    runId,
    stepId,
    stepKey,
    stepName,
    method,
    url,
    statusCode,
    success,
    durationMs,
    requestHeadersJson,
    requestBody,
    responseHeadersJson,
    responseBody,
    responseTruncated,
    error,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestLogRow &&
          other.id == this.id &&
          other.shortcutId == this.shortcutId &&
          other.runId == this.runId &&
          other.stepId == this.stepId &&
          other.stepKey == this.stepKey &&
          other.stepName == this.stepName &&
          other.method == this.method &&
          other.url == this.url &&
          other.statusCode == this.statusCode &&
          other.success == this.success &&
          other.durationMs == this.durationMs &&
          other.requestHeadersJson == this.requestHeadersJson &&
          other.requestBody == this.requestBody &&
          other.responseHeadersJson == this.responseHeadersJson &&
          other.responseBody == this.responseBody &&
          other.responseTruncated == this.responseTruncated &&
          other.error == this.error &&
          other.createdAt == this.createdAt);
}

class RequestLogsCompanion extends UpdateCompanion<RequestLogRow> {
  final Value<int> id;
  final Value<int> shortcutId;
  final Value<int?> runId;
  final Value<int?> stepId;
  final Value<String> stepKey;
  final Value<String> stepName;
  final Value<String> method;
  final Value<String> url;
  final Value<int?> statusCode;
  final Value<bool> success;
  final Value<int> durationMs;
  final Value<String> requestHeadersJson;
  final Value<String> requestBody;
  final Value<String> responseHeadersJson;
  final Value<String> responseBody;
  final Value<bool> responseTruncated;
  final Value<String?> error;
  final Value<DateTime> createdAt;
  const RequestLogsCompanion({
    this.id = const Value.absent(),
    this.shortcutId = const Value.absent(),
    this.runId = const Value.absent(),
    this.stepId = const Value.absent(),
    this.stepKey = const Value.absent(),
    this.stepName = const Value.absent(),
    this.method = const Value.absent(),
    this.url = const Value.absent(),
    this.statusCode = const Value.absent(),
    this.success = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.requestHeadersJson = const Value.absent(),
    this.requestBody = const Value.absent(),
    this.responseHeadersJson = const Value.absent(),
    this.responseBody = const Value.absent(),
    this.responseTruncated = const Value.absent(),
    this.error = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RequestLogsCompanion.insert({
    this.id = const Value.absent(),
    required int shortcutId,
    this.runId = const Value.absent(),
    this.stepId = const Value.absent(),
    required String stepKey,
    required String stepName,
    required String method,
    required String url,
    this.statusCode = const Value.absent(),
    required bool success,
    required int durationMs,
    required String requestHeadersJson,
    required String requestBody,
    required String responseHeadersJson,
    required String responseBody,
    this.responseTruncated = const Value.absent(),
    this.error = const Value.absent(),
    required DateTime createdAt,
  }) : shortcutId = Value(shortcutId),
       stepKey = Value(stepKey),
       stepName = Value(stepName),
       method = Value(method),
       url = Value(url),
       success = Value(success),
       durationMs = Value(durationMs),
       requestHeadersJson = Value(requestHeadersJson),
       requestBody = Value(requestBody),
       responseHeadersJson = Value(responseHeadersJson),
       responseBody = Value(responseBody),
       createdAt = Value(createdAt);
  static Insertable<RequestLogRow> custom({
    Expression<int>? id,
    Expression<int>? shortcutId,
    Expression<int>? runId,
    Expression<int>? stepId,
    Expression<String>? stepKey,
    Expression<String>? stepName,
    Expression<String>? method,
    Expression<String>? url,
    Expression<int>? statusCode,
    Expression<bool>? success,
    Expression<int>? durationMs,
    Expression<String>? requestHeadersJson,
    Expression<String>? requestBody,
    Expression<String>? responseHeadersJson,
    Expression<String>? responseBody,
    Expression<bool>? responseTruncated,
    Expression<String>? error,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shortcutId != null) 'shortcut_id': shortcutId,
      if (runId != null) 'run_id': runId,
      if (stepId != null) 'step_id': stepId,
      if (stepKey != null) 'step_key': stepKey,
      if (stepName != null) 'step_name': stepName,
      if (method != null) 'method': method,
      if (url != null) 'url': url,
      if (statusCode != null) 'status_code': statusCode,
      if (success != null) 'success': success,
      if (durationMs != null) 'duration_ms': durationMs,
      if (requestHeadersJson != null)
        'request_headers_json': requestHeadersJson,
      if (requestBody != null) 'request_body': requestBody,
      if (responseHeadersJson != null)
        'response_headers_json': responseHeadersJson,
      if (responseBody != null) 'response_body': responseBody,
      if (responseTruncated != null) 'response_truncated': responseTruncated,
      if (error != null) 'error': error,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RequestLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? shortcutId,
    Value<int?>? runId,
    Value<int?>? stepId,
    Value<String>? stepKey,
    Value<String>? stepName,
    Value<String>? method,
    Value<String>? url,
    Value<int?>? statusCode,
    Value<bool>? success,
    Value<int>? durationMs,
    Value<String>? requestHeadersJson,
    Value<String>? requestBody,
    Value<String>? responseHeadersJson,
    Value<String>? responseBody,
    Value<bool>? responseTruncated,
    Value<String?>? error,
    Value<DateTime>? createdAt,
  }) {
    return RequestLogsCompanion(
      id: id ?? this.id,
      shortcutId: shortcutId ?? this.shortcutId,
      runId: runId ?? this.runId,
      stepId: stepId ?? this.stepId,
      stepKey: stepKey ?? this.stepKey,
      stepName: stepName ?? this.stepName,
      method: method ?? this.method,
      url: url ?? this.url,
      statusCode: statusCode ?? this.statusCode,
      success: success ?? this.success,
      durationMs: durationMs ?? this.durationMs,
      requestHeadersJson: requestHeadersJson ?? this.requestHeadersJson,
      requestBody: requestBody ?? this.requestBody,
      responseHeadersJson: responseHeadersJson ?? this.responseHeadersJson,
      responseBody: responseBody ?? this.responseBody,
      responseTruncated: responseTruncated ?? this.responseTruncated,
      error: error ?? this.error,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (shortcutId.present) {
      map['shortcut_id'] = Variable<int>(shortcutId.value);
    }
    if (runId.present) {
      map['run_id'] = Variable<int>(runId.value);
    }
    if (stepId.present) {
      map['step_id'] = Variable<int>(stepId.value);
    }
    if (stepKey.present) {
      map['step_key'] = Variable<String>(stepKey.value);
    }
    if (stepName.present) {
      map['step_name'] = Variable<String>(stepName.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (statusCode.present) {
      map['status_code'] = Variable<int>(statusCode.value);
    }
    if (success.present) {
      map['success'] = Variable<bool>(success.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (requestHeadersJson.present) {
      map['request_headers_json'] = Variable<String>(requestHeadersJson.value);
    }
    if (requestBody.present) {
      map['request_body'] = Variable<String>(requestBody.value);
    }
    if (responseHeadersJson.present) {
      map['response_headers_json'] = Variable<String>(
        responseHeadersJson.value,
      );
    }
    if (responseBody.present) {
      map['response_body'] = Variable<String>(responseBody.value);
    }
    if (responseTruncated.present) {
      map['response_truncated'] = Variable<bool>(responseTruncated.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RequestLogsCompanion(')
          ..write('id: $id, ')
          ..write('shortcutId: $shortcutId, ')
          ..write('runId: $runId, ')
          ..write('stepId: $stepId, ')
          ..write('stepKey: $stepKey, ')
          ..write('stepName: $stepName, ')
          ..write('method: $method, ')
          ..write('url: $url, ')
          ..write('statusCode: $statusCode, ')
          ..write('success: $success, ')
          ..write('durationMs: $durationMs, ')
          ..write('requestHeadersJson: $requestHeadersJson, ')
          ..write('requestBody: $requestBody, ')
          ..write('responseHeadersJson: $responseHeadersJson, ')
          ..write('responseBody: $responseBody, ')
          ..write('responseTruncated: $responseTruncated, ')
          ..write('error: $error, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ShortcutsTable shortcuts = $ShortcutsTable(this);
  late final $RequestStepsTable requestSteps = $RequestStepsTable(this);
  late final $ExecutionRunsTable executionRuns = $ExecutionRunsTable(this);
  late final $RequestLogsTable requestLogs = $RequestLogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    shortcuts,
    requestSteps,
    executionRuns,
    requestLogs,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'shortcuts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('request_steps', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'shortcuts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('execution_runs', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'shortcuts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('request_logs', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'execution_runs',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('request_logs', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'request_steps',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('request_logs', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$ShortcutsTableCreateCompanionBuilder =
    ShortcutsCompanion Function({
      Value<int> id,
      required String name,
      Value<String> description,
      Value<String> icon,
      Value<int> color,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$ShortcutsTableUpdateCompanionBuilder =
    ShortcutsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> description,
      Value<String> icon,
      Value<int> color,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$ShortcutsTableReferences
    extends BaseReferences<_$AppDatabase, $ShortcutsTable, ShortcutRow> {
  $$ShortcutsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RequestStepsTable, List<RequestStepRow>>
  _requestStepsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.requestSteps,
    aliasName: $_aliasNameGenerator(
      db.shortcuts.id,
      db.requestSteps.shortcutId,
    ),
  );

  $$RequestStepsTableProcessedTableManager get requestStepsRefs {
    final manager = $$RequestStepsTableTableManager(
      $_db,
      $_db.requestSteps,
    ).filter((f) => f.shortcutId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_requestStepsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExecutionRunsTable, List<ExecutionRunRow>>
  _executionRunsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.executionRuns,
    aliasName: $_aliasNameGenerator(
      db.shortcuts.id,
      db.executionRuns.shortcutId,
    ),
  );

  $$ExecutionRunsTableProcessedTableManager get executionRunsRefs {
    final manager = $$ExecutionRunsTableTableManager(
      $_db,
      $_db.executionRuns,
    ).filter((f) => f.shortcutId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_executionRunsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RequestLogsTable, List<RequestLogRow>>
  _requestLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.requestLogs,
    aliasName: $_aliasNameGenerator(db.shortcuts.id, db.requestLogs.shortcutId),
  );

  $$RequestLogsTableProcessedTableManager get requestLogsRefs {
    final manager = $$RequestLogsTableTableManager(
      $_db,
      $_db.requestLogs,
    ).filter((f) => f.shortcutId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_requestLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ShortcutsTableFilterComposer
    extends Composer<_$AppDatabase, $ShortcutsTable> {
  $$ShortcutsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> requestStepsRefs(
    Expression<bool> Function($$RequestStepsTableFilterComposer f) f,
  ) {
    final $$RequestStepsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.requestSteps,
      getReferencedColumn: (t) => t.shortcutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RequestStepsTableFilterComposer(
            $db: $db,
            $table: $db.requestSteps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> executionRunsRefs(
    Expression<bool> Function($$ExecutionRunsTableFilterComposer f) f,
  ) {
    final $$ExecutionRunsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.executionRuns,
      getReferencedColumn: (t) => t.shortcutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExecutionRunsTableFilterComposer(
            $db: $db,
            $table: $db.executionRuns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> requestLogsRefs(
    Expression<bool> Function($$RequestLogsTableFilterComposer f) f,
  ) {
    final $$RequestLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.requestLogs,
      getReferencedColumn: (t) => t.shortcutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RequestLogsTableFilterComposer(
            $db: $db,
            $table: $db.requestLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ShortcutsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShortcutsTable> {
  $$ShortcutsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShortcutsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShortcutsTable> {
  $$ShortcutsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> requestStepsRefs<T extends Object>(
    Expression<T> Function($$RequestStepsTableAnnotationComposer a) f,
  ) {
    final $$RequestStepsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.requestSteps,
      getReferencedColumn: (t) => t.shortcutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RequestStepsTableAnnotationComposer(
            $db: $db,
            $table: $db.requestSteps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> executionRunsRefs<T extends Object>(
    Expression<T> Function($$ExecutionRunsTableAnnotationComposer a) f,
  ) {
    final $$ExecutionRunsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.executionRuns,
      getReferencedColumn: (t) => t.shortcutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExecutionRunsTableAnnotationComposer(
            $db: $db,
            $table: $db.executionRuns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> requestLogsRefs<T extends Object>(
    Expression<T> Function($$RequestLogsTableAnnotationComposer a) f,
  ) {
    final $$RequestLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.requestLogs,
      getReferencedColumn: (t) => t.shortcutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RequestLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.requestLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ShortcutsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShortcutsTable,
          ShortcutRow,
          $$ShortcutsTableFilterComposer,
          $$ShortcutsTableOrderingComposer,
          $$ShortcutsTableAnnotationComposer,
          $$ShortcutsTableCreateCompanionBuilder,
          $$ShortcutsTableUpdateCompanionBuilder,
          (ShortcutRow, $$ShortcutsTableReferences),
          ShortcutRow,
          PrefetchHooks Function({
            bool requestStepsRefs,
            bool executionRunsRefs,
            bool requestLogsRefs,
          })
        > {
  $$ShortcutsTableTableManager(_$AppDatabase db, $ShortcutsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShortcutsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShortcutsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShortcutsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ShortcutsCompanion(
                id: id,
                name: name,
                description: description,
                icon: icon,
                color: color,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String> description = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> color = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => ShortcutsCompanion.insert(
                id: id,
                name: name,
                description: description,
                icon: icon,
                color: color,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ShortcutsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                requestStepsRefs = false,
                executionRunsRefs = false,
                requestLogsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (requestStepsRefs) db.requestSteps,
                    if (executionRunsRefs) db.executionRuns,
                    if (requestLogsRefs) db.requestLogs,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (requestStepsRefs)
                        await $_getPrefetchedData<
                          ShortcutRow,
                          $ShortcutsTable,
                          RequestStepRow
                        >(
                          currentTable: table,
                          referencedTable: $$ShortcutsTableReferences
                              ._requestStepsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShortcutsTableReferences(
                                db,
                                table,
                                p0,
                              ).requestStepsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.shortcutId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (executionRunsRefs)
                        await $_getPrefetchedData<
                          ShortcutRow,
                          $ShortcutsTable,
                          ExecutionRunRow
                        >(
                          currentTable: table,
                          referencedTable: $$ShortcutsTableReferences
                              ._executionRunsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShortcutsTableReferences(
                                db,
                                table,
                                p0,
                              ).executionRunsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.shortcutId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (requestLogsRefs)
                        await $_getPrefetchedData<
                          ShortcutRow,
                          $ShortcutsTable,
                          RequestLogRow
                        >(
                          currentTable: table,
                          referencedTable: $$ShortcutsTableReferences
                              ._requestLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShortcutsTableReferences(
                                db,
                                table,
                                p0,
                              ).requestLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.shortcutId == item.id,
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

typedef $$ShortcutsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShortcutsTable,
      ShortcutRow,
      $$ShortcutsTableFilterComposer,
      $$ShortcutsTableOrderingComposer,
      $$ShortcutsTableAnnotationComposer,
      $$ShortcutsTableCreateCompanionBuilder,
      $$ShortcutsTableUpdateCompanionBuilder,
      (ShortcutRow, $$ShortcutsTableReferences),
      ShortcutRow,
      PrefetchHooks Function({
        bool requestStepsRefs,
        bool executionRunsRefs,
        bool requestLogsRefs,
      })
    >;
typedef $$RequestStepsTableCreateCompanionBuilder =
    RequestStepsCompanion Function({
      Value<int> id,
      required int shortcutId,
      required String stepKey,
      required String name,
      required int sortOrder,
      required String requestJson,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$RequestStepsTableUpdateCompanionBuilder =
    RequestStepsCompanion Function({
      Value<int> id,
      Value<int> shortcutId,
      Value<String> stepKey,
      Value<String> name,
      Value<int> sortOrder,
      Value<String> requestJson,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$RequestStepsTableReferences
    extends BaseReferences<_$AppDatabase, $RequestStepsTable, RequestStepRow> {
  $$RequestStepsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ShortcutsTable _shortcutIdTable(_$AppDatabase db) =>
      db.shortcuts.createAlias(
        $_aliasNameGenerator(db.requestSteps.shortcutId, db.shortcuts.id),
      );

  $$ShortcutsTableProcessedTableManager get shortcutId {
    final $_column = $_itemColumn<int>('shortcut_id')!;

    final manager = $$ShortcutsTableTableManager(
      $_db,
      $_db.shortcuts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shortcutIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$RequestLogsTable, List<RequestLogRow>>
  _requestLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.requestLogs,
    aliasName: $_aliasNameGenerator(db.requestSteps.id, db.requestLogs.stepId),
  );

  $$RequestLogsTableProcessedTableManager get requestLogsRefs {
    final manager = $$RequestLogsTableTableManager(
      $_db,
      $_db.requestLogs,
    ).filter((f) => f.stepId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_requestLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RequestStepsTableFilterComposer
    extends Composer<_$AppDatabase, $RequestStepsTable> {
  $$RequestStepsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stepKey => $composableBuilder(
    column: $table.stepKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get requestJson => $composableBuilder(
    column: $table.requestJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ShortcutsTableFilterComposer get shortcutId {
    final $$ShortcutsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shortcutId,
      referencedTable: $db.shortcuts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShortcutsTableFilterComposer(
            $db: $db,
            $table: $db.shortcuts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> requestLogsRefs(
    Expression<bool> Function($$RequestLogsTableFilterComposer f) f,
  ) {
    final $$RequestLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.requestLogs,
      getReferencedColumn: (t) => t.stepId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RequestLogsTableFilterComposer(
            $db: $db,
            $table: $db.requestLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RequestStepsTableOrderingComposer
    extends Composer<_$AppDatabase, $RequestStepsTable> {
  $$RequestStepsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stepKey => $composableBuilder(
    column: $table.stepKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get requestJson => $composableBuilder(
    column: $table.requestJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ShortcutsTableOrderingComposer get shortcutId {
    final $$ShortcutsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shortcutId,
      referencedTable: $db.shortcuts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShortcutsTableOrderingComposer(
            $db: $db,
            $table: $db.shortcuts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RequestStepsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RequestStepsTable> {
  $$RequestStepsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get stepKey =>
      $composableBuilder(column: $table.stepKey, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get requestJson => $composableBuilder(
    column: $table.requestJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ShortcutsTableAnnotationComposer get shortcutId {
    final $$ShortcutsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shortcutId,
      referencedTable: $db.shortcuts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShortcutsTableAnnotationComposer(
            $db: $db,
            $table: $db.shortcuts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> requestLogsRefs<T extends Object>(
    Expression<T> Function($$RequestLogsTableAnnotationComposer a) f,
  ) {
    final $$RequestLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.requestLogs,
      getReferencedColumn: (t) => t.stepId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RequestLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.requestLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RequestStepsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RequestStepsTable,
          RequestStepRow,
          $$RequestStepsTableFilterComposer,
          $$RequestStepsTableOrderingComposer,
          $$RequestStepsTableAnnotationComposer,
          $$RequestStepsTableCreateCompanionBuilder,
          $$RequestStepsTableUpdateCompanionBuilder,
          (RequestStepRow, $$RequestStepsTableReferences),
          RequestStepRow,
          PrefetchHooks Function({bool shortcutId, bool requestLogsRefs})
        > {
  $$RequestStepsTableTableManager(_$AppDatabase db, $RequestStepsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RequestStepsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RequestStepsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RequestStepsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> shortcutId = const Value.absent(),
                Value<String> stepKey = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String> requestJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => RequestStepsCompanion(
                id: id,
                shortcutId: shortcutId,
                stepKey: stepKey,
                name: name,
                sortOrder: sortOrder,
                requestJson: requestJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int shortcutId,
                required String stepKey,
                required String name,
                required int sortOrder,
                required String requestJson,
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => RequestStepsCompanion.insert(
                id: id,
                shortcutId: shortcutId,
                stepKey: stepKey,
                name: name,
                sortOrder: sortOrder,
                requestJson: requestJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RequestStepsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({shortcutId = false, requestLogsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (requestLogsRefs) db.requestLogs,
                  ],
                  addJoins:
                      <
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
                        if (shortcutId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.shortcutId,
                                    referencedTable:
                                        $$RequestStepsTableReferences
                                            ._shortcutIdTable(db),
                                    referencedColumn:
                                        $$RequestStepsTableReferences
                                            ._shortcutIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (requestLogsRefs)
                        await $_getPrefetchedData<
                          RequestStepRow,
                          $RequestStepsTable,
                          RequestLogRow
                        >(
                          currentTable: table,
                          referencedTable: $$RequestStepsTableReferences
                              ._requestLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RequestStepsTableReferences(
                                db,
                                table,
                                p0,
                              ).requestLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.stepId == item.id,
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

typedef $$RequestStepsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RequestStepsTable,
      RequestStepRow,
      $$RequestStepsTableFilterComposer,
      $$RequestStepsTableOrderingComposer,
      $$RequestStepsTableAnnotationComposer,
      $$RequestStepsTableCreateCompanionBuilder,
      $$RequestStepsTableUpdateCompanionBuilder,
      (RequestStepRow, $$RequestStepsTableReferences),
      RequestStepRow,
      PrefetchHooks Function({bool shortcutId, bool requestLogsRefs})
    >;
typedef $$ExecutionRunsTableCreateCompanionBuilder =
    ExecutionRunsCompanion Function({
      Value<int> id,
      required int shortcutId,
      required String status,
      required DateTime startedAt,
      Value<DateTime?> finishedAt,
      Value<int?> durationMs,
      Value<String?> error,
    });
typedef $$ExecutionRunsTableUpdateCompanionBuilder =
    ExecutionRunsCompanion Function({
      Value<int> id,
      Value<int> shortcutId,
      Value<String> status,
      Value<DateTime> startedAt,
      Value<DateTime?> finishedAt,
      Value<int?> durationMs,
      Value<String?> error,
    });

final class $$ExecutionRunsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ExecutionRunsTable, ExecutionRunRow> {
  $$ExecutionRunsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ShortcutsTable _shortcutIdTable(_$AppDatabase db) =>
      db.shortcuts.createAlias(
        $_aliasNameGenerator(db.executionRuns.shortcutId, db.shortcuts.id),
      );

  $$ShortcutsTableProcessedTableManager get shortcutId {
    final $_column = $_itemColumn<int>('shortcut_id')!;

    final manager = $$ShortcutsTableTableManager(
      $_db,
      $_db.shortcuts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shortcutIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$RequestLogsTable, List<RequestLogRow>>
  _requestLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.requestLogs,
    aliasName: $_aliasNameGenerator(db.executionRuns.id, db.requestLogs.runId),
  );

  $$RequestLogsTableProcessedTableManager get requestLogsRefs {
    final manager = $$RequestLogsTableTableManager(
      $_db,
      $_db.requestLogs,
    ).filter((f) => f.runId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_requestLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExecutionRunsTableFilterComposer
    extends Composer<_$AppDatabase, $ExecutionRunsTable> {
  $$ExecutionRunsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnFilters(column),
  );

  $$ShortcutsTableFilterComposer get shortcutId {
    final $$ShortcutsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shortcutId,
      referencedTable: $db.shortcuts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShortcutsTableFilterComposer(
            $db: $db,
            $table: $db.shortcuts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> requestLogsRefs(
    Expression<bool> Function($$RequestLogsTableFilterComposer f) f,
  ) {
    final $$RequestLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.requestLogs,
      getReferencedColumn: (t) => t.runId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RequestLogsTableFilterComposer(
            $db: $db,
            $table: $db.requestLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExecutionRunsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExecutionRunsTable> {
  $$ExecutionRunsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnOrderings(column),
  );

  $$ShortcutsTableOrderingComposer get shortcutId {
    final $$ShortcutsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shortcutId,
      referencedTable: $db.shortcuts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShortcutsTableOrderingComposer(
            $db: $db,
            $table: $db.shortcuts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExecutionRunsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExecutionRunsTable> {
  $$ExecutionRunsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => column);

  $$ShortcutsTableAnnotationComposer get shortcutId {
    final $$ShortcutsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shortcutId,
      referencedTable: $db.shortcuts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShortcutsTableAnnotationComposer(
            $db: $db,
            $table: $db.shortcuts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> requestLogsRefs<T extends Object>(
    Expression<T> Function($$RequestLogsTableAnnotationComposer a) f,
  ) {
    final $$RequestLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.requestLogs,
      getReferencedColumn: (t) => t.runId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RequestLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.requestLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExecutionRunsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExecutionRunsTable,
          ExecutionRunRow,
          $$ExecutionRunsTableFilterComposer,
          $$ExecutionRunsTableOrderingComposer,
          $$ExecutionRunsTableAnnotationComposer,
          $$ExecutionRunsTableCreateCompanionBuilder,
          $$ExecutionRunsTableUpdateCompanionBuilder,
          (ExecutionRunRow, $$ExecutionRunsTableReferences),
          ExecutionRunRow,
          PrefetchHooks Function({bool shortcutId, bool requestLogsRefs})
        > {
  $$ExecutionRunsTableTableManager(_$AppDatabase db, $ExecutionRunsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExecutionRunsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExecutionRunsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExecutionRunsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> shortcutId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<String?> error = const Value.absent(),
              }) => ExecutionRunsCompanion(
                id: id,
                shortcutId: shortcutId,
                status: status,
                startedAt: startedAt,
                finishedAt: finishedAt,
                durationMs: durationMs,
                error: error,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int shortcutId,
                required String status,
                required DateTime startedAt,
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<String?> error = const Value.absent(),
              }) => ExecutionRunsCompanion.insert(
                id: id,
                shortcutId: shortcutId,
                status: status,
                startedAt: startedAt,
                finishedAt: finishedAt,
                durationMs: durationMs,
                error: error,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExecutionRunsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({shortcutId = false, requestLogsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (requestLogsRefs) db.requestLogs,
                  ],
                  addJoins:
                      <
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
                        if (shortcutId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.shortcutId,
                                    referencedTable:
                                        $$ExecutionRunsTableReferences
                                            ._shortcutIdTable(db),
                                    referencedColumn:
                                        $$ExecutionRunsTableReferences
                                            ._shortcutIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (requestLogsRefs)
                        await $_getPrefetchedData<
                          ExecutionRunRow,
                          $ExecutionRunsTable,
                          RequestLogRow
                        >(
                          currentTable: table,
                          referencedTable: $$ExecutionRunsTableReferences
                              ._requestLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExecutionRunsTableReferences(
                                db,
                                table,
                                p0,
                              ).requestLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.runId == item.id,
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

typedef $$ExecutionRunsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExecutionRunsTable,
      ExecutionRunRow,
      $$ExecutionRunsTableFilterComposer,
      $$ExecutionRunsTableOrderingComposer,
      $$ExecutionRunsTableAnnotationComposer,
      $$ExecutionRunsTableCreateCompanionBuilder,
      $$ExecutionRunsTableUpdateCompanionBuilder,
      (ExecutionRunRow, $$ExecutionRunsTableReferences),
      ExecutionRunRow,
      PrefetchHooks Function({bool shortcutId, bool requestLogsRefs})
    >;
typedef $$RequestLogsTableCreateCompanionBuilder =
    RequestLogsCompanion Function({
      Value<int> id,
      required int shortcutId,
      Value<int?> runId,
      Value<int?> stepId,
      required String stepKey,
      required String stepName,
      required String method,
      required String url,
      Value<int?> statusCode,
      required bool success,
      required int durationMs,
      required String requestHeadersJson,
      required String requestBody,
      required String responseHeadersJson,
      required String responseBody,
      Value<bool> responseTruncated,
      Value<String?> error,
      required DateTime createdAt,
    });
typedef $$RequestLogsTableUpdateCompanionBuilder =
    RequestLogsCompanion Function({
      Value<int> id,
      Value<int> shortcutId,
      Value<int?> runId,
      Value<int?> stepId,
      Value<String> stepKey,
      Value<String> stepName,
      Value<String> method,
      Value<String> url,
      Value<int?> statusCode,
      Value<bool> success,
      Value<int> durationMs,
      Value<String> requestHeadersJson,
      Value<String> requestBody,
      Value<String> responseHeadersJson,
      Value<String> responseBody,
      Value<bool> responseTruncated,
      Value<String?> error,
      Value<DateTime> createdAt,
    });

final class $$RequestLogsTableReferences
    extends BaseReferences<_$AppDatabase, $RequestLogsTable, RequestLogRow> {
  $$RequestLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ShortcutsTable _shortcutIdTable(_$AppDatabase db) =>
      db.shortcuts.createAlias(
        $_aliasNameGenerator(db.requestLogs.shortcutId, db.shortcuts.id),
      );

  $$ShortcutsTableProcessedTableManager get shortcutId {
    final $_column = $_itemColumn<int>('shortcut_id')!;

    final manager = $$ShortcutsTableTableManager(
      $_db,
      $_db.shortcuts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shortcutIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExecutionRunsTable _runIdTable(_$AppDatabase db) =>
      db.executionRuns.createAlias(
        $_aliasNameGenerator(db.requestLogs.runId, db.executionRuns.id),
      );

  $$ExecutionRunsTableProcessedTableManager? get runId {
    final $_column = $_itemColumn<int>('run_id');
    if ($_column == null) return null;
    final manager = $$ExecutionRunsTableTableManager(
      $_db,
      $_db.executionRuns,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_runIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RequestStepsTable _stepIdTable(_$AppDatabase db) =>
      db.requestSteps.createAlias(
        $_aliasNameGenerator(db.requestLogs.stepId, db.requestSteps.id),
      );

  $$RequestStepsTableProcessedTableManager? get stepId {
    final $_column = $_itemColumn<int>('step_id');
    if ($_column == null) return null;
    final manager = $$RequestStepsTableTableManager(
      $_db,
      $_db.requestSteps,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_stepIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RequestLogsTableFilterComposer
    extends Composer<_$AppDatabase, $RequestLogsTable> {
  $$RequestLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stepKey => $composableBuilder(
    column: $table.stepKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stepName => $composableBuilder(
    column: $table.stepName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get statusCode => $composableBuilder(
    column: $table.statusCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get success => $composableBuilder(
    column: $table.success,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get requestHeadersJson => $composableBuilder(
    column: $table.requestHeadersJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get requestBody => $composableBuilder(
    column: $table.requestBody,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get responseHeadersJson => $composableBuilder(
    column: $table.responseHeadersJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get responseBody => $composableBuilder(
    column: $table.responseBody,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get responseTruncated => $composableBuilder(
    column: $table.responseTruncated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ShortcutsTableFilterComposer get shortcutId {
    final $$ShortcutsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shortcutId,
      referencedTable: $db.shortcuts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShortcutsTableFilterComposer(
            $db: $db,
            $table: $db.shortcuts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExecutionRunsTableFilterComposer get runId {
    final $$ExecutionRunsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.runId,
      referencedTable: $db.executionRuns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExecutionRunsTableFilterComposer(
            $db: $db,
            $table: $db.executionRuns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RequestStepsTableFilterComposer get stepId {
    final $$RequestStepsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stepId,
      referencedTable: $db.requestSteps,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RequestStepsTableFilterComposer(
            $db: $db,
            $table: $db.requestSteps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RequestLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $RequestLogsTable> {
  $$RequestLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stepKey => $composableBuilder(
    column: $table.stepKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stepName => $composableBuilder(
    column: $table.stepName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get statusCode => $composableBuilder(
    column: $table.statusCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get success => $composableBuilder(
    column: $table.success,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get requestHeadersJson => $composableBuilder(
    column: $table.requestHeadersJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get requestBody => $composableBuilder(
    column: $table.requestBody,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get responseHeadersJson => $composableBuilder(
    column: $table.responseHeadersJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get responseBody => $composableBuilder(
    column: $table.responseBody,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get responseTruncated => $composableBuilder(
    column: $table.responseTruncated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ShortcutsTableOrderingComposer get shortcutId {
    final $$ShortcutsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shortcutId,
      referencedTable: $db.shortcuts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShortcutsTableOrderingComposer(
            $db: $db,
            $table: $db.shortcuts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExecutionRunsTableOrderingComposer get runId {
    final $$ExecutionRunsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.runId,
      referencedTable: $db.executionRuns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExecutionRunsTableOrderingComposer(
            $db: $db,
            $table: $db.executionRuns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RequestStepsTableOrderingComposer get stepId {
    final $$RequestStepsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stepId,
      referencedTable: $db.requestSteps,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RequestStepsTableOrderingComposer(
            $db: $db,
            $table: $db.requestSteps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RequestLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RequestLogsTable> {
  $$RequestLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get stepKey =>
      $composableBuilder(column: $table.stepKey, builder: (column) => column);

  GeneratedColumn<String> get stepName =>
      $composableBuilder(column: $table.stepName, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<int> get statusCode => $composableBuilder(
    column: $table.statusCode,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get success =>
      $composableBuilder(column: $table.success, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get requestHeadersJson => $composableBuilder(
    column: $table.requestHeadersJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get requestBody => $composableBuilder(
    column: $table.requestBody,
    builder: (column) => column,
  );

  GeneratedColumn<String> get responseHeadersJson => $composableBuilder(
    column: $table.responseHeadersJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get responseBody => $composableBuilder(
    column: $table.responseBody,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get responseTruncated => $composableBuilder(
    column: $table.responseTruncated,
    builder: (column) => column,
  );

  GeneratedColumn<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ShortcutsTableAnnotationComposer get shortcutId {
    final $$ShortcutsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shortcutId,
      referencedTable: $db.shortcuts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShortcutsTableAnnotationComposer(
            $db: $db,
            $table: $db.shortcuts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExecutionRunsTableAnnotationComposer get runId {
    final $$ExecutionRunsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.runId,
      referencedTable: $db.executionRuns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExecutionRunsTableAnnotationComposer(
            $db: $db,
            $table: $db.executionRuns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RequestStepsTableAnnotationComposer get stepId {
    final $$RequestStepsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stepId,
      referencedTable: $db.requestSteps,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RequestStepsTableAnnotationComposer(
            $db: $db,
            $table: $db.requestSteps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RequestLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RequestLogsTable,
          RequestLogRow,
          $$RequestLogsTableFilterComposer,
          $$RequestLogsTableOrderingComposer,
          $$RequestLogsTableAnnotationComposer,
          $$RequestLogsTableCreateCompanionBuilder,
          $$RequestLogsTableUpdateCompanionBuilder,
          (RequestLogRow, $$RequestLogsTableReferences),
          RequestLogRow,
          PrefetchHooks Function({bool shortcutId, bool runId, bool stepId})
        > {
  $$RequestLogsTableTableManager(_$AppDatabase db, $RequestLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RequestLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RequestLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RequestLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> shortcutId = const Value.absent(),
                Value<int?> runId = const Value.absent(),
                Value<int?> stepId = const Value.absent(),
                Value<String> stepKey = const Value.absent(),
                Value<String> stepName = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<int?> statusCode = const Value.absent(),
                Value<bool> success = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<String> requestHeadersJson = const Value.absent(),
                Value<String> requestBody = const Value.absent(),
                Value<String> responseHeadersJson = const Value.absent(),
                Value<String> responseBody = const Value.absent(),
                Value<bool> responseTruncated = const Value.absent(),
                Value<String?> error = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RequestLogsCompanion(
                id: id,
                shortcutId: shortcutId,
                runId: runId,
                stepId: stepId,
                stepKey: stepKey,
                stepName: stepName,
                method: method,
                url: url,
                statusCode: statusCode,
                success: success,
                durationMs: durationMs,
                requestHeadersJson: requestHeadersJson,
                requestBody: requestBody,
                responseHeadersJson: responseHeadersJson,
                responseBody: responseBody,
                responseTruncated: responseTruncated,
                error: error,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int shortcutId,
                Value<int?> runId = const Value.absent(),
                Value<int?> stepId = const Value.absent(),
                required String stepKey,
                required String stepName,
                required String method,
                required String url,
                Value<int?> statusCode = const Value.absent(),
                required bool success,
                required int durationMs,
                required String requestHeadersJson,
                required String requestBody,
                required String responseHeadersJson,
                required String responseBody,
                Value<bool> responseTruncated = const Value.absent(),
                Value<String?> error = const Value.absent(),
                required DateTime createdAt,
              }) => RequestLogsCompanion.insert(
                id: id,
                shortcutId: shortcutId,
                runId: runId,
                stepId: stepId,
                stepKey: stepKey,
                stepName: stepName,
                method: method,
                url: url,
                statusCode: statusCode,
                success: success,
                durationMs: durationMs,
                requestHeadersJson: requestHeadersJson,
                requestBody: requestBody,
                responseHeadersJson: responseHeadersJson,
                responseBody: responseBody,
                responseTruncated: responseTruncated,
                error: error,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RequestLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({shortcutId = false, runId = false, stepId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
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
                        if (shortcutId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.shortcutId,
                                    referencedTable:
                                        $$RequestLogsTableReferences
                                            ._shortcutIdTable(db),
                                    referencedColumn:
                                        $$RequestLogsTableReferences
                                            ._shortcutIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (runId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.runId,
                                    referencedTable:
                                        $$RequestLogsTableReferences
                                            ._runIdTable(db),
                                    referencedColumn:
                                        $$RequestLogsTableReferences
                                            ._runIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (stepId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.stepId,
                                    referencedTable:
                                        $$RequestLogsTableReferences
                                            ._stepIdTable(db),
                                    referencedColumn:
                                        $$RequestLogsTableReferences
                                            ._stepIdTable(db)
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

typedef $$RequestLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RequestLogsTable,
      RequestLogRow,
      $$RequestLogsTableFilterComposer,
      $$RequestLogsTableOrderingComposer,
      $$RequestLogsTableAnnotationComposer,
      $$RequestLogsTableCreateCompanionBuilder,
      $$RequestLogsTableUpdateCompanionBuilder,
      (RequestLogRow, $$RequestLogsTableReferences),
      RequestLogRow,
      PrefetchHooks Function({bool shortcutId, bool runId, bool stepId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ShortcutsTableTableManager get shortcuts =>
      $$ShortcutsTableTableManager(_db, _db.shortcuts);
  $$RequestStepsTableTableManager get requestSteps =>
      $$RequestStepsTableTableManager(_db, _db.requestSteps);
  $$ExecutionRunsTableTableManager get executionRuns =>
      $$ExecutionRunsTableTableManager(_db, _db.executionRuns);
  $$RequestLogsTableTableManager get requestLogs =>
      $$RequestLogsTableTableManager(_db, _db.requestLogs);
}
