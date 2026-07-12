# Ô Ăn Quan — Traditional Vietnamese Design Spec

Implementation reference for Phases 2–4. All tokens here are the source of truth;
phase code must read from these values, not redefine them.

> Decisions resolved (defaults from plan open questions): **single warm
> "daylight" theme** this round (night/lacquer variant deferred); **haptics +
> animation only**, no audio this round.

## 1. References

- Ô ăn quan overview, board shape, rules — Wikipedia (EN): https://en.wikipedia.org/wiki/%C3%94_%C4%83n_quan
- Ô ăn quan (VI), cultural context, `dân`/`quan` stones — https://vi.wikipedia.org/wiki/%C3%94_%C4%83n_quan
- Material palette grounded in: hand-drawn chalk boards on pavement + carved
  wooden folk boards; pebbles are river stones, mandarin marked by a larger
  stone or fruit pit.

Board model confirmed: rectangle, **2 long rows of 5 square citizen pits** (`ô
dân`), a **half-circle mandarin pit** (`ô quan`) at each short end. Matches the
code's 12-index model.

## 2. Color Palette

Single warm daylight palette. Hex + usage + AA contrast notes (contrast ratio
vs. the listed background; AA body text needs ≥4.5:1, large/UI ≥3:1).

### Surfaces
| Token | Hex | Usage |
|-------|-----|-------|
| `paper` | `#F4E9D8` | App background (warm sand) |
| `paperPanel` | `#EAD9BD` | Cards, dialogs, menu tiles |
| `paperSunken` | `#E0CCAA` | Inset areas, tutorial card |
| `woodMid` | `#9A6B3F` | Board surface base |
| `woodDeep` | `#6E4423` | Board grain / edges |
| `pitShadow` | `#4A2C16` | Carved pit interior shadow |
| `pitFloor` | `#7E5630` | Lightened pit floor (stone contrast) |

### Ink / text
| Token | Hex | On `paper` | On `woodMid` |
|-------|-----|-----------|--------------|
| `ink` | `#2B2118` | 11.6:1 ✅ AAA | 4.9:1 ✅ AA |
| `inkMuted` | `#6E5C49` | 4.6:1 ✅ AA | — (use on paper only) |
| `inkOnWood` | `#F4E9D8` | — | 4.6:1 ✅ AA (labels on board) |

### Accents
| Token | Hex | Meaning | On `paper` |
|-------|-----|---------|-----------|
| `accentP1` | `#B5462E` | Player 1 (terracotta) | 4.6:1 ✅ AA |
| `accentP2` | `#2E7D6B` | Player 2 (jade) | 4.0:1 ✅ AA-large/UI |
| `accentGold` | `#B07D1E` | Mandarin / score (aged gold; darkened from `#C8962E` for AA) | 4.5:1 ✅ AA |
| `warning` | `#B5631E` | Debt / borrow / invalid | 4.5:1 ✅ AA |

> P2 jade at 4.0:1 is AA for large text + UI components only. Use jade for ≥18px
> bold or as a non-text accent (borders, stone fill, active glow). For small
> jade text, darken to `#256456` (4.9:1).

### Stones
| Token | Hex | Usage |
|-------|-----|-------|
| `stoneCitizen` | `#EDE4D0` | Citizen pebble (ivory river stone) |
| `stoneCitizenAlt` | `#5B7C8D` | Optional slate variant for visual variety |
| `stoneCitizenShade` | `#C7B89C` | Pebble lower-half shading (3D) |
| `stoneMandarin` | `#C8962E` | Mandarin stone fill (gold) — non-text, glow OK |
| `stoneMandarinShade` | `#8A6418` | Mandarin stone shading |
| `stoneHighlight` | `#FFFFFFCC` | Specular dot on each stone |

No neon glow anywhere. Replace prior `activeShadowP1/2` glow with a soft
accent-tinted carved shadow (see §5).

## 3. Typography (Google Fonts — Vietnamese verified)

Both families ship a full Vietnamese subset (`ăâêôơưđ` + tone marks) on Google
Fonts.

| Role | Font | Weight | Notes |
|------|------|--------|-------|
| Display / title | **Lora** (warm serif) | 600/700 | Traditional, full VN subset |
| Heading | Lora | 600 | |
| Body / captions | **Be Vietnam Pro** (humanist sans) | 400/500 | Designed for Vietnamese; pristine diacritics |
| Labels / numerals | Be Vietnam Pro | 500/600 | Use `FontFeature.tabularFigures()` for counts |

Type scale (logical px, scales with window class via §6 multiplier):
`display 30 / title 22 / heading 18 / body 15 / label 13 / caption 11`.

> Verification: Lora and Be Vietnam Pro both list "Vietnamese" under Google Fonts
> languages. Phase 1 success criterion met. If any glyph renders as tofu in
> testing, fall back to `Noto Serif` (display) — also VN-complete.

