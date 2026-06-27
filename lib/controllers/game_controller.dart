import 'dart:async';
import 'package:flutter/material.dart';
import '../models/board_square.dart';
import '../models/game_state.dart';
import '../ai/ai_player.dart';
import '../models/game_status.dart';

class GameController extends ChangeNotifier {
  GameState _state;
  List<GameState> _history = [];
  int? _selectedSquareIndex;
  bool _isAnimating = false;
  List<GameState> _animationFrames = [];
  int _currentFrameIndex = 0;
  Timer? _animationTimer;

  GameController({GameMode mode = GameMode.localPvP})
      : _state = GameState.initial(mode);

  GameState get state => _state;
  int? get selectedSquareIndex => _selectedSquareIndex;
  bool get isAnimating => _isAnimating;

  void resetGame(GameMode mode) {
    _animationTimer?.cancel();
    _state = GameState.initial(mode);
    _history.clear();
    _selectedSquareIndex = null;
    _isAnimating = false;
    _animationFrames.clear();
    _currentFrameIndex = 0;
    notifyListeners();

    // If starting vs AI and AI is Player 1 (not typical, Player 1 is human, but just in case)
    _checkAndTriggerAIMove();
  }

  void selectSquare(int index) {
    if (_isAnimating || _state.phase == GamePhase.gameOver) return;

    // Check if player owns this square
    if (_state.activePlayer == 1 && (index < 0 || index > 4)) return;
    if (_state.activePlayer == 2 && (index < 6 || index > 10)) return;

    // Check if empty
    if (_state.board[index].isEmpty) return;

    _selectedSquareIndex = index;
    notifyListeners();
  }

  void cancelSelection() {
    _selectedSquareIndex = null;
    notifyListeners();
  }

