import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App starts correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const Lab());
    expect(find.text('ЛР4 — Персонажи Гарри Поттера'), findsOneWidget);
  });
}
