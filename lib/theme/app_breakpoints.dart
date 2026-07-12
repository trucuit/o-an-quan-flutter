import 'package:flutter/widgets.dart';

/// Material-style window size classes driven by available width.
/// See `design-spec.md` §6.
enum WindowSizeClass { compact, medium, expanded }

abstract final class AppBreakpoints {
  static const double mediumMin = 600;
  static const double expandedMin = 1024;

  /// Max content width for the centered arena on large screens.
  static const double expandedMaxContentWidth = 1100;

  static WindowSizeClass of(BuildContext context) =>
      fromWidth(MediaQuery.sizeOf(context).width);

  static WindowSizeClass fromWidth(double width) {
    if (width >= expandedMin) return WindowSizeClass.expanded;
    if (width >= mediumMin) return WindowSizeClass.medium;
    return WindowSizeClass.compact;
  }

  static bool isLandscape(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return size.width >= size.height;
  }

  /// Type/spacing multiplier per size class (design-spec §6).
  static double scale(BuildContext context) => switch (of(context)) {
        WindowSizeClass.compact => 1.0,
        WindowSizeClass.medium => 1.1,
        WindowSizeClass.expanded => 1.2,
      };

  /// Pick a value by current window size class.
  static T responsive<T>(
    BuildContext context, {
    required T compact,
    T? medium,
    T? expanded,
  }) =>
      switch (of(context)) {
        WindowSizeClass.compact => compact,
        WindowSizeClass.medium => medium ?? compact,
        WindowSizeClass.expanded => expanded ?? medium ?? compact,
      };
}