  void playMove(bool isClockwise) {
    if (_selectedSquareIndex == null || _isAnimating) return;

    _history.add(_state.copyWith()); // Save for undo

    int startIndex = _selectedSquareIndex!;
    _selectedSquareIndex = null;
    _isAnimating = true;
    _state = _state.copyWith(phase: GamePhase.animating);
    notifyListeners();

    // Generate animation frames
    _animationFrames = _generateDistributionFrames(startIndex, isClockwise);
    _currentFrameIndex = 0;

    // Start playback timer (250ms per step for smooth animation)
    _animationTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (_currentFrameIndex < _animationFrames.length) {
        _state = _animationFrames[_currentFrameIndex];
        _currentFrameIndex++;
        notifyListeners();
      } else {
        timer.cancel();
        _isAnimating = false;
        _postMoveProcessing();
      }
    });
  }

  List<GameState> _generateDistributionFrames(int startIdx, bool isClockwise) {
    List<GameState> frames = [];
    GameState currentLocalState = _state.copyWith();

    // 1. Pick up stones
    List<BoardSquare> currentBoard = currentLocalState.board.map((e) => e.copyWith()).toList();
    int stonesInHand = currentBoard[startIdx].citizenCount;
    currentBoard[startIdx].citizenCount = 0;

    currentLocalState = currentLocalState.copyWith(
      board: currentBoard,
      statusMessage: "Nhặt Ô $startIdx",
      currentStatus: GameStatus.pick(squareIndex: startIdx, count: stonesInHand),
    );
    frames.add(currentLocalState.copyWith());

    int currIdx = startIdx;

    while (stonesInHand > 0) {
      // Move to next square
      currIdx = isClockwise ? (currIdx + 1) % 12 : (currIdx - 1 + 12) % 12;

      // Distribute a stone
      currentBoard = currentLocalState.board.map((e) => e.copyWith()).toList();
      currentBoard[currIdx].citizenCount += 1;
      stonesInHand -= 1;

      currentLocalState = currentLocalState.copyWith(
        board: currentBoard,
        statusMessage: "Rải Ô $currIdx",
        currentStatus: GameStatus.sow(squareIndex: currIdx, count: stonesInHand),
      );
      frames.add(currentLocalState.copyWith());

      // If hand is empty, determine next action
      if (stonesInHand == 0) {
        int nextIdx = isClockwise ? (currIdx + 1) % 12 : (currIdx - 1 + 12) % 12;
        BoardSquare nextSquare = currentBoard[nextIdx];

        if (nextSquare.isMandarin) {
          // Rule: Hit Mandarin square -> turn ends
          currentLocalState = currentLocalState.copyWith(
            statusMessage: "Quan Ô $nextIdx",
            currentStatus: GameStatus.stop(reason: 'quan'),
          );
          frames.add(currentLocalState.copyWith());
          break;
        } else if (!nextSquare.isEmpty) {
          // Rule: Next square is citizen & non-empty -> pick up and continue
          stonesInHand = nextSquare.citizenCount;
          currentBoard = currentLocalState.board.map((e) => e.copyWith()).toList();
          currentBoard[nextIdx].citizenCount = 0;

          currentLocalState = currentLocalState.copyWith(
            board: currentBoard,
            statusMessage: "Nhặt Ô $nextIdx",
            currentStatus: GameStatus.pick(squareIndex: nextIdx, count: stonesInHand),
          );
          frames.add(currentLocalState.copyWith());
          currIdx = nextIdx;
        } else {
          // Rule: Next square is empty -> CAPTURE or STOP
          int captureTargetIdx = isClockwise ? (nextIdx + 1) % 12 : (nextIdx - 1 + 12) % 12;
          BoardSquare captureSquare = currentBoard[captureTargetIdx];

          if (captureSquare.isEmpty) {
            // Two empty squares -> stop
            currentLocalState = currentLocalState.copyWith(
              statusMessage: "Dừng",
              currentStatus: GameStatus.stop(reason: 'empty'),
            );
            frames.add(currentLocalState.copyWith());
            break;
          } else {
            // Chain capture loop
            int checkEmptyIdx = nextIdx;
            int player = currentLocalState.activePlayer;

            int newCapturedPoolP1 = currentLocalState.player1CapturedPool;
            int newCapturedPoolP2 = currentLocalState.player2CapturedPool;
            int newMandarinCapP1 = currentLocalState.player1MandarinCaptured;
            int newMandarinCapP2 = currentLocalState.player2MandarinCaptured;
            int newScoreP1 = currentLocalState.player1Score;
            int newScoreP2 = currentLocalState.player2Score;
            int newDebtP1 = currentLocalState.player1Debt;
            int newDebtP2 = currentLocalState.player2Debt;

            while (currentBoard[checkEmptyIdx].isEmpty) {
              int capIdx = isClockwise ? (checkEmptyIdx + 1) % 12 : (checkEmptyIdx - 1 + 12) % 12;
              if (currentBoard[capIdx].isEmpty) {
                break; // Stop chain capture
              }

              // Capture capIdx!
              int capturedCitizen = currentBoard[capIdx].citizenCount;
              bool capturedMandarin = currentBoard[capIdx].hasMandarin;

              currentBoard = currentBoard.map((e) => e.copyWith()).toList();
              currentBoard[capIdx].citizenCount = 0;
              currentBoard[capIdx].hasMandarin = false;

              // Calculate values
              int pointsEarned = capturedCitizen + (capturedMandarin ? 5 : 0);

              if (player == 1) {
                newCapturedPoolP1 += capturedCitizen;
                if (capturedMandarin) newMandarinCapP1 += 1;
                newScoreP1 = newCapturedPoolP1 + (newMandarinCapP1 * 5) - newDebtP1;
              } else {
                newCapturedPoolP2 += capturedCitizen;
                if (capturedMandarin) newMandarinCapP2 += 1;
                newScoreP2 = newCapturedPoolP2 + (newMandarinCapP2 * 5) - newDebtP2;
              }

              currentLocalState = currentLocalState.copyWith(
                board: currentBoard,
                player1CapturedPool: newCapturedPoolP1,
                player2CapturedPool: newCapturedPoolP2,
                player1MandarinCaptured: newMandarinCapP1,
                player2MandarinCaptured: newMandarinCapP2,
                player1Score: newScoreP1,
                player2Score: newScoreP2,
                statusMessage: "Ăn Ô $capIdx",
                currentStatus: GameStatus.capture(
                  squareIndex: capIdx,
                  count: capturedCitizen,
                  mandarin: capturedMandarin,
                ),
              );
              frames.add(currentLocalState.copyWith());

              // Prepare next check
              checkEmptyIdx = isClockwise ? (capIdx + 1) % 12 : (capIdx - 1 + 12) % 12;
            }
            break; // Finished move
          }
        }
      }
    }

    return frames;
  }

  void _postMoveProcessing() {
    // 1. Check if game is over (both mandarin squares empty)
    bool isMandarin5Empty = !_state.board[5].hasMandarin && _state.board[5].citizenCount == 0;
    bool isMandarin11Empty = !_state.board[11].hasMandarin && _state.board[11].citizenCount == 0;

    if (isMandarin5Empty && isMandarin11Empty) {
      _endGame();
      return;
    }

    int nextPlayer = _state.activePlayer == 1 ? 2 : 1;

    _state = _state.copyWith(
      activePlayer: nextPlayer,
      phase: GamePhase.playing,
      statusMessage: "Lượt P$nextPlayer",
      currentStatus: GameStatus.turn(player: nextPlayer),
    );

    // 3. Check if next player's side is empty and needs refilling
    _checkSideRefill();

    notifyListeners();

    // 4. Trigger AI move if next player is AI
    _checkAndTriggerAIMove();
  }

  void _checkSideRefill() {
    int player = _state.activePlayer;
    bool allEmpty = true;

    if (player == 1) {
      for (int i = 0; i <= 4; i++) {
        if (_state.board[i].citizenCount > 0) {
          allEmpty = false;
          break;
        }
      }
    } else {
      for (int i = 6; i <= 10; i++) {
        if (_state.board[i].citizenCount > 0) {
          allEmpty = false;
          break;
        }
      }
    }

    if (allEmpty) {
      List<BoardSquare> newBoard = _state.board.map((e) => e.copyWith()).toList();
      int newCapturedPoolP1 = _state.player1CapturedPool;
      int newCapturedPoolP2 = _state.player2CapturedPool;
      int newDebtP1 = _state.player1Debt;
      int newDebtP2 = _state.player2Debt;
      int newScoreP1 = _state.player1Score;
      int newScoreP2 = _state.player2Score;

      String message = "Rải sân";
      GameStatus status = GameStatus.refill(count: 5);

      if (player == 1) {
        if (newCapturedPoolP1 >= 5) {
          newCapturedPoolP1 -= 5;
        } else {
          int deficit = 5 - newCapturedPoolP1;
          newDebtP1 += deficit;
          newCapturedPoolP1 = 0;
          message = "Mượn $deficit";
          status = GameStatus.borrow(count: deficit);
        }
        for (int i = 0; i <= 4; i++) {
          newBoard[i].citizenCount = 1;
        }
        newScoreP1 = newCapturedPoolP1 + (_state.player1MandarinCaptured * 5) - newDebtP1;
      } else {
        if (newCapturedPoolP2 >= 5) {
          newCapturedPoolP2 -= 5;
        } else {
          int deficit = 5 - newCapturedPoolP2;
          newDebtP2 += deficit;
          newCapturedPoolP2 = 0;
          message = "Mượn $deficit";
          status = GameStatus.borrow(count: deficit);
        }
        for (int i = 6; i <= 10; i++) {
          newBoard[i].citizenCount = 1;
        }
        newScoreP2 = newCapturedPoolP2 + (_state.player2MandarinCaptured * 5) - newDebtP2;
      }

      _state = _state.copyWith(
        board: newBoard,
        player1CapturedPool: newCapturedPoolP1,
        player2CapturedPool: newCapturedPoolP2,
        player1Debt: newDebtP1,
        player2Debt: newDebtP2,
        player1Score: newScoreP1,
        player2Score: newScoreP2,
        statusMessage: message,
        currentStatus: status,
      );
    }
  }

  void _endGame() {
    List<BoardSquare> newBoard = _state.board.map((e) => e.copyWith()).toList();

    int remainingP1 = 0;
    int remainingP2 = 0;

    // Sweep P1's remaining citizen stones
    for (int i = 0; i <= 4; i++) {
      remainingP1 += newBoard[i].citizenCount;
      newBoard[i].citizenCount = 0;
    }

    // Sweep P2's remaining citizen stones
    for (int i = 6; i <= 10; i++) {
      remainingP2 += newBoard[i].citizenCount;
      newBoard[i].citizenCount = 0;
    }

    int finalPoolP1 = _state.player1CapturedPool + remainingP1;
    int finalPoolP2 = _state.player2CapturedPool + remainingP2;

    int finalScoreP1 = finalPoolP1 + (_state.player1MandarinCaptured * 5) - _state.player1Debt;
    int finalScoreP2 = finalPoolP2 + (_state.player2MandarinCaptured * 5) - _state.player2Debt;

    String winnerMsg = "";
    if (finalScoreP1 > finalScoreP2) {
      winnerMsg = "P1 🏆 ($finalScoreP1 - $finalScoreP2)";
    } else if (finalScoreP2 > finalScoreP1) {
      winnerMsg = _state.mode == GameMode.localPvP
          ? "P2 🏆 ($finalScoreP2 - $finalScoreP1)"
          : "Máy 🏆 ($finalScoreP2 - $finalScoreP1)";
    } else {
      winnerMsg = "Hòa 🤝 ($finalScoreP1 - $finalScoreP2)";
    }

    _state = _state.copyWith(
      board: newBoard,
      player1CapturedPool: finalPoolP1,
      player2CapturedPool: finalPoolP2,
      player1Score: finalScoreP1,
      player2Score: finalScoreP2,
      phase: GamePhase.gameOver,
      statusMessage: winnerMsg,
      currentStatus: GameStatus.gameOver(winnerLabel: winnerMsg),
    );
    notifyListeners();
  }

  void undo() {
    if (_history.isEmpty || _isAnimating) return;
    _state = _history.removeLast();
    _selectedSquareIndex = null;
    notifyListeners();

    // If opponent was AI, we need to undo AI's move as well so human can play again
    if (_state.mode != GameMode.localPvP && _state.activePlayer == 2 && _history.isNotEmpty) {
      _state = _history.removeLast();
      notifyListeners();
    }
  }

  void _checkAndTriggerAIMove() {
    if (_state.phase == GamePhase.gameOver || _state.mode == GameMode.localPvP || _state.activePlayer != 2) {
      return;
    }

    // Schedule AI move to allow small buffer after player turn finishes
    Future.delayed(const Duration(milliseconds: 600), () {
      if (_state.phase == GamePhase.playing && _state.activePlayer == 2) {
        _triggerAIMove();
      }
    });
  }

  void _triggerAIMove() {
    AIMove bestMove = AIPlayer.getBestMove(_state);
    if (bestMove.squareIndex != -1) {
      selectSquare(bestMove.squareIndex);
      // Wait another moment to simulate AI "thinking" before playing
      Future.delayed(const Duration(milliseconds: 500), () {
        playMove(bestMove.isClockwise);
      });
    }
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }
}
