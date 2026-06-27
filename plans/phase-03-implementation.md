---
phase: 3
title: Implementation
status: completed
effort: 6h
dependencies:
  - 2
---

# Phase 3: Implementation

## Overview
Write the codebase for models, controllers, AI engine, UI components, and the main game screens in Flutter.

## Related Code Files
- Create: `lib/models/board_square.dart`
- Create: `lib/models/game_state.dart`
- Create: `lib/controllers/game_controller.dart`
- Create: `lib/ai/ai_player.dart`
- Create: `lib/theme/game_theme.dart`
- Create: `lib/widgets/square_widget.dart`
- Create: `lib/widgets/board_widget.dart`
- Create: `lib/widgets/score_board.dart`
- Create: `lib/widgets/direction_selector.dart`
- Create: `lib/screens/menu_screen.dart`
- Create: `lib/screens/game_screen.dart`
- Create: `lib/screens/tutorial_screen.dart`
- Modify: `lib/main.dart`
- Modify: `pubspec.yaml`

## Implementation Steps

### 1. Project Initialization & Dependencies
* Edit [pubspec.yaml](file:///Volumes/m2/dev/o-an-quan-flutter/pubspec.yaml) to add dependencies like `google_fonts` and `flutter_animate` (if needed) or write clean custom animations.
* Setup asset directory for sound effects and any images (if applicable, but we will use custom painters and SVG icons to keep it completely self-contained and performant).

### 2. State & Engine Implementation
* Write models and controller.
* Implement the circular step-by-step frame generator in `game_controller.dart` that returns a list of events/states for the animation engine to step through.
* Implement empty side refilling (cung cấp dân) and game-over detection.

### 3. AI Solver (Minimax & Greedy)
* Implement AI agent in `ai_player.dart`.
* Integrate AI into game loop: when it is the AI's turn, trigger the search asynchronously (to avoid UI stutter) and execute the chosen move with animations.

### 4. High-Fidelity UI & Animations
* Design visual theme: Sleek dark glassmorphism, with dynamic animations.
* Build custom painter or layout for the 10 citizen squares in a grid and 2 semi-circle mandarin squares at the ends.
* Build interactive overlay for move direction selection.
* Draw pebbles/stones dynamically in each square (placed randomly in a cluster using polar coordinates inside the square bounds).

### 5. Screens & Workflows
* Menu Screen: Mode selection (Single Player, Local Two Players, Tutorial).
* Game Screen: Active board, score banners, active player indicator, undo button, restart button, back button.
* Tutorial Screen: Guided step-by-step game showing how a move works and how to capture stones.

## Success Criteria
- [ ] Game logic matches all traditional rules.
- [ ] AI plays smart moves at hard difficulty and executes moves correctly.
- [ ] Stone distribution and captures animate step-by-step smoothly.
- [ ] Design is premium and dark mode matches high-quality guidelines.
