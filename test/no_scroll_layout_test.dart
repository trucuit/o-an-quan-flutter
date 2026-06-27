import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:o_an_quan/models/game_state.dart';
import 'package:o_an_quan/screens/menu_screen.dart';
import 'package:o_an_quan/screens/game_screen.dart';
import 'package:o_an_quan/screens/tutorial_screen.dart';

void main() {
  final viewports = [
    const Size(640, 360),
    const Size(844, 390),
    const Size(1024, 768),
  ];

  for (final size in viewports) {
    testWidgets('MenuScreen no scroll at ${size.width}x${size.height}', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const MaterialApp(home: MenuScreen()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(Scrollable), findsNothing);
    });

    testWidgets('GameScreen no scroll at ${size.width}x${size.height}', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const MaterialApp(home: GameScreen(mode: GameMode.localPvP)),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('TutorialScreen no scroll at ${size.width}x${size.height}', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const MaterialApp(home: TutorialScreen()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(Scrollable), findsNothing);
    });
  }
}