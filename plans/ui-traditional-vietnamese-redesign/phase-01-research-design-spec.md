---
phase: 1
title: Research & Design Spec
status: completed
priority: P1
dependencies: []
---

# Phase 1: Research & Design Spec

## Overview

Establish the authentic Traditional Vietnamese visual language and a written
design spec that phases 2–4 implement against. No app code changes — this phase
produces a single reference document plus a decided token table.

## Requirements

- Functional: a `design-spec.md` covering palette, typography, materials
  (board/pebbles), iconography, spacing/motion tokens, and responsive
  breakpoints + per-breakpoint layout intent.
- Non-functional: choices grounded in real Ô Ăn Quan references and WCAG AA
  contrast; mobile-readable; no invented cultural motifs that misrepresent the
  game.

## Architecture

Reference the real game to drive decisions:

- **Board:** rectangular wooden board, two long rows of 5 square citizen pits
  (`ô dân`), a half-circle "mandarin" pit (`ô quan`) at each end. Pebbles are
  small stones (`dân`); mandarins are large stones (`quan`).
- **Palette (proposed, to be finalized):**
  - Paper/background warm sand `#F4E9D8`, panel `#EAD9BD`
  - Wood board mid `#9A6B3F`, deep grain `#6E4423`, carved pit shadow `#4A2C16`
  - Ink text `#2B2118`, muted `#6E5C49`
  - Player 1 accent terracotta `#B5462E`; Player 2 accent jade `#2E7D6B`
  - Mandarin stone aged gold `#C8962E`; citizen stone ivory `#EDE4D0` / river
    slate `#5B7C8D`
  - Status/positive jade, warning amber, AA-checked on paper + wood.
- **Typography:** keep Google Fonts; pick a warm humanist serif for
  display/title (e.g. `Be Vietnam Pro` for full Vietnamese diacritics, or a
  serif like `Noto Serif` that renders `ăâêôơưđ` correctly) and a clean sans for
  body/labels. **Must verify full Vietnamese diacritic coverage.**
- **Responsive breakpoints (proposed):** `compact` < 600, `medium` 600–1023,
  `expanded` ≥ 1024 logical px (Material window-size classes). Define board
  orientation + chrome placement per class and per portrait/landscape.
- **Motion:** sowing pebble travel 180–260ms ease, capture pulse, turn-change
  transition; all reduced-motion safe.

## Related Code Files

- Create: `plans/ui-traditional-vietnamese-redesign/design-spec.md`
- Read (reference only, no edits): `lib/theme/game_theme.dart`,
  `lib/theme/game_play_theme.dart`, `lib/theme/game_icons.dart`,
  `lib/theme/app_motion.dart`, `pubspec.yaml`

## Implementation Steps

1. Gather 3–5 references of real Ô Ăn Quan boards/pebbles; note shape, materials,
   colors. (WebSearch/WebFetch acceptable; cite URLs in the spec.)
2. Lock the palette table with hex + intended usage + AA contrast notes
   (text-on-paper, text-on-wood, accent-on-paper).
3. Choose display + body fonts; confirm Vietnamese diacritic rendering; list
   Google Fonts names.
4. Define spacing scale (keep 4/8dp), radii, elevation/shadow language (soft
   carved shadows, no neon glow), and motion tokens.
5. Define responsive breakpoints and a small layout matrix: for each
   {compact, medium, expanded} × {portrait, landscape}, describe board size,
   board orientation, and where player rails / HUD / actions sit.
6. Define pebble visual spec: stone shape, size ranges, how counts map to
   clustered stones vs. a numeric badge at high counts (e.g. show up to N
   stones, then "+count").
7. Write `design-spec.md` consolidating all of the above; flag any open
   decisions for the user.

## Success Criteria

- [ ] `design-spec.md` exists with palette, typography, materials, spacing,
      motion, and a per-breakpoint layout matrix.
- [ ] Every text/accent color pairing has an AA contrast note.
- [ ] Chosen fonts confirmed to render Vietnamese diacritics.
- [ ] Pebble-count rendering rule defined (stones vs. numeric fallback).
- [ ] References cited as URLs.

## Risk Assessment

- **Font diacritics:** some display fonts drop `ơ/ư/đ`. Mitigation: verify
  early, keep `Be Vietnam Pro` as a safe fallback.
- **Aesthetic vs. legibility:** wood textures can hurt contrast. Mitigation: AA
  checks mandatory; pits get a lightened inner surface for stone contrast.
- **Scope creep into logic:** none — doc-only phase.
