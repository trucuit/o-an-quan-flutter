import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'game_theme.dart';

/// Board-specific visual tokens. Values now resolve to the unified Vietnamese
/// palette in [GameTheme] — this file no longer holds an independent color set.
abstract final class GamePlayTheme {
  static const Color p1 = GameTheme.accentP1;
  static const Color p2 = GameTheme.accentP2;
  static const Color cellFill = GameTheme.pitFloor;
  static const Color cellBorder = GameTheme.woodDeep;
  static const Color boardFill = GameTheme.woodMid;
  static const Color mandarin = GameTheme.stoneMandarin;
  static const Color hudBar = Color(0x332B2118);

  static Color playerColor(int index) {
    if (index < 5 || index == 5) return p1;
    return p2;
  }

  static Color playerColorForSquare(int squareIndex) {
    if (squareIndex < 5 || squareIndex == 5) return p1;
    return p2;
  }

  static TextStyle cellCountStyle(double size) => GoogleFonts.beVietnamPro(
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: GameTheme.inkOnWood,
        fontFeatures: const [FontFeature.tabularFigures()],
        height: 1,
      );
}
