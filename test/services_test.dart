import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_tookit/src/database/app_database.dart';
import 'package:pocket_tookit/src/models/api_models.dart';
import 'package:pocket_tookit/src/repositories/shortcut_repository.dart';
import 'package:pocket_tookit/src/services/curl_import_service.dart';
import 'package:pocket_tookit/src/services/shortcut_execution_service.dart';
import 'package:pocket_tookit/src/services/template_resolver.dart';

void main() {
  group('CurlImportService', () {
    test('maps a curl command to a request step', () {
      final result = CurlImportService().parse(
        r'''curl -X POST "https://api.example.com/login?tenant=demo" -u "me:secret" -H "Content-Type: application/json" -d "{\"email\":\"a@example.com\"}"''',
      );

      expect(result.step.request.method, 'POST');
      expect(result.step.request.url, 'https://api.example.com/login');
      expect(result.step.request.query, {'tenant': 'demo'});
      expect(result.step.request.headers['Content-Type'], 'application/json');
      expect(result.step.request.auth.type, AuthType.basic);
      expect(result.step.request.body.type, BodyType.json);
    });
  });

  group('TemplateResolver', () {
    test('resolves status, headers and body values', () {
      final resolver = TemplateResolver();
      final context = TemplateContext(
        steps: {
          'login': StepExecutionSnapshot(
            status: 200,
            headers: const {'content-type': 'application/json'},
            body: const {
              'token': 'abc',
              'user': {'id': 7},
            },
          ),
        },
      );

      expect(
        resolver.resolveString(
          'Bearer {{steps.login.body.token}} / {{steps.login.status}}',
          context,
        ),
        'Bearer abc / 200',
      );
      expect(
        resolver.resolveString('{{steps.login.headers.content-type}}', context),
        'application/json',
      );
      expect(
        resolver.resolveString('{{steps.login.body.user.id}}', context),
        '7',
      );
    });

    test('throws when a variable is missing', () {
      expect(
        () => TemplateResolver().resolveString(
          '{{steps.login.body.token}}',
          const TemplateContext(),
        ),
        throwsA(isA<TemplateResolutionException>()),
      );
    });

    test('uses manual variable overrides for single-step debugging', () {
      expect(
        TemplateResolver().resolveString(
          'Bearer {{ steps.login.body.token }}',
          const TemplateContext(
            variables: {'steps.login.body.token': 'manual-token'},
          ),
        ),
        'Bearer manual-token',
      );
    });
  });

  group('ShortcutExecutionService', () {
    test('runs linear steps and writes request logs', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final repository = ShortcutRepository(db);
      final adapter = QueueAdapter([
        (options) {
          expect(options.method, 'POST');
          return ResponseBody.fromString(
            jsonEncode({'token': 'abc'}),
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        },
        (options) {
          expect(options.uri.queryParameters['token'], 'abc');
          return ResponseBody.fromString(
            jsonEncode({'ok': true}),
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        },
      ]);
      final dio = Dio()..httpClientAdapter = adapter;
      final service = ShortcutExecutionService(
        repository: repository,
        templateResolver: TemplateResolver(),
        dio: dio,
      );

      final now = DateTime.now();
      final shortcutId = await repository.saveShortcut(
        ApiShortcut(
          name: '登录后请求',
          createdAt: now,
          updatedAt: now,
          steps: [
            RequestStep(
              key: 'login',
              name: '登录',
              sortOrder: 0,
              request: const RequestDefinition(
                method: 'POST',
                url: 'https://api.example.com/login',
                body: BodyConfig(
                  type: BodyType.json,
                  raw: '{"email":"a@example.com"}',
                ),
              ),
              createdAt: now,
              updatedAt: now,
            ),
            RequestStep(
              key: 'profile',
              name: '资料',
              sortOrder: 1,
              request: const RequestDefinition(
                method: 'GET',
                url: 'https://api.example.com/profile',
                query: {'token': '{{steps.login.body.token}}'},
              ),
              createdAt: now,
              updatedAt: now,
            ),
          ],
        ),
      );
      final shortcut = await repository.getShortcut(shortcutId);

      final result = await service.execute(shortcut!);
      final logs = await repository.watchLogs().first;

      expect(result.success, isTrue);
      expect(result.results, hasLength(2));
      expect(logs, hasLength(2));
      expect(logs.first.success, isTrue);
      expect(adapter.remaining, 0);
    });

    test('debugs one step without running sibling steps', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final repository = ShortcutRepository(db);
      final adapter = QueueAdapter([
        (options) {
          expect(options.method, 'GET');
          expect(options.uri.path, '/profile');
          expect(options.uri.queryParameters['token'], 'manual-token');
          return ResponseBody.fromString(
            jsonEncode({'name': 'Ada'}),
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        },
      ]);
      final service = ShortcutExecutionService(
        repository: repository,
        templateResolver: TemplateResolver(),
        dio: Dio()..httpClientAdapter = adapter,
      );

      final now = DateTime.now();
      final shortcutId = await repository.saveShortcut(
        ApiShortcut(
          name: '单步调试',
          createdAt: now,
          updatedAt: now,
          steps: [
            RequestStep(
              key: 'login',
              name: '登录',
              sortOrder: 0,
              request: const RequestDefinition(
                method: 'POST',
                url: 'https://api.example.com/login',
              ),
              createdAt: now,
              updatedAt: now,
            ),
            RequestStep(
              key: 'profile',
              name: '资料',
              sortOrder: 1,
              request: const RequestDefinition(
                method: 'GET',
                url: 'https://api.example.com/profile',
                query: {'token': '{{steps.login.body.token}}'},
              ),
              createdAt: now,
              updatedAt: now,
            ),
          ],
        ),
      );
      final shortcut = (await repository.getShortcut(shortcutId))!;

      final result = await service.executeStep(
        shortcut,
        shortcut.steps[1],
        initialContext: const TemplateContext(
          variables: {'steps.login.body.token': 'manual-token'},
        ),
      );
      final logs = await repository.watchLogs().first;

      expect(result.success, isTrue);
      expect(result.results, hasLength(1));
      expect(result.results.single.step.key, 'profile');
      expect(logs, hasLength(1));
      expect(logs.single.stepKey, 'profile');
      expect(logs.single.url, contains('manual-token'));
      expect(adapter.remaining, 0);
    });

    test('stops on non-2xx response', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final repository = ShortcutRepository(db);
      final adapter = QueueAdapter([
        (_) => ResponseBody.fromString('nope', 401),
        (_) => ResponseBody.fromString('should not run', 200),
      ]);
      final service = ShortcutExecutionService(
        repository: repository,
        templateResolver: TemplateResolver(),
        dio: Dio()..httpClientAdapter = adapter,
      );

      final now = DateTime.now();
      final shortcutId = await repository.saveShortcut(
        ApiShortcut(
          name: '失败停止',
          createdAt: now,
          updatedAt: now,
          steps: [
            RequestStep(
              key: 'first',
              name: '第一步',
              sortOrder: 0,
              request: const RequestDefinition(
                method: 'GET',
                url: 'https://api.example.com/a',
              ),
              createdAt: now,
              updatedAt: now,
            ),
            RequestStep(
              key: 'second',
              name: '第二步',
              sortOrder: 1,
              request: const RequestDefinition(
                method: 'GET',
                url: 'https://api.example.com/b',
              ),
              createdAt: now,
              updatedAt: now,
            ),
          ],
        ),
      );

      final result = await service.execute(
        (await repository.getShortcut(shortcutId))!,
      );

      expect(result.success, isFalse);
      expect(result.results, hasLength(1));
      expect(adapter.remaining, 1);
    });
  });
}

class QueueAdapter implements HttpClientAdapter {
  QueueAdapter(this._handlers);

  final List<ResponseBody Function(RequestOptions options)> _handlers;

  int get remaining => _handlers.length;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (_handlers.isEmpty) {
      throw StateError('No fake response left');
    }
    return _handlers.removeAt(0)(options);
  }

  @override
  void close({bool force = false}) {}
}
