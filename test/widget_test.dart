import 'package:flutter_test/flutter_test.dart';
import 'package:irisflow/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const IrisFlowApp());
    expect(find.text('IrisFlow'), findsWidgets);
  });
}