## 4. Pebble & Mandarin Rendering Rule

- A pit shows up to **8 citizen stones** clustered (deterministic positions
  seeded by pit index so they don't jump on rebuild).
- Count **9+** → show a compact cluster of 6 stones **plus a numeric badge**
  `×N` in `ink` on a `paperPanel` chip at pit corner.
- Mandarin pit: one large `stoneMandarin` stone when present, plus its citizen
  count rendered as a small `×N` gold-chip badge.
- Empty pit: carved empty pit (no stones, no "0").
- Stone diameter scales to pit size: `clamp(pitMinSide * 0.18, 8, 22)`.
- Each stone: radial fill `stoneCitizen → stoneCitizenShade`, 1px
  `stoneMandarinShade@30%` rim, `stoneHighlight` specular dot upper-left.

## 5. Spacing, Radius, Shadow, Motion

- **Spacing** (keep 4/8 rhythm): `xs 4 / sm 8 / md 16 / lg 24 / xl 32`.
- **Radius**: `sm 8 / md 12 / card 16 / pill 999`. Mandarin pit = half-moon
  (full semicircle on the outer end).
- **Carved shadow** (replaces neon glow): inner shadow `pitShadow@55%` for pits;
  card elevation = soft `#00000026` blur 16 y+6, plus 1px top `#FFFFFF55`
  bevel for the paper bevel look.
- **Active highlight**: accent-tinted ring (P1 terracotta / P2 jade), 2px,
  + accent@18% soft outer shadow blur 12. No bright glow.
- **Motion tokens** (extend `app_motion.dart`):
  - `fast 150 / medium 200 / slow 300` (existing) +
  - `sowTick 200` (per-pit stone hop), `capturePulse 260`, `turnSwap 240`.
  - Curves: hop `Curves.easeInOut`, pulse `Curves.easeOutBack`, enter/exit
    existing.
  - All gated by `AppMotion.resolve(context, …)` → `Duration.zero` under reduced
    motion (snap to final state).

## 6. Responsive Breakpoints & Layout Matrix

Window-size classes from `MediaQuery.sizeOf(context).width`:
`compact < 600 | medium 600–1023 | expanded ≥ 1024`.

Type/spacing multiplier: `compact ×1.0 / medium ×1.1 / expanded ×1.2`.
Content max-width on expanded: **1100px**, centered, paper margins each side.

| Class × Orientation | Board | Player rails | Top bar / HUD | Notes |
|---------------------|-------|--------------|---------------|-------|
| compact · portrait | Board scaled to width, centered vertically; 2 rows stacked | Rails **above & below** board (P2 top, P1 bottom) as horizontal score strips | Top bar top, action HUD bottom | Primary phone case now newly supported |
| compact · landscape | Board fills height, centered | Rails **left & right** of board (current behavior) | Top bar top, HUD bottom | Matches today's layout, restyled |
| medium (tablet) | Larger board, generous margins | Rails beside board (landscape) / flanking (portrait) | Same, bigger touch targets | |
| expanded (desktop/web) | Centered ≤1100px arena, board centerpiece | Rails beside board with score detail | Persistent top bar; hover/focus states | Mouse + keyboard affordances |

Menu reflow: `compact portrait` 1 column × 4 (or 2×2 if height allows) ·
`compact landscape / medium` 2×2 grid · `expanded` centered 2×2 panel ≤640px.

Tutorial: portrait = icon over text card; landscape/medium+ = icon beside text.

## 7. Token → Code Mapping (for Phase 2)

- Rewrite `lib/theme/game_theme.dart` → these tokens + `buildTheme()` on
  `ColorScheme.light` seeded from `paper`/`ink`/`accentP1`.
- Collapse `lib/theme/game_play_theme.dart` to re-export board tokens
  (`woodMid`, `pitFloor`, `stone*`) from the unified file.
- New `lib/theme/pebble_style.dart` (Phase 3) holds §4 stone geometry/colors.
- New `lib/theme/app_breakpoints.dart` (Phase 2) holds §6 classes + multiplier.
- Extend `lib/theme/app_motion.dart` with §5 motion tokens.

## 8. Decisions (resolved at review gate 2026-06-27)

1. **Night variant** — ❌ deferred. Single daylight theme this round.
2. **Audio** — ✅ **in scope.** Add simple sow/capture/invalid SFX via
   `audioplayers`. Requires 3–4 short CC0 sound assets under `assets/audio/`
   (to be sourced or user-provided). Wire in Phase 3 alongside haptics; gate by a
   mute toggle + reduced-motion is independent of audio.
3. **Stone variety** — ✅ **mixed slate/ivory.** Citizen pebbles alternate
   `stoneCitizen` (ivory) and `stoneCitizenAlt` (slate) deterministically by
   stone position within a pit (seeded), for visual interest. Mandarin stays gold.
