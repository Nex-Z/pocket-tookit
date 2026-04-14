import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_tookit/src/models/api_models.dart';
import 'package:pocket_tookit/src/providers.dart';
import 'package:pocket_tookit/src/ui/pages/shortcut_library_page.dart';

void main() {
  testWidgets('shows the empty shortcut library', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          shortcutsProvider.overrideWith(
            (ref) => Stream.value(const <ApiShortcut>[]),
          ),
        ],
        child: const CupertinoApp(home: ShortcutLibraryPage()),
      ),
    );
    await tester.pump();

    expect(find.text('指令库'), findsOneWidget);
    expect(find.text('把常用 API 做成指令'), findsOneWidget);
    expect(find.byIcon(CupertinoIcons.add), findsOneWidget);
  });
}
