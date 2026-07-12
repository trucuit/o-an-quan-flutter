import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../theme/game_theme.dart';
import '../theme/game_icons.dart';
import '../widgets/no_scroll_scaffold.dart';
import '../widgets/icon_action_button.dart';
import '../widgets/tutorial_board_diagram.dart';
import 'game_screen.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  int _currentStep = 0;

  static const _stepIcons = [
    GameIcons.board,
    GameIcons.sow,
    GameIcons.pick,
    GameIcons.capture,
    GameIcons.stop,
    GameIcons.score,
  ];

  static const _stepCaptions = [
    '12 ô: 10 dân + 2 quan hai đầu',
    'Chọn ô dân, rải từng viên theo chiều',
    'Ô sau có quân → nhặt tiếp rải',
    'Ô sau trống, ô kế có quân → ăn',
    'Chạm Ô Quan hoặc 2 ô trống → dừng',
    'Hết quan → gom quân, tính điểm',
  ];

  @override
  Widget build(BuildContext context) {
    final isLast = _currentStep == _stepCaptions.length - 1;

    return NoScrollScaffold(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          children: [
            Row(
              children: [
                IconActionButton(
                  icon: GameIcons.back,
                  semanticsLabel: GameIcons.semanticsLabel(GameIcons.back),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(GameIcons.tutorial, color: GameTheme.ink, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '${_currentStep + 1}/${_stepCaptions.length}',
                        style: GameTheme.labelStyle.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 44),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_stepCaptions.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _currentStep == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentStep == index
                        ? GameTheme.primaryP2
                        : GameTheme.inkMuted.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: GameTheme.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: GameTheme.woodDeep.withValues(alpha: 0.15)),
                  boxShadow: GameTheme.glassShadows,
                ),
                child: Center(
                  child: _currentStep == 0
                      ? _boardStep()
                      : _iconStep(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconActionButton(
                  icon: GameIcons.prev,
                  semanticsLabel: GameIcons.semanticsLabel(GameIcons.prev),
                  onPressed: _currentStep > 0
                      ? () => setState(() => _currentStep--)
                      : null,
                ),
                IconActionButton(
                  icon: isLast ? GameIcons.play : GameIcons.next,
                  semanticsLabel: isLast ? 'Chơi ngay' : GameIcons.semanticsLabel(GameIcons.next),
                  onPressed: () {
                    if (!isLast) {
                      setState(() => _currentStep++);
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GameScreen(mode: GameMode.localPvP),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Step 1: board diagram sized to fill most of the card, with the caption
  /// pinned just beneath it instead of floating in leftover space.
  Widget _boardStep() {
    // Diagram takes all space left after the caption (via Expanded) so it fills
    // the card on large screens yet never overflows on short viewports.
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(child: Center(child: TutorialBoardDiagram())),
        const SizedBox(height: 12),
        _caption(),
      ],
    );
  }

  /// Steps 2-6: one large icon centered with the caption directly below it,
  /// so the pair reads as a single balanced unit instead of an icon
  /// stranded in a tall empty area.
  Widget _iconStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // FittedBox keeps the icon at 96 when there's room but scales it down
        // on short viewports so the step never overflows the card.
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Icon(
              _stepIcons[_currentStep],
              size: 96,
              color: GameTheme.primaryP2,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _caption(),
      ],
    );
  }

  Widget _caption() {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          _stepCaptions[_currentStep],
          textAlign: TextAlign.center,
          maxLines: 2,
          style: GameTheme.bodyStyle.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}