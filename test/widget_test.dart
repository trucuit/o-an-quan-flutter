import 'package:flutter_test/flutter_test.dart';
import 'package:o_an_quan/main.dart';

void main() {
  testWidgets('Menu Screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the title is displayed on screen
    expect(find.text('Ô ĂN QUAN'), findsOneWidget);
    expect(find.text('Chơi Hai Người'), findsOneWidget);
  });
}
