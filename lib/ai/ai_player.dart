import 'dart:math';
import '../models/board_square.dart';
import '../models/game_state.dart';

class AIMove {
  final int squareIndex;
  final bool isClockwise;
  final int evaluation;

  AIMove({
    required this.squareIndex,
    required this.isClockwise,
    required this.evaluation,
  });
}

class AIPlayer {
  static final Random _random = Random();

  /// Gets the best move for Player 2 (the AI) based on the difficulty level.
  static AIMove getBestMove(GameState state) {
    List<AIMove> validMoves = _getValidMoves(state, 2);
    if (validMoves.isEmpty) {
      return AIMove(squareIndex: -1, isClockwise: true, evaluation: 0);
    }

    if (state.mode == GameMode.vsEasyAI) {
      return validMoves[_random.nextInt(validMoves.length)];
    } else if (state.mode == GameMode.vsMediumAI) {
      return _getGreedyMove(state, validMoves);
    } else {
      // vsHardAI -> Minimax with alpha-beta pruning
      return _getMinimaxMove(state, validMoves);
    }
  }

  static List<AIMove> _getValidMoves(GameState state, int player) {
    List<AIMove> moves = [];
    int start = player == 1 ? 0 : 6;
    int end = player == 1 ? 4 : 10;

    for (int i = start; i <= end; i++) {
      if (state.board[i].citizenCount > 0) {
        moves.add(AIMove(squareIndex: i, isClockwise: true, evaluation: 0));
        moves.add(AIMove(squareIndex: i, isClockwise: false, evaluation: 0));
      }
    }
    return moves;
  }

  static AIMove _getGreedyMove(GameState state, List<AIMove> validMoves) {
    AIMove bestMove = validMoves[0];
    int maxScoreGained = -999999;

    for (var move in validMoves) {
      GameState nextState = _simulateMove(state, move.squareIndex, move.isClockwise);
      int scoreGained = nextState.player2Score - state.player2Score;
      if (scoreGained > maxScoreGained) {
        maxScoreGained = scoreGained;
        bestMove = move;
      }
    }

    return bestMove;
  }

  static AIMove _getMinimaxMove(GameState state, List<AIMove> validMoves) {
    int bestVal = -9999999;
    AIMove bestMove = validMoves[0];

    // Alpha-beta pruning
    int alpha = -99999999;
    int beta = 99999999;

    for (var move in validMoves) {
      GameState nextState = _simulateMove(state, move.squareIndex, move.isClockwise);
      // Minimax evaluation at depth 3 (4 ply deep search is fast enough)
      int moveVal = _minimax(nextState, 3, false, alpha, beta);

      if (moveVal > bestVal) {
        bestVal = moveVal;
        bestMove = move;
      }
      alpha = max(alpha, bestVal);
    }

    return bestMove;
  }

  static int _minimax(GameState state, int depth, bool isMax, int alpha, int beta) {
    // Terminate evaluation if game is over
    bool isMandarin5Empty = !state.board[5].hasMandarin && state.board[5].citizenCount == 0;
    bool isMandarin11Empty = !state.board[11].hasMandarin && state.board[11].citizenCount == 0;

    if (depth == 0 || (isMandarin5Empty && isMandarin11Empty)) {
      return _evaluateBoard(state);
    }

    int activePlayer = isMax ? 2 : 1;
    List<AIMove> validMoves = _getValidMoves(state, activePlayer);

    // If active player has no moves (needs refilling)
    if (validMoves.isEmpty) {
      GameState refilledState = _simulateRefill(state, activePlayer);
      validMoves = _getValidMoves(refilledState, activePlayer);
      if (validMoves.isEmpty) {
        return _evaluateBoard(refilledState);
      }
      state = refilledState;
    }

    if (isMax) {
      int maxEval = -99999999;
      for (var move in validMoves) {
        GameState nextState = _simulateMove(state, move.squareIndex, move.isClockwise);
        int eval = _minimax(nextState, depth - 1, false, alpha, beta);
        maxEval = max(maxEval, eval);
        alpha = max(alpha, eval);
        if (beta <= alpha) break; // Pruning
      }
      return maxEval;
    } else {
      int minEval = 99999999;
      for (var move in validMoves) {
        GameState nextState = _simulateMove(state, move.squareIndex, move.isClockwise);
        int eval = _minimax(nextState, depth - 1, true, alpha, beta);
        minEval = min(minEval, eval);
        beta = min(beta, eval);
        if (beta <= alpha) break; // Pruning
      }
      return minEval;
    }
  }

  /// Evaluation function from Player 2 (AI)'s perspective.
  static int _evaluateBoard(GameState state) {
    // 1. Score difference
    int scoreDiff = state.player2Score - state.player1Score;

    // 2. Sweeping remaining stones if game ended
    bool isMandarin5Empty = !state.board[5].hasMandarin && state.board[5].citizenCount == 0;
    bool isMandarin11Empty = !state.board[11].hasMandarin && state.board[11].citizenCount == 0;

    if (isMandarin5Empty && isMandarin11Empty) {
      int p1Sweep = 0;
      int p2Sweep = 0;
      for (int i = 0; i <= 4; i++) p1Sweep += state.board[i].citizenCount;
      for (int i = 6; i <= 10; i++) p2Sweep += state.board[i].citizenCount;
      
      int finalScoreP1 = state.player1CapturedPool + p1Sweep + (state.player1MandarinCaptured * 5) - state.player1Debt;
      int finalScoreP2 = state.player2CapturedPool + p2Sweep + (state.player2MandarinCaptured * 5) - state.player2Debt;
      
      return (finalScoreP2 - finalScoreP1) * 1000; // Large weight for winning state
    }

    // 3. Citizen stones distribution count
    int p2Stones = 0;
    for (int i = 6; i <= 10; i++) p2Stones += state.board[i].citizenCount;

    // Penalty for empty side (having to refill)
    int emptyPenalty = p2Stones == 0 ? -10 : 0;

    // Favor moves that capture Mandarin squares or keep citizen squares safe
    return (scoreDiff * 20) + p2Stones + emptyPenalty;
  }

