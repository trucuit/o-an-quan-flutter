import 'package:flutter/material.dart';

/// Motion tokens aligned with ui-ux-pro-max (150–300ms micro-interactions).
abstract final class AppMotion {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 200);
  static const Duration slow = Duration(milliseconds: 300);

  // Gameplay motion (design-spec §5).
  static const Duration sowTick = Duration(milliseconds: 200);
  static const Duration capturePulse = Duration(milliseconds: 260);
  static const Duration turnSwap = Duration(milliseconds: 240);

  static const Curve hop = Curves.easeInOut;
  static const Curve pulse = Curves.easeOutBack;

  static bool reducedMotion(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context);

  static Duration resolve(BuildContext context, Duration preferred) =>
      reducedMotion(context) ? Duration.zero : preferred;

  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
}