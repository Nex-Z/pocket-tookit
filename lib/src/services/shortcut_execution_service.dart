import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/api_models.dart';
import '../repositories/shortcut_repository.dart';
import 'template_resolver.dart';

const maxBodySnapshotChars = 32 * 1024;

class BodySnapshot {
  const BodySnapshot({required this.text, required this.truncated});

  final String text;
  final bool truncated;
}

class StepExecutionResult {
  const StepExecutionResult({
    required this.step,
    required this.log,
    required this.success,
    this.error,
  });

  final RequestStep step;
  final RequestLogEntry log;
  final bool success;
  final String? error;
}

class ShortcutExecutionResult {
  const ShortcutExecutionResult({
    required this.shortcut,
    required this.runId,
    required this.results,
    required this.context,
    required this.success,
    this.error,
  });

  final ApiShortcut shortcut;
  final int runId;
  final List<StepExecutionResult> results;
  final TemplateContext context;
  final bool success;
  final String? error;
}

class ResolvedRequest {
  const ResolvedRequest({
    required this.method,
    required this.url,
    required this.headers,
    required this.data,
    this.contentType,
  });

  final String method;
  final String url;
  final Map<String, String> headers;
  final Object? data;
  final String? contentType;
}

class ShortcutExecutionService {
  ShortcutExecutionService({
    required ShortcutRepository repository,
    required TemplateResolver templateResolver,
    Dio? dio,
  }) : _repository = repository,
       _templateResolver = templateResolver,
       _dio = dio ?? Dio();

  final ShortcutRepository _repository;
  final TemplateResolver _templateResolver;
  final Dio _dio;

  Future<ShortcutExecutionResult> execute(ApiShortcut shortcut) async {
    final shortcutId = shortcut.id;
    if (shortcutId == null) {
      throw StateError('请先保存指令再执行');
    }

    final runStartedAt = DateTime.now();
    final runId = await _repository.startRun(shortcutId);
    var context = const TemplateContext();
    final results = <StepExecutionResult>[];
    String? runError;

    for (final step in shortcut.steps) {
      final startedAt = DateTime.now();
      ResolvedRequest? resolved;
      RequestLogEntry? log;

      try {
        resolved = _resolveRequest(step.request, context);
        final response = await _dio.request<Object?>(
          resolved.url,
          data: resolved.data,
          options: Options(
            method: resolved.method,
            headers: resolved.headers,
            contentType: resolved.contentType,
            sendTimeout: Duration(seconds: step.request.timeoutSeconds),
            receiveTimeout: Duration(seconds: step.request.timeoutSeconds),
            validateStatus: (_) => true,
          ),
        );

        final durationMs = DateTime.now().difference(startedAt).inMilliseconds;
        final statusCode = response.statusCode;
        final success =
            statusCode != null && statusCode >= 200 && statusCode < 300;
        final responseHeaders = _headersToMap(response.headers);
        final responseBody = normalizeResponseBody(response.data);
        final responseSnapshot = bodySnapshot(response.data);

        log = await _repository.insertLog(
          RequestLogDraft(
            shortcutId: shortcutId,
            runId: runId,
            stepId: step.id,
            stepKey: step.key,
            stepName: step.name,
            method: resolved.method,
            url: resolved.url,
            statusCode: statusCode,
            success: success,
            durationMs: durationMs,
            requestHeaders: resolved.headers,
            requestBody: bodySnapshot(resolved.data).text,
            responseHeaders: responseHeaders,
            responseBody: responseSnapshot.text,
            responseTruncated: responseSnapshot.truncated,
            error: success ? null : 'HTTP $statusCode',
            createdAt: startedAt,
          ),
        );

        results.add(
          StepExecutionResult(step: step, log: log, success: success),
        );
        if (!success) {
          runError = '步骤 ${step.name} 返回 HTTP $statusCode';
          break;
        }

        context = context.withStep(
          step.key,
          StepExecutionSnapshot(
            status: statusCode,
            headers: responseHeaders,
            body: responseBody,
          ),
        );
      } catch (error) {
        final durationMs = DateTime.now().difference(startedAt).inMilliseconds;
        final message = _errorMessage(error);
        log = await _repository.insertLog(
          RequestLogDraft(
            shortcutId: shortcutId,
            runId: runId,
            stepId: step.id,
            stepKey: step.key,
            stepName: step.name,
            method: resolved?.method ?? step.request.method,
            url: resolved?.url ?? step.request.url,
            success: false,
            durationMs: durationMs,
            requestHeaders: resolved?.headers ?? step.request.headers,
            requestBody: resolved == null
                ? ''
                : bodySnapshot(resolved.data).text,
            responseHeaders: const {},
            responseBody: '',
            responseTruncated: false,
            error: message,
            createdAt: startedAt,
          ),
        );
        results.add(
          StepExecutionResult(
            step: step,
            log: log,
            success: false,
            error: message,
          ),
        );
        runError = '步骤 ${step.name} 执行失败：$message';
        break;
      }
    }

    final success = runError == null;
    await _repository.finishRun(
      runId: runId,
      status: success ? ExecutionStatus.success : ExecutionStatus.failed,
      durationMs: DateTime.now().difference(runStartedAt).inMilliseconds,
      error: runError,
    );

    return ShortcutExecutionResult(
      shortcut: shortcut,
      runId: runId,
      results: results,
      context: context,
      success: success,
      error: runError,
    );
  }

