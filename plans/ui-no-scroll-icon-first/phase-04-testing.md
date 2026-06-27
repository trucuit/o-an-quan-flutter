---
phase: 4
title: Testing & QA
status: completed
priority: P2
dependencies:
  - 3
---

# Phase 4: Testing & QA

## Overview

Verify no-scroll constraint trên nhiều viewport, accessibility labels, và game logic không regress sau status refactor.

## Requirements

- Functional: Widget tests assert no `Scrollable` trên main screens; overflow tests pass.
- Non-functional: Semantics tree có labels cho mọi icon action.

## Architecture

```
test/
├── game_logic_test.dart          # existing — update if status API changes
├── widget_test.dart              # existing — update smoke test
├── no_scroll_layout_test.dart    # NEW — viewport overflow tests
└── status_chip_test.dart         # NEW — GameStatus rendering
```

## Related Code Files

- Create: `test/no_scroll_layout_test.dart`
- Create: `test/status_chip_test.dart`
- Modify: `test/game_logic_test.dart` (if `GameState` fields added)
- Modify: `test/widget_test.dart`

## Implementation Steps

### 1. No-Scroll Layout Tests

```dart
// test/no_scroll_layout_test.dart
void main() {
  final viewports = [
    Size(640, 360),  // phone small landscape
    Size(844, 390),  // phone standard
    Size(1024, 768), // tablet
  ];

  for (final size in viewports) {
    testWidgets('MenuScreen no overflow at $size', (tester) async {
      tester.view.physicalSize = size * 3; // 3x density
      tester.view.devicePixelRatio = 3;
      await tester.pumpWidget(const MaterialApp(home: MenuScreen()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      // Assert no Scrollable in tree
      expect(find.byType(Scrollable), findsNothing);
    });
  }
  // Repeat for GameScreen(mode: localPvP), TutorialScreen
}
```

### 2. Status Chip Tests

```dart
testWidgets('StatusChipBar renders capture chips', (tester) async {
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: StatusChipBar(
        status: GameStatus.capture(squareIndex: 7, citizens: 3, mandarin: true),
      ),
    ),
  ));
  expect(find.byIcon(Icons.celebration), findsOneWidget);
  expect(find.text('3'), findsOneWidget);
});
```

### 3. Accessibility Audit

Manual + automated checklist:

```dart
testWidgets('Menu icon tiles have semantics', (tester) async {
  await tester.pumpWidget(...);
  final SemanticsNode first = tester.getSemantics(find.byType(IconMenuTile).first);
  expect(first.label, isNotEmpty);
});
```

Verify:
- [ ] Mọi `IconActionButton` có `Semantics(label: ...)`
- [ ] `Tooltip` message khớp semantics label
- [ ] Active player pulse không block touch targets

### 4. Game Logic Regression

Run existing tests:
```bash
flutter test test/game_logic_test.dart
```

If `GameState.initial()` adds `currentStatus: null`, existing tests should pass unchanged.

### 5. Visual QA (Manual)

Screenshot comparison trên emulator:

| Screen | Check |
|--------|-------|
| Menu | 4 tiles visible, no scroll indicator |
| Game | Board + panels + status + controls fit |
| Tutorial | Step icon + 2-line caption visible |
| Game Over | Icon buttons tappable |
| Direction overlay | CW/CCW icons centered |

Compare với `screenshot.png`–`screenshot4.png` baseline — board proportions maintained.

### 6. Device Matrix

| Platform | Min version | Notes |
|----------|-------------|-------|
| Android | API 21+ | Test on Pixel 4a emulator landscape |
| iOS | 12+ | iPhone SE landscape if available |
| Web | — | Optional; landscape lock may differ |

## Success Criteria

- [ ] `flutter test` — all pass
- [ ] `no_scroll_layout_test.dart` — 3 viewports × 3 screens = 9 tests green
- [ ] No `Scrollable` widget in Menu/Game/Tutorial main widget trees
- [ ] `status_chip_test.dart` covers pick/sow/capture/stop/refill/borrow
- [ ] Manual QA checklist signed off (screenshots updated)

## Risk Assessment

| Risk | Mitigation |
|------|------------|
| `flutter` not in CI PATH | Document `flutter test` command in README |
| Viewport test flaky on web | Skip web in automated tests; manual only |
| Golden test drift | Optional — skip golden, use exception-null assert only |
