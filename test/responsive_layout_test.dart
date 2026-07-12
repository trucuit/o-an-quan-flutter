import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:o_an_quan/models/game_state.dart';
import 'package:o_an_quan/screens/menu_screen.dart';
import 'package:o_an_quan/screens/game_screen.dart';
import 'package:o_an_quan/screens/tutorial_screen.dart';

/// Verifies the redesigned screens render without overflow across window-size
/// classes AND both orientations — portrait is newly supported after removing
/// the forced-landscape lock.
void main() {
  final viewports = <String, Size>{
    'compact portrait': const Size(390, 844),
    'compact landscape': const Size(844, 390),
    'medium portrait': const Size(768, 1024),
    'medium landscape': const Size(1024, 768),
    'expanded': const Size(1280, 900),
  };

  viewports.forEach((label, size) {
    Future<void> pump(WidgetTester tester, Widget home) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(MaterialApp(home: home));
      await tester.pumpAndSettle();
    }

    testWidgets('MenuScreen no overflow — $label', (tester) async {
      await pump(tester, const MenuScreen());
      expect(tester.takeException(), isNull);
      expect(find.byType(Scrollable), findsNothing);
    });

    testWidgets('GameScreen no overflow — $label', (tester) async {
      await pump(tester, const GameScreen(mode: GameMode.localPvP));
      expect(tester.takeException(), isNull);
    });

    testWidgets('TutorialScreen no overflow — $label', (tester) async {
      await pump(tester, const TutorialScreen());
      expect(tester.takeException(), isNull);
      expect(find.byType(Scrollable), findsNothing);
    });
  });
}
