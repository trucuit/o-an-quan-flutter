import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/game_theme.dart';

/// Paints the static wood-grain board surface behind the pit grid.
/// Static layer — `shouldRepaint` is false so it caches across frames.
class BoardPainter extends CustomPainter {
  const BoardPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final radius = Radius.circular(GameTheme.radiusCard);
    final rrect = RRect.fromRectAndRadius(rect, radius);
    canvas.save();
    canvas.clipRRect(rrect);

    // Base wood gradient.
    final base = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFA5743F), GameTheme.woodMid, GameTheme.woodDeep],
        stops: [0.0, 0.55, 1.0],
      ).createShader(rect);
    canvas.drawRect(rect, base);

    // Wood grain: gentle horizontal arcs in darker tone.
    final grain = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = GameTheme.woodDeep.withValues(alpha: 0.22);
    final rng = math.Random(11);
    final lines = (size.height / 14).floor();
    for (var i = 0; i < lines; i++) {
      final y = (i + 0.5) * (size.height / lines);
      final path = Path()..moveTo(0, y);
      final waves = 3 + rng.nextInt(2);
      for (var w = 1; w <= waves; w++) {
        final x = size.width * w / waves;
        final cx = size.width * (w - 0.5) / waves;
        final cy = y + (rng.nextDouble() - 0.5) * 6;
        path.quadraticBezierTo(cx, cy, x, y);
      }
      canvas.drawPath(path, grain);
    }

    // Soft vignette for depth.
    final vignette = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.9,
        colors: [
          Colors.transparent,
          GameTheme.pitShadow.withValues(alpha: 0.28),
        ],
        stops: const [0.7, 1.0],
      ).createShader(rect);
    canvas.drawRect(rect, vignette);

    // Inner bevel highlight.
    final bevel = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = const Color(0xFFC79A66).withValues(alpha: 0.4);
    canvas.drawRRect(rrect.deflate(0.75), bevel);

    canvas.restore();
  }

  @override
  bool shouldRepaint(BoardPainter oldDelegate) => false;
}
