---
title: Traditional Vietnamese UI/UX Redesign
description: >-
  Full UI/UX refactor of the Ô Ăn Quan Flutter app from the current dark neon
  look to an authentic Traditional Vietnamese aesthetic (warm paper, wood-grain
  board, ink/terracotta palette, real pebble visuals), with a responsive layout
  across phone/tablet/desktop/web in both orientations, real stone-sowing
  animation, and a coherent screen flow.
status: completed
priority: P1
branch: main
tags:
  - ui
  - ux
  - flutter
  - redesign
  - responsive
  - animation
  - traditional-vietnamese
blockedBy: []
blocks: []
created: '2026-06-27T15:42:45.566Z'
createdBy: 'ck:plan'
source: skill
---

# Traditional Vietnamese UI/UX Redesign

## Overview

Redirect the app's entire visual language. The current build mixes a neon
"cyberpunk" menu (`game_theme.dart`) with a muted dark board
(`game_play_theme.dart`), is **hard-locked to landscape + immersive** in
`main.dart`, and renders pits as flat boxes showing a bare count number — there
are **no real pebbles and no sowing animation**.

This plan rebuilds the UI around an authentic **Traditional Vietnamese**
aesthetic: warm paper backgrounds, a wood-grain carved board, ink + terracotta +
jade accents, and rendered pebble/stone clusters. It is **responsive across all
platforms** (phone/tablet/desktop/web, portrait + landscape) and introduces a
**real stone-sowing animation** with capture feedback and haptics. All four
scope areas the user selected are covered: visual restyle, layout &
responsiveness, interaction & animation, and screens & flow.

**Game logic (`controllers/`, `ai/`, `models/`) is out of scope** — this is a
presentation-layer refactor. Public model/controller contracts are preserved
unless a phase explicitly notes otherwise.

## Design Goals

- One coherent design-token system (retire the neon/muted split).
- Authentic feel: real Ô Ăn Quan board shape (2 rows of 5 citizen pits + 2
  half-moon mandarin pits), wood/stone materials, Vietnamese cultural palette.
- Responsive: no overflow, no forced orientation, adapts portrait ↔ landscape
  and phone ↔ tablet ↔ desktop/web.
- Animated: pebbles visibly sow pit-to-pit; captures and turn changes are felt.
- Accessible: ≥48dp touch targets, semantics labels retained, contrast AA,
  reduced-motion honored.

## Phases

| Phase | Name | Status | Description |
|-------|------|--------|-------------|
| 1 | [Research & Design Spec](./phase-01-research-design-spec.md) | completed | Design spec written (palette, fonts, materials, motion, breakpoints). |
| 2 | [Design System Foundation](./phase-02-design-system-foundation.md) | completed | Vietnamese token system replaces neon; themes unified; responsive primitives; landscape lock removed. |
| 3 | [Board Pebbles & Animation](./phase-03-board-pebbles-animation.md) | completed | Wood-grain CustomPainter board; real pebble clusters; sowing animation synced to controller frames; haptics + SFX. |
| 4 | [Screens & Flow Restyle](./phase-04-screens-flow-restyle.md) | completed | Responsive menu/game/tutorial/dialogs; portrait rails; mobile-only immersive; contrast fixes. |
| 5 | [Testing & Verification](./phase-05-testing-verification.md) | completed | 38 tests green; manual emulator sweep (menu, landscape, portrait). |

## Dependencies

- Builds on completed plans `plans/ui-refactor-landscape/` and
  `plans/ui-no-scroll-icon-first/` (both `completed`). This plan **supersedes**
  their landscape-only / icon-first decisions where they conflict with the new
  responsive + traditional direction (notably the forced landscape lock and the
  neon token set).
- No external/cross-plan blockers.

## Cross-Cutting Constraints

- Preserve `GameController`, `GameState`, `BoardSquare`, AI behavior, and the
  12-pit index model (0–4 = P1 citizens, 5 = right mandarin, 6–10 = P2 citizens,
  11 = left mandarin).
- Keep `flutter_lucide` for UI action icons; pebbles/board are custom-painted,
  not icon glyphs.
- Honor `MediaQuery.disableAnimationsOf` (reduced motion) everywhere new
  animation is added.
- YAGNI/KISS/DRY: one token source, shared layout primitives, no per-screen
  bespoke theming.

## Open Questions

- **Day/night theming:** ship a single warm "daylight" theme now, or also a
  night/lacquer variant? Plan assumes **single warm theme + optional dark
  variant deferred** unless requested.
- **Sound:** the original root plan mentions sound effects but none are wired.
  Plan scopes **haptics + animation only**; audio is a follow-up unless
  requested.
