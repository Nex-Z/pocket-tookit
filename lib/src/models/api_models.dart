import 'dart:convert';

enum AuthType { none, bearer, basic, apiKey }

enum ApiKeyPlacement { header, query }

enum BodyType { none, json, text, formUrlEncoded, formData }

enum ExecutionStatus { running, success, failed }

const defaultShortcutColor = 0xFFFF9F0A;

class ApiShortcut {
  const ApiShortcut({
    this.id,
    required this.name,
    this.description = '',
    this.icon = 'bolt',
    this.color = defaultShortcutColor,
    required this.createdAt,
    required this.updatedAt,
    this.steps = const [],
  });

  factory ApiShortcut.draft() {
    final now = DateTime.now();
    return ApiShortcut(
      name: '新指令',
      description: '按顺序编排 API 请求',
      createdAt: now,
      updatedAt: now,
      steps: [RequestStep.draft(sortOrder: 0)],
    );
  }

  final int? id;
  final String name;
  final String description;
  final String icon;
  final int color;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<RequestStep> steps;

  ApiShortcut copyWith({
    int? id,
    String? name,
    String? description,
    String? icon,
    int? color,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<RequestStep>? steps,
  }) {
    return ApiShortcut(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      steps: steps ?? this.steps,
    );
  }
}

