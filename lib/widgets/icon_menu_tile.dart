import 'package:flutter/material.dart';
import '../theme/game_theme.dart';
import 'scale_pressable.dart';

class IconMenuTile extends StatelessWidget {
  final IconData icon;
  final String semanticsLabel;
  final String? label;
  final IconData? badge;
  final Gradient gradient;
  final VoidCallback onTap;

  const IconMenuTile({
    super.key,
    required this.icon,
    required this.semanticsLabel,
    this.label,
    this.badge,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
              borderRadius: BorderRadius.circular(20),
              splashColor: Colors.white.withValues(alpha: 0.08),
              highlightColor: Colors.white.withValues(alpha: 0.04),
              child: Container(
                decoration: BoxDecoration(
                  color: GameTheme.cardBackground.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: GameTheme.borderSubtle)),
                  boxShadow: GameTheme.glassShadows,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: gradient,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(icon, color: Colors.white, size: 28),
                        ),
                        if (badge != null)
                          Positioned(
                            right: -4,
                            top: -4,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: GameTheme.background,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white24),
                              ),
                              child: Icon(badge, size: 12, color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                    if (label != null) ...[
                      const SizedBox(height: GameTheme.spaceSm),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: GameTheme.spaceSm),
                          child: Text(
                            label!,
                            maxLines: 1,
                            style: GameTheme.headingStyle.copyWith(fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}