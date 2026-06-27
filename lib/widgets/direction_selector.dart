import 'package:flutter/material.dart';
import '../theme/game_theme.dart';
import '../theme/game_icons.dart';
import 'icon_action_button.dart';
import 'scale_pressable.dart';

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

  @override
  Widget build(BuildContext context) {
    final isP1 = squareIndex < 5;
    final accent = isP1 ? GameTheme.primaryP1 : GameTheme.primaryP2;

    return Semantics(
      label: 'Chọn chiều rải quân',
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: GameTheme.cardBackground.withOpacity(0.96),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            boxShadow: GameTheme.glassShadows,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(GameIcons.square, size: 18, color: accent),
                  const SizedBox(width: 6),
                  Text(
                    '$squareIndex',
                    style: GameTheme.headingStyle.copyWith(fontSize: 18, color: accent),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDirectionButton(
                    icon: GameIcons.counterClockwise,
                    semanticsLabel: GameIcons.semanticsLabel(GameIcons.counterClockwise),
                    onTap: () => onDirectionSelect(false),
                  ),
                  const SizedBox(width: 32),
                  _buildDirectionButton(
                    icon: GameIcons.clockwise,
                    semanticsLabel: GameIcons.semanticsLabel(GameIcons.clockwise),
                    onTap: () => onDirectionSelect(true),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              IconActionButton(
                icon: GameIcons.cancel,
                semanticsLabel: GameIcons.semanticsLabel(GameIcons.cancel),
                onPressed: onCancel,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDirectionButton({
    required IconData icon,
    required String semanticsLabel,
    required VoidCallback onTap,
  }) {
    return Semantics(
      label: semanticsLabel,
      button: true,
      child: Tooltip(
        message: semanticsLabel,
        child: ScalePressable(
          onTap: onTap,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              splashColor: Colors.white.withValues(alpha: 0.1),
              child: Container(
                width: GameTheme.minTouchTarget + 24,
                height: GameTheme.minTouchTarget + 24,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                ),
                child: Icon(icon, color: Colors.white, size: 36),
              ),
            ),
          ),
        ),
      ),
    );
  }
}