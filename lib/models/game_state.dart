import 'board_square.dart';
import 'game_status.dart';

enum GamePhase { menu, playing, animating, gameOver }

enum GameMode { localPvP, vsEasyAI, vsMediumAI, vsHardAI }

class GameState {
  final List<BoardSquare> board;
  final int activePlayer; // 1 or 2
  final int player1Score; // Total score points (citizen + 5*mandarin)
  final int player2Score;
  final int player1CapturedPool; // Citizen stones captured (used for refilling)
  final int player2CapturedPool;
  final int player1MandarinCaptured; // Mandarin stones captured
  final int player2MandarinCaptured;
  final int player1Debt; // Debt in stones from refilling
  final int player2Debt;
  final GamePhase phase;
  final GameMode mode;
  final String statusMessage;
  final GameStatus? currentStatus;

  GameState({
    required this.board,
    required this.activePlayer,
    required this.player1Score,
    required this.player2Score,
    required this.player1CapturedPool,
    required this.player2CapturedPool,
    required this.player1MandarinCaptured,
    required this.player2MandarinCaptured,
    required this.player1Debt,
    required this.player2Debt,
    required this.phase,
    required this.mode,
    required this.statusMessage,
    this.currentStatus,
  });

  factory GameState.initial(GameMode mode) {
    List<BoardSquare> initialBoard = List.generate(12, (index) {
      bool isMandarin = (index == 5 || index == 11);
      return BoardSquare(
        index: index,
        isMandarin: isMandarin,
        citizenCount: isMandarin ? 0 : 5,
        hasMandarin: isMandarin,
      );
    });

    return GameState(
      board: initialBoard,
      activePlayer: 1,
      player1Score: 0,
      player2Score: 0,
      player1CapturedPool: 0,
      player2CapturedPool: 0,
      player1MandarinCaptured: 0,
      player2MandarinCaptured: 0,
      player1Debt: 0,
      player2Debt: 0,
      phase: GamePhase.playing,
      mode: mode,
      statusMessage: "Lượt P1",
      currentStatus: GameStatus.turn(player: 1),
    );
  }

  GameState copyWith({
    List<BoardSquare>? board,
    int? activePlayer,
    int? player1Score,
    int? player2Score,
    int? player1CapturedPool,
    int? player2CapturedPool,
    int? player1MandarinCaptured,
    int? player2MandarinCaptured,
    int? player1Debt,
    int? player2Debt,
    GamePhase? phase,
    GameMode? mode,
    String? statusMessage,
    GameStatus? currentStatus,
  }) {
    return GameState(
      board: board ?? this.board.map((e) => e.copyWith()).toList(),
      activePlayer: activePlayer ?? this.activePlayer,
      player1Score: player1Score ?? this.player1Score,
      player2Score: player2Score ?? this.player2Score,
      player1CapturedPool: player1CapturedPool ?? this.player1CapturedPool,
      player2CapturedPool: player2CapturedPool ?? this.player2CapturedPool,
      player1MandarinCaptured: player1MandarinCaptured ?? this.player1MandarinCaptured,
      player2MandarinCaptured: player2MandarinCaptured ?? this.player2MandarinCaptured,
      player1Debt: player1Debt ?? this.player1Debt,
      player2Debt: player2Debt ?? this.player2Debt,
      phase: phase ?? this.phase,
      mode: mode ?? this.mode,
      statusMessage: statusMessage ?? this.statusMessage,
      currentStatus: currentStatus ?? this.currentStatus,
    );
  }
}
