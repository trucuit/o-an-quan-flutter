import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:o_an_quan/models/game_state.dart';
import 'package:o_an_quan/models/game_status.dart';
import 'package:o_an_quan/widgets/status_chip_bar.dart';

void main() {
  testWidgets('StatusChipBar renders capture with human square name', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatusChipBar(
            status: GameStatus.capture(squareIndex: 7, count: 3, mandarin: true),
          ),
        ),
      ),
    );

    expect(find.textContaining('Ăn 3 quân'), findsOneWidget);
    expect(find.textContaining('Ô trên 4'), findsOneWidget);
  });

  testWidgets('StatusChipBar hides turn-only status', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatusChipBar(status: GameStatus.turn(player: 2)),
        ),
      ),
    );

    expect(find.textContaining('Lượt P2'), findsNothing);
  });

  testWidgets('StatusChipBar shows AI thinking message', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatusChipBar(
            status: GameStatus.turn(player: 2),
            isAnimating: true,
            mode: GameMode.vsMediumAI,
            activePlayer: 2,
          ),
        ),
      ),
    );

    expect(find.text('Máy đang đi…'), findsOneWidget);
  });
}