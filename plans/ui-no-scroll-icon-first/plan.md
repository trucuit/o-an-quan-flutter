---
title: UI No-Scroll Icon-First Refactor
description: >-
  Refactor toàn bộ UI Ô Ăn Quan Flutter: mọi màn hình hiển thị trọn trong
  viewport landscape, loại bỏ scroll, ưu tiên icon thay text. Xây dựng trên plan
  ui-refactor-landscape đã hoàn thành.
status: completed
priority: P1
branch: feature/ui-no-scroll-icon-first
tags:
  - ui
  - ux
  - flutter
  - landscape
  - icons
  - no-scroll
blockedBy: []
blocks: []
created: '2026-06-27T14:50:32.434Z'
createdBy: 'ck:plan'
source: skill
---

# UI No-Scroll Icon-First Refactor

## Overview

Plan này tinh chỉnh UI sau `plans/ui-refactor-landscape/` (đã completed). Mục tiêu:

1. **Không scroll** — mọi màn hình chính (Menu, Game, Tutorial) fit trọn trong viewport landscape, kể cả phone nhỏ (≥360×640 logical px landscape).
2. **Icon-first** — giảm text hiển thị; dùng `IconData` + `Tooltip` + `Semantics` cho actions, stats, status, navigation.
3. **Giữ accessibility** — icon-only không được mất ngữ cảnh cho screen reader.

### Vấn đề hiện tại (audit nhanh)

| Màn hình | Scroll / overflow | Text-heavy |
|----------|-------------------|------------|
| `menu_screen.dart` | `SingleChildScrollView` bọc 4 card lớn + footer | title/subtitle mỗi card, footer text |
| `game_screen.dart` | Column center có thể overflow khi panel cao | mode title, status banner text, game-over buttons text |
| `tutorial_screen.dart` | `SingleChildScrollView` trong description | 6 bước text dài, nav buttons text |
| `score_board.dart` | — | tên player, AI difficulty tag |
| `direction_selector.dart` | — | "Ô N", "HỦY" |
| `game_controller.dart` | — | status messages dùng emoji + text dài |

### Nguyên tắc thiết kế

- **Layout**: `LayoutBuilder` + `FittedBox` / scale factor từ `min(width, height)` — không dùng `SingleChildScrollView` trên flow chính.
- **Icon vocabulary**: Material Icons thống nhất (đã dùng trong project); tạo `GameIcons` map tập trung.
- **Text chỉ giữ**: số điểm, số quân (data), title app một dòng ngắn.
- **Spacing**: 4/8dp rhythm; touch target ≥44pt.

## Phases

| Phase | Name | Status | Deliverable |
|-------|------|--------|-------------|
| 1 | [Research & Audit](./phase-01-research.md) | Pending | Completed |
| 2 | [Architecture](./phase-02-architecture.md) | Pending | Completed |
| 3 | [Implementation](./phase-03-implementation.md) | Pending | Completed |
| 4 | [Testing & QA](./phase-04-testing.md) | Pending | Completed |

## Target Layout (Landscape)

```
┌─────────────────────────────────────────────────────────────┐
│ [←]  [mode icon]                              [↻] [ℹ]      │  ← icon toolbar, no text title
├──────────┬────────────────────────────────────┬─────────────┤
│ P2 panel │         BOARD (scaled fit)         │  P1 panel   │
│ icon+num │                                    │  icon+num   │
├──────────┴────────────────────────────────────┴─────────────┤
│ [status chips: pick/sow/capture icons]     [↩ undo]        │
└─────────────────────────────────────────────────────────────┘
```

Menu (2×2 grid, no scroll):

```
┌─────────────────────────────────────────────────────────────┐
│                    Ô ĂN QUAN  [board icon]                  │
├──────────────────────┬──────────────────────────────────────┤
│ [👥] PvP             │ [🤖+] AI Hard                       │
├──────────────────────┼──────────────────────────────────────┤
│ [🤖] AI Medium       │ [?] Tutorial                        │
└──────────────────────┴──────────────────────────────────────┘
```

## Dependencies

- **Prior work**: `plans/ui-refactor-landscape/` (completed) — landscape lock, immersive mode, basic icon buttons đã có.
- **Không block** plan khác; không thay đổi game engine / AI logic.

## Open Questions

1. **Tutorial**: Giữ 6 bước text dài trong card, hay chuyển sang icon diagram + 1 dòng caption? → **Đề xuất**: icon diagram per step, caption ≤40 ký tự, `FittedBox` scale text.
2. **Rules overlay**: Dialog scroll hiện tại — chuyển sang bottom sheet icon-grid hay giữ scroll trong overlay phụ? → **Đề xuất**: overlay phụ được scroll (không phải flow chính); main game screen vẫn no-scroll.

## Acceptance Criteria (toàn plan)

- [ ] Menu, Game, Tutorial không có `ScrollView`/`SingleChildScrollView` trên layout chính
- [ ] Không overflow trên 360×640 landscape (iPhone SE class)
- [ ] ≥80% interactive elements là icon-only (có Tooltip + Semantics)
- [ ] Status bar game dùng icon chips thay chuỗi text emoji
- [ ] `flutter test` pass; widget test mới cho no-overflow
