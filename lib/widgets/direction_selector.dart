import 'package:flutter/material.dart';
import '../theme/game_play_theme.dart';
import '../theme/game_theme.dart';
import '../theme/game_icons.dart';
import '../utils/square_names.dart';
import 'haptics.dart';

/// Compact direction bar — fits inside the pit width, no overflow.
class DirectionSelector extends StatelessWidget {
  final int squareIndex;
  final Function(bool) onDirectionSelect;
  final VoidCallback onCancel;

  const DirectionSelector({
    super.key,
    required this.squareIndex,
    required this.onDirectionSelect,
    required this.onCancel,
  });

  static const double barHeight = 34;

  @override
  Widget build(BuildContext context) {
    final isP1 = squareIndex < 5;
    final accent = isP1 ? GamePlayTheme.p1 : GamePlayTheme.p2;

    return Semantics(
      label: 'Chọn chiều rải từ ${SquareNames.display(squareIndex)}',
      child: Material(
        color: GameTheme.paperPanel.withValues(alpha: 0.96),
        elevation: 3,
        shadowColor: GameTheme.pitShadow.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(barHeight / 2),
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: double.infinity,
          height: barHeight,
          decoration: BoxDecoration(
            border: Border.all(color: accent.withValues(alpha: 0.45)),
            borderRadius: BorderRadius.circular(barHeight / 2),
          ),
          child: Row(
            children: [
              Expanded(
                child: _DirButton(
                  icon: GameIcons.sowLeft,
                  label: GameIcons.semanticsLabel(GameIcons.sowLeft),
                  accent: accent,
                  onTap: () => onDirectionSelect(false),
                ),
              ),
              _divider(),
              Expanded(
                child: _DirButton(
                  icon: GameIcons.sowRight,
                  label: GameIcons.semanticsLabel(GameIcons.sowRight),
                  accent: accent,
                  onTap: () => onDirectionSelect(true),
                ),
              ),
              _divider(),
              Expanded(
                child: _DirButton(
                  icon: GameIcons.cancel,
                  label: 'Hủy',
                  accent: GameTheme.inkMuted,
                  onTap: onCancel,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 20,
      color: GameTheme.woodDeep.withValues(alpha: 0.12),
    );
  }
}

class _DirButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accent;
  final VoidCallback onTap;

  const _DirButton({
    required this.icon,
    required this.label,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      child: Tooltip(
        message: label,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Haptics.tick();
              onTap();
            },
            child: SizedBox(
              height: DirectionSelector.barHeight,
              child: Icon(icon, size: 18, color: accent),
            ),
          ),
        ),
      ),
    );
  }
}