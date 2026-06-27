---
phase: 1
title: Research
status: completed
effort: 2h
---

# Phase 1: Research

## Overview
Understand the rules of the Vietnamese traditional game "Ô ăn quan" (Mandarin Square Capturing) and model its state and operations mathematically to ensure bug-free gameplay logic.

## Game Rules & Logic Details

### 1. Board Layout
We represent the board as a circular list of 12 squares (indices `0` to `11`):
* **Player 1 Citizen Squares:** Indices `0, 1, 2, 3, 4`
* **Right Mandarin Square:** Index `5` (neutral/mandarin)
* **Player 2 Citizen Squares:** Indices `6, 7, 8, 9, 10`
* **Left Mandarin Square:** Index `11` (neutral/mandarin)

Circular movement is computed as:
* **Clockwise:** `(index + 1) % 12`
* **Counter-Clockwise:** `(index - 1 + 12) % 12`

### 2. Initial Setup
* Citizen squares (`0..4`, `6..10`) start with 5 citizen stones each.
* Mandarin squares (`5`, `11`) start with 1 Mandarin stone (worth 5 points) and 0 citizen stones.
* Total initial stones: 50 citizen stones, 2 Mandarin stones. Total starting score value: 60 points.

### 3. Move Execution & Turn Progression
A player selects one of their non-empty citizen squares and a direction (Clockwise or Counter-Clockwise).
1. **Distribution:** Pick up all stones from the selected square (leaving it empty). Distribute them one by one in the chosen direction into the next squares.
2. **Termination Cases:** Let `L` be the square where the last stone is placed, and `N = next(L)` in the distribution direction:
   * **Case 1 (Continue):** If `N` is a citizen square AND is NOT empty, pick up all stones in `N` and repeat distribution starting from `next(N)`.
   * **Case 2 (Turn Ends):** If `N` is a Mandarin square, the turn ends immediately, regardless of whether `N` is empty or not. (Stones in a Mandarin square cannot be picked up for distribution).
   * **Case 3 (Capture):** If `N` is empty:
     * Let `C = next(N)`.
     * If `C` is NOT empty, the player captures all stones in `C` (both citizen and mandarin). The captured stones are added to the player's score.
     * **Chain Captures:** After capturing `C`, check `NC = next(C)` and `CC = next(NC)`. If `NC` is empty and `CC` is NOT empty, the player captures all stones in `CC`. This chain capture repeats until the condition fails (i.e., we encounter two consecutive empty squares or a non-empty square where we would have to distribute).
     * If `C` is empty (two consecutive empty squares), the turn ends with no capture.

### 4. Special Situations
* **Empty Board (Cung cấp dân):** If a player's turn starts and all 5 of their citizen squares are empty, they must take 5 stones from their captured pool and place 1 stone in each of their 5 squares. If they have fewer than 5 stones, they borrow from the opponent (score becomes negative or is tracked as debt).
* **Game End:** The game ends immediately when both Mandarin squares (`5` and `11`) are empty (both Mandarin stones are captured).
* **Scoring on End:** Any citizen stones remaining on the board are swept/claimed by the player who controls that side (Player 1 gets remaining stones on `0..4`, Player 2 gets remaining stones on `6..10`).
* **Winner:** The player with the highest total points (Citizen stone = 1 point, Mandarin stone = 5 points).

## Success Criteria
- [x] Clear mathematical model of the circular board.
- [x] Rule edge cases documented (chain capture, empty side refill, borrowing, game end).
