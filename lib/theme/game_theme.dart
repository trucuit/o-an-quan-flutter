import 'package:flutter/material.dart';

/// Semantic design tokens for Ô Ăn Quan (dark immersive gaming).
abstract final class GameTheme {
  // Surfaces
  static const Color background = Color(0xFF0F172A);
  static const Color boardBackground = Color(0xFF1E293B);
  static const Color cardBackground = Color(0xFF1E293B);
  static const Color surfaceElevated = Color(0xFF334155);

  // On-surface text (WCAG AA on dark surfaces)
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFFCBD5E1);
  static const Color textMuted = Color(0xFF94A3B8);

  // Brand / players
  static const Color primaryP1 = Color(0xFFE2E8F0);
  static const Color primaryP2 = Color(0xFF94A3B8);
  static const Color accent = Color(0xFFF97316);
  static const Color accentMuted = Color(0xFFFB923C);

  static const Color mandarinColor = Color(0xFFF1F5F9);
  static const Color citizenColor = Color(0xFF94A3B8);

  // Interaction
  static const double disabledOpacity = 0.38;
  static const double scrimLight = 0.45;
  static const double scrimHeavy = 0.6;
  static const double borderSubtle = 0.08;

  // Spacing (4/8dp rhythm)
  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 16;
  static const double spaceLg = 24;
  static const double spaceXl = 32;

  // Icon sizes
  static const double iconSm = 16;
  static const double iconMd = 24;
  static const double iconLg = 32;

  // Touch
  static const double minTouchTarget = 48;

  // Legacy aliases
  static const Color textLight = textPrimary;

  static const LinearGradient p1Gradient = LinearGradient(
    colors: [Color(0xFFE2E8F0), Color(0xFF94A3B8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient p2Gradient = LinearGradient(
    colors: [Color(0xFF94A3B8), Color(0xFF475569)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient mandarinGradient = LinearGradient(
    colors: [Color(0xFFF1F5F9), Color(0xFFCBD5E1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient boardGradient = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static List<BoxShadow> glassShadows = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: Colors.white.withValues(alpha: 0.02),
      blurRadius: 1,
      spreadRadius: 1,
      offset: const Offset(0, -1),
    ),
  ];

  static List<BoxShadow> activeShadowP1 = [
    BoxShadow(
      color: const Color(0xFFE2E8F0).withValues(alpha: 0.25),
      blurRadius: 12,
      spreadRadius: 2,
    ),
  ];

  static List<BoxShadow> activeShadowP2 = [
    BoxShadow(
      color: const Color(0xFF94A3B8).withValues(alpha: 0.25),
      blurRadius: 12,
      spreadRadius: 2,
    ),
  ];

  static TextStyle get titleStyle => const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textPrimary,
        letterSpacing: 1.2,
        height: 1.2,
      );

  static TextStyle get headingStyle => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        height: 1.3,
      );

  static TextStyle get bodyStyle => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        height: 1.5,
      );

  static TextStyle get labelStyle => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textMuted,
        height: 1.4,
      );

  static ThemeData buildTheme() {
    const scheme = ColorScheme.dark(
      surface: background,
      onSurface: textPrimary,
      primary: accent,
      onPrimary: textPrimary,
      secondary: primaryP2,
      onSecondary: textPrimary,
      error: Color(0xFFEF4444),
      onError: textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      splashFactory: InkRipple.splashFactory,
      textTheme: const TextTheme(
        displaySmall: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: textPrimary),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: textPrimary),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: textSecondary, height: 1.5),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textMuted),
      ),
    );
  }
}