class RequestStep {
  const RequestStep({
    this.id,
    this.shortcutId,
    required this.key,
    required this.name,
    required this.sortOrder,
    required this.request,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RequestStep.draft({required int sortOrder}) {
    final now = DateTime.now();
    final number = sortOrder + 1;
    return RequestStep(
      key: 'step$number',
      name: '请求 $number',
      sortOrder: sortOrder,
      request: RequestDefinition.empty(),
      createdAt: now,
      updatedAt: now,
    );
  }

  final int? id;
  final int? shortcutId;
  final String key;
  final String name;
  final int sortOrder;
  final RequestDefinition request;
  final DateTime createdAt;
  final DateTime updatedAt;

  RequestStep copyWith({
    int? id,
    int? shortcutId,
    String? key,
    String? name,
    int? sortOrder,
    RequestDefinition? request,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RequestStep(
      id: id ?? this.id,
      shortcutId: shortcutId ?? this.shortcutId,
      key: key ?? this.key,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      request: request ?? this.request,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class RequestDefinition {
  const RequestDefinition({
    required this.method,
    required this.url,
    this.query = const {},
    this.headers = const {},
    this.auth = const AuthConfig.none(),
    this.body = const BodyConfig.none(),
    this.timeoutSeconds = 30,
  });

  factory RequestDefinition.empty() {
    return const RequestDefinition(method: 'GET', url: '');
  }

  factory RequestDefinition.fromJson(Map<String, Object?> json) {
    return RequestDefinition(
      method: (json['method'] as String?) ?? 'GET',
      url: (json['url'] as String?) ?? '',
      query: _decodeStringMap(json['query']),
      headers: _decodeStringMap(json['headers']),
      auth: AuthConfig.fromJson(_decodeObject(json['auth'])),
      body: BodyConfig.fromJson(_decodeObject(json['body'])),
      timeoutSeconds: (json['timeoutSeconds'] as num?)?.toInt() ?? 30,
    );
  }

  final String method;
  final String url;
  final Map<String, String> query;
  final Map<String, String> headers;
  final AuthConfig auth;
  final BodyConfig body;
  final int timeoutSeconds;

  Map<String, Object?> toJson() {
    return {
      'method': method,
      'url': url,
      'query': query,
      'headers': headers,
      'auth': auth.toJson(),
      'body': body.toJson(),
      'timeoutSeconds': timeoutSeconds,
    };
  }

  String toJsonString() => jsonEncode(toJson());

  RequestDefinition copyWith({
    String? method,
    String? url,
    Map<String, String>? query,
    Map<String, String>? headers,
    AuthConfig? auth,
    BodyConfig? body,
    int? timeoutSeconds,
  }) {
    return RequestDefinition(
      method: method ?? this.method,
      url: url ?? this.url,
      query: query ?? this.query,
      headers: headers ?? this.headers,
      auth: auth ?? this.auth,
      body: body ?? this.body,
      timeoutSeconds: timeoutSeconds ?? this.timeoutSeconds,
    );
  }
}

class AuthConfig {
  const AuthConfig({
    required this.type,
    this.token = '',
    this.username = '',
    this.password = '',
    this.apiKeyName = '',
    this.apiKeyValue = '',
    this.apiKeyPlacement = ApiKeyPlacement.header,
  });

  const AuthConfig.none() : this(type: AuthType.none);

  factory AuthConfig.fromJson(Map<String, Object?> json) {
    return AuthConfig(
      type:
          _enumByName(AuthType.values, json['type'] as String?) ??
          AuthType.none,
      token: (json['token'] as String?) ?? '',
      username: (json['username'] as String?) ?? '',
      password: (json['password'] as String?) ?? '',
      apiKeyName: (json['apiKeyName'] as String?) ?? '',
      apiKeyValue: (json['apiKeyValue'] as String?) ?? '',
      apiKeyPlacement:
          _enumByName(
            ApiKeyPlacement.values,
            json['apiKeyPlacement'] as String?,
          ) ??
          ApiKeyPlacement.header,
    );
  }

  final AuthType type;
  final String token;
  final String username;
  final String password;
  final String apiKeyName;
  final String apiKeyValue;
  final ApiKeyPlacement apiKeyPlacement;

  Map<String, Object?> toJson() {
    return {
      'type': type.name,
      'token': token,
      'username': username,
      'password': password,
      'apiKeyName': apiKeyName,
      'apiKeyValue': apiKeyValue,
      'apiKeyPlacement': apiKeyPlacement.name,
    };
  }

  AuthConfig copyWith({
    AuthType? type,
    String? token,
    String? username,
    String? password,
    String? apiKeyName,
    String? apiKeyValue,
    ApiKeyPlacement? apiKeyPlacement,
  }) {
    return AuthConfig(
      type: type ?? this.type,
      token: token ?? this.token,
      username: username ?? this.username,
      password: password ?? this.password,
      apiKeyName: apiKeyName ?? this.apiKeyName,
      apiKeyValue: apiKeyValue ?? this.apiKeyValue,
      apiKeyPlacement: apiKeyPlacement ?? this.apiKeyPlacement,
    );
  }
}

class BodyConfig {
  const BodyConfig({required this.type, this.raw = '', this.fields = const {}});

  const BodyConfig.none() : this(type: BodyType.none);

  factory BodyConfig.fromJson(Map<String, Object?> json) {
    return BodyConfig(
      type:
          _enumByName(BodyType.values, json['type'] as String?) ??
          BodyType.none,
      raw: (json['raw'] as String?) ?? '',
      fields: _decodeStringMap(json['fields']),
    );
  }

  final BodyType type;
  final String raw;
  final Map<String, String> fields;

  Map<String, Object?> toJson() {
    return {'type': type.name, 'raw': raw, 'fields': fields};
  }

  BodyConfig copyWith({
    BodyType? type,
    String? raw,
    Map<String, String>? fields,
  }) {
    return BodyConfig(
      type: type ?? this.type,
      raw: raw ?? this.raw,
      fields: fields ?? this.fields,
    );
  }
}

class ExecutionRunRecord {
  const ExecutionRunRecord({
    required this.id,
    required this.shortcutId,
    required this.status,
    required this.startedAt,
    this.finishedAt,
    this.durationMs,
    this.error,
  });

  final int id;
  final int shortcutId;
  final ExecutionStatus status;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final int? durationMs;
  final String? error;
}

class RequestLogEntry {
  const RequestLogEntry({
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
    required this.requestHeaders,
    required this.requestBody,
    required this.responseHeaders,
    required this.responseBody,
    required this.responseTruncated,
    this.error,
    required this.createdAt,
  });

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
  final Map<String, String> requestHeaders;
  final String requestBody;
  final Map<String, String> responseHeaders;
  final String responseBody;
  final bool responseTruncated;
  final String? error;
  final DateTime createdAt;
}

class RequestLogDraft {
  const RequestLogDraft({
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
    required this.requestHeaders,
    required this.requestBody,
    required this.responseHeaders,
    required this.responseBody,
    required this.responseTruncated,
    this.error,
    required this.createdAt,
  });

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
  final Map<String, String> requestHeaders;
  final String requestBody;
  final Map<String, String> responseHeaders;
  final String responseBody;
  final bool responseTruncated;
  final String? error;
  final DateTime createdAt;
}

Map<String, Object?> decodeJsonObject(String value) {
  if (value.trim().isEmpty) {
    return {};
  }
  final decoded = jsonDecode(value);
  if (decoded is Map<String, Object?>) {
    return decoded;
  }
  if (decoded is Map) {
    return decoded.map((key, value) => MapEntry(key.toString(), value));
  }
  return {};
}

Map<String, String> _decodeStringMap(Object? value) {
  if (value is Map<String, String>) {
    return value;
  }
  if (value is Map) {
    return value.map(
      (key, value) => MapEntry(key.toString(), value?.toString() ?? ''),
    );
  }
  return {};
}

Map<String, Object?> _decodeObject(Object? value) {
  if (value is Map<String, Object?>) {
    return value;
  }
  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), value));
  }
  return {};
}

T? _enumByName<T extends Enum>(List<T> values, String? name) {
  if (name == null) {
    return null;
  }
  for (final value in values) {
    if (value.name == name) {
      return value;
    }
  }
  return null;
}
