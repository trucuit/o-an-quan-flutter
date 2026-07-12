import 'package:flutter/material.dart';
import '../../theme/game_theme.dart';

/// Shared wood/paper shell for in-game modals.
class GameDialogShell extends StatelessWidget {
  final Widget child;
  final Color? accentColor;

  const GameDialogShell({
    super.key,
    required this.child,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final accent = accentColor ?? GameTheme.accentGold;
    return Container(
      constraints: const BoxConstraints(maxWidth: 360),
      decoration: BoxDecoration(
        color: GameTheme.paperPanel,
        borderRadius: BorderRadius.circular(GameTheme.radiusCard),
        border: Border.all(color: GameTheme.woodDeep.withValues(alpha: 0.25)),
        boxShadow: GameTheme.glassShadows,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 4,
            width: double.infinity,
            color: accent,
          ),
          Padding(
            padding: const EdgeInsets.all(GameTheme.spaceMd),
            child: child,
          ),
        ],
      ),
    );
  }
}

Color gameDialogBarrier = Colors.black.withValues(alpha: GameTheme.scrimLight);