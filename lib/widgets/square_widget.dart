import 'package:flutter/material.dart';
import '../models/board_square.dart';
import '../theme/app_motion.dart';
import '../theme/game_theme.dart';
import '../theme/game_play_theme.dart';
import '../utils/square_names.dart';
import 'board/pebble_cluster.dart';
import 'scale_pressable.dart';

/// A single carved pit on the wooden board, holding its pebble cluster.
class SquareWidget extends StatelessWidget {
  final BoardSquare square;
  final bool isSelectable;
  final bool isSelected;
  final VoidCallback onTap;

  const SquareWidget({
    super.key,
    required this.square,
    required this.isSelectable,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accent = GamePlayTheme.playerColorForSquare(square.index);
    final radius = _borderRadiusFor(square.index);

    final pitLabel = SquareNames.display(square.index);
    final stoneCount = square.citizenCount;
    final semanticsValue = square.isMandarin
        ? (stoneCount > 0 ? '$stoneCount quân' : (square.hasMandarin ? '1 quan' : 'trống'))
        : (stoneCount > 0 ? '$stoneCount quân' : 'trống');

    return Semantics(
      label: pitLabel,
      value: semanticsValue,
      button: isSelectable || isSelected,
      enabled: isSelectable || isSelected,
      child: ScalePressable(
        onTap: (isSelectable || isSelected) ? onTap : null,
        child: AnimatedContainer(
          duration: AppMotion.resolve(context, AppMotion.medium),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
          // Carved pit: lighter floor with an inner shadow.
          gradient: RadialGradient(
            center: const Alignment(0, -0.2),
            radius: 0.95,
            colors: [
              GameTheme.pitFloor,
              GameTheme.pitShadow.withValues(alpha: 0.92),
            ],
            stops: const [0.45, 1.0],
          ),
          borderRadius: radius,
          border: Border.all(
            color: isSelected
                ? accent
                : isSelectable
                    ? accent.withValues(alpha: 0.55)
                    : GameTheme.woodDeep.withValues(alpha: 0.6),
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: PebbleCluster(
              citizenCount: square.citizenCount,
              isMandarin: square.isMandarin,
              hasMandarin: square.hasMandarin,
              pitIndex: square.index,
            ),
          ),
        ),
      ),
    );
  }

  BorderRadius _borderRadiusFor(int index) {
    const r = Radius.circular(GameTheme.radiusMd);
    const cap = Radius.circular(80);
    return BorderRadius.only(
      topLeft: index == 11 ? cap : r,
      bottomLeft: index == 11 ? cap : r,
      topRight: index == 5 ? cap : r,
      bottomRight: index == 5 ? cap : r,
    );
  }
}
