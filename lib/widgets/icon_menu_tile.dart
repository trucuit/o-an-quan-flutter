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
          child: Container(
            decoration: BoxDecoration(
              color: GameTheme.cardBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: GameTheme.woodDeep.withValues(alpha: 0.18)),
              boxShadow: GameTheme.glassShadows,
            ),
            // Scale the icon badge + label with the tile's own footprint so a
            // large landscape tile doesn't leave a tiny icon floating alone
            // in a sea of empty space.
            child: LayoutBuilder(
              builder: (context, constraints) {
                final shortSide = constraints.maxWidth < constraints.maxHeight
                    ? constraints.maxWidth
                    : constraints.maxHeight;
                // 52px badge at a ~130px-tall tile is the original baseline.
                final badgeSize = (shortSide * 0.4).clamp(52.0, 84.0);
                final iconSize = badgeSize * 0.54;
                final badgeRadius = badgeSize * 0.31;
                final fontSize = (shortSide * 0.1).clamp(13.0, 19.0);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: badgeSize,
                          height: badgeSize,
                          decoration: BoxDecoration(
                            gradient: gradient,
                            borderRadius: BorderRadius.circular(badgeRadius),
                          ),
                          child: Icon(icon, color: Colors.white, size: iconSize),
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
                            style: GameTheme.headingStyle.copyWith(fontSize: fontSize),
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}