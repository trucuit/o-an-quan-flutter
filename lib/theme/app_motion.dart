import 'package:flutter/material.dart';

/// Motion tokens aligned with ui-ux-pro-max (150–300ms micro-interactions).
abstract final class AppMotion {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 200);
  static const Duration slow = Duration(milliseconds: 300);

  static bool reducedMotion(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context);

  static Duration resolve(BuildContext context, Duration preferred) =>
      reducedMotion(context) ? Duration.zero : preferred;

  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
}