---
phase: 3
title: Board Pebbles & Animation
status: completed
priority: P1
dependencies:
  - 2
---

# Phase 3: Board Pebbles & Animation

## Overview

The signature work: render a wood-grain carved board and real pebble clusters
instead of flat boxes + bare numbers, and add a **stone-sowing animation** so
moves are visibly played pit-to-pit, with capture and turn feedback plus
haptics. This is the largest interaction change and the heart of "it feels like
the real game."

## Requirements

- Functional:
  - Wood board surface with carved square pits + two half-moon mandarin pits.
  - Pebbles drawn as small stones clustered inside a pit; mandarin stone
    distinct (larger, gold). High counts fall back to "N stones + numeric badge"
    per the Phase 1 rule.
  - Sowing animation: when a move plays, stones travel one pit at a time along
    the sow direction; capture pits flash/collect; active player highlight and
    turn-change transition.
  - Haptics on sow tick, capture, and invalid action; honor reduced motion.
- Non-functional: 60fps on a mid phone; animation duration driven by motion
  tokens; **game logic untouched** — animation visualizes the controller's
  resulting states, it does not compute moves.

## Architecture

- **Animation source of truth (DECIDED):** `GameController` **already emits
  per-step frames** — `playMove` builds `_animationFrames` (one `GameState` per
  pick/sow/capture step) and plays them via a 300ms `Timer.periodic`, calling
  `notifyListeners()` each step. So the board already advances one pit per frame;
  it only *looks* like ticking numbers because nothing is rendered as stones.
  **Chosen approach:** animate **at the `PebbleCluster` level synced to that
  existing cadence** — each cluster detects its count delta between frames and
  animates stones dropping in / being swept out, with a capture pulse. **No
  separate `sowing_animator.dart` is created** (would duplicate path logic the
  controller already owns). `isAnimating` still gates input. Logic untouched.
- **Rendering:** `BoardPainter` (`CustomPainter`) for wood + carved pits;
  pebbles either painted in the same painter or as positioned `PebbleCluster`
  widgets driven by an `AnimationController`. Deterministic per-pit stone
  placement (seed by pit index) so stones don't jump between rebuilds.
- **New widgets:**
  - `lib/widgets/board/board_painter.dart` — wood + pits.
  - `lib/widgets/board/pebble_cluster.dart` — stone layout for a count.
  - `lib/widgets/board/sowing_animator.dart` — drives stone travel between pits.
  - `lib/theme/pebble_style.dart` — stone shapes/colors/size ramp from tokens.
- **Haptics:** `HapticFeedback` (selectionClick on sow tick, mediumImpact on
  capture); wrapped in a helper that no-ops under reduced motion / unsupported
  platforms (web/desktop).

## Related Code Files

- Rewrite: `lib/widgets/board_widget.dart` (compose painter + clusters +
  animator; keep its public props: `board`, `activePlayer`, `selectedIndex`,
  `isAnimating`, `onSquareTap`)
- Rewrite: `lib/widgets/square_widget.dart` (becomes pit + pebble cluster, or is
  replaced by board-level painting; remove bare-number rendering)
- Create: `lib/widgets/board/board_painter.dart`
- Create: `lib/widgets/board/pebble_cluster.dart`
- Create: `lib/widgets/board/sowing_animator.dart`
- Create: `lib/theme/pebble_style.dart`
- Create: `lib/widgets/haptics.dart` (reduced-motion / platform-safe wrapper)
- Read: `lib/controllers/game_controller.dart`, `lib/models/board_square.dart`,
  `lib/models/game_state.dart` (understand state transitions; do not change
  logic)

## Implementation Steps

1. Build `BoardPainter`: wood grain (layered gradients/noise), 10 square pits in
   two rows, 2 half-moon mandarin pits, carved inner shadow. Verify against the
   12-index model (0–4 bottom, 6–10 top reversed, 5 right quan, 11 left quan).
2. Build `PebbleCluster` + `pebble_style.dart`: deterministic stone layout for a
   given count; mandarin stone variant; numeric fallback past the cap.
3. Replace flat `square_widget` rendering with pit + cluster; keep tap/selection
   affordances and `ScalePressable` feel.
4. Implement `sowing_animator.dart`: on `GameState` change, compute the sow path
   and tween stones pit-to-pit; surface a "busy" signal aligned with
   `isAnimating` so input stays gated during animation.
5. Add capture feedback (pit pulse + stones flying to the capturing player rail)
   and active-player highlight / turn-change transition.
6. Add `haptics.dart` and wire sow-tick / capture / invalid haptics; no-op under
   reduced motion and on web/desktop.
7. Validate timings against motion tokens; confirm reduced-motion path skips
   travel and snaps to final state.

## Success Criteria

- [ ] Board renders as wood with carved square + half-moon pits, no flat boxes.
- [ ] Pits show clustered stones (mandarin distinct); high counts use the capped
      stones + numeric rule.
- [ ] Playing a move animates stones pit-to-pit in the chosen direction; input
      is gated until it finishes.
- [ ] Captures show feedback and the player rail updates; turn change is
      visually clear.
- [ ] Haptics fire on supported platforms; reduced motion snaps to final state
      with no travel animation.
- [ ] Game logic/tests unchanged; AI and 12-index model intact.
- [ ] No dropped frames in a manual mid-phone profile pass.

## Risk Assessment

- **Animation/state desync:** the hardest risk — animating a diff while the
  controller advances. Mitigation: animate from a captured snapshot; only accept
  input after the animator reports done (mirror `isAnimating`).
- **Performance of CustomPainter + per-frame stones:** Mitigation: cache the
  static wood layer (`shouldRepaint` false for board), animate only stones;
  consider `RepaintBoundary`.
- **Half-moon pit hit-testing:** custom shapes complicate taps. Mitigation:
  mandarins are non-selectable anyway; citizen pits stay rectangular for simple
  hit areas.
- **Web/desktop haptics absent:** Mitigation: platform-guarded no-op helper.
