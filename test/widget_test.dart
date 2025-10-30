import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App starts correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const LabApp());
    expect(find.text('123'), findsOneWidget);
  });
}
