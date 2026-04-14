import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'ui/pages/log_detail_page.dart';
import 'ui/pages/request_logs_page.dart';
import 'ui/pages/shortcut_editor_page.dart';
import 'ui/pages/shortcut_library_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const ShortcutLibraryPage(),
      ),
      GoRoute(
        path: '/shortcut/new',
        builder: (context, state) => const ShortcutEditorPage(),
      ),
      GoRoute(
        path: '/shortcut/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          return ShortcutEditorPage(shortcutId: id);
        },
      ),
      GoRoute(
        path: '/logs',
        builder: (context, state) => const RequestLogsPage(),
      ),
      GoRoute(
        path: '/logs/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          return LogDetailPage(logId: id);
        },
      ),
    ],
  );
});

class PocketToolkitApp extends ConsumerWidget {
  const PocketToolkitApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return CupertinoApp.router(
      title: 'Pocket Toolkit',
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFFFF9F0A),
        scaffoldBackgroundColor: Color(0xFFF6F6F8),
        barBackgroundColor: Color(0xF7F6F6F8),
        textTheme: CupertinoTextThemeData(
          navLargeTitleTextStyle: TextStyle(
            color: Color(0xFF151518),
            fontSize: 34,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
        ),
      ),
      routerConfig: router,
    );
  }
}
