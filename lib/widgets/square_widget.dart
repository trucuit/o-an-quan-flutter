import 'dart:math';
import 'package:flutter/material.dart';
import '../models/board_square.dart';
import '../theme/game_theme.dart';
import '../theme/game_icons.dart';

class SquareWidget extends StatelessWidget {
  final BoardSquare square;
  final bool isSelectable;
  final bool isSelected;
  final VoidCallback onTap;

  const SquareWidget({
    super.key,
    required this.square,
    required this.isSelectable,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.white.withOpacity(0.08);
    List<BoxShadow> shadows = [];

    if (isSelected) {
      borderColor = square.index < 5 ? GameTheme.primaryP1 : GameTheme.primaryP2;
      shadows = square.index < 5 ? GameTheme.activeShadowP1 : GameTheme.activeShadowP2;
    } else if (isSelectable) {
      borderColor = (square.index < 5 ? GameTheme.primaryP1 : GameTheme.primaryP2).withOpacity(0.4);
    }

    Widget content = CustomPaint(
      painter: StonesPainter(
        citizenCount: square.citizenCount,
        hasMandarin: square.hasMandarin,
        isMandarinSquare: square.isMandarin,
      ),
    );

    // Neumorphic / Glassmorphic container
    return GestureDetector(
      onTap: (isSelectable || isSelected) ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: GameTheme.cardBackground.withOpacity(isSelectable ? 0.9 : 0.7),
          borderRadius: BorderRadius.only(
            topLeft: square.index == 11 ? const Radius.circular(80) : const Radius.circular(16),
            bottomLeft: square.index == 11 ? const Radius.circular(80) : const Radius.circular(16),
            topRight: square.index == 5 ? const Radius.circular(80) : const Radius.circular(16),
            bottomRight: square.index == 5 ? const Radius.circular(80) : const Radius.circular(16),
          ),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 3 : (isSelectable ? 1.5 : 1),
          ),
          boxShadow: shadows.isNotEmpty ? shadows : GameTheme.glassShadows,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: square.index == 11 ? const Radius.circular(80) : const Radius.circular(16),
            bottomLeft: square.index == 11 ? const Radius.circular(80) : const Radius.circular(16),
            topRight: square.index == 5 ? const Radius.circular(80) : const Radius.circular(16),
            bottomRight: square.index == 5 ? const Radius.circular(80) : const Radius.circular(16),
          ),
          child: Stack(
            children: [
              Positioned.fill(child: content),
              // Stone count badge
              if (square.citizenCount > 0 || square.hasMandarin)
                Positioned(
                  top: 8,
                  left: square.index == 11 ? 40 : (square.index == 5 ? null : 8),
                  right: square.index == 5 ? 40 : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (square.hasMandarin) ...[
                          const Icon(GameIcons.mandarin, size: 10, color: GameTheme.mandarinColor),
                          const SizedBox(width: 2),
                        ],
                        if (square.citizenCount > 0) ...[
                          const Icon(GameIcons.citizen, size: 10, color: GameTheme.citizenColor),
                          const SizedBox(width: 2),
                          Text(
                            "${square.citizenCount}",
                            style: const TextStyle(
                              color: GameTheme.textPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              fontFeatures: [FontFeature.tabularFigures()],
                            ),
                          ),
                        ] else if (square.hasMandarin) ...[
                          const Text(
                            "1",
                            style: TextStyle(
                              color: GameTheme.textPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              fontFeatures: [FontFeature.tabularFigures()],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class StonesPainter extends CustomPainter {
  final int citizenCount;
  final bool hasMandarin;
  final bool isMandarinSquare;

  StonesPainter({
    required this.citizenCount,
    required this.hasMandarin,
    required this.isMandarinSquare,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final Random random = Random(citizenCount + (hasMandarin ? 99 : 0)); // Seed for deterministic layout

    // Pre-allocate paints used in this paint pass to avoid GC pressure
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.25)
      ..style = PaintingStyle.fill;

    final Paint pebblePaint = Paint()
      ..style = PaintingStyle.fill;

    final Paint reflectionPaint = Paint()
      ..color = Colors.white.withOpacity(0.22)
      ..style = PaintingStyle.fill;

    // Paint Mandarin Stone
    if (hasMandarin) {
      final double mandarinRadius = isMandarinSquare ? 18.0 : 14.0;
      final Paint mandarinPaint = Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFFFBBF24), Color(0xFFD97706)],
          stops: [0.3, 1.0],
        ).createShader(Rect.fromCircle(center: Offset(centerX, centerY), radius: mandarinRadius))
        ..style = PaintingStyle.fill;

      final Paint glowPaint = Paint()
        ..color = const Color(0xFFFBBF24).withOpacity(0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
        ..style = PaintingStyle.fill;

      final Paint cutPaint = Paint()
        ..color = Colors.white.withOpacity(0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      // Mandarin glow
      canvas.drawCircle(Offset(centerX, centerY), mandarinRadius + 4, glowPaint);
      // Mandarin body
      canvas.drawCircle(Offset(centerX, centerY), mandarinRadius, mandarinPaint);

      // Mandarin gem cuts / crown reflections
      canvas.drawCircle(Offset(centerX, centerY), mandarinRadius * 0.5, cutPaint);
      canvas.drawLine(
        Offset(centerX - mandarinRadius, centerY),
        Offset(centerX + mandarinRadius, centerY),
        cutPaint,
      );
      canvas.drawLine(
        Offset(centerX, centerY - mandarinRadius),
        Offset(centerX, centerY + mandarinRadius),
        cutPaint,
      );
    }

    // Paint Citizen Stones (Pebbles) using Fibonacci Spiral packing
    if (citizenCount > 0) {
      final double pebbleRadius = isMandarinSquare ? 4.5 : 5.5;
      
      // Determine center offset if Mandarin stone is taking space
      double spiralScale = isMandarinSquare ? 7.5 : 8.5;
      double startRadiusIndex = hasMandarin ? 6.0 : 0.0;

      for (int i = 0; i < citizenCount; i++) {
        // Fibonacci spiral packing: r = c * sqrt(n), theta = n * 137.5 deg
        final double n = i + startRadiusIndex;
        final double theta = n * 2.39996; // Golden angle in radians
        final double r = spiralScale * sqrt(n);

        // Convert polar coordinates to Cartesian
        double pX = centerX + r * cos(theta);
        double pY = centerY + r * sin(theta);

        // Ensure pebbles stay within bounds with some margin
        if (isMandarinSquare) {
          // Mandarin bounds check (semi-circle approximation)
          final double distFromCenter = sqrt(pow(pX - centerX, 2) + pow(pY - centerY, 2));
          if (distFromCenter > size.width / 2 - 12) {
            // Reposition randomly inside bounds if it spills out
            final double safeR = random.nextDouble() * (size.width / 2 - 20) + 10;
            final double safeAngle = random.nextDouble() * 2 * pi;
            pX = centerX + safeR * cos(safeAngle);
            pY = centerY + safeR * sin(safeAngle);
          }
        } else {
          // Citizen bounds check (rectangle)
          pX = pX.clamp(14.0, size.width - 14.0);
          pY = pY.clamp(14.0, size.height - 14.0);
        }

        // 1. Draw pebble shadow (offset slightly bottom-right)
        canvas.drawCircle(Offset(pX + 1, pY + 1.2), pebbleRadius, shadowPaint);

        // 2. Draw pebble body (solid color from cache palette)
        pebblePaint.color = _getPebbleColor(i, random);
        canvas.drawCircle(Offset(pX, pY), pebbleRadius, pebblePaint);

        // 3. Draw 3D reflection highlight dot (offset top-left)
        canvas.drawCircle(
          Offset(pX - pebbleRadius * 0.35, pY - pebbleRadius * 0.35),
          pebbleRadius * 0.28,
          reflectionPaint,
        );
      }
    }
  }

  Color _getPebbleColor(int index, Random random) {
    // Generate slate-blue variations for a pebble look
    final List<Color> colors = [
      const Color(0xFF64748B), // Slate 500
      const Color(0xFF475569), // Slate 600
      const Color(0xFF334155), // Slate 700
      const Color(0xFF94A3B8), // Slate 400
      const Color(0xFFCBD5E1), // Slate 300
    ];
    return colors[random.nextInt(colors.length)];
  }

  @override
  bool shouldRepaint(covariant StonesPainter oldDelegate) {
    return oldDelegate.citizenCount != citizenCount ||
        oldDelegate.hasMandarin != hasMandarin ||
        oldDelegate.isMandarinSquare != isMandarinSquare;
  }
}
