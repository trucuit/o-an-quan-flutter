---
phase: 4
title: Testing
status: completed
effort: 2h
dependencies:
  - 3
---

# Phase 4: Testing

## Overview
Perform unit testing on core game logic, AI optimization validation, and UI layout checks across screen sizes.

## Test Cases

### 1. Game State & Logic Unit Tests (`test/game_logic_test.dart`)
* **Starting Board State:** Verify 10 citizen squares have 5 stones each and 2 mandarin squares have 1 mandarin stone each.
* **Basic Distribution:** Pick square 0 clockwise -> Verify stones are placed in 1, 2, 3, 4, 5 and state is processed correctly.
* **Turn Continuation:** Ensure that when the last stone lands on a non-empty citizen square, the stones are picked up and distributed continues.
* **Turn Termination:** Ensure landing on Mandarin square stops distribution and ends turn.
* **Single Capture:** End on empty citizen square, next is non-empty -> Verify stones are captured and added to player score.
* **Chain Capture:** End on empty, capture non-empty, check if next is empty and next after is non-empty -> verify chain capture of both.
* **Refill (Cung cấp dân):** Force empty side for player 1, start turn -> verify 5 stones are subtracted from player 1 captured pool and placed 1 in each of P1's squares.
* **Game Over Sweeping:** Verify game ends when both mandarins are empty, and remaining citizen stones go to the respective side owners.

### 2. AI Testing (`test/ai_player_test.dart`)
* Validate AI always selects a valid move.
* Test execution time of Hard difficulty Minimax search to ensure it is under 100ms.

### 3. UI Widget Tests (`test/board_widget_test.dart`)
* Test selection of citizen square opens clockwise/counter-clockwise selectors.
* Test that tapping on opponent squares does not trigger selection.
* Test resizing and layouts on narrow phone screens to ensure no layout overflows.

## Success Criteria
- [ ] 100% pass rate on game logic unit tests.
- [ ] AI moves are fast and do not block the UI main thread.
- [ ] No visual overflows on portrait mobile devices or web browsers.
