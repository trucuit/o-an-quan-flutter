import 'package:flutter/material.dart';
import '../theme/game_theme.dart';
import 'board/board_painter.dart';
import 'board/pebble_cluster.dart';

/// 12-pit board schematic for tutorial step 1 — uses the same wood surface and
/// real pebbles as the game so the diagram matches what the player will see.
class TutorialBoardDiagram extends StatelessWidget {
  const TutorialBoardDiagram({super.key});

  // P1 (bottom) terracotta, P2 (top) jade — matches the in-game player accents.
  static const _p2Color = GameTheme.accentP2;
  static const _p1Color = GameTheme.accentP1;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.isFinite ? constraints.maxWidth : 320.0;
        final maxHeight = constraints.maxHeight.isFinite ? constraints.maxHeight : 200.0;
        // Fit the largest board at a fixed 2.4:1 aspect ratio that respects
        // both available dimensions, so the diagram fills the card's height
        // (not just its width) when the card gives it generous vertical room.
        final height = (maxWidth / 2.4).clamp(0.0, maxHeight);
        final width = height * 2.4;

        return SizedBox(
          width: width,
          height: height,
          child: CustomPaint(
            painter: const BoardPainter(),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  _quanPit(),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(child: _citizenRow([10, 9, 8, 7, 6], _p2Color)),
                        const SizedBox(height: 4),
                        Expanded(child: _citizenRow([0, 1, 2, 3, 4], _p1Color)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  _quanPit(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _quanPit() {
    return AspectRatio(
      aspectRatio: 0.5,
      child: _pitFrame(
        borderColor: GameTheme.accentGold,
        radius: 40,
        child: const PebbleCluster(
          citizenCount: 0,
          isMandarin: true,
          hasMandarin: true,
          pitIndex: 99,
        ),
      ),
    );
  }

  Widget _citizenRow(List<int> indices, Color border) {
    return Row(
      children: indices.map((i) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: _pitFrame(
              borderColor: border,
              radius: GameTheme.radiusSm,
              child: PebbleCluster(
                citizenCount: 5,
                isMandarin: false,
                hasMandarin: false,
                pitIndex: i,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _pitFrame({
    required Color borderColor,
    required double radius,
    required Widget child,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -0.2),
          radius: 0.95,
          colors: [
            GameTheme.pitFloor,
            GameTheme.pitShadow.withValues(alpha: 0.92),
          ],
          stops: const [0.45, 1.0],
        ),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor.withValues(alpha: 0.6)),
      ),
      child: Padding(padding: const EdgeInsets.all(2), child: child),
    );
  }
}
