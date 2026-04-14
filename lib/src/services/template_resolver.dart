import 'dart:convert';

import 'package:json_path/json_path.dart';

class StepExecutionSnapshot {
  const StepExecutionSnapshot({
    required this.status,
    required this.headers,
    required this.body,
  });

  final int? status;
  final Map<String, String> headers;
  final Object? body;
}

class TemplateContext {
  const TemplateContext({
    this.steps = const {},
    this.environment = const {},
    this.variables = const {},
  });

  final Map<String, StepExecutionSnapshot> steps;
  final Map<String, String> environment;
  final Map<String, String> variables;

  TemplateContext withStep(String key, StepExecutionSnapshot snapshot) {
    return TemplateContext(
      steps: {...steps, key: snapshot},
      environment: environment,
      variables: variables,
    );
  }
}

class TemplateResolutionException implements Exception {
  const TemplateResolutionException(this.message);

  final String message;

  @override
  String toString() => message;
}

class TemplateResolver {
  static final _pattern = RegExp(r'{{\s*([^{}]+?)\s*}}');

  String resolveString(String input, TemplateContext context) {
    return input.replaceAllMapped(_pattern, (match) {
      final expression = match.group(1)!.trim();
      final value = resolveExpression(expression, context);
      if (value is String) {
        return value;
      }
      if (value == null) {
        return '';
      }
      if (value is num || value is bool) {
        return value.toString();
      }
      return jsonEncode(value);
    });
  }

  Map<String, String> resolveMap(
    Map<String, String> input,
    TemplateContext context,
  ) {
    return input.map(
      (key, value) =>
          MapEntry(resolveString(key, context), resolveString(value, context)),
    );
  }

  Object? resolveExpression(String expression, TemplateContext context) {
    final override = context.variables[expression];
    if (override != null) {
      return override;
    }

    final parts = expression.split('.');
    if (parts.isEmpty) {
      throw const TemplateResolutionException('变量为空');
    }

    if (parts.first == 'env') {
      final key = parts.skip(1).join('.');
      if (!context.environment.containsKey(key)) {
        throw TemplateResolutionException('环境变量 $key 不存在');
      }
      return context.environment[key];
    }

    if (parts.length < 3 || parts.first != 'steps') {
      throw TemplateResolutionException('无法识别变量 {{$expression}}');
    }

    final stepKey = parts[1];
    final snapshot = context.steps[stepKey];
    if (snapshot == null) {
      throw TemplateResolutionException('步骤 $stepKey 尚无响应');
    }

    final scope = parts[2];
    if (scope == 'status') {
      return snapshot.status;
    }

    if (scope == 'headers') {
      final headerName = parts.skip(3).join('.').toLowerCase();
      final headers = snapshot.headers.map(
        (key, value) => MapEntry(key.toLowerCase(), value),
      );
      if (!headers.containsKey(headerName)) {
        throw TemplateResolutionException('步骤 $stepKey 的响应头 $headerName 不存在');
      }
      return headers[headerName];
    }

    if (scope == 'body') {
      final path = parts.skip(3).join('.');
      if (path.isEmpty) {
        return snapshot.body;
      }
      return _readBodyPath(stepKey, snapshot.body, path);
    }

    throw TemplateResolutionException('无法识别步骤字段 $scope');
  }

  Object? _readBodyPath(String stepKey, Object? body, String path) {
    if (body == null) {
      throw TemplateResolutionException('步骤 $stepKey 的响应体为空');
    }

    final jsonPath = path.startsWith(r'$') ? path : '\$.$path';
    final matches = JsonPath(jsonPath).read(body).toList();
    if (matches.isEmpty) {
      throw TemplateResolutionException('步骤 $stepKey 的响应体路径 $path 不存在');
    }
    return matches.first.value;
  }
}
