---
phase: 2
title: Design System Foundation
status: completed
priority: P1
dependencies:
  - 1
---

# Phase 2: Design System Foundation

## Overview

Turn the design spec into code: one Vietnamese token system replacing the neon
tokens, a unified theme (retiring the `game_theme` / `game_play_theme` split),
shared responsive primitives, and removal of the forced landscape lock. This is
the foundation every screen in Phase 4 builds on.

## Requirements

- Functional: new color/typography/spacing/motion tokens from `design-spec.md`;
  `ThemeData` built from them; a responsive helper exposing window-size class
  and orientation; `main.dart` no longer locks orientation or forces immersive.
- Non-functional: single source of truth (no duplicate palettes); existing
  widgets keep compiling via thin compatibility shims where cheap, otherwise are
  updated in Phase 4; reduced-motion preserved.

## Architecture

- **Tokens:** rewrite `lib/theme/game_theme.dart` as `AppTheme` (or keep the
  `GameTheme` name to limit churn) holding the new paper/wood/ink/accent
  palette, serif+sans `TextStyle`s, spacing, radii, carved-shadow language, and
  `buildTheme()` returning a warm `ColorScheme.light`-based `ThemeData`.
- **Retire the split:** fold `game_play_theme.dart` into the single token file
  (or keep it as a re-export of board-specific tokens that now read from the
  unified palette). No second independent color set.
- **Responsive primitive:** new `lib/theme/app_breakpoints.dart` (or
  `lib/widgets/responsive/`) exposing `WindowSizeClass { compact, medium,
  expanded }` from `MediaQuery.sizeOf`, plus helpers
  `isLandscape(context)` and `responsive<T>({compact, medium, expanded})`.
- **Orientation:** `main.dart` drops `setPreferredOrientations([landscape*])`
  and `immersiveSticky`; use `SystemUiMode.edgeToEdge` and allow all
  orientations. Per-screen immersion (if any) becomes opt-in, not global.
- Keep `app_motion.dart`; extend with any new durations/curves from the spec.

## Related Code Files

- Modify: `lib/theme/game_theme.dart` (new token system + light theme)
- Modify: `lib/theme/game_play_theme.dart` (collapse into unified tokens or
  re-export)
- Modify: `lib/main.dart` (remove landscape lock + immersive; edge-to-edge; all
  orientations)
- Modify: `lib/theme/app_motion.dart` (add spec motion tokens if needed)
- Create: `lib/theme/app_breakpoints.dart` (window-size class + responsive
  helpers)
- Read: `lib/theme/game_icons.dart` (recolor only; icon set unchanged)

## Implementation Steps

1. Implement the palette + typography + spacing/radii/shadow tokens per
   `design-spec.md` in `game_theme.dart`; build a light-based `ThemeData`.
2. Replace neon gradients/glows (`p1Gradient`, `activeShadowP1/2`, etc.) with
   carved-shadow + accent equivalents; keep names where widgets reference them
   to reduce breakage, or add deprecation shims.
3. Collapse `game_play_theme.dart` onto the unified palette so board colors come
   from one source.
4. Add `app_breakpoints.dart` with `WindowSizeClass`, `isLandscape`,
   `responsive<T>(...)`.
5. Update `main.dart`: remove orientation lock, switch to edge-to-edge, allow
   all orientations; keep `MaterialApp` wiring.
6. `flutter analyze` and fix fallout; ensure the app still launches on a phone
   and a wide window without crashing (visual polish lands in Phase 4).

## Success Criteria

- [ ] Exactly one color palette exists in the codebase (no neon set remaining).
- [ ] `buildTheme()` returns the warm Vietnamese theme; app boots on it.
- [ ] `main.dart` no longer forces landscape; app rotates freely and runs
      edge-to-edge.
- [ ] `WindowSizeClass` + responsive helpers available and unit-referenced.
- [ ] `flutter analyze` clean; app launches in portrait and landscape.

## Risk Assessment

- **Wide breakage from renames:** changing token names cascades. Mitigation:
  keep public token identifiers stable where possible; stage visual fixes in
  Phase 4.
- **Removing immersive changes safe areas:** Mitigation: Phase 4 layouts use
  `SafeArea`; verify notch/cutout handling there.
- **Light theme regressions on existing dark widgets:** expected; Phase 4 owns
  the per-widget restyle, Phase 2 only must compile + boot.
