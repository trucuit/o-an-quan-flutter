import 'package:flutter/material.dart';
import '../../models/game_state.dart';
import '../../theme/app_motion.dart';
import '../../theme/game_icons.dart';
import '../../theme/game_play_theme.dart';
import '../../theme/game_theme.dart';
import 'game_layout.dart';

/// Score strip — active turn shown via a full accent ring, brighter paper,
/// and a soft accent shadow; pool details in tooltip only.
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

  /// Active-state ring width — thicker than the inactive hairline so the
  /// current turn reads at a glance without axis-specific tuning.
  static const double _activeBorderWidth = 2.5;
  static const double _inactiveBorderWidth = 1.5;

  @override
  Widget build(BuildContext context) {
    final isP1 = playerNumber == 1;
    final color = isP1 ? GamePlayTheme.p1 : GamePlayTheme.p2;
    final activeShadow = isP1 ? GameTheme.activeShadowP1 : GameTheme.activeShadowP2;
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
                // Opaque paper chip so the score stays legible on the wood board;
                // active turn gets a brighter chip plus a full accent ring so it
                // reads at a glance, not just a stronger edge on one side.
                color: isActive ? GameTheme.paper : GameTheme.paper.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: GameTheme.pitShadow.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                  if (isActive) ...activeShadow,
                ],
                border: Border.all(
                  color: isActive ? color : color.withValues(alpha: 0.35),
                  width: isActive ? _activeBorderWidth : _inactiveBorderWidth,
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