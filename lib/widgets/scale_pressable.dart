import 'package:flutter/material.dart';
import '../theme/app_motion.dart';

/// Tap scale feedback (0.97) per ui-ux-pro-max press-feedback rule.
class ScalePressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  const ScalePressable({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius,
  });

  @override
  State<ScalePressable> createState() => _ScalePressableState();
}

class _ScalePressableState extends State<ScalePressable> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final duration = AppMotion.resolve(context, AppMotion.fast);
    final scale = _pressed && widget.onTap != null ? 0.97 : 1.0;

    return GestureDetector(
      onTapDown: widget.onTap == null ? null : (_) => setState(() => _pressed = true),
      onTapUp: widget.onTap == null ? null : (_) => setState(() => _pressed = false),
      onTapCancel: widget.onTap == null ? null : () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: scale,
        duration: duration,
        curve: AppMotion.enter,
        child: widget.child,
      ),
    );
  }
}