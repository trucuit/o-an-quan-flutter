import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:o_an_quan/controllers/game_controller.dart';
import 'package:o_an_quan/models/game_state.dart';
import 'package:o_an_quan/widgets/board/pebble_cluster.dart';

void main() {
  testWidgets('a move animates through frames and settles to an advanced state',
      (tester) async {
    final controller = GameController(mode: GameMode.localPvP);
    addTearDown(controller.dispose);
    await tester.pumpWidget(const SizedBox());

    expect(controller.state.activePlayer, 1);
    controller.selectSquare(0); // P1 pit, 5 stones on the initial board
    controller.playMove(true); // clockwise
    expect(controller.isAnimating, isTrue);

    // Advance the controller's 300ms periodic frame timer to completion.
    await tester.pump(const Duration(seconds: 10));

    expect(controller.isAnimating, isFalse);
    // The view's animation never blocks the controller from settling.
    final settled = controller.state.activePlayer != 1 ||
        controller.state.phase == GamePhase.gameOver;
    expect(settled, isTrue);
  });

  testWidgets('reduced motion snaps cluster count changes without error',
      (tester) async {
    Widget host(int count) => MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: PebbleCluster(
                    citizenCount: count,
                    isMandarin: false,
                    hasMandarin: false,
                    pitIndex: 1,
                  ),
                ),
              ),
            ),
          ),
        );

    await tester.pumpWidget(host(2));
    await tester.pumpWidget(host(5)); // count change under reduced motion
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
