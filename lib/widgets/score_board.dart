import 'dart:io';
import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../theme/game_theme.dart';
import '../theme/game_icons.dart';
import '../theme/app_motion.dart';

class PlayerPanel extends StatelessWidget {
  final int playerNumber;
  final bool isActive;
  final int score;
  final int citizenPool;
  final int mandarinPool;
  final int debt;
  final GameMode mode;

  const PlayerPanel({
    super.key,
    required this.playerNumber,
    required this.isActive,
    required this.score,
    required this.citizenPool,
    required this.mandarinPool,
    required this.debt,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    final isP1 = playerNumber == 1;
    final playerColor = isP1 ? GameTheme.primaryP1 : GameTheme.primaryP2;
    final playerGradient = isP1 ? GameTheme.p1Gradient : GameTheme.p2Gradient;
    final playerIcon = isP1 ? GameIcons.player1 : _getPlayer2Icon();

    return AnimatedContainer(
      duration: AppMotion.slow,
      curve: AppMotion.enter,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: GameTheme.cardBackground.withOpacity(isActive ? 0.9 : 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? playerColor : Colors.white.withOpacity(0.05),
          width: isActive ? 2.0 : 1.0,
        ),
        boxShadow: isActive
            ? [BoxShadow(color: playerColor.withOpacity(0.15), blurRadius: 12, spreadRadius: 1)]
            : GameTheme.glassShadows,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              if (isActive) _PulseCircle(color: playerColor),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(gradient: playerGradient, shape: BoxShape.circle),
                child: Icon(playerIcon, color: Colors.white, size: 20),
              ),
              if (!isP1 && mode != GameMode.localPvP)
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: _difficultyBadge(),
                ),
            ],
          ),
          const SizedBox(height: 8),
          _statRow(GameIcons.score, '$score', playerColor, size: 18),
          const SizedBox(height: 6),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 6,
            runSpacing: 4,
            children: [
              _statRow(GameIcons.citizen, '$citizenPool', GameTheme.citizenColor),
              _statRow(GameIcons.mandarin, '$mandarinPool', GameTheme.mandarinColor),
              if (debt > 0) _statRow(GameIcons.debt, '-$debt', Colors.redAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _difficultyBadge() {
    final badge = switch (mode) {
      GameMode.vsHardAI => GameIcons.hardBadge,
      GameMode.vsMediumAI => GameIcons.mediumBadge,
      GameMode.vsEasyAI => Icons.speed,
      _ => null,
    };
    if (badge == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: GameTheme.background,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white24),
      ),
      child: Icon(badge, size: 10, color: GameTheme.primaryP2),
    );
  }

  Widget _statRow(IconData icon, String text, Color color, {double size = 11}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: size == 18 ? 14 : 10, color: color),
        const SizedBox(width: 3),
        Text(
          text,
          style: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.w700,
            color: color.withOpacity(0.95),
          ),
        ),
      ],
    );
  }

  IconData _getPlayer2Icon() {
    if (mode == GameMode.localPvP) return GameIcons.player2;
    return GameIcons.ai;
  }
}

class _PulseCircle extends StatefulWidget {
  final Color color;

  const _PulseCircle({required this.color});

  @override
  State<_PulseCircle> createState() => _PulseCircleState();
}

class _PulseCircleState extends State<_PulseCircle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    if (!Platform.environment.containsKey('FLUTTER_TEST')) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (AppMotion.reducedMotion(context)) {
      return const SizedBox.shrink();
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 40 + (20 * _controller.value),
          height: 40 + (20 * _controller.value),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: widget.color.withOpacity(1.0 - _controller.value),
              width: 1.5,
            ),
          ),
        );
      },
    );
  }
}