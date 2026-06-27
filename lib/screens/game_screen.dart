import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../controllers/game_controller.dart';
import '../theme/game_theme.dart';
import '../theme/game_icons.dart';
import '../widgets/board_widget.dart';
import '../widgets/score_board.dart';
import '../widgets/direction_selector.dart';
import '../widgets/status_chip_bar.dart';
import '../widgets/icon_action_button.dart';

class GameScreen extends StatefulWidget {
  final GameMode mode;

  const GameScreen({super.key, required this.mode});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GameController(mode: widget.mode);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        final state = _controller.state;
        final selectedIndex = _controller.selectedSquareIndex;

        return Scaffold(
          backgroundColor: GameTheme.background,
          body: Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: PlayerPanel(
                            playerNumber: 2,
                            isActive: state.activePlayer == 2 && state.phase != GamePhase.gameOver,
                            score: state.player2Score,
                            citizenPool: state.player2CapturedPool,
                            mandarinPool: state.player2MandarinCaptured,
                            debt: state.player2Debt,
                            mode: state.mode,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Column(
                          children: [
                            _buildHeader(),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Center(
                                  child: BoardWidget(
                                    board: state.board,
                                    activePlayer: state.activePlayer,
                                    selectedIndex: selectedIndex,
                                    isAnimating: _controller.isAnimating,
                                    onSquareTap: _controller.selectSquare,
                                  ),
                                ),
                              ),
                            ),
                            StatusChipBar(status: state.currentStatus),
                            const SizedBox(height: 6),
                            _buildControls(state),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: PlayerPanel(
                            playerNumber: 1,
                            isActive: state.activePlayer == 1 && state.phase != GamePhase.gameOver,
                            score: state.player1Score,
                            citizenPool: state.player1CapturedPool,
                            mandarinPool: state.player1MandarinCaptured,
                            debt: state.player1Debt,
                            mode: state.mode,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (selectedIndex != null)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withValues(alpha: GameTheme.scrimLight),
                    child: DirectionSelector(
                      squareIndex: selectedIndex,
                      onDirectionSelect: _controller.playMove,
                      onCancel: _controller.cancelSelection,
                    ),
                  ),
                ),
              if (state.phase == GamePhase.gameOver) _buildGameOverOverlay(state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconActionButton(
          icon: GameIcons.back,
          semanticsLabel: GameIcons.semanticsLabel(GameIcons.home),
          onPressed: _controller.isAnimating ? null : () => Navigator.pop(context),
        ),
        Tooltip(
          message: _modeSemanticsLabel(),
          child: Icon(GameIcons.forMode(widget.mode), color: Colors.white, size: 24),
        ),
        IconActionButton(
          icon: GameIcons.restart,
          semanticsLabel: GameIcons.semanticsLabel(GameIcons.restart),
          onPressed: _showResetConfirmation,
        ),
      ],
    );
  }

  String _modeSemanticsLabel() {
    switch (widget.mode) {
      case GameMode.localPvP:
        return GameIcons.semanticsLabel(GameIcons.pvp);
      case GameMode.vsHardAI:
        return GameIcons.semanticsLabel(GameIcons.aiHard);
      case GameMode.vsMediumAI:
        return GameIcons.semanticsLabel(GameIcons.aiMedium);
      case GameMode.vsEasyAI:
        return 'Đấu máy dễ';
    }
  }

  Widget _buildControls(GameState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconActionButton(
          icon: GameIcons.undo,
          semanticsLabel: GameIcons.semanticsLabel(GameIcons.undo),
          onPressed: _controller.isAnimating || state.phase == GamePhase.gameOver
              ? null
              : _controller.undo,
        ),
        const SizedBox(width: 16),
        IconActionButton(
          icon: GameIcons.rules,
          semanticsLabel: GameIcons.semanticsLabel(GameIcons.rules),
          onPressed: _showRulesOverlay,
        ),
      ],
    );
  }

  Widget _buildGameOverOverlay(GameState state) {
    final isP1Winner = state.player1Score > state.player2Score;
    final isTie = state.player1Score == state.player2Score;
    final resultIcon = isTie
        ? GameIcons.tie
        : (isP1Winner ? GameIcons.win : GameIcons.ai);
    final textColor = isTie
        ? GameTheme.mandarinColor
        : (isP1Winner ? GameTheme.primaryP1 : GameTheme.primaryP2);

    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: GameTheme.scrimHeavy),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: GameTheme.cardBackground,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: textColor.withOpacity(0.3), width: 1.5),
              boxShadow: GameTheme.glassShadows,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(resultIcon, size: 48, color: textColor),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildScoreResult(GameIcons.player1, state.player1Score, GameTheme.primaryP1),
                    Container(width: 1, height: 40, color: Colors.white24),
                    _buildScoreResult(
                      state.mode == GameMode.localPvP ? GameIcons.player2 : GameIcons.ai,
                      state.player2Score,
                      GameTheme.primaryP2,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconActionButton(
                      icon: GameIcons.home,
                      semanticsLabel: GameIcons.semanticsLabel(GameIcons.home),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 16),
                    IconActionButton(
                      icon: GameIcons.restart,
                      semanticsLabel: GameIcons.semanticsLabel(GameIcons.restart),
                      color: textColor,
                      backgroundColor: textColor.withOpacity(0.2),
                      onPressed: () => _controller.resetGame(widget.mode),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreResult(IconData icon, int score, Color color) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          '$score',
          style: TextStyle(color: color, fontSize: 28, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }

  void _showResetConfirmation() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: GameTheme.scrimLight),
      builder: (context) {
        return Semantics(
          label: 'Xác nhận chơi lại',
          child: AlertDialog(
            backgroundColor: GameTheme.cardBackground,
            title: Row(
              children: [
                const Icon(GameIcons.warning, color: GameTheme.accent, size: 22),
                const SizedBox(width: GameTheme.spaceSm),
                Expanded(
                  child: Text(
                    'Chơi lại?',
                    style: GameTheme.headingStyle.copyWith(fontSize: 18),
                  ),
                ),
              ],
            ),
            content: Row(
              children: [
                const Icon(GameIcons.restart, color: GameTheme.textSecondary, size: 28),
                const SizedBox(width: GameTheme.spaceMd),
                Expanded(
                  child: Text(
                    'Hủy ván hiện tại và bắt đầu lại.',
                    style: GameTheme.bodyStyle.copyWith(color: GameTheme.textSecondary),
                  ),
                ),
              ],
            ),
            actions: [
              IconActionButton(
                icon: GameIcons.cancel,
                semanticsLabel: GameIcons.semanticsLabel(GameIcons.cancel),
                onPressed: () => Navigator.pop(context),
              ),
              IconActionButton(
                icon: GameIcons.confirm,
                semanticsLabel: 'Đồng ý chơi lại',
                color: GameTheme.accent,
                onPressed: () {
                  Navigator.pop(context);
                  _controller.resetGame(widget.mode);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRulesOverlay() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: GameTheme.cardBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(GameIcons.rules, color: Colors.white, size: 32),
                const SizedBox(height: 16),
                _ruleRow(GameIcons.sow, 'Rải từng viên theo chiều chọn'),
                _ruleRow(GameIcons.pick, 'Nhặt tiếp nếu ô sau có quân'),
                _ruleRow(GameIcons.capture, 'Ăn khi ô sau trống, ô kế có quân'),
                _ruleRow(GameIcons.stop, 'Dừng khi chạm Ô Quan'),
                _ruleRow(GameIcons.refill, 'Hết quân → rải 5 từ kho'),
                const SizedBox(height: 12),
                IconActionButton(
                  icon: GameIcons.cancel,
                  semanticsLabel: 'Đóng',
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _ruleRow(IconData icon, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: GameTheme.primaryP2),
          const SizedBox(width: 10),
          Expanded(
            child: Text(hint, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}