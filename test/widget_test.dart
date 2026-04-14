import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_tookit/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('显示打卡表单', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const ClockInApp());
    await tester.pump();

    expect(find.text('打卡'), findsWidgets);
    expect(find.text('服务器地址'), findsOneWidget);
    expect(find.text('token'), findsOneWidget);
    expect(find.text('上班卡'), findsOneWidget);
    expect(find.text('下班卡'), findsOneWidget);
    expect(find.text('暂无打卡结果'), findsOneWidget);
  });
}
