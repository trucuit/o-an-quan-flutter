import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'game_theme.dart';

/// Stone geometry + colors and deterministic in-pit layout (design-spec §4).
abstract final class PebbleStyle {
  /// Max citizen stones drawn before falling back to a numeric badge.
  static const int maxStonesShown = 8;

  /// Stones drawn alongside the badge when the count exceeds [maxStonesShown].
  static const int cappedClusterCount = 6;

  /// Stone diameter relative to the smaller pit side, clamped to sane bounds.
  static double stoneDiameter(double pitMinSide) =>
      (pitMinSide * 0.18).clamp(8.0, 22.0);

  /// Mandarin stone is noticeably larger than a citizen stone.
  static double mandarinDiameter(double pitMinSide) =>
      (pitMinSide * 0.34).clamp(16.0, 40.0);

  /// Citizen stone fill — alternates ivory/slate deterministically by [seed]
  /// (stone position within the pit) for visual variety.
  static Color citizenFill(int seed) =>
      seed.isEven ? GameTheme.stoneCitizen : GameTheme.stoneCitizenAlt;

  static Color citizenShade(int seed) => seed.isEven
      ? GameTheme.stoneCitizenShade
      : const Color(0xFF3F5965); // slate shade

  /// Deterministic offsets (unit circle, range -1..1) for [count] stones inside
  /// a pit. Seeded by [pitIndex] so stones never jump between rebuilds/frames.
  static List<Offset> layout(int count, int pitIndex) {
    if (count <= 0) return const [];
    final rng = math.Random(pitIndex * 31 + 7);
    final positions = <Offset>[];
    // First stone centered; the rest on jittered concentric rings.
    positions.add(Offset.zero);
    for (var i = 1; i < count; i++) {
      final ring = i <= 6 ? 0.55 : 0.82;
      final baseAngle = (i / count) * 2 * math.pi;
      final angle = baseAngle + (rng.nextDouble() - 0.5) * 0.6;
      final radius = ring + (rng.nextDouble() - 0.5) * 0.12;
      positions.add(Offset(math.cos(angle) * radius, math.sin(angle) * radius));
    }
    return positions;
  }
}
