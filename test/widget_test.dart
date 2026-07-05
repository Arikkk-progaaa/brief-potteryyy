import 'package:flutter_test/flutter_test.dart';

import 'package:brief_pottery/main.dart';

void main() {
  testWidgets('Приложение открывает экран расписания', (tester) async {
    await tester.pumpWidget(const BriefPotteryApp());

    expect(find.text('Расписание'), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('Расписание'), findsOneWidget);
  });
}
