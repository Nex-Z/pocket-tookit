import 'package:curl_parser/curl_parser.dart';

import '../models/api_models.dart';

class CurlImportResult {
  const CurlImportResult({required this.step, this.warnings = const []});

  final RequestStep step;
  final List<String> warnings;
}

class CurlImportService {
  CurlImportResult parse(String input, {int sortOrder = 0}) {
    final parsed = Curl.parse(input.trim());
    final warnings = <String>[];
    final headers = Map<String, String>.from(parsed.headers ?? {});

    if ((parsed.cookie ?? '').isNotEmpty) {
      headers['Cookie'] = parsed.cookie!;
    }
    if ((parsed.userAgent ?? '').isNotEmpty) {
      headers['User-Agent'] = parsed.userAgent!;
    }
    if ((parsed.referer ?? '').isNotEmpty) {
      headers['Referer'] = parsed.referer!;
    }
    if (parsed.insecure) {
      warnings.add('已识别 -k/--insecure，移动端执行时仍使用系统 TLS 校验。');
    }
    if (parsed.location) {
      warnings.add('已识别 -L/--location，Dio 默认会跟随重定向。');
    }

    final auth = _authFromUser(parsed.user);
    final body = _bodyFromCurl(parsed, warnings);
    final pathName = parsed.uri.pathSegments.isEmpty
        ? parsed.uri.host
        : parsed.uri.pathSegments.last;
    final method = parsed.method.toUpperCase();

    final now = DateTime.now();
    final urlWithoutQuery = Uri(
      scheme: parsed.uri.scheme,
      userInfo: parsed.uri.userInfo,
      host: parsed.uri.host,
      port: parsed.uri.hasPort ? parsed.uri.port : null,
      path: parsed.uri.path,
    ).toString();
    return CurlImportResult(
      warnings: warnings,
      step: RequestStep(
        key: 'step${sortOrder + 1}',
        name: '$method ${pathName.isEmpty ? parsed.uri.host : pathName}',
        sortOrder: sortOrder,
        request: RequestDefinition(
          method: method,
          url: urlWithoutQuery,
          query: parsed.uri.queryParameters,
          headers: headers,
          auth: auth,
          body: body,
          timeoutSeconds: 30,
        ),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  AuthConfig _authFromUser(String? user) {
    if (user == null || user.isEmpty) {
      return const AuthConfig.none();
    }

    final parts = user.split(':');
    return AuthConfig(
      type: AuthType.basic,
      username: parts.first,
      password: parts.length > 1 ? parts.sublist(1).join(':') : '',
    );
  }

  BodyConfig _bodyFromCurl(Curl curl, List<String> warnings) {
    if (curl.form && curl.formData != null) {
      final fields = <String, String>{};
      for (final entry in curl.formData!) {
        final typeName = entry.type.toString().toLowerCase();
        if (typeName.endsWith('.file')) {
          warnings.add('暂不支持文件上传字段 ${entry.name}，已跳过。');
          continue;
        }
        fields[entry.name] = entry.value;
      }
      return BodyConfig(type: BodyType.formData, fields: fields);
    }

    final data = curl.data;
    if (data == null || data.isEmpty) {
      return const BodyConfig.none();
    }

    final contentType = _contentType(curl.headers ?? {});
    if (contentType.contains('application/x-www-form-urlencoded')) {
      return BodyConfig(
        type: BodyType.formUrlEncoded,
        fields: Uri.splitQueryString(data),
      );
    }
    if (contentType.contains('text/plain')) {
      return BodyConfig(type: BodyType.text, raw: data);
    }
    return BodyConfig(type: BodyType.json, raw: data);
  }

  String _contentType(Map<String, String> headers) {
    for (final entry in headers.entries) {
      if (entry.key.toLowerCase() == 'content-type') {
        return entry.value.toLowerCase();
      }
    }
    return '';
  }
}
