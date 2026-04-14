import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../models/api_models.dart';

part 'app_database.g.dart';

@DataClassName('ShortcutRow')
class Shortcuts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get icon => text().withDefault(const Constant('bolt'))();
  IntColumn get color =>
      integer().withDefault(const Constant(defaultShortcutColor))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

@DataClassName('RequestStepRow')
class RequestSteps extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get shortcutId =>
      integer().references(Shortcuts, #id, onDelete: KeyAction.cascade)();
  TextColumn get stepKey => text()();
  TextColumn get name => text()();
  IntColumn get sortOrder => integer()();
  TextColumn get requestJson => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

@DataClassName('ExecutionRunRow')
class ExecutionRuns extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get shortcutId =>
      integer().references(Shortcuts, #id, onDelete: KeyAction.cascade)();
  TextColumn get status => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get finishedAt => dateTime().nullable()();
  IntColumn get durationMs => integer().nullable()();
  TextColumn get error => text().nullable()();
}

@DataClassName('RequestLogRow')
class RequestLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get shortcutId =>
      integer().references(Shortcuts, #id, onDelete: KeyAction.cascade)();
  IntColumn get runId => integer().nullable().references(
    ExecutionRuns,
    #id,
    onDelete: KeyAction.setNull,
  )();
  IntColumn get stepId => integer().nullable().references(
    RequestSteps,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get stepKey => text()();
  TextColumn get stepName => text()();
  TextColumn get method => text()();
  TextColumn get url => text()();
  IntColumn get statusCode => integer().nullable()();
  BoolColumn get success => boolean()();
  IntColumn get durationMs => integer()();
  TextColumn get requestHeadersJson => text()();
  TextColumn get requestBody => text()();
  TextColumn get responseHeadersJson => text()();
  TextColumn get responseBody => text()();
  BoolColumn get responseTruncated =>
      boolean().withDefault(const Constant(false))();
  TextColumn get error => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

@DriftDatabase(tables: [Shortcuts, RequestSteps, ExecutionRuns, RequestLogs])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  AppDatabase.defaults() : super(driftDatabase(name: 'pocket_tookit'));

  @override
  int get schemaVersion => 1;
}

RequestDefinition requestDefinitionFromJson(String value) {
  return RequestDefinition.fromJson(decodeJsonObject(value));
}

String encodeStringMap(Map<String, String> value) => jsonEncode(value);

Map<String, String> decodeStringMap(String value) {
  if (value.trim().isEmpty) {
    return {};
  }
  final decoded = jsonDecode(value);
  if (decoded is Map) {
    return decoded.map(
      (key, value) => MapEntry(key.toString(), value?.toString() ?? ''),
    );
  }
  return {};
}

ExecutionStatus executionStatusFromName(String name) {
  return ExecutionStatus.values.firstWhere(
    (status) => status.name == name,
    orElse: () => ExecutionStatus.failed,
  );
}
