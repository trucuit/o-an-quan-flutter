---
phase: 4
title: Screens & Flow Restyle
status: completed
priority: P1
dependencies:
  - 2
  - 3
---

# Phase 4: Screens & Flow Restyle

## Overview

Apply the new design system and responsive primitives across every screen and
piece of chrome: menu, game (top bar / player rails / bottom HUD / direction
selector / game-over), tutorial, and dialogs. Make each layout adapt across
compact / medium / expanded window classes and both orientations — no overflow,
no forced landscape.

## Requirements

- Functional: all screens restyled to the Vietnamese palette/typography and
  laid out responsively; the board (Phase 3) is the centerpiece and stays
  legible on phone portrait through desktop/web.
- Non-functional: ≥48dp touch targets, semantics labels retained, AA contrast,
  reduced-motion respected; no horizontal scrolling; safe-area correct now that
  immersive lock is gone.

## Architecture

- **Responsive scaffold:** replace `no_scroll_scaffold.dart`'s landscape-only
  assumption with a `SafeArea` + `LayoutBuilder` scaffold that picks a layout
  via `WindowSizeClass` (Phase 2). Centered max-width content on expanded/web.
- **Menu (`menu_screen.dart`):** keep the four entries (PvP, hard AI, medium AI,
  tutorial) but as tiles styled like wood/paper cards; grid reflows 2×2 (compact
  landscape / medium) ↔ 1×4 or 2×2 (compact portrait) ↔ centered panel
  (expanded). Replace neon gradients with accent-on-wood.
- **Game (`game_screen.dart` + `widgets/game/*`):** rework `game_layout.dart`
  metrics into responsive values; player rails sit beside the board in landscape
  and above/below in portrait; top bar + bottom HUD restyled; direction selector
  and game-over overlay re-skinned. Remove the global immersive call from
  `game_screen.dart` or make it landscape-mobile-only.
- **Tutorial (`tutorial_screen.dart`):** restyle stepper + card to paper/ink;
  ensure the 6-step content fits all classes (portrait card grows, landscape
  side-by-side icon+text).
- **Dialogs (`game_rules_dialog.dart`, `game_reset_dialog.dart`):** paper
  surfaces, ink text, accent buttons.
- Recolor `game_icons.dart` usages to accents; the icon set itself is unchanged.

## Related Code Files

- Modify: `lib/screens/menu_screen.dart`
- Modify: `lib/screens/game_screen.dart`
- Modify: `lib/screens/tutorial_screen.dart`
- Modify: `lib/widgets/no_scroll_scaffold.dart` (→ responsive safe scaffold)
- Modify: `lib/widgets/game/game_layout.dart` (responsive metrics)
- Modify: `lib/widgets/game/game_top_bar.dart`,
  `lib/widgets/game/game_bottom_hud.dart`,
  `lib/widgets/game/game_player_rail.dart`,
  `lib/widgets/game/game_over_overlay.dart`,
  `lib/widgets/game/game_rules_dialog.dart`,
  `lib/widgets/game/game_reset_dialog.dart`
- Modify: `lib/widgets/direction_selector.dart`,
  `lib/widgets/status_chip_bar.dart`, `lib/widgets/icon_menu_tile.dart`,
  `lib/widgets/icon_action_button.dart`, `lib/widgets/score_board.dart`
- Read: `lib/theme/*`, `lib/widgets/board_widget.dart` (Phase 3 output)

## Implementation Steps

1. Build the responsive scaffold (SafeArea + window-class switch); migrate
   `no_scroll_scaffold` usages to it.
2. Restyle + reflow the menu; verify 2×2 and 1×N layouts and centered expanded
   layout.
3. Make `game_layout.dart` metrics responsive (rail width/placement, bar
   heights, gutters) keyed to window class + orientation.
4. Restyle game top bar, bottom HUD, player rails, direction selector, status
   chip, and game-over overlay; move rails above/below board in portrait.
5. Restyle tutorial stepper/card and confirm fit in every class.
6. Restyle dialogs and remaining shared widgets
   (`icon_menu_tile`, `icon_action_button`, `score_board`, `status_chip_bar`).
7. Remove/guard the global immersive call so non-mobile platforms behave; verify
   safe areas on a notch device.
8. `flutter analyze`; manual sweep on phone portrait, phone landscape, tablet,
   and a wide desktop/web window for overflow + legibility.

## Success Criteria

- [ ] Menu, game, tutorial, dialogs, and overlays all use the Vietnamese
      palette/typography — no neon remnants anywhere.
- [ ] Each screen renders without overflow in compact portrait, compact
      landscape, medium, and expanded (web/desktop) classes.
- [ ] Player rails reposition correctly between portrait and landscape.
- [ ] All interactive controls ≥48dp; semantics labels intact; AA contrast.
- [ ] App is fully usable in portrait (forced-landscape lock gone end to end).
- [ ] `flutter analyze` clean.

## Risk Assessment

- **Portrait board legibility:** a wide 5×2 board is awkward in portrait.
  Mitigation: scale board to width and place rails above/below; consider a
  slight board aspect adjustment, never altering the index model.
- **Many touched files:** high churn. Mitigation: lean on shared scaffold +
  tokens so each widget change is mechanical; commit per screen.
- **Web/desktop input differences:** hover/focus states. Mitigation: ensure
  focus highlights and keyboard activation on actionable widgets.
