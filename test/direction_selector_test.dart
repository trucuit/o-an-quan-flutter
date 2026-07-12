import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:o_an_quan/widgets/direction_selector.dart';

void main() {
  testWidgets('DirectionSelector fits a narrow pit without overflow', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 110,
              child: DirectionSelector(
                squareIndex: 0,
                onDirectionSelect: (_) {},
                onCancel: () {},
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    await tester.tapAt(const Offset(20, 20));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}