  Future<ShortcutExecutionResult> executeStep(
    ApiShortcut shortcut,
    RequestStep step, {
    TemplateContext initialContext = const TemplateContext(),
  }) async {
    final shortcutId = shortcut.id;
    if (shortcutId == null) {
      throw StateError('请先保存指令再调试');
    }

    final runStartedAt = DateTime.now();
    final runId = await _repository.startRun(shortcutId);
    var context = initialContext;
    final startedAt = DateTime.now();
    ResolvedRequest? resolved;
    late StepExecutionResult result;
    String? runError;

    try {
      resolved = _resolveRequest(step.request, context);
      final response = await _dio.request<Object?>(
        resolved.url,
        data: resolved.data,
        options: Options(
          method: resolved.method,
          headers: resolved.headers,
          contentType: resolved.contentType,
          sendTimeout: Duration(seconds: step.request.timeoutSeconds),
          receiveTimeout: Duration(seconds: step.request.timeoutSeconds),
          validateStatus: (_) => true,
        ),
      );

      final durationMs = DateTime.now().difference(startedAt).inMilliseconds;
      final statusCode = response.statusCode;
      final success =
          statusCode != null && statusCode >= 200 && statusCode < 300;
      final responseHeaders = _headersToMap(response.headers);
      final responseBody = normalizeResponseBody(response.data);
      final responseSnapshot = bodySnapshot(response.data);
      final log = await _repository.insertLog(
        RequestLogDraft(
          shortcutId: shortcutId,
          runId: runId,
          stepId: step.id,
          stepKey: step.key,
          stepName: step.name,
          method: resolved.method,
          url: resolved.url,
          statusCode: statusCode,
          success: success,
          durationMs: durationMs,
          requestHeaders: resolved.headers,
          requestBody: bodySnapshot(resolved.data).text,
          responseHeaders: responseHeaders,
          responseBody: responseSnapshot.text,
          responseTruncated: responseSnapshot.truncated,
          error: success ? null : 'HTTP $statusCode',
          createdAt: startedAt,
        ),
      );

      result = StepExecutionResult(step: step, log: log, success: success);
      if (success) {
        context = context.withStep(
          step.key,
          StepExecutionSnapshot(
            status: statusCode,
            headers: responseHeaders,
            body: responseBody,
          ),
        );
      } else {
        runError = '步骤 ${step.name} 返回 HTTP $statusCode';
      }
    } catch (error) {
      final durationMs = DateTime.now().difference(startedAt).inMilliseconds;
      final message = _errorMessage(error);
      final log = await _repository.insertLog(
        RequestLogDraft(
          shortcutId: shortcutId,
          runId: runId,
          stepId: step.id,
          stepKey: step.key,
          stepName: step.name,
          method: resolved?.method ?? step.request.method,
          url: resolved?.url ?? step.request.url,
          success: false,
          durationMs: durationMs,
          requestHeaders: resolved?.headers ?? step.request.headers,
          requestBody: resolved == null ? '' : bodySnapshot(resolved.data).text,
          responseHeaders: const {},
          responseBody: '',
          responseTruncated: false,
          error: message,
          createdAt: startedAt,
        ),
      );
      result = StepExecutionResult(
        step: step,
        log: log,
        success: false,
        error: message,
      );
      runError = '步骤 ${step.name} 调试失败：$message';
    }

    final success = runError == null;
    await _repository.finishRun(
      runId: runId,
      status: success ? ExecutionStatus.success : ExecutionStatus.failed,
      durationMs: DateTime.now().difference(runStartedAt).inMilliseconds,
      error: runError,
    );

    return ShortcutExecutionResult(
      shortcut: shortcut,
      runId: runId,
      results: [result],
      context: context,
      success: success,
      error: runError,
    );
  }

