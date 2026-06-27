---
phase: 2
title: Architecture & Design System Update
status: completed
effort: 1d
dependencies:
  - 1
---

# Phase 2: Architecture & Design System Update

## Overview
Update the Flutter layout architecture to be explicitly landscape-oriented, adapting responsiveness for varying landscape aspect ratios (e.g., tablets vs. ultra-wide phones). Incorporate `ui-ux-pro-max` spacing and interaction standards.

## Requirements
- Functional: The board layout must center properly and maximize height or width appropriately without horizontal scrolling.
- Non-functional: All interactive touch targets must be at least 44x44pt (using `hitSlop` or minimum padding/size). Provide visual feedback (ripple/scale) under 150ms on tap.

## Architecture
- `LayoutBuilder` / `MediaQuery`: Use to calculate dimensions for the board squares and pits in a landscape context.
- Design System: Implement an 8dp spacing scale (4, 8, 16, 24, 32, 48) for padding and margins.
- System Overrides: `SystemChrome` calls in the app initialization phase to lock landscape and hide status bars.

## Related Code Files
- Modify: `lib/main.dart`, `lib/theme/app_theme.dart` (or similar theme file), `lib/widgets/board_widget.dart`.
- Create: `lib/utils/design_tokens.dart` (if not exists, for 8dp spacing constants and sizes).

## Implementation Steps
1. Update `main.dart` to set preferred orientations to `landscapeLeft` and `landscapeRight`.
2. Update `main.dart` to set system UI mode to `immersiveSticky`.
3. Create/update the design tokens file for spacing (e.g., `Spacing.sm = 8.0`, `Spacing.md = 16.0`) and touch targets (`MinTouchTarget.size = 44.0`).
4. Architect the main game layout: typically Board in center, player avatars/scores on the left and right edges (or top/bottom edges, considering safe areas).

## Success Criteria
- [ ] App forces landscape orientation on launch.
- [ ] System UI (status bar, navigation bar) is hidden.
- [ ] New layout structure is defined utilizing the 8dp grid system.

## Risk Assessment
- Risk: Notches (Dynamic Island) cutting off UI elements on the edges.
  - Mitigation: Use `SafeArea` to ensure UI elements avoid notches, but allow the board background to extend to the edges.
