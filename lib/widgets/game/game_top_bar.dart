import 'package:flutter/material.dart';
import '../../models/game_state.dart';
import '../../theme/game_icons.dart';
import '../../theme/game_play_theme.dart';
import '../../theme/game_theme.dart';
import 'game_layout.dart';
import '../icon_action_button.dart';

class GameTopBar extends StatelessWidget {
  final GameMode mode;
  final bool canNavigateBack;
  final VoidCallback onBack;
  final VoidCallback onRestart;

  const GameTopBar({
    super.key,
    required this.mode,
    required this.canNavigateBack,
    required this.onBack,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: GameLayout.topBarHeight,
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
              SizedBox(
                width: GameTheme.minTouchTarget,
                height: GameTheme.minTouchTarget,
                child: IconActionButton(
                  icon: GameIcons.back,
                  semanticsLabel: 'Về menu',
                  tooltip: 'Về menu',
                  onPressed: canNavigateBack ? onBack : null,
                ),
              ),
              Expanded(
                child: Center(
                  child: Tooltip(
                    message: _modeLabel(mode),
                    child: Semantics(
                      label: _modeLabel(mode),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            GameIcons.forMode(mode),
                            color: GameTheme.ink,
                            size: GameTheme.iconMd,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _modeLabel(mode),
                            style: GameTheme.labelStyle.copyWith(
                              fontSize: 13,
                              color: GameTheme.ink,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (_difficultyIcon(mode) != null) ...[
                            const SizedBox(width: 4),
                            Icon(
                              _difficultyIcon(mode),
                              color: GameTheme.inkMuted,
                              size: GameTheme.iconSm,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: GameTheme.minTouchTarget,
                height: GameTheme.minTouchTarget,
                child: IconActionButton(
                  icon: GameIcons.restart,
                  semanticsLabel: GameIcons.semanticsLabel(GameIcons.restart),
                  tooltip: 'Chơi lại',
                  onPressed: onRestart,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static IconData? _difficultyIcon(GameMode mode) {
    switch (mode) {
      case GameMode.localPvP:
        return null;
      case GameMode.vsEasyAI:
        return GameIcons.easyBadge;
      case GameMode.vsMediumAI:
        return GameIcons.mediumBadge;
      case GameMode.vsHardAI:
        return GameIcons.hardBadge;
    }
  }

  static String _modeLabel(GameMode mode) {
    switch (mode) {
      case GameMode.localPvP:
        return 'Hai người';
      case GameMode.vsHardAI:
        return 'Máy khó';
      case GameMode.vsMediumAI:
        return 'Máy TB';
      case GameMode.vsEasyAI:
        return 'Máy dễ';
    }
  }
}