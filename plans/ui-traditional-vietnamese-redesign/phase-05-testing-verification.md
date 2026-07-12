---
phase: 5
title: Testing & Verification
status: completed
priority: P2
dependencies:
  - 2
  - 3
  - 4
---

# Phase 5: Testing & Verification

## Overview

Prove the redesign works and didn't regress logic: update/extend widget tests,
add golden/layout tests across breakpoints, run accessibility checks, and do a
manual multi-platform screenshot sweep. The existing `test/` suite must stay
green (game logic is unchanged by design).

## Requirements

- Functional: existing tests pass; new tests cover responsive layout (no
  overflow per window class), pebble-count rendering, and the sowing animation's
  start/end state; a11y assertions for semantics + touch size.
- Non-functional: tests deterministic (pump fixed sizes, settle animations);
  reduced-motion path tested; manual evidence captured as screenshots.

## Architecture

- Use `WidgetTester` with `tester.view.physicalSize` / `binding.window` overrides
  to assert each `WindowSizeClass` layout renders without overflow.
- Golden tests (optional but recommended) for board + menu at a small set of
  canonical sizes (phone portrait, phone landscape, tablet, desktop).
- Animation tests: drive `pumpAndSettle`; assert final pit counts match the
  controller's resulting `GameState` (animation must not change logic).
- Manual sweep documented with `ui_check_*` screenshots like prior plans.

## Related Code Files

- Modify: `test/status_chip_test.dart` (already touched in working tree; align
  with restyle)
- Create: `test/responsive_layout_test.dart` (no-overflow per window class)
- Create: `test/board_pebble_render_test.dart` (count → stones / numeric rule)
- Create: `test/sowing_animation_test.dart` (start/settle equals controller
  state; reduced-motion snaps)
- Read: existing `test/*`, `lib/controllers/game_controller.dart`

## Implementation Steps

1. Run the current suite; fix any tests broken by Phases 2–4 (expected:
   `status_chip_test`, anything asserting old colors/landscape).
2. Add `responsive_layout_test.dart` pumping menu + game at compact-portrait,
   compact-landscape, medium, and expanded sizes; assert no overflow and key
   widgets present.
3. Add `board_pebble_render_test.dart` for the stone-cluster vs. numeric-cap
   rule and mandarin-stone variant.
4. Add `sowing_animation_test.dart`: play a move, `pumpAndSettle`, assert final
   board matches controller; assert reduced-motion (`disableAnimations`) snaps
   without intermediate frames blocking.
5. A11y pass: assert ≥48dp on interactive widgets and presence of semantics
   labels on icon-only controls.
6. Manual sweep: capture `ui_check_*` screenshots on phone portrait, phone
   landscape, tablet, and a wide web/desktop window; eyeball contrast +
   overflow.
7. `flutter analyze` + `flutter test` green; record results.

## Success Criteria

- [ ] `flutter test` passes (existing + new).
- [ ] No-overflow asserted for all four window classes.
- [ ] Pebble-count rendering and sowing start/settle covered by tests.
- [ ] Reduced-motion path verified.
- [ ] Touch-target + semantics assertions pass.
- [ ] Manual screenshot evidence captured for each platform/orientation.
- [ ] `flutter analyze` clean.

## Risk Assessment

- **Flaky animation tests:** Mitigation: always `pumpAndSettle` / fixed
  durations; assert end state, not intermediate frames.
- **Golden churn:** goldens are brittle across font rendering. Mitigation: keep
  golden set small and platform-pinned, or assert structure instead of goldens
  if CI font rendering differs.
- **Hidden logic coupling:** if a test reveals animation altered state, that's a
  real bug from Phase 3 — fix the view, not the test.
