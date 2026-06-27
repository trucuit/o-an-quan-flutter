import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:o_an_quan/models/game_status.dart';
import 'package:o_an_quan/theme/game_icons.dart';
import 'package:o_an_quan/widgets/status_chip_bar.dart';

void main() {
  testWidgets('StatusChipBar renders capture chips', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatusChipBar(
            status: GameStatus.capture(squareIndex: 7, count: 3, mandarin: true),
          ),
        ),
      ),
    );

    expect(find.byIcon(GameIcons.capture), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);
  });

  testWidgets('StatusChipBar renders turn chip', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatusChipBar(status: GameStatus.turn(player: 2)),
        ),
      ),
    );

    expect(find.text('P2'), findsOneWidget);
  });
}