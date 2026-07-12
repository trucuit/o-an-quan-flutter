import 'package:flutter/material.dart';
import '../../theme/game_theme.dart';

/// Shared layout metrics for the fullscreen game arena.
abstract final class GameLayout {
  static const double topBarHeight = 52;
  static const double bottomHudHeight = 52;
  static const double playerRailWidth = 64;
  static const double railEdgeInset = 6;
  /// Horizontal gutter reserved so overlay rails do not cover mandarin pits.
  static const double railGutterWidth = playerRailWidth + railEdgeInset + GameTheme.spaceMd;
  /// Vertical alignment for rails beside citizen rows (P2 top, P1 bottom).
  static const double railAlignP2Y = -0.28;
  static const double railAlignP1Y = 0.28;
  static const double arenaGap = GameTheme.spaceXs;

  static EdgeInsets arenaPadding(BuildContext context) {
    final view = MediaQuery.viewPaddingOf(context);
    final sideInset = railEdgeInset + GameTheme.spaceXs;
    return EdgeInsets.only(
      left: view.left > 0 ? view.left : sideInset,
      right: view.right > 0 ? view.right : sideInset,
      top: arenaGap,
      bottom: arenaGap,
    );
  }
}