import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Semantic design tokens for Ô Ăn Quan — Traditional Vietnamese daylight theme.
///
/// Source of truth: `plans/ui-traditional-vietnamese-redesign/design-spec.md`.
/// Warm paper surfaces, wood-grain board, ink text, terracotta (P1) / jade (P2)
/// / aged-gold (mandarin) accents. No neon. Legacy token names are kept as
/// aliases that now resolve to the new palette so existing widgets keep
/// compiling while Phase 4 restyles them.
abstract final class GameTheme {
  // ── Canonical palette (Vietnamese daylight) ──────────────────────────────
  // Surfaces
  static const Color paper = Color(0xFFF4E9D8);
  static const Color paperPanel = Color(0xFFEAD9BD);
  static const Color paperSunken = Color(0xFFE0CCAA);
  static const Color woodMid = Color(0xFF9A6B3F);
  static const Color woodDeep = Color(0xFF6E4423);
  static const Color pitShadow = Color(0xFF4A2C16);
  static const Color pitFloor = Color(0xFF7E5630);

  // Ink / text
  static const Color ink = Color(0xFF2B2118);
  static const Color inkMuted = Color(0xFF6E5C49);
  static const Color inkOnWood = Color(0xFFF4E9D8);

  // Accents
  static const Color accentP1 = Color(0xFFB5462E); // terracotta
  static const Color accentP2 = Color(0xFF2E7D6B); // jade
  static const Color accentP2Text = Color(0xFF256456); // jade for small text (AA)
  static const Color accentGold = Color(0xFFB07D1E); // aged gold (AA on paper)
  static const Color warningColor = Color(0xFFB5631E);

  // Stones
  static const Color stoneCitizen = Color(0xFFEDE4D0);
  static const Color stoneCitizenAlt = Color(0xFF5B7C8D);
  static const Color stoneCitizenShade = Color(0xFFC7B89C);
  static const Color stoneMandarin = Color(0xFFC8962E);
  static const Color stoneMandarinShade = Color(0xFF8A6418);

  // ── Legacy aliases (repointed to new palette) ────────────────────────────
  static const Color background = paper;
  static const Color boardBackground = woodMid;
  static const Color cardBackground = paperPanel;
  static const Color surfaceElevated = paperSunken;
  static const Color textPrimary = ink;
  static const Color textSecondary = inkMuted;
  static const Color textMuted = inkMuted;
  static const Color textLight = ink;
  static const Color primaryP1 = accentP1;
  static const Color primaryP2 = accentP2;
  static const Color accent = accentGold;
  static const Color accentMuted = warningColor;
  static const Color mandarinColor = stoneMandarin;
  static const Color citizenColor = accentP2;

  // Interaction
  static const double disabledOpacity = 0.38;
  static const double scrimLight = 0.32;
  static const double scrimHeavy = 0.5;
  static const double borderSubtle = 0.15;

  // Spacing (4/8dp rhythm)
  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 16;
  static const double spaceLg = 24;
  static const double spaceXl = 32;

  // Radii
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusCard = 16;

  // Icon sizes
  static const double iconSm = 16;
  static const double iconMd = 24;
  static const double iconLg = 32;

  // Touch
  static const double minTouchTarget = 48;

  // ── Gradients (warm, non-neon) ───────────────────────────────────────────
  static const LinearGradient p1Gradient = LinearGradient(
    colors: [Color(0xFFC25A40), accentP1],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient p2Gradient = LinearGradient(
    colors: [Color(0xFF3C9482), accentP2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient mandarinGradient = LinearGradient(
    colors: [stoneMandarin, accentGold],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient boardGradient = LinearGradient(
    colors: [woodMid, woodDeep],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ── Shadows (soft carved/bevel, no glow) ─────────────────────────────────
  static List<BoxShadow> glassShadows = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.15),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
    BoxShadow(
      color: Colors.white.withValues(alpha: 0.33),
      blurRadius: 1,
      offset: const Offset(0, -1),
    ),
  ];

  static List<BoxShadow> activeShadowP1 = [
    BoxShadow(
      color: accentP1.withValues(alpha: 0.18),
      blurRadius: 12,
      spreadRadius: 1,
    ),
  ];

  static List<BoxShadow> activeShadowP2 = [
    BoxShadow(
      color: accentP2.withValues(alpha: 0.18),
      blurRadius: 12,
      spreadRadius: 1,
    ),
  ];

  // ── Typography (Lora display + Be Vietnam Pro body; VN-complete) ──────────
  static TextStyle get titleStyle => GoogleFonts.lora(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: ink,
        letterSpacing: 0.5,
        height: 1.2,
      );

  static TextStyle get headingStyle => GoogleFonts.lora(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: ink,
        height: 1.3,
      );

  static TextStyle get bodyStyle => GoogleFonts.beVietnamPro(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: ink,
        height: 1.5,
      );

  static TextStyle get labelStyle => GoogleFonts.beVietnamPro(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: inkMuted,
        height: 1.4,
      );

  /// Minimum 12px footnote — ui-ux-pro-max readable-font-size floor.
  static TextStyle get captionStyle => GoogleFonts.beVietnamPro(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: inkMuted,
        height: 1.4,
      );

  static ThemeData buildTheme() {
    const scheme = ColorScheme.light(
      surface: paper,
      onSurface: ink,
      primary: accentP1,
      onPrimary: paper,
      secondary: accentP2,
      onSecondary: paper,
      tertiary: accentGold,
      error: Color(0xFFA3301F),
      onError: paper,
    );

    final baseTextTheme = Typography.material2021().black;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: paper,
      splashFactory: InkRipple.splashFactory,
      textTheme: GoogleFonts.beVietnamProTextTheme(baseTextTheme).copyWith(
        displaySmall: GoogleFonts.lora(fontSize: 30, fontWeight: FontWeight.w700, color: ink),
        titleLarge: GoogleFonts.lora(fontSize: 22, fontWeight: FontWeight.w600, color: ink),
        titleMedium: GoogleFonts.beVietnamPro(fontSize: 16, fontWeight: FontWeight.w600, color: ink),
        bodyMedium: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.w400, color: ink, height: 1.5),
        labelMedium: GoogleFonts.beVietnamPro(fontSize: 13, fontWeight: FontWeight.w500, color: inkMuted),
      ),
    );
  }
}
