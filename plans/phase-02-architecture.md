---
phase: 2
title: Architecture
status: completed
effort: 3h
dependencies:
  - 1
---

# Phase 2: Architecture

## Overview
Design the software structure, class relationships, state flow, and animation pipelines for the Ô ăn quan game.

## Architecture Components

### 1. Data Models
We need a robust model for board state and players.
* `GameState`: Holds the status of the board, active player, captured stones, history of moves, and current game phase (`menu`, `playing`, `animating`, `gameOver`).
* `BoardSquare`: Repesents each of the 12 squares.
  ```dart
  class BoardSquare {
    final int index;
    final bool isMandarin;
    int citizenCount;
    bool hasMandarin;
    
    BoardSquare({
      required this.index,
      required this.isMandarin,
      required this.citizenCount,
      required this.hasMandarin,
    });
    
    BoardSquare copyWith({int? citizenCount, bool? hasMandarin}) {
      return BoardSquare(
        index: index,
        isMandarin: isMandarin,
        citizenCount: citizenCount ?? this.citizenCount,
        hasMandarin: hasMandarin ?? this.hasMandarin,
      );
    }
  }
  ```

### 2. State & Distribution Engine
To enable animations, the distribution logic should generate a sequence of step-by-step board frames rather than jumping directly to the final state.
* `GameController`:
  * Manages the active game state.
  * Exposes method `selectMove(int squareIndex, bool isClockwise)`.
  * Computes the intermediate states step-by-step (e.g., stone picked up, stone placed in square X, stone placed in square Y, turn continues, capture occurred).
  * Exposes a stream or list of `GameFrame` states for the UI to animate sequentially.

### 3. UI and Theme Design
* **Aesthetics:** A modern dark wood or sleek neon dark-mode theme. We will use:
  * Google Fonts (e.g., "Space Grotesk" or "Plus Jakarta Sans") for typography.
  * Neumorphic design for citizen and mandarin squares.
  * Smooth animations using Flutter's built-in `AnimatedBuilder`, `TweenAnimationBuilder`, and particle transitions.
  * Interactive overlay: When selecting a square, show floating buttons on top of it representing the two direction choices (Clockwise ↻ and Counter-Clockwise ↺).

### 4. Heuristic & Minimax AI Player
To provide an engaging single-player experience, we implement an AI player with three difficulty levels:
* **Easy:** Random valid moves.
* **Medium:** Heuristic-based (greedy algorithm that picks the move with the highest immediate capture value).
* **Hard:** Minimax search (depth 4) with alpha-beta pruning. Evaluates the board based on:
  * Difference in score.
  * Citizen stones remaining on their side.
  * Avoidance of setup moves that allow the opponent to capture the Mandarin squares.

## Success Criteria
- [x] Defined models for the circular board state.
- [x] Designed step-by-step state output for animations.
- [x] Outlined AI engine logic (Minimax + Heuristic).
