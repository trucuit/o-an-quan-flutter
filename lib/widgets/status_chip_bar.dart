import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/game_status.dart';
import '../theme/app_motion.dart';
import '../theme/game_icons.dart';
import '../theme/game_play_theme.dart';
import '../theme/game_theme.dart';
import '../utils/square_names.dart';

class StatusChipBar extends StatelessWidget {
  final GameStatus? status;
  final bool isAnimating;
  final GameMode? mode;
  final int? activePlayer;

  const StatusChipBar({
    super.key,
    required this.status,
    this.isAnimating = false,
    this.mode,
    this.activePlayer,
  });

  @override
  Widget build(BuildContext context) {
    final message = _messageFor(status, isAnimating, mode, activePlayer);
    if (message == null || message.isEmpty) {
      return const SizedBox(height: 32);
    }

    final color = _colorFor(status, activePlayer);
    final icon = _iconFor(status, isAnimating, mode, activePlayer);

    return Semantics(
      liveRegion: true,
      label: message,
      child: AnimatedSwitcher(
        duration: AppMotion.resolve(context, AppMotion.medium),
        child: Row(
          key: ValueKey(message),
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: color),
              const SizedBox(width: GameTheme.spaceXs),
            ],
            Flexible(
              child: Text(
                message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _messageFor(
    GameStatus? s,
    bool animating,
    GameMode? mode,
    int? player,
  ) {
    if (animating &&
        mode != null &&
        mode != GameMode.localPvP &&
        player == 2) {
      return 'Máy đang đi…';
    }

    if (s == null || s.kind == StatusKind.idle || s.kind == StatusKind.turn) {
      return null;
    }

    switch (s.kind) {
      case StatusKind.pick:
        return 'Chọn ${SquareNames.display(s.squareIndex!)} · ${s.count} quân';
      case StatusKind.sow:
        return 'Rải từ ${SquareNames.display(s.squareIndex!)}';
      case StatusKind.capture:
        final quan = s.hasMandarin ? ' + quan' : '';
        return 'Ăn ${s.count} quân$quan · ${SquareNames.display(s.squareIndex!)}';
      case StatusKind.refill:
        return 'Bổ ${s.count} quân';
      case StatusKind.borrow:
        return 'Vay ${s.count} quân';
      case StatusKind.stop:
        return s.winnerLabel ?? 'Dừng lượt';
      case StatusKind.gameOver:
        return s.winnerLabel ?? 'Kết thúc';
      case StatusKind.turn:
      case StatusKind.idle:
        return null;
    }
  }

  IconData? _iconFor(
    GameStatus? s,
    bool animating,
    GameMode? mode,
    int? player,
  ) {
    if (animating &&
        mode != null &&
        mode != GameMode.localPvP &&
        player == 2) {
      return GameIcons.ai;
    }
    if (s == null) return null;
    return GameIcons.forStatus(s.kind);
  }

  Color _colorFor(GameStatus? s, int? player) {
    if (s?.kind == StatusKind.gameOver) return GameTheme.accentMuted;
    if (player == 1) return GamePlayTheme.p1;
    if (player == 2) return GamePlayTheme.p2;
    return GameTheme.textSecondary;
  }
}