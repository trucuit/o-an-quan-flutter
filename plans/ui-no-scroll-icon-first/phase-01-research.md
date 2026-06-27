---
phase: 1
title: Research & Audit
status: completed
priority: P1
dependencies: []
---

# Phase 1: Research & Audit

## Overview

Audit toàn bộ UI hiện tại để xác định điểm scroll/overflow và inventory text cần thay bằng icon. Đo viewport landscape tối thiểu và lập bảng ánh xạ icon.

## Requirements

- Functional: Danh sách đầy đủ widget dùng `ScrollView`; bảng text → icon cho mọi màn hình.
- Non-functional: Tuân `ui-ux-pro-max` — touch ≥44pt, contrast ≥4.5:1, không emoji làm icon UI.

## Architecture

Không thay đổi code engine. Output là spec document trong phase này, feed vào Phase 2.

## Related Code Files

- Review: `lib/screens/menu_screen.dart`, `game_screen.dart`, `tutorial_screen.dart`
- Review: `lib/widgets/score_board.dart`, `direction_selector.dart`, `board_widget.dart`
- Review: `lib/controllers/game_controller.dart` (status messages)
- Review: `lib/main.dart` (orientation lock — đã có)

## Implementation Steps

### 1. Scroll & Overflow Inventory

Grep và ghi nhận mọi `ScrollView`, `SingleChildScrollView`, `ListView`:

| File | Widget | Loại | Hành động đề xuất |
|------|--------|------|-------------------|
| `menu_screen.dart:57` | `SingleChildScrollView` | Main flow | **Remove** → 2×2 `GridView` fixed |
| `tutorial_screen.dart:123` | `SingleChildScrollView` | Step body | **Remove** → `FittedBox` + icon diagram |
| `game_screen.dart:426` | `SingleChildScrollView` | Rules dialog | **Keep** (secondary overlay) |
| `game_screen.dart` Column center | implicit overflow risk | Main flow | Add `Flexible` + scale |

### 2. Viewport Matrix

Test targets (logical px, landscape):

| Device class | Size (W×H) | Min height budget |
|--------------|------------|-------------------|
| Phone small | 640×360 | Board ~180px, panels ~120px |
| Phone standard | 844×390 | Comfortable |
| Tablet | 1024×768 | Scale up, không scroll |

Công thức scale:

```dart
double scale = min(
  constraints.maxWidth / designWidth,  // 640
  constraints.maxHeight / designHeight, // 360
).clamp(0.75, 1.0);
```

### 3. Icon Vocabulary Map

Tạo draft `GameIcons` (Phase 2 implement):

| Ngữ cảnh | Text hiện tại | Icon | Semantics label |
|----------|---------------|------|-----------------|
| PvP mode | "Chơi Hai Người" | `Icons.people` | Chơi hai người |
| AI Hard | "Đấu Với Máy (Khó)" | `Icons.smart_toy` + `Icons.bolt` badge | Đấu máy khó |
| AI Medium | "Đấu Với Máy (Thường)" | `Icons.smart_toy` | Đấu máy thường |
| Tutorial | "Hướng Dẫn Luật Chơi" | `Icons.school_outlined` | Hướng dẫn |
| Back | "Về Menu" | `Icons.home_outlined` | Về menu |
| Restart | "Chơi lại" | `Icons.refresh` | Chơi lại |
| Undo | "Hoàn tác" | `Icons.undo` | Hoàn tác |
| Rules | "Luật chơi" | `Icons.menu_book_outlined` | Luật chơi |
| P1 | "Người chơi 1 (Bạn)" | `Icons.person` | Người chơi 1 |
| P2 local | "Người chơi 2" | `Icons.person_outline` | Người chơi 2 |
| AI opponent | "Máy Đối Thủ" | `Icons.smart_toy_outlined` | Máy đối thủ |
| Citizen pool | "dân" count | `Icons.circle` | Kho dân |
| Mandarin pool | "quan" count | `Icons.diamond` | Kho quan |
| Debt | "nợ" | `Icons.account_balance_wallet` | Nợ điểm |
| Score | điểm | `Icons.emoji_events` | Điểm |
| CW direction | thuận | `Icons.rotate_right` | Chiều thuận |
| CCW direction | ngược | `Icons.rotate_left` | Chiều ngược |
| Cancel | "HỦY" | `Icons.close` | Hủy chọn |
| Win | "BẠN THẮNG" | `Icons.emoji_events` + color | Chiến thắng |
| Tie | "HÒA" | `Icons.handshake_outlined` | Hòa |
| Status: pick | "Nhặt" | `Icons.back_hand` | Nhặt quân |
| Status: sow | "Rải" | `Icons.scatter_plot` | Rải quân |
| Status: capture | "Ăn" | `Icons.celebration` | Ăn quân |
| Status: stop | "Dừng" | `Icons.stop_circle_outlined` | Dừng lượt |
| Status: refill | "Rải sân" | `Icons.grid_on` | Rải sân |
| Status: borrow | "Mượn" | `Icons.credit_card_off` | Mượn điểm |

### 4. Status Message Refactor Spec

`GameController` hiện emit string emoji. Phase 3 sẽ thêm:

```dart
enum StatusKind { pick, sow, capture, stop, refill, borrow, turn, gameOver }

class GameStatus {
  final StatusKind kind;
  final int? squareIndex;
  final int? count;
  final bool? hasMandarin;
  final int? activePlayer;
}
```

UI render icon chips từ `GameStatus`, không parse string.

### 5. Menu Density Analysis

Hiện tại 4 card × (~86px height + 16 gap) + title (~120px) + footer (~40px) ≈ **520px** > 360px landscape → **cần scroll**.

Fix: 2×2 grid, mỗi cell ~150×120px, icon 48px center, label 1 dòng `FittedBox`, bỏ subtitle.

## Success Criteria

- [ ] Bảng scroll inventory hoàn chỉnh với hành động remove/keep cho từng instance
- [ ] Icon map ≥25 entries với semantics labels
- [ ] Viewport matrix xác định `designWidth=640`, `designHeight=360`
- [ ] Spec `GameStatus` model được approve trong phase doc

## Risk Assessment

| Risk | Mitigation |
|------|------------|
| Icon không đủ rõ cho user mới | Tooltip on long-press; tutorial screen vẫn có (icon+short text) |
| Menu 2×2 chật trên phone nhỏ | `FittedBox` scale toàn grid; min font 10px |
| Refactor status messages breaking tests | Phase 4 update `game_logic_test.dart` nếu cần |
