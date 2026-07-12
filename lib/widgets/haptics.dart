import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Platform-safe haptic feedback. No-ops on web/desktop where the platform
/// channel is unavailable, so callers never need to guard.
abstract final class Haptics {
  static bool get _supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android);

  /// Light tick — used per sown stone.
  static void tick() {
    if (_supported) HapticFeedback.selectionClick();
  }

  /// Stronger pulse — used on capture.
  static void capture() {
    if (_supported) HapticFeedback.mediumImpact();
  }

  /// Sharp feedback — used on invalid / blocked action.
  static void invalid() {
    if (_supported) HapticFeedback.heavyImpact();
  }
}
