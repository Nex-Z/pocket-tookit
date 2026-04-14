import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../models/api_models.dart';

class ShortcutRepository {
  ShortcutRepository(this._db);

  final AppDatabase _db;

  Stream<List<ApiShortcut>> watchShortcuts() {
    final query = _db.select(_db.shortcuts)
      ..orderBy([(table) => OrderingTerm.desc(table.updatedAt)]);

    return query.watch().map((rows) => rows.map(_shortcutFromRow).toList());
  }

  Stream<List<RequestLogEntry>> watchLogs() {
    final query = _db.select(_db.requestLogs)
      ..orderBy([(table) => OrderingTerm.desc(table.createdAt)]);

    return query.watch().map((rows) => rows.map(_logFromRow).toList());
  }

  Future<ApiShortcut?> getShortcut(int id) async {
    final row = await (_db.select(
      _db.shortcuts,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
    if (row == null) {
      return null;
    }
    final steps =
        await (_db.select(_db.requestSteps)
              ..where((table) => table.shortcutId.equals(id))
              ..orderBy([(table) => OrderingTerm.asc(table.sortOrder)]))
            .get();

    return _shortcutFromRow(
      row,
    ).copyWith(steps: steps.map(_stepFromRow).toList());
  }

  Future<RequestLogEntry?> getLog(int id) async {
    final row = await (_db.select(
      _db.requestLogs,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
    return row == null ? null : _logFromRow(row);
  }

  Future<int> saveShortcut(ApiShortcut shortcut) async {
    final now = DateTime.now();

    return _db.transaction(() async {
      final shortcutId = shortcut.id;
      final savedId =
          shortcutId ??
          await _db
              .into(_db.shortcuts)
              .insert(
                ShortcutsCompanion.insert(
                  name: shortcut.name,
                  description: Value(shortcut.description),
                  icon: Value(shortcut.icon),
                  color: Value(shortcut.color),
                  createdAt: shortcut.createdAt,
                  updatedAt: now,
                ),
              );

      if (shortcutId != null) {
        await (_db.update(
          _db.shortcuts,
        )..where((table) => table.id.equals(shortcutId))).write(
          ShortcutsCompanion(
            name: Value(shortcut.name),
            description: Value(shortcut.description),
            icon: Value(shortcut.icon),
            color: Value(shortcut.color),
            updatedAt: Value(now),
          ),
        );
        await (_db.delete(
          _db.requestSteps,
        )..where((table) => table.shortcutId.equals(shortcutId))).go();
      }

      for (final (index, step) in shortcut.steps.indexed) {
        final createdAt = step.id == null ? now : step.createdAt;
        await _db
            .into(_db.requestSteps)
            .insert(
              RequestStepsCompanion.insert(
                shortcutId: savedId,
                stepKey: step.key.trim().isEmpty
                    ? 'step${index + 1}'
                    : step.key.trim(),
                name: step.name.trim().isEmpty
                    ? '请求 ${index + 1}'
                    : step.name.trim(),
                sortOrder: index,
                requestJson: step.request.toJsonString(),
                createdAt: createdAt,
                updatedAt: now,
              ),
            );
      }

      return savedId;
    });
  }

  Future<void> deleteShortcut(int id) {
    return (_db.delete(
      _db.shortcuts,
    )..where((table) => table.id.equals(id))).go();
  }

  Future<int> startRun(int shortcutId) {
    final now = DateTime.now();
    return _db
        .into(_db.executionRuns)
        .insert(
          ExecutionRunsCompanion.insert(
            shortcutId: shortcutId,
            status: ExecutionStatus.running.name,
            startedAt: now,
          ),
        );
  }

  Future<void> finishRun({
    required int runId,
    required ExecutionStatus status,
    required int durationMs,
    String? error,
  }) {
    return (_db.update(
      _db.executionRuns,
    )..where((table) => table.id.equals(runId))).write(
      ExecutionRunsCompanion(
        status: Value(status.name),
        finishedAt: Value(DateTime.now()),
        durationMs: Value(durationMs),
        error: Value(error),
      ),
    );
  }

  Future<RequestLogEntry> insertLog(RequestLogDraft draft) async {
    final id = await _db
        .into(_db.requestLogs)
        .insert(
          RequestLogsCompanion.insert(
            shortcutId: draft.shortcutId,
            runId: Value(draft.runId),
            stepId: Value(draft.stepId),
            stepKey: draft.stepKey,
            stepName: draft.stepName,
            method: draft.method,
            url: draft.url,
            statusCode: Value(draft.statusCode),
            success: draft.success,
            durationMs: draft.durationMs,
            requestHeadersJson: encodeStringMap(draft.requestHeaders),
            requestBody: draft.requestBody,
            responseHeadersJson: encodeStringMap(draft.responseHeaders),
            responseBody: draft.responseBody,
            responseTruncated: Value(draft.responseTruncated),
            error: Value(draft.error),
            createdAt: draft.createdAt,
          ),
        );

    final row = await (_db.select(
      _db.requestLogs,
    )..where((table) => table.id.equals(id))).getSingle();
    return _logFromRow(row);
  }

  Future<void> deleteLog(int id) {
    return (_db.delete(
      _db.requestLogs,
    )..where((table) => table.id.equals(id))).go();
  }

  Future<void> clearLogs() => _db.delete(_db.requestLogs).go();

  ApiShortcut _shortcutFromRow(ShortcutRow row) {
    return ApiShortcut(
      id: row.id,
      name: row.name,
      description: row.description,
      icon: row.icon,
      color: row.color,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  RequestStep _stepFromRow(RequestStepRow row) {
    return RequestStep(
      id: row.id,
      shortcutId: row.shortcutId,
      key: row.stepKey,
      name: row.name,
      sortOrder: row.sortOrder,
      request: requestDefinitionFromJson(row.requestJson),
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  RequestLogEntry _logFromRow(RequestLogRow row) {
    return RequestLogEntry(
      id: row.id,
      shortcutId: row.shortcutId,
      runId: row.runId,
      stepId: row.stepId,
      stepKey: row.stepKey,
      stepName: row.stepName,
      method: row.method,
      url: row.url,
      statusCode: row.statusCode,
      success: row.success,
      durationMs: row.durationMs,
      requestHeaders: decodeStringMap(row.requestHeadersJson),
      requestBody: row.requestBody,
      responseHeaders: decodeStringMap(row.responseHeadersJson),
      responseBody: row.responseBody,
      responseTruncated: row.responseTruncated,
      error: row.error,
      createdAt: row.createdAt,
    );
  }
}
