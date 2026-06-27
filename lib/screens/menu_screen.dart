import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../theme/game_theme.dart';
import '../theme/game_icons.dart';
import '../widgets/no_scroll_scaffold.dart';
import '../widgets/icon_menu_tile.dart';
import 'game_screen.dart';
import 'tutorial_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NoScrollScaffold(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: IconMenuTile(
                            icon: GameIcons.pvp,
                            semanticsLabel: GameIcons.semanticsLabel(GameIcons.pvp),
                            label: 'Chơi Hai Người',
                            gradient: GameTheme.p1Gradient,
                            onTap: () => _launchGame(context, GameMode.localPvP),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: IconMenuTile(
                            icon: GameIcons.aiHard,
                            badge: GameIcons.hardBadge,
                            semanticsLabel: GameIcons.semanticsLabel(GameIcons.aiHard),
                            label: 'Máy khó',
                            gradient: GameTheme.p2Gradient,
                            onTap: () => _launchGame(context, GameMode.vsHardAI),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: IconMenuTile(
                            icon: GameIcons.aiMedium,
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
                            icon: GameIcons.tutorial,
                            semanticsLabel: GameIcons.semanticsLabel(GameIcons.tutorial),
                            label: 'Hướng dẫn',
                            gradient: const LinearGradient(
                              colors: [Color(0xFF64748B), Color(0xFF475569)],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const TutorialScreen()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Tooltip(
              message: GameIcons.semanticsLabel(GameIcons.flag),
              child: Icon(GameIcons.flag, size: 16, color: Colors.white.withOpacity(0.3)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(GameIcons.board, color: GameTheme.primaryP2, size: 28),
        const SizedBox(width: 10),
        FittedBox(
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
      ],
    );
  }

  void _launchGame(BuildContext context, GameMode mode) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameScreen(mode: mode)),
    );
  }
}