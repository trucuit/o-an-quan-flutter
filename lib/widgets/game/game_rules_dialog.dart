import 'package:flutter/material.dart';
import '../../theme/game_icons.dart';
import '../../theme/game_theme.dart';
import '../icon_action_button.dart';
import 'game_dialog_shell.dart';

void showGameRulesDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: gameDialogBarrier,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: GameDialogShell(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(GameIcons.rules, color: GameTheme.accentGold, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Luật chơi',
                  style: GameTheme.headingStyle.copyWith(
                    fontSize: 18,
                    color: GameTheme.ink,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _ruleRow(GameIcons.sow, 'Rải từng viên theo chiều chọn'),
            _ruleRow(GameIcons.pick, 'Nhặt tiếp nếu ô sau có quân'),
            _ruleRow(GameIcons.capture, 'Ăn khi ô sau trống, ô kế có quân'),
            _ruleRow(GameIcons.stop, 'Dừng khi chạm Ô Quan'),
            _ruleRow(GameIcons.refill, 'Hết quân → rải 5 từ kho'),
            const SizedBox(height: 12),
            IconActionButton(
              icon: GameIcons.cancel,
              semanticsLabel: 'Đóng',
              tooltip: 'Đóng',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _ruleRow(IconData icon, String hint) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        Icon(icon, size: 16, color: GameTheme.accentP2Text),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            hint,
            style: GameTheme.bodyStyle.copyWith(fontSize: 13, color: GameTheme.inkMuted),
          ),
        ),
      ],
    ),
  );
}