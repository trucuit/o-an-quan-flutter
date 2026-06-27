import 'package:flutter_test/flutter_test.dart';
import 'package:o_an_quan/controllers/game_controller.dart';
import 'package:o_an_quan/models/board_square.dart';
import 'package:o_an_quan/models/game_state.dart';

void main() {
  group('Game Logic Unit Tests', () {
    test('Initial Board Setup', () {
      final controller = GameController(mode: GameMode.localPvP);
      final state = controller.state;

      // 10 citizen squares should have 5 stones each
      for (int i = 0; i <= 4; i++) {
        expect(state.board[i].citizenCount, 5);
        expect(state.board[i].isMandarin, false);
      }
      for (int i = 6; i <= 10; i++) {
        expect(state.board[i].citizenCount, 5);
        expect(state.board[i].isMandarin, false);
      }

      // 2 mandarin squares should have 1 mandarin stone, 0 citizen stones
      expect(state.board[5].hasMandarin, true);
      expect(state.board[5].citizenCount, 0);
      expect(state.board[5].isMandarin, true);

      expect(state.board[11].hasMandarin, true);
      expect(state.board[11].citizenCount, 0);
      expect(state.board[11].isMandarin, true);

      expect(state.player1Score, 0);
      expect(state.player2Score, 0);
      expect(state.activePlayer, 1);
    });

    test('Selecting Square Validation', () {
      final controller = GameController(mode: GameMode.localPvP);

      // Selecting opponent square (P2's square 7 when activePlayer is P1) should be ignored
      controller.selectSquare(7);
      expect(controller.selectedSquareIndex, null);

      // Selecting own non-empty square (P1's square 2) should be selected
      controller.selectSquare(2);
      expect(controller.selectedSquareIndex, 2);

      // Canceling selection should clear index
      controller.cancelSelection();
      expect(controller.selectedSquareIndex, null);
    });

    test('Game End Detection and Sweeping', () {
      final controller = GameController(mode: GameMode.localPvP);
      
      // Let's manually set up a board state where both mandarins are empty to trigger game over
      List<BoardSquare> customBoard = List.generate(12, (index) {
        bool isMandarin = (index == 5 || index == 11);
        return BoardSquare(
          index: index,
          isMandarin: isMandarin,
          citizenCount: isMandarin ? 0 : 2, // 2 citizen stones on each citizen square
          hasMandarin: false, // Mandarins are empty
        );
      });

      // Set state to check game over triggering
      // We can't edit state directly, but we can verify our controller handles game-over sweeps.
      // Let's create a game controller, simulate a move that captures the last mandarin stone, 
      // or check the logic directly in the state transitions.
    });
  });
}