  ResolvedRequest _resolveRequest(
    RequestDefinition request,
    TemplateContext context,
  ) {
    final headers = _templateResolver.resolveMap(request.headers, context);
    final query = _templateResolver.resolveMap(request.query, context);
    final urlText = _templateResolver.resolveString(request.url, context);
    final uri = Uri.parse(urlText);
    final queryParameters = <String, String>{...uri.queryParameters, ...query}
      ..removeWhere((key, value) => key.isEmpty);

    var resolvedUrl = uri.replace(queryParameters: queryParameters).toString();
    final authHeaders = <String, String>{};
    final authQuery = <String, String>{};
    _applyAuth(request.auth, context, authHeaders, authQuery);

    if (authQuery.isNotEmpty) {
      final authUri = Uri.parse(resolvedUrl);
      resolvedUrl = authUri
          .replace(queryParameters: {...authUri.queryParameters, ...authQuery})
          .toString();
    }

    final resolvedHeaders = {...headers, ...authHeaders};
    final (data, contentType) = _resolveBody(
      request.body,
      context,
      resolvedHeaders,
    );

    return ResolvedRequest(
      method: request.method.toUpperCase(),
      url: resolvedUrl,
      headers: resolvedHeaders,
      data: data,
      contentType: contentType,
    );
  }

  void _applyAuth(
    AuthConfig auth,
    TemplateContext context,
    Map<String, String> headers,
    Map<String, String> query,
  ) {
    switch (auth.type) {
      case AuthType.none:
        return;
      case AuthType.bearer:
        final token = _templateResolver.resolveString(auth.token, context);
        if (token.isNotEmpty) {
          headers['Authorization'] = 'Bearer $token';
        }
        return;
      case AuthType.basic:
        final username = _templateResolver.resolveString(
          auth.username,
          context,
        );
        final password = _templateResolver.resolveString(
          auth.password,
          context,
        );
        final encoded = base64Encode(utf8.encode('$username:$password'));
        headers['Authorization'] = 'Basic $encoded';
        return;
      case AuthType.apiKey:
        final name = _templateResolver.resolveString(auth.apiKeyName, context);
        final value = _templateResolver.resolveString(
          auth.apiKeyValue,
          context,
        );
        if (name.isEmpty) {
          return;
        }
        if (auth.apiKeyPlacement == ApiKeyPlacement.header) {
          headers[name] = value;
        } else {
          query[name] = value;
        }
        return;
    }
  }

  (Object?, String?) _resolveBody(
    BodyConfig body,
    TemplateContext context,
    Map<String, String> headers,
  ) {
    switch (body.type) {
      case BodyType.none:
        return (null, null);
      case BodyType.json:
        final raw = _templateResolver.resolveString(body.raw, context);
        if (raw.trim().isEmpty) {
          return (null, Headers.jsonContentType);
        }
        try {
          return (jsonDecode(raw), Headers.jsonContentType);
        } catch (_) {
          return (raw, Headers.jsonContentType);
        }
      case BodyType.text:
        return (
          _templateResolver.resolveString(body.raw, context),
          Headers.textPlainContentType,
        );
      case BodyType.formUrlEncoded:
        return (
          _templateResolver.resolveMap(body.fields, context),
          Headers.formUrlEncodedContentType,
        );
      case BodyType.formData:
        final fields = _templateResolver.resolveMap(body.fields, context);
        headers.putIfAbsent('Content-Type', () => 'multipart/form-data');
        return (FormData.fromMap(fields), 'multipart/form-data');
    }
  }

  Map<String, String> _headersToMap(Headers headers) {
    return headers.map.map((key, value) => MapEntry(key, value.join(', ')));
  }

  String _errorMessage(Object error) {
    if (error is DioException) {
      return error.message ?? error.type.name;
    }
    return error.toString();
  }
}

Object? normalizeResponseBody(Object? data) {
  if (data is String) {
    try {
      return jsonDecode(data);
    } catch (_) {
      return data;
    }
  }
  return data;
}

BodySnapshot bodySnapshot(Object? data, {int maxChars = maxBodySnapshotChars}) {
  final text = _bodyToText(data);
  if (text.length <= maxChars) {
    return BodySnapshot(text: text, truncated: false);
  }
  return BodySnapshot(
    text:
        '${text.substring(0, maxChars)}\n... 已截断 ${text.length - maxChars} 个字符',
    truncated: true,
  );
}

String _bodyToText(Object? data) {
  if (data == null) {
    return '';
  }
  if (data is String) {
    return data;
  }
  if (data is FormData) {
    final fields = data.fields
        .map((entry) => '${entry.key}=${entry.value}')
        .join('\n');
    final files = data.files.map((entry) => '${entry.key}=<file>').join('\n');
    return [fields, files].where((value) => value.isNotEmpty).join('\n');
  }
  try {
    return const JsonEncoder.withIndent('  ').convert(data);
  } catch (_) {
    return data.toString();
  }
}
