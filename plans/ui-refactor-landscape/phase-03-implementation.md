---
phase: 3
title: Implementation & Refactoring
status: completed
effort: 2d
dependencies:
  - 2
---

# Phase 3: Implementation & Refactoring

## Overview
Execute the layout changes and apply the text-to-icon replacements. Polish interactions to match `ui-ux-pro-max` guidelines for accessibility, state transition animations, and contrast.

## Requirements
- Functional: Replace all primary action buttons with their icon equivalents. Re-layout the board to fit landscape.
- Non-functional: Include `Tooltip` and `Semantics(label: ...)` for every icon button. Ensure proper disabled states (opacity 0.38-0.5, no interaction). 

## Architecture
- Refactoring existing stateless/stateful widgets.
- Utilizing `IconButton` or custom `InkWell`/`GestureDetector` with minimum size constraints.

## Related Code Files
- Modify: `lib/screens/game_screen.dart`, `lib/widgets/player_info_widget.dart`, `lib/widgets/control_panel.dart`.
- Create: `lib/widgets/icon_action_button.dart` (a reusable component that enforces 44pt touch target and tooltips).

## Implementation Steps
1. Create a reusable `IconActionButton` widget that enforces the 44x44pt minimum touch target, includes a `Tooltip`, and uses `Semantics`.
2. Replace text-based control buttons (Undo, Restart, Settings, Pause) with `IconActionButton`.
3. Refactor the board rendering logic in `GameScreen` to optimize for landscape (e.g., drawing the 2 rows of 5 pits horizontally with the 2 mandarin pits on the left and right).
4. Apply the 8dp spacing rhythm to all margins and padding.
5. Verify color contrasts for all new icons and surfaces in both Light and Dark themes.
6. Test interactive feedback (ripples/scale animations) and ensure they respond quickly (< 150ms).

## Success Criteria
- [ ] UI is successfully refactored to landscape full-screen.
- [ ] No structural emoji icons remain; vector icons are used.
- [ ] All icon buttons have a touch target of at least 44x44pt.
- [ ] Screen reader navigation reads out proper labels for all icons.
- [ ] Layout scales properly on varying landscape screen sizes without horizontal/vertical overflow.

## Risk Assessment
- Risk: Layout breaks on smaller phones in landscape due to lack of vertical space.
  - Mitigation: Use `FittedBox` or dynamic scaling based on `MediaQuery.size.height` to shrink the board proportionally so it always fits vertically.
