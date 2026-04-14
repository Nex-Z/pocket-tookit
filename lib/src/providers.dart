import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database/app_database.dart';
import 'models/api_models.dart';
import 'repositories/shortcut_repository.dart';
import 'services/curl_import_service.dart';
import 'services/shortcut_execution_service.dart';
import 'services/template_resolver.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase.defaults();
  ref.onDispose(database.close);
  return database;
});

final shortcutRepositoryProvider = Provider<ShortcutRepository>((ref) {
  return ShortcutRepository(ref.watch(databaseProvider));
});

final dioProvider = Provider<Dio>((ref) => Dio());

final templateResolverProvider = Provider<TemplateResolver>((ref) {
  return TemplateResolver();
});

final curlImportServiceProvider = Provider<CurlImportService>((ref) {
  return CurlImportService();
});

final shortcutExecutionServiceProvider = Provider<ShortcutExecutionService>((
  ref,
) {
  return ShortcutExecutionService(
    repository: ref.watch(shortcutRepositoryProvider),
    templateResolver: ref.watch(templateResolverProvider),
    dio: ref.watch(dioProvider),
  );
});

final shortcutsProvider = StreamProvider<List<ApiShortcut>>((ref) {
  return ref.watch(shortcutRepositoryProvider).watchShortcuts();
});

final shortcutProvider = FutureProvider.family<ApiShortcut?, int>((ref, id) {
  return ref.watch(shortcutRepositoryProvider).getShortcut(id);
});

final requestLogsProvider = StreamProvider<List<RequestLogEntry>>((ref) {
  return ref.watch(shortcutRepositoryProvider).watchLogs();
});

final requestLogProvider = FutureProvider.family<RequestLogEntry?, int>((
  ref,
  id,
) {
  return ref.watch(shortcutRepositoryProvider).getLog(id);
});
