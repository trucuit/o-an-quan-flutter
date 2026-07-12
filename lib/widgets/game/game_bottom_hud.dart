import 'package:flutter/material.dart';
import '../../models/game_state.dart';
import '../../models/game_status.dart';
import '../../theme/game_icons.dart';
import '../../theme/game_play_theme.dart';
import '../../theme/game_theme.dart';
import 'game_layout.dart';
import '../icon_action_button.dart';
import '../status_chip_bar.dart';

class GameBottomHud extends StatelessWidget {
  final GameStatus? status;
  final bool canUndo;
  final bool isAnimating;
  final GameMode mode;
  final int activePlayer;
  final VoidCallback onUndo;
  final VoidCallback onRules;

  const GameBottomHud({
    super.key,
    required this.status,
    required this.canUndo,
    required this.isAnimating,
    required this.mode,
    required this.activePlayer,
    required this.onUndo,
    required this.onRules,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: GameLayout.bottomHudHeight,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: GamePlayTheme.hudBar,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: GameTheme.spaceSm,
            right: GameTheme.spaceMd,
          ),
          child: Row(
            children: [
              Expanded(
                child: StatusChipBar(
                  status: status,
                  isAnimating: isAnimating,
                  mode: mode,
                  activePlayer: activePlayer,
                ),
              ),
              SizedBox(
                width: GameTheme.minTouchTarget,
                height: GameTheme.minTouchTarget,
                child: IconActionButton(
                  icon: GameIcons.undo,
                  semanticsLabel: GameIcons.semanticsLabel(GameIcons.undo),
                  tooltip: 'Hoàn tác',
                  onPressed: canUndo ? onUndo : null,
                ),
              ),
              const SizedBox(width: GameTheme.spaceSm),
              SizedBox(
                width: GameTheme.minTouchTarget,
                height: GameTheme.minTouchTarget,
                child: IconActionButton(
                  icon: GameIcons.rules,
                  semanticsLabel: GameIcons.semanticsLabel(GameIcons.rules),
                  tooltip: 'Luật chơi',
                  onPressed: onRules,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}