import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../audio/sound_player.dart';
import '../controllers/game_controller.dart';
import '../models/game_state.dart';
import '../models/game_status.dart';
import '../theme/app_breakpoints.dart';
import '../theme/game_theme.dart';
import '../widgets/board_widget.dart';
import '../widgets/haptics.dart';
import '../widgets/game/game_bottom_hud.dart';
import '../widgets/game/game_layout.dart';
import '../widgets/game/game_over_overlay.dart';
import '../widgets/game/game_player_rail.dart';
import '../widgets/game/game_reset_dialog.dart';
import '../widgets/game/game_rules_dialog.dart';
import '../widgets/game/game_top_bar.dart';

class GameScreen extends StatefulWidget {
  final GameMode mode;

  const GameScreen({super.key, required this.mode});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameController _controller;
  GameStatus? _lastFeedbackStatus;

  @override
  void initState() {
    super.initState();
    _controller = GameController(mode: widget.mode);
    _lastFeedbackStatus = _controller.state.currentStatus;
    _controller.addListener(_emitFeedback);
    _enterFullScreen();
  }

  /// Fires haptics + SFX as the controller streams per-step move frames.
  void _emitFeedback() {
    final status = _controller.state.currentStatus;
    if (status == null || identical(status, _lastFeedbackStatus)) return;
    _lastFeedbackStatus = status;
    switch (status.kind) {
      case StatusKind.pick:
      case StatusKind.sow:
        Haptics.tick();
        SoundPlayer.instance.sow();
      case StatusKind.capture:
        Haptics.capture();
        SoundPlayer.instance.capture();
      case StatusKind.refill:
      case StatusKind.borrow:
        Haptics.tick();
      case StatusKind.idle:
      case StatusKind.stop:
      case StatusKind.turn:
      case StatusKind.gameOver:
        break;
    }
  }

  void _enterFullScreen() {
    // Immersive fullscreen only makes sense on mobile; desktop/web stay
    // edge-to-edge (set globally in main).
    final isMobile = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);
    if (!isMobile) return;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _controller.removeListener(_emitFeedback);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final state = _controller.state;
        final selected = _controller.selectedSquareIndex;
        final isGameOver = state.phase == GamePhase.gameOver;

        return Scaffold(
          backgroundColor: GameTheme.background,
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: GameLayout.arenaPadding(context),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Column(
                  children: [
                    GameTopBar(
                      mode: widget.mode,
                      canNavigateBack: !_controller.isAnimating,
                      onBack: () => Navigator.pop(context),
                      onRestart: _confirmRestart,
                    ),
                    Expanded(child: _buildArena(state, selected)),
                    GameBottomHud(
                      status: state.currentStatus,
                      canUndo: !_controller.isAnimating && !isGameOver,
                      isAnimating: _controller.isAnimating,
                      mode: state.mode,
                      activePlayer: state.activePlayer,
                      onUndo: _controller.undo,
                      onRules: () => showGameRulesDialog(context),
                    ),
                  ],
                ),
                if (isGameOver)
                  GameOverOverlay(
                    state: state,
                    onHome: () => Navigator.pop(context),
                    onRestart: () => _controller.resetGame(widget.mode),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildArena(GameState state, int? selected) {
    return AppBreakpoints.isLandscape(context)
        ? _buildLandscapeArena(state, selected)
        : _buildPortraitArena(state, selected);
  }

  /// Landscape: board fills width, rails overlay the side gutters.
  Widget _buildLandscapeArena(GameState state, int? selected) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _board(state, selected),
        Positioned(
          left: 0,
          width: GameLayout.railGutterWidth,
          top: 0,
          bottom: 0,
          child: Align(
            alignment: const Alignment(0, GameLayout.railAlignP2Y),
            child: _playerRail(state, 2, Axis.vertical),
          ),
        ),
        Positioned(
          right: 0,
          width: GameLayout.railGutterWidth,
          top: 0,
          bottom: 0,
          child: Align(
            alignment: const Alignment(0, GameLayout.railAlignP1Y),
            child: _playerRail(state, 1, Axis.vertical),
          ),
        ),
      ],
    );
  }

  /// Portrait: rails stack above (P2) and below (P1) the board.
  Widget _buildPortraitArena(GameState state, int? selected) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: GameTheme.spaceSm),
          child: _playerRail(state, 2, Axis.horizontal),
        ),
        Expanded(child: _board(state, selected, sideGutter: GameTheme.spaceSm)),
        Padding(
          padding: const EdgeInsets.only(top: GameTheme.spaceSm),
          child: _playerRail(state, 1, Axis.horizontal),
        ),
      ],
    );
  }

  Widget _board(GameState state, int? selected, {double? sideGutter}) {
    return BoardWidget(
      board: state.board,
      activePlayer: state.activePlayer,
      selectedIndex: selected,
      isAnimating: _controller.isAnimating,
      onSquareTap: _controller.selectSquare,
      onDirectionSelect: selected != null ? _controller.playMove : null,
      onCancelDirection: selected != null ? _controller.cancelSelection : null,
      sideGutter: sideGutter ?? GameLayout.railGutterWidth,
    );
  }

  Widget _playerRail(GameState state, int playerNumber, Axis axis) {
    final isP1 = playerNumber == 1;
    return GamePlayerRail(
      playerNumber: playerNumber,
      isActive: state.activePlayer == playerNumber && state.phase != GamePhase.gameOver,
      score: isP1 ? state.player1Score : state.player2Score,
      citizenPool: isP1 ? state.player1CapturedPool : state.player2CapturedPool,
      mandarinPool: isP1 ? state.player1MandarinCaptured : state.player2MandarinCaptured,
      debt: isP1 ? state.player1Debt : state.player2Debt,
      mode: state.mode,
      axis: axis,
    );
  }

  Future<void> _confirmRestart() async {
    final confirmed = await showGameResetDialog(context);
    if (confirmed == true && mounted) {
      _controller.resetGame(widget.mode);
    }
  }
}