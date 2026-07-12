import 'package:flutter/material.dart';
import '../../models/game_state.dart';
import '../../theme/game_icons.dart';
import '../../theme/game_play_theme.dart';
import '../../theme/game_theme.dart';
import '../icon_action_button.dart';
import 'game_dialog_shell.dart';

class GameOverOverlay extends StatelessWidget {
  final GameState state;
  final VoidCallback onHome;
  final VoidCallback onRestart;

  const GameOverOverlay({
    super.key,
    required this.state,
    required this.onHome,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    final isP1Winner = state.player1Score > state.player2Score;
    final isTie = state.player1Score == state.player2Score;
    final resultIcon = isTie
        ? GameIcons.tie
        : (isP1Winner ? GameIcons.win : GameIcons.ai);
    final accent = isTie
        ? GameTheme.accentGold
        : (isP1Winner ? GamePlayTheme.p1 : GamePlayTheme.p2);
    final headline = isTie
        ? 'Hòa!'
        : (isP1Winner
            ? 'Người chơi 1 thắng'
            : (state.mode == GameMode.localPvP ? 'Người chơi 2 thắng' : 'Máy thắng'));

    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      label: 'Kết thúc ván — $headline',
      child: ColoredBox(
        color: Colors.black.withValues(alpha: GameTheme.scrimHeavy),
        child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: GameTheme.spaceLg),
          child: GameDialogShell(
            accentColor: accent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(resultIcon, size: 40, color: accent),
                const SizedBox(height: GameTheme.spaceSm),
                Text(
                  headline,
                  style: GameTheme.headingStyle.copyWith(fontSize: 18, color: GameTheme.ink),
                ),
                const SizedBox(height: GameTheme.spaceMd),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _scoreColumn(GameIcons.player1, state.player1Score, GamePlayTheme.p1),
                    Container(
                      width: 1,
                      height: 36,
                      margin: const EdgeInsets.symmetric(horizontal: GameTheme.spaceMd),
                      color: GameTheme.woodDeep.withValues(alpha: 0.25),
                    ),
                    _scoreColumn(
                      state.mode == GameMode.localPvP ? GameIcons.player2 : GameIcons.ai,
                      state.player2Score,
                      GamePlayTheme.p2,
                    ),
                  ],
                ),
                const SizedBox(height: GameTheme.spaceMd),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconActionButton(
                      icon: GameIcons.home,
                      semanticsLabel: GameIcons.semanticsLabel(GameIcons.home),
                      tooltip: 'Về menu',
                      onPressed: onHome,
                    ),
                    const SizedBox(width: GameTheme.spaceMd),
                    IconActionButton(
                      icon: GameIcons.restart,
                      semanticsLabel: GameIcons.semanticsLabel(GameIcons.restart),
                      tooltip: 'Chơi lại',
                      color: accent,
                      backgroundColor: accent.withValues(alpha: 0.15),
                      onPressed: onRestart,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }

  Widget _scoreColumn(IconData icon, int score, Color color) {
    return Column(
      children: [
        Icon(icon, color: GameTheme.inkMuted, size: 18),
        const SizedBox(height: 4),
        Text(
          '$score',
          style: TextStyle(color: color, fontSize: 26, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}