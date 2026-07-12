import 'package:flutter/material.dart';
import '../../theme/app_motion.dart';
import '../../theme/game_theme.dart';
import '../../theme/pebble_style.dart';

/// Renders the stones inside one pit as real pebbles, animating count deltas
/// in sync with the controller's per-step frames: stones added since the last
/// frame scale/fade in; a capture (count drop) triggers a brief pulse.
class PebbleCluster extends StatefulWidget {
  final int citizenCount;
  final bool isMandarin;
  final bool hasMandarin;
  final int pitIndex;

  const PebbleCluster({
    super.key,
    required this.citizenCount,
    required this.isMandarin,
    required this.hasMandarin,
    required this.pitIndex,
  });

  @override
  State<PebbleCluster> createState() => _PebbleClusterState();
}

class _PebbleClusterState extends State<PebbleCluster>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late int _prevCount;

  @override
  void initState() {
    super.initState();
    _prevCount = widget.citizenCount;
    _controller = AnimationController(vsync: this, duration: AppMotion.sowTick)
      ..value = 1;
  }

  @override
  void didUpdateWidget(covariant PebbleCluster oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.citizenCount != oldWidget.citizenCount) {
      _prevCount = oldWidget.citizenCount;
      if (!AppMotion.reducedMotion(context)) {
        _controller
          ..value = 0
          ..forward();
      } else {
        _controller.value = 1;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final minSide = constraints.biggest.shortestSide;
        final count = widget.citizenCount;
        final showBadge = count > PebbleStyle.maxStonesShown;
        final drawnCitizens = showBadge
            ? PebbleStyle.cappedClusterCount
            : count.clamp(0, PebbleStyle.maxStonesShown);

        return Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => CustomPaint(
                size: constraints.biggest,
                painter: _PebblePainter(
                  drawnCitizens: drawnCitizens,
                  prevCitizens: _prevCount.clamp(0, drawnCitizens),
                  pitIndex: widget.pitIndex,
                  minSide: minSide,
                  hasMandarin: widget.hasMandarin,
                  appear: _controller.value,
                ),
              ),
            ),
            // Numeric badge only when stones can't all be drawn (count > cap);
            // otherwise the visible pebbles already convey the count.
            if (!widget.isMandarin && showBadge)
              Align(alignment: Alignment.topRight, child: _CountBadge(count: count)),
            // Mandarin pit: the large gold stone conveys "quan"; show only a
            // small count when extra citizen stones have piled up alongside it.
            if (widget.isMandarin && count > 0)
              _MandarinCountLabel(
                citizenCount: count,
                hasMandarin: widget.hasMandarin,
                minSide: minSide,
              ),
          ],
        );
      },
    );
  }
}

class _MandarinCountLabel extends StatelessWidget {
  final int citizenCount;
  final bool hasMandarin;
  final double minSide;

  const _MandarinCountLabel({
    required this.citizenCount,
    required this.hasMandarin,
    required this.minSide,
  });

  @override
  Widget build(BuildContext context) {
    final display = citizenCount > 0
        ? '$citizenCount'
        : (hasMandarin ? '1' : null);
    if (display == null) return const SizedBox.shrink();

    final fontSize = (minSide * 0.28).clamp(14.0, 28.0);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasMandarin && citizenCount > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Icon(
              Icons.circle,
              size: fontSize * 0.35,
              color: GameTheme.stoneMandarin,
            ),
          ),
        Text(
          display,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: GameTheme.inkOnWood,
            fontFeatures: const [FontFeature.tabularFigures()],
            height: 1,
            shadows: const [
              Shadow(color: Color(0x66000000), blurRadius: 2, offset: Offset(0, 1)),
            ],
          ),
        ),
        if (hasMandarin && citizenCount == 0)
          Text(
            'quan',
            style: TextStyle(
              fontSize: fontSize * 0.35,
              color: GameTheme.inkOnWood.withValues(alpha: 0.8),
              height: 1,
            ),
          ),
      ],
    );
  }
}

class _CountBadge extends StatelessWidget {
  final int count;
  const _CountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: GameTheme.paperPanel,
          borderRadius: BorderRadius.circular(GameTheme.radiusSm),
          border: Border.all(color: GameTheme.woodDeep.withValues(alpha: 0.3)),
        ),
        child: Text(
          '×$count',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: GameTheme.ink,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _PebblePainter extends CustomPainter {
  final int drawnCitizens;
  final int prevCitizens;
  final int pitIndex;
  final double minSide;
  final bool hasMandarin;
  final double appear; // 0..1 progress for newly added stones

  _PebblePainter({
    required this.drawnCitizens,
    required this.prevCitizens,
    required this.pitIndex,
    required this.minSide,
    required this.hasMandarin,
    required this.appear,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final usableRadius = size.shortestSide * 0.32;

    // Mandarin stone (large gold) sits behind citizen stones.
    if (hasMandarin) {
      final d = PebbleStyle.mandarinDiameter(minSide);
      _drawStone(
        canvas,
        center,
        d / 2,
        GameTheme.stoneMandarin,
        GameTheme.stoneMandarinShade,
      );
    }

    if (drawnCitizens <= 0) return;
    final positions = PebbleStyle.layout(drawnCitizens, pitIndex);
    final r = PebbleStyle.stoneDiameter(minSide) / 2;

    for (var i = 0; i < positions.length; i++) {
      final isNew = i >= prevCitizens;
      final scale = isNew ? Curves.easeOutBack.transform(appear) : 1.0;
      if (scale <= 0) continue;
      final pos = center + positions[i] * usableRadius;
      _drawStone(
        canvas,
        pos,
        r * scale,
        PebbleStyle.citizenFill(i),
        PebbleStyle.citizenShade(i),
        opacity: isNew ? appear.clamp(0.0, 1.0) : 1.0,
      );
    }
  }

  void _drawStone(
    Canvas canvas,
    Offset c,
    double radius,
    Color fill,
    Color shade, {
    double opacity = 1.0,
  }) {
    if (radius <= 0) return;
    final rect = Rect.fromCircle(center: c, radius: radius);
    final body = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.4, -0.5),
        colors: [
          fill.withValues(alpha: opacity),
          shade.withValues(alpha: opacity),
        ],
      ).createShader(rect);
    // Drop shadow.
    canvas.drawCircle(
      c + const Offset(0, 1),
      radius,
      Paint()..color = GameTheme.pitShadow.withValues(alpha: 0.35 * opacity),
    );
    canvas.drawCircle(c, radius, body);
    // Specular highlight.
    canvas.drawCircle(
      c + Offset(-radius * 0.32, -radius * 0.36),
      radius * 0.28,
      Paint()..color = Colors.white.withValues(alpha: 0.7 * opacity),
    );
  }

  @override
  bool shouldRepaint(_PebblePainter old) =>
      old.drawnCitizens != drawnCitizens ||
      old.appear != appear ||
      old.hasMandarin != hasMandarin ||
      old.prevCitizens != prevCitizens;
}
