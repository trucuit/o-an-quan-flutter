import 'package:flutter/material.dart';
import '../../models/game_state.dart';
import '../../theme/app_motion.dart';
import '../../theme/game_icons.dart';
import '../../theme/game_play_theme.dart';
import '../../theme/game_theme.dart';
import 'game_layout.dart';

/// Score strip — active turn shown via border; pool details in tooltip only.
class GamePlayerRail extends StatelessWidget {
  final int playerNumber;
  final bool isActive;
  final int score;
  final int citizenPool;
  final int mandarinPool;
  final int debt;
  final GameMode mode;
  final Axis axis;

  const GamePlayerRail({
    super.key,
    required this.playerNumber,
    required this.isActive,
    required this.score,
    required this.citizenPool,
    required this.mandarinPool,
    required this.debt,
    required this.mode,
    this.axis = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    final isP1 = playerNumber == 1;
    final color = isP1 ? GamePlayTheme.p1 : GamePlayTheme.p2;
    final icon = isP1 ? GameIcons.player1 : (mode == GameMode.localPvP ? GameIcons.player2 : GameIcons.ai);
    final horizontal = axis == Axis.horizontal;

    final semanticsValue = [
      'Điểm $score',
      'Dân $citizenPool',
      'Quan $mandarinPool',
      if (debt > 0) 'Nợ $debt',
      if (isActive) 'đang đi',
    ].join(', ');

    final tooltipLines = [
      if (isActive) 'Đang đi',
      'Điểm: $score',
      'Kho dân: $citizenPool',
      'Kho quan: $mandarinPool',
      if (debt > 0) 'Nợ: $debt',
    ].join('\n');

    return Semantics(
      label: isP1 ? 'Người chơi 1' : (mode == GameMode.localPvP ? 'Người chơi 2' : 'Máy'),
      value: semanticsValue,
      child: Tooltip(
        message: tooltipLines,
        child: IgnorePointer(
          child: AnimatedOpacity(
            opacity: isActive ? 1 : 0.82,
            duration: AppMotion.slow,
            child: Container(
              width: horizontal ? null : GameLayout.playerRailWidth,
              padding: EdgeInsets.symmetric(
                vertical: horizontal ? 6 : 8,
                horizontal: horizontal ? 12 : 6,
              ),
              decoration: BoxDecoration(
                // Opaque paper chip so the score stays legible on the wood board.
                color: GameTheme.paper.withValues(alpha: isActive ? 0.98 : 0.92),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: GameTheme.pitShadow.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border(
                  left: horizontal
                      ? BorderSide.none
                      : BorderSide(color: isActive ? color : color.withValues(alpha: 0.35), width: 3),
                  bottom: horizontal
                      ? BorderSide(color: isActive ? color : color.withValues(alpha: 0.35), width: 3)
                      : BorderSide.none,
                ),
              ),
              child: horizontal
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 16, color: color),
                        const SizedBox(width: 8),
                        Text('$score', style: _scoreStyle()),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, size: 16, color: color),
                        const SizedBox(height: 6),
                        Text('$score', style: _scoreStyle()),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _scoreStyle() => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: GameTheme.ink.withValues(alpha: isActive ? 1 : 0.85),
        fontFeatures: const [FontFeature.tabularFigures()],
        height: 1,
      );
}