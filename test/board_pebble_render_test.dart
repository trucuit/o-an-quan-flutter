import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:o_an_quan/theme/pebble_style.dart';
import 'package:o_an_quan/widgets/board/pebble_cluster.dart';

/// Covers the design-spec §4 pebble rule: stones up to the cap, then a numeric
/// badge; mandarin variant renders.
void main() {
  Widget host(Widget child) => MaterialApp(
        home: Scaffold(
          body: Center(child: SizedBox(width: 80, height: 80, child: child)),
        ),
      );

  testWidgets('no badge at or below the cap — stones convey the count', (tester) async {
    await tester.pumpWidget(host(const PebbleCluster(
      citizenCount: PebbleStyle.maxStonesShown,
      isMandarin: false,
      hasMandarin: false,
      pitIndex: 2,
    )));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.textContaining('×'), findsNothing);
  });

  testWidgets('hides badge when citizen count is zero', (tester) async {
    await tester.pumpWidget(host(const PebbleCluster(
      citizenCount: 0,
      isMandarin: false,
      hasMandarin: false,
      pitIndex: 2,
    )));
    await tester.pumpAndSettle();
    expect(find.textContaining('×'), findsNothing);
  });

  testWidgets('shows numeric badge when count exceeds the cap', (tester) async {
    await tester.pumpWidget(host(const PebbleCluster(
      citizenCount: 12,
      isMandarin: false,
      hasMandarin: false,
      pitIndex: 3,
    )));
    await tester.pumpAndSettle();
    expect(find.text('×12'), findsOneWidget);
  });

  testWidgets('mandarin pit renders without error', (tester) async {
    await tester.pumpWidget(host(const PebbleCluster(
      citizenCount: 0,
      isMandarin: true,
      hasMandarin: true,
      pitIndex: 5,
    )));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  test('layout is deterministic for a given pit and count', () {
    final a = PebbleStyle.layout(6, 4);
    final b = PebbleStyle.layout(6, 4);
    expect(a, equals(b));
    expect(a.length, 6);
  });
}
