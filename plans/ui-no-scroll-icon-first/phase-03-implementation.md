---
phase: 3
title: Implementation
status: completed
priority: P1
dependencies:
  - 2
---

# Phase 3: Implementation

## Overview

Refactor từng màn hình và widget theo architecture Phase 2. Thứ tự: foundation widgets → models → controller → screens.

## Requirements

- Functional: Remove scroll từ main flows; icon-first UI live trên 3 screens.
- Non-functional: Mọi `IconButton`/`InkWell` action ≥44pt; `Tooltip` + `Semantics` bắt buộc.

## Architecture

Bottom-up implementation order:

```
game_icons.dart → game_status.dart → icon_action_button.dart
    → status_chip_bar.dart → no_scroll_scaffold.dart
    → game_controller (status emit)
    → score_board / player_panel_compact
    → menu_screen → game_screen → tutorial_screen
    → direction_selector
```

## Related Code Files

- Create: `lib/theme/game_icons.dart`
- Create: `lib/models/game_status.dart`
- Create: `lib/widgets/no_scroll_scaffold.dart`
- Create: `lib/widgets/icon_menu_tile.dart`
- Create: `lib/widgets/icon_action_button.dart`
- Create: `lib/widgets/status_chip_bar.dart`
- Modify: `lib/models/game_state.dart`
- Modify: `lib/controllers/game_controller.dart`
- Modify: `lib/screens/menu_screen.dart`
- Modify: `lib/screens/game_screen.dart`
- Modify: `lib/screens/tutorial_screen.dart`
- Modify: `lib/widgets/score_board.dart`
- Modify: `lib/widgets/direction_selector.dart`

## Implementation Steps

### Step 1: Foundation — `game_icons.dart` + `icon_action_button.dart`

```dart
// game_icons.dart
abstract final class GameIcons {
  static const pvp = Icons.people;
  static const aiHard = Icons.smart_toy;
  // ... full map from Phase 1

  static String label(IconData icon) => _labels[icon] ?? '';
}
```

Extract `IconActionButton` từ `game_screen._buildControls`.

### Step 2: `game_status.dart` + `GameState` update

```dart
enum StatusKind { idle, pick, sow, capture, stop, refill, borrow, turn, gameOver }

class GameStatus {
  final StatusKind kind;
  final int? squareIndex;
  final int? count;
  final bool hasMandarin;
  final int? player;
  // factory constructors: GameStatus.pick(square, count), etc.
}
```

Add to `GameState`:
```dart
final GameStatus? currentStatus;
```

### Step 3: `game_controller.dart` — emit structured status

Replace mỗi `statusMessage: "Nhặt 🖐️..."` bằng:

```dart
currentStatus: GameStatus.pick(squareIndex: startIdx, count: stonesInHand),
```

Giữ `statusMessage` sync (deprecated) cho tests tạm thời:
```dart
statusMessage: currentStatus?.toDebugString() ?? '',
```

Locations to update (~15 call sites trong `_generateDistributionFrames`, `_postMoveProcessing`, `_checkSideRefill`, `_endGame`).

### Step 4: `status_chip_bar.dart`

```dart
class StatusChipBar extends StatelessWidget {
  final GameStatus? status;
  // Row of 1-3 chips: [icon] [optional square#] [optional count]
  // AnimatedSwitcher for transitions
}
```

Render ví dụ capture:
`[🎉 icon] [ô 7] [⚪×3] [💎×1]` — numbers only, no Vietnamese verbs.

### Step 5: `menu_screen.dart` — 2×2 grid, no scroll

**Before:**
```dart
SingleChildScrollView(
  child: Column(children: [title, 4× _buildMenuCard, footer]),
)
```

**After:**
```dart
NoScrollScaffold(
  child: Column(
    children: [
      // Compact header: logo icon + "Ô ĂN QUAN" FittedBox
      Expanded(
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.35,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            IconMenuTile(icon: GameIcons.pvp, label: '2 người', onTap: ...),
            IconMenuTile(icon: GameIcons.aiHard, badge: Icons.bolt, ...),
            IconMenuTile(icon: GameIcons.aiMedium, ...),
            IconMenuTile(icon: GameIcons.tutorial, ...),
          ],
        ),
      ),
      // Footer: icon only — Icons.flag for VN
    ],
  ),
)
```

Remove subtitle text từ cards. Label tối đa 2 từ.

### Step 6: `score_board.dart` → compact icon layout

- Remove `name`, `nameShort`, `_getAIDifficultyTag` text display
- AI difficulty → icon badge: `Icons.bolt` (hard), `Icons.trending_flat` (medium)
- Layout: vertical stack, max ~90px wide
- Remove `isNarrow` branch — 1 layout only

### Step 7: `game_screen.dart` — tighten vertical budget

Changes:
1. `_buildHeader`: bỏ text `_getGameModeTitle()` → `Icon` theo mode (`Icons.people`, `Icons.smart_toy`)
2. `_buildStatusBanner` → `StatusChipBar(status: state.currentStatus)`
3. Side panels: `flex: 2` → `flex: 1` (tiết kiệm width cho board)
4. Center column: wrap board trong `Flexible` + reduce padding `vertical: 12` → `8`
5. `_buildGameOverOverlay`:
   - Title → large icon (`Icons.emoji_events` / `Icons.handshake`)
   - Buttons → `IconActionButton` (home, refresh) thay "Về Menu" / "Chơi Lại"
   - Score labels → icon only (person vs smart_toy)
6. `_showResetConfirmation`: icon dialog — `Icons.warning_amber` title, icon buttons confirm/cancel

Reduce center column children height budget:
```
header: 44px
board: Expanded (flex)
status: 36px
controls: 44px
padding: 16px
Total fixed: ~140px → board gets rest
```

### Step 8: `direction_selector.dart` — icon only

- Remove `"Ô $squareIndex"` text → chip với `Icons.grid_on` + number
- Remove `TextButton.icon` "HỦY" → `IconActionButton(Icons.close)`
- Add `Semantics(label: 'Chọn chiều rải quân')`

### Step 9: `tutorial_screen.dart` — no scroll

- Remove `SingleChildScrollView` in step body
- Add large step icon (64px) above caption
- Caption: `FittedBox(child: Text(..., maxLines: 2))`
- Nav: `IconActionButton(Icons.arrow_back)` / `IconActionButton(Icons.arrow_forward)` / `Icons.sports_esports` for finish
- Step badge "BƯỚC 1/6" → dot indicator only (đã có) + small `Text('${step+1}/${total}')` FittedBox
- Reduce padding `28` → `16`

### Step 10: Polish

- Verify `debugPaintSizeEnabled` không overflow trên 640×360
- Remove unused `_buildMenuCard` text styles
- Run `dart format lib/`

## Success Criteria

- [ ] `menu_screen.dart` không còn `ScrollView`
- [ ] `tutorial_screen.dart` không còn `ScrollView` trên main body
- [ ] `game_screen.dart` dùng `StatusChipBar` thay text banner
- [ ] `PlayerPanel` không hiển thị tên text dài
- [ ] `direction_selector.dart` icon-only
- [ ] `GameController` emit `GameStatus` structured
- [ ] 6 file mới created, compile clean

## Risk Assessment

| Risk | Mitigation |
|------|------------|
| Game screen overflow on SE | Reduce panel flex; shrink status chip font |
| Status migration misses edge case | Grep all `statusMessage` assignments |
| Tutorial text truncated | `maxLines: 2` + shorter copy rewrite |
