import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../theme/game_theme.dart';
import '../theme/game_icons.dart';
import '../theme/app_breakpoints.dart';
import '../widgets/no_scroll_scaffold.dart';
import '../widgets/icon_menu_tile.dart';
import '../widgets/scale_pressable.dart';
import 'game_screen.dart';
import 'tutorial_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  // Distinct hue per entry so difficulty reads at a glance.
  static const _pvpGradient = LinearGradient(colors: [Color(0xFF7C8AA0), Color(0xFF566179)]);
  static const _easyGradient = LinearGradient(colors: [Color(0xFF5B8A72), Color(0xFF3D6B55)]);
  static const _hardGradient = GameTheme.p1Gradient; // terracotta

  /// Comfortable content width on landscape/wide screens — keeps tiles from
  /// stretching full-bleed with the icon+label lost in a sea of empty space.
  static const double _maxContentWidth = 720;

  @override
  Widget build(BuildContext context) {
    final isLandscape = AppBreakpoints.isLandscape(context);

    return NoScrollScaffold(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isLandscape ? _maxContentWidth : double.infinity,
                  ),
                  child: _buildGrid(context, isLandscape: isLandscape),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isLandscape ? _maxContentWidth : double.infinity,
              ),
              child: _buildTutorialBar(context),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(GameIcons.flag, size: 14, color: GameTheme.inkMuted.withValues(alpha: 0.7)),
                const SizedBox(width: 6),
                Text(
                  GameIcons.semanticsLabel(GameIcons.flag),
                  style: GameTheme.captionStyle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// The 2x2 mode grid. In landscape the available height tends to be short
  /// and the constrained width wide, so rows are capped to a comfortable
  /// aspect ratio instead of stretching to fill all height — this keeps
  /// tiles from ballooning with empty space around a tiny icon+label.
  Widget _buildGrid(BuildContext context, {required bool isLandscape}) {
    final row1 = Row(
      children: [
        Expanded(
          child: IconMenuTile(
            icon: GameIcons.pvp,
            semanticsLabel: GameIcons.semanticsLabel(GameIcons.pvp),
            label: 'Chơi Hai Người',
            gradient: _pvpGradient,
            onTap: () => _launchGame(context, GameMode.localPvP),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: IconMenuTile(
            icon: GameIcons.ai,
            badge: GameIcons.easyBadge,
            semanticsLabel: 'Đấu máy dễ',
            label: 'Máy dễ',
            gradient: _easyGradient,
            onTap: () => _launchGame(context, GameMode.vsEasyAI),
          ),
        ),
      ],
    );

    final row2 = Row(
      children: [
        Expanded(
          child: IconMenuTile(
            icon: GameIcons.ai,
            badge: GameIcons.mediumBadge,
            semanticsLabel: GameIcons.semanticsLabel(GameIcons.aiMedium),
            label: 'Máy TB',
            gradient: GameTheme.mandarinGradient,
            onTap: () => _launchGame(context, GameMode.vsMediumAI),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: IconMenuTile(
            icon: GameIcons.ai,
            badge: GameIcons.hardBadge,
            semanticsLabel: GameIcons.semanticsLabel(GameIcons.aiHard),
            label: 'Máy khó',
            gradient: _hardGradient,
            onTap: () => _launchGame(context, GameMode.vsHardAI),
          ),
        ),
      ],
    );

    if (!isLandscape) {
      // Portrait: keep the original behavior — rows expand to fill height.
      return Column(
        children: [
          Expanded(child: row1),
          const SizedBox(height: 12),
          Expanded(child: row2),
        ],
      );
    }

    // Landscape: cap each tile row's height relative to the constrained
    // content width so tiles read as squarish cards, not wide empty bars.
    // Also bounded by available height so short landscape viewports (e.g.
    // small phones) never overflow.
    return LayoutBuilder(
      builder: (context, constraints) {
        final widthBasedHeight = constraints.maxWidth / 2 * 0.62;
        final heightBudget = (constraints.maxHeight - 12) / 2;
        final rowHeight = widthBasedHeight.clamp(120.0, 220.0).clamp(0.0, heightBudget > 0 ? heightBudget : widthBasedHeight);
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: rowHeight, child: row1),
            const SizedBox(height: 12),
            SizedBox(height: rowHeight, child: row2),
          ],
        );
      },
    );
  }

  /// Short, full-width row — avoids an orphaned tall 5th tile in the grid.
  Widget _buildTutorialBar(BuildContext context) {
    return Semantics(
      label: GameIcons.semanticsLabel(GameIcons.tutorial),
      button: true,
      child: ScalePressable(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TutorialScreen()),
        ),
        child: Container(
          height: 56,
          width: double.infinity,
          decoration: BoxDecoration(
            color: GameTheme.cardBackground,
            borderRadius: BorderRadius.circular(GameTheme.radiusCard),
            border: Border.all(color: GameTheme.woodDeep.withValues(alpha: 0.18)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(GameIcons.tutorial, size: 22, color: GameTheme.accentP2),
              const SizedBox(width: 10),
              Text('Hướng dẫn', style: GameTheme.headingStyle.copyWith(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Semantics(
      header: true,
      label: 'Ô Ăn Quan — trò chơi dân gian Việt Nam',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(GameIcons.board, color: GameTheme.primaryP2, size: 28),
          const SizedBox(width: 10),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Ô ĂN QUAN',
                style: GameTheme.titleStyle.copyWith(
                  fontSize: 32,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launchGame(BuildContext context, GameMode mode) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameScreen(mode: mode)),
    );
  }
}
