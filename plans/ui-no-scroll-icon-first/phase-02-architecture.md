---
phase: 2
title: Architecture
status: completed
priority: P1
dependencies:
  - 1
---

# Phase 2: Architecture

## Overview

Thiết kế hệ thống layout no-scroll và thư viện widget icon-first tái sử dụng. Tách presentation status khỏi string parsing.

## Requirements

- Functional: `NoScrollScaffold` fit viewport; `GameIcons` constants; `GameStatus` model.
- Non-functional: Không thêm dependency pub.dev; giữ `ChangeNotifier` pattern hiện tại.

## Architecture

### Component Diagram

```
main.dart (landscape lock)
    └── MenuScreen
            └── NoScrollScaffold
                    └── FittedBox → MenuGrid (2×2 IconMenuTile)
    └── GameScreen
            └── NoScrollScaffold
                    ├── IconToolbar (back, mode, restart)
                    ├── Row: PlayerPanelCompact | BoardWidget | PlayerPanelCompact
                    ├── StatusChipBar (from GameStatus)
                    └── IconActionBar (undo, rules)
    └── TutorialScreen
            └── NoScrollScaffold
                    ├── StepIndicator (dots only)
                    ├── TutorialStepCard (icon + FittedBox caption)
                    └── IconNavBar (prev/next icons)
```

### New Files

```
lib/
├── theme/
│   └── game_icons.dart          # Icon + semantics map
├── models/
│   └── game_status.dart         # StatusKind enum + GameStatus class
├── widgets/
│   ├── no_scroll_scaffold.dart  # Viewport-fitting wrapper
│   ├── icon_menu_tile.dart      # Grid cell for menu
│   ├── icon_action_button.dart  # 44pt + tooltip + semantics
│   ├── status_chip_bar.dart     # Icon chips row
│   └── player_panel_compact.dart # Icon-only player stats (or refactor score_board)
```

### NoScrollScaffold

```dart
class NoScrollScaffold extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  // Wraps child in LayoutBuilder → SizedBox.expand → FittedBox(scaleDown only)
  // OR: LayoutBuilder with computed padding, no FittedBox if child uses flex
}
```

**Quyết định**: Game screen dùng `Flex` layout (không FittedBox toàn màn) vì board cần `Expanded`. Menu/Tutorial dùng `FittedBox` khi cần.

### GameStatus Integration

```dart
// game_state.dart — add field
GameStatus? currentStatus;

// game_controller.dart — replace statusMessage strings
void _emitStatus(GameStatus status) {
  _state = _state.copyWith(currentStatus: status);
  notifyListeners();
}
```

Giữ `statusMessage` deprecated 1 phase để backward compat tests, remove trong Phase 4.

### PlayerPanelCompact

Thay `PlayerPanel` wide/narrow branching bằng 1 layout cố định:

```
┌─────────┐
│ (avatar)│  ← icon circle, pulse if active
│  🏆 12  │  ← score row
│ ⚪3 💎1 │  ← stat icons + numbers only
│ 💳-2    │  ← debt if > 0
└─────────┘
```

Max width ~100px, no player name text.

### IconActionButton

```dart
class IconActionButton extends StatelessWidget {
  final IconData icon;
  final String semanticsLabel;
  final String? tooltip;
  final VoidCallback? onPressed;
  final Color? color;

  // constraints: min 44×44
  // style: backgroundColor white 8% opacity, radius 12
}
```

Extract từ `game_screen.dart` `_buildControls` — DRY.

### Menu Grid

```dart
class MenuGrid extends StatelessWidget {
  // GridView.count(crossAxisCount: 2, childAspectRatio: 1.4)
  // 4 tiles: PvP, AI Hard, AI Medium, Tutorial
  // Title: icon 48px + optional 1-line label below (FittedBox)
}
```

### Tutorial Step Icons

| Step | Icon |
|------|------|
| 1 Board | `Icons.grid_view` |
| 2 Sow | `Icons.swap_horiz` |
| 3 Continue | `Icons.loop` |
| 4 Capture | `Icons.download` |
| 5 Stop | `Icons.pause_circle` |
| 6 Score | `Icons.leaderboard` |

Caption: max 2 lines, `fontSize: scale * 14`, `maxLines: 2`.

## Related Code Files

- Create: `lib/theme/game_icons.dart`
- Create: `lib/models/game_status.dart`
- Create: `lib/widgets/no_scroll_scaffold.dart`
- Create: `lib/widgets/icon_menu_tile.dart`
- Create: `lib/widgets/icon_action_button.dart`
- Create: `lib/widgets/status_chip_bar.dart`
- Modify: `lib/models/game_state.dart` (add `GameStatus?`)
- Modify: `lib/controllers/game_controller.dart` (emit `GameStatus`)
- Modify: `lib/widgets/score_board.dart` → slim or replace with `player_panel_compact.dart`

## Implementation Steps

1. Define `GameIcons` static class với icon + `semanticsLabel` pairs.
2. Define `GameStatus` model và `StatusKind` enum.
3. Implement `NoScrollScaffold` với `LayoutBuilder`.
4. Implement `IconActionButton` (extract from game_screen).
5. Implement `StatusChipBar` — maps `GameStatus` → `Row` of `Chip` with icon only.
6. Implement `IconMenuTile` + `MenuGrid` layout spec.
7. Add `currentStatus` to `GameState.copyWith`.
8. Document migration: `statusMessage` → `currentStatus` in controller.

## Success Criteria

- [ ] 6 new widget/model files spec'd with public API
- [ ] `GameStatus` covers all `StatusKind` values used in controller
- [ ] Layout decision documented: Flex vs FittedBox per screen
- [ ] No new pub.dev dependencies

## Risk Assessment

| Risk | Mitigation |
|------|------------|
| `GameState` copyWith churn | Add optional `currentStatus`, default null |
| Dual status fields during migration | Controller sets both; UI reads `currentStatus` only |
| PlayerPanel refactor breaks layout | Keep `PlayerPanel` as export alias to compact version |
