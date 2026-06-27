import 'package:flutter/material.dart';
import '../models/game_status.dart';
import '../theme/game_icons.dart';
import '../theme/game_theme.dart';
import '../theme/app_motion.dart';

class StatusChipBar extends StatelessWidget {
  final GameStatus? status;

  const StatusChipBar({super.key, this.status});

  @override
  Widget build(BuildContext context) {
    if (status == null || status!.kind == StatusKind.idle) {
      return const SizedBox(height: 36);
    }

    return AnimatedSwitcher(
      duration: AppMotion.medium,
      child: Container(
        key: ValueKey(status),
        height: 36,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.04)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildChips(status!),
        ),
      ),
    );
  }

  List<Widget> _buildChips(GameStatus s) {
    final chips = <Widget>[
      _chip(icon: GameIcons.forStatus(s.kind), color: GameTheme.primaryP2),
    ];

    if (s.squareIndex != null) {
      chips.add(_divider());
      chips.add(_chip(icon: GameIcons.square, label: '${s.squareIndex}'));
    }

    if (s.count != null) {
      chips.add(_divider());
      chips.add(_chip(icon: GameIcons.citizen, label: '${s.count}'));
    }

    if (s.hasMandarin) {
      chips.add(_divider());
      chips.add(_chip(icon: GameIcons.mandarin, label: '1', color: GameTheme.mandarinColor));
    }

    if (s.player != null) {
      chips.add(_divider());
      chips.add(_chip(
        icon: s.player == 1 ? GameIcons.player1 : GameIcons.player2,
        label: 'P${s.player}',
      ));
    }

    if (s.winnerLabel != null && s.kind == StatusKind.gameOver) {
      chips.add(_divider());
      chips.add(_chip(icon: GameIcons.win, label: s.winnerLabel!));
    }

    return chips;
  }

  Widget _divider() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Icon(Icons.chevron_right, size: 14, color: Colors.white.withOpacity(0.3)),
      );

  Widget _chip({required IconData icon, String? label, Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color ?? Colors.white.withOpacity(0.9)),
        if (label != null) ...[
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color ?? Colors.white.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}