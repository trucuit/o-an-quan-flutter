import 'package:flutter/material.dart';
import '../theme/game_theme.dart';
import '../theme/game_icons.dart';
import '../widgets/no_scroll_scaffold.dart';
import '../widgets/icon_action_button.dart';

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
                      const Icon(GameIcons.tutorial, color: Colors.white, size: 20),
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
                    color: _currentStep == index ? GameTheme.primaryP2 : Colors.white24,
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
                  color: GameTheme.cardBackground.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.06)),
                  boxShadow: GameTheme.glassShadows,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _stepIcons[_currentStep],
                      size: 56,
                      color: GameTheme.primaryP2,
                    ),
                    const SizedBox(height: 16),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          _stepCaptions[_currentStep],
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                  icon: _currentStep == _stepCaptions.length - 1
                      ? GameIcons.play
                      : GameIcons.next,
                  semanticsLabel: _currentStep == _stepCaptions.length - 1
                      ? GameIcons.semanticsLabel(GameIcons.play)
                      : GameIcons.semanticsLabel(GameIcons.next),
                  onPressed: () {
                    if (_currentStep < _stepCaptions.length - 1) {
                      setState(() => _currentStep++);
                    } else {
                      Navigator.pop(context);
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
}