import 'package:flutter/material.dart';
import '../theme/game_theme.dart';

class IconActionButton extends StatelessWidget {
  final IconData icon;
  final String semanticsLabel;
  final String? tooltip;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final double size;

  const IconActionButton({
    super.key,
    required this.icon,
    required this.semanticsLabel,
    this.tooltip,
    this.onPressed,
    this.color,
    this.backgroundColor,
    this.size = 22,
  });

  @override
  Widget build(BuildContext context) {
    final label = tooltip ?? semanticsLabel;
    return Tooltip(
      message: label,
      child: Semantics(
        label: semanticsLabel,
        button: true,
        enabled: onPressed != null,
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, size: size),
          color: color ?? Colors.white,
          disabledColor: Colors.white.withValues(alpha: GameTheme.disabledOpacity),
          padding: const EdgeInsets.all(12),
          constraints: const BoxConstraints(
            minWidth: GameTheme.minTouchTarget,
            minHeight: GameTheme.minTouchTarget,
          ),
          style: IconButton.styleFrom(
            backgroundColor: backgroundColor ?? Colors.white.withOpacity(0.08),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}