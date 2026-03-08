import 'package:flutter_test/flutter_test.dart';
import 'package:scrrpa_app/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const ScrrpaApp());
    expect(find.byType(ScrrpaApp), findsOneWidget);
  });
}
