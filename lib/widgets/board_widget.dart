import 'package:flutter/material.dart';
import '../models/board_square.dart';
import '../theme/game_theme.dart';
import 'board/board_painter.dart';
import 'game/game_layout.dart';
import 'direction_selector.dart';
import 'square_widget.dart';

class BoardWidget extends StatelessWidget {
  final List<BoardSquare> board;
  final int activePlayer;
  final int? selectedIndex;
  final bool isAnimating;
  final Function(int) onSquareTap;
  final void Function(bool clockwise)? onDirectionSelect;
  final VoidCallback? onCancelDirection;

  /// Horizontal padding reserved on each side. Landscape reserves room for the
  /// overlay rails; portrait passes a small value since rails sit above/below.
  final double sideGutter;

  const BoardWidget({
    super.key,
    required this.board,
    required this.activePlayer,
    required this.selectedIndex,
    required this.isAnimating,
    required this.onSquareTap,
    this.onDirectionSelect,
    this.onCancelDirection,
    this.sideGutter = GameLayout.railGutterWidth,
  });

  /// Width : height ratio that keeps the pits from stretching. The board is
  /// centered and letterboxed so portrait shows a correctly-proportioned board
  /// instead of tall, narrow pits.
  static const double boardAspectRatio = 2.4;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: boardAspectRatio,
        child: _buildBoard(context),
      ),
    );
  }

  Widget _buildBoard(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double totalHeight = constraints.maxHeight;
        const double rowGap = 4;
        const double cellVerticalPadding = 4; // symmetric 2px top + bottom per row
        final double unitHeight = ((totalHeight - rowGap - cellVerticalPadding * 2) / 2)
            .clamp(20.0, totalHeight / 2);
        final double mandarinHeight = unitHeight * 2 + rowGap + cellVerticalPadding;

        return CustomPaint(
          painter: const BoardPainter(),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(GameTheme.radiusCard),
              border: Border.all(
                color: GameTheme.woodDeep.withValues(alpha: 0.5),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: sideGutter),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              // Left Mandarin Square (Index 11)
              Expanded(
                flex: 11,
                child: SizedBox(
                  height: mandarinHeight,
                  child: SquareWidget(
                    square: board[11],
                    isSelectable: false,
                    isSelected: selectedIndex == 11,
                    onTap: () {},
                  ),
                ),
              ),
              const SizedBox(width: 4),

              // Citizen Squares column (5x2 grid)
              Expanded(
                flex: 50,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top Row: Player 2 (Indices 10, 9, 8, 7, 6 from left to right)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [10, 9, 8, 7, 6].map((index) {
                        bool isSelectable = activePlayer == 2 &&
                            !isAnimating &&
                            board[index].citizenCount > 0;
                        return Expanded(
                          child: _citizenPitCell(
                            index: index,
                            unitHeight: unitHeight,
                            isSelectable: isSelectable,
                            pickerBelow: true,
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: rowGap),
                    // Bottom Row: Player 1 (Indices 0, 1, 2, 3, 4 from left to right)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [0, 1, 2, 3, 4].map((index) {
                        bool isSelectable = activePlayer == 1 &&
                            !isAnimating &&
                            board[index].citizenCount > 0;
                        return Expanded(
                          child: _citizenPitCell(
                            index: index,
                            unitHeight: unitHeight,
                            isSelectable: isSelectable,
                            pickerBelow: false,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),

              // Right Mandarin Square (Index 5)
              Expanded(
                flex: 11,
                child: SizedBox(
                  height: mandarinHeight,
                  child: SquareWidget(
                    square: board[5],
                    isSelectable: false,
                    isSelected: selectedIndex == 5,
                    onTap: () {},
                  ),
                ),
              ),
              ],
            ),
            ),
          ),
        );
      },
    );
  }

  Widget _citizenPitCell({
    required int index,
    required double unitHeight,
    required bool isSelectable,
    required bool pickerBelow,
  }) {
    final isSelected = selectedIndex == index;
    final showPicker = isSelected &&
        onDirectionSelect != null &&
        onCancelDirection != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
      child: SizedBox(
        height: unitHeight,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            IgnorePointer(
              ignoring: showPicker,
              child: SquareWidget(
                square: board[index],
                isSelectable: isSelectable,
                isSelected: isSelected,
                onTap: () => onSquareTap(index),
              ),
            ),
            if (showPicker)
              Positioned(
                left: 2,
                right: 2,
                top: pickerBelow ? null : 4,
                bottom: pickerBelow ? 4 : null,
                child: DirectionSelector(
                  squareIndex: index,
                  onDirectionSelect: onDirectionSelect!,
                  onCancel: onCancelDirection!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
