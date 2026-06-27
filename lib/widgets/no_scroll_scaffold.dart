import 'package:flutter/material.dart';
import '../theme/game_theme.dart';

class NoScrollScaffold extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  const NoScrollScaffold({
    super.key,
    required this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? GameTheme.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: child,
            );
          },
        ),
      ),
    );
  }
}