  /// Fast non-mutating simulation of a move.
  static GameState _simulateMove(GameState state, int startIdx, bool isClockwise) {
    GameState localState = state.copyWith();
    List<BoardSquare> board = localState.board.map((e) => e.copyWith()).toList();

    int stonesInHand = board[startIdx].citizenCount;
    board[startIdx].citizenCount = 0;

    int currIdx = startIdx;

    while (stonesInHand > 0) {
      currIdx = isClockwise ? (currIdx + 1) % 12 : (currIdx - 1 + 12) % 12;
      board[currIdx].citizenCount += 1;
      stonesInHand -= 1;

      if (stonesInHand == 0) {
        int nextIdx = isClockwise ? (currIdx + 1) % 12 : (currIdx - 1 + 12) % 12;
        BoardSquare nextSquare = board[nextIdx];

        if (nextSquare.isMandarin) {
          break; // Ends turn
        } else if (nextSquare.citizenCount > 0) {
          stonesInHand = nextSquare.citizenCount;
          board[nextIdx].citizenCount = 0;
          currIdx = nextIdx;
        } else {
          // Next is empty -> Check for captures
          int checkEmptyIdx = nextIdx;
          int newCapturedPoolP1 = localState.player1CapturedPool;
          int newCapturedPoolP2 = localState.player2CapturedPool;
          int newMandarinCapP1 = localState.player1MandarinCaptured;
          int newMandarinCapP2 = localState.player2MandarinCaptured;
          int newDebtP1 = localState.player1Debt;
          int newDebtP2 = localState.player2Debt;

          while (board[checkEmptyIdx].citizenCount == 0 && !board[checkEmptyIdx].hasMandarin) {
            int capIdx = isClockwise ? (checkEmptyIdx + 1) % 12 : (checkEmptyIdx - 1 + 12) % 12;
            if (board[capIdx].citizenCount == 0 && !board[capIdx].hasMandarin) {
              break; // Stop capturing
            }

            int capCit = board[capIdx].citizenCount;
            bool capMan = board[capIdx].hasMandarin;

            board[capIdx].citizenCount = 0;
            board[capIdx].hasMandarin = false;

            if (state.activePlayer == 1) {
              newCapturedPoolP1 += capCit;
              if (capMan) newMandarinCapP1 += 1;
            } else {
              newCapturedPoolP2 += capCit;
              if (capMan) newMandarinCapP2 += 1;
            }

            checkEmptyIdx = isClockwise ? (capIdx + 1) % 12 : (capIdx - 1 + 12) % 12;
          }

          int newScoreP1 = newCapturedPoolP1 + (newMandarinCapP1 * 5) - newDebtP1;
          int newScoreP2 = newCapturedPoolP2 + (newMandarinCapP2 * 5) - newDebtP2;

          localState = localState.copyWith(
            board: board,
            player1CapturedPool: newCapturedPoolP1,
            player2CapturedPool: newCapturedPoolP2,
            player1MandarinCaptured: newMandarinCapP1,
            player2MandarinCaptured: newMandarinCapP2,
            player1Score: newScoreP1,
            player2Score: newScoreP2,
          );
          break;
        }
      }
    }

    // Return the state with the board updated
    return localState.copyWith(board: board);
  }

  /// Simulates a refill when a player's side is empty.
  static GameState _simulateRefill(GameState state, int player) {
    List<BoardSquare> newBoard = state.board.map((e) => e.copyWith()).toList();
    int newCapturedPoolP1 = state.player1CapturedPool;
    int newCapturedPoolP2 = state.player2CapturedPool;
    int newDebtP1 = state.player1Debt;
    int newDebtP2 = state.player2Debt;

    if (player == 1) {
      if (newCapturedPoolP1 >= 5) {
        newCapturedPoolP1 -= 5;
      } else {
        newDebtP1 += (5 - newCapturedPoolP1);
        newCapturedPoolP1 = 0;
      }
      for (int i = 0; i <= 4; i++) newBoard[i].citizenCount = 1;
    } else {
      if (newCapturedPoolP2 >= 5) {
        newCapturedPoolP2 -= 5;
      } else {
        newDebtP2 += (5 - newCapturedPoolP2);
        newCapturedPoolP2 = 0;
      }
      for (int i = 6; i <= 10; i++) newBoard[i].citizenCount = 1;
    }

    int newScoreP1 = newCapturedPoolP1 + (state.player1MandarinCaptured * 5) - newDebtP1;
    int newScoreP2 = newCapturedPoolP2 + (state.player2MandarinCaptured * 5) - newDebtP2;

    return state.copyWith(
      board: newBoard,
      player1CapturedPool: newCapturedPoolP1,
      player2CapturedPool: newCapturedPoolP2,
      player1Debt: newDebtP1,
      player2Debt: newDebtP2,
      player1Score: newScoreP1,
      player2Score: newScoreP2,
    );
  }
}
