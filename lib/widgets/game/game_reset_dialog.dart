import 'package:flutter/material.dart';
import '../../theme/game_icons.dart';
import '../../theme/game_theme.dart';
import '../icon_action_button.dart';
import 'game_dialog_shell.dart';

Future<bool?> showGameResetDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierColor: gameDialogBarrier,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: GameDialogShell(
        accentColor: GameTheme.warningColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(GameIcons.warning, color: GameTheme.warningColor, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Chơi lại?',
                  style: GameTheme.headingStyle.copyWith(
                    fontSize: 18,
                    color: GameTheme.ink,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Hủy ván hiện tại và bắt đầu lại từ đầu.',
              textAlign: TextAlign.center,
              style: GameTheme.bodyStyle.copyWith(fontSize: 13, color: GameTheme.inkMuted),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconActionButton(
                  icon: GameIcons.cancel,
                  semanticsLabel: GameIcons.semanticsLabel(GameIcons.cancel),
                  tooltip: 'Hủy',
                  onPressed: () => Navigator.pop(context, false),
                ),
                IconActionButton(
                  icon: GameIcons.confirm,
                  semanticsLabel: 'Đồng ý chơi lại',
                  tooltip: 'Đồng ý',
                  color: GameTheme.accentGold,
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}