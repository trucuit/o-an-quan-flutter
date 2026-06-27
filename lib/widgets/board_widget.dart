import 'package:flutter/material.dart';
import '../models/board_square.dart';
import '../models/game_state.dart';
import 'square_widget.dart';

class BoardWidget extends StatelessWidget {
  final List<BoardSquare> board;
  final int activePlayer;
  final int? selectedIndex;
  final bool isAnimating;
  final Function(int) onSquareTap;

  const BoardWidget({
    super.key,
    required this.board,
    required this.activePlayer,
    required this.selectedIndex,
    required this.isAnimating,
    required this.onSquareTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate dynamic dimensions based on screen space
        final double totalWidth = constraints.maxWidth;
        final double totalHeight = constraints.maxHeight;

        // The board layout consists of: [Left Mandarin (1 unit)] + [5 Citizen Squares (5 units)] + [Right Mandarin (1 unit)] = 7 units wide + spacing
        // Width needs ~7.2 units, Height needs ~2.2 units + 16px padding.
        final double maxUnitWidth = totalWidth / 7.2;
        final double maxUnitHeight = totalHeight / 2.4; 
        
        // Ensure the unit respects both constraints (aspect ratio unitHeight = unitWidth * 1.1)
        final double unitWidthByWidth = maxUnitWidth;
        final double unitWidthByHeight = maxUnitHeight / 1.1;
        
        final double unitWidth = unitWidthByWidth < unitWidthByHeight ? unitWidthByWidth : unitWidthByHeight;
        final double unitHeight = unitWidth * 1.1;

        return Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.05),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left Mandarin Square (Index 11)
              SizedBox(
                width: unitWidth * 1.1,
                height: unitHeight * 2 + 8, // Spans both rows + spacing
                child: SquareWidget(
                  square: board[11],
                  isSelectable: false,
                  isSelected: selectedIndex == 11,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 4),

              // Citizen Squares column (5x2 grid)
              Expanded(
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
                            child: SizedBox(
                              height: unitHeight,
                              child: SquareWidget(
                                square: board[index],
                                isSelectable: isSelectable,
                                isSelected: selectedIndex == index,
                                onTap: () => onSquareTap(index),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 4),
                    // Bottom Row: Player 1 (Indices 0, 1, 2, 3, 4 from left to right)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [0, 1, 2, 3, 4].map((index) {
                        bool isSelectable = activePlayer == 1 &&
                            !isAnimating &&
                            board[index].citizenCount > 0;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
                            child: SizedBox(
                              height: unitHeight,
                              child: SquareWidget(
                                square: board[index],
                                isSelectable: isSelectable,
                                isSelected: selectedIndex == index,
                                onTap: () => onSquareTap(index),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),

              // Right Mandarin Square (Index 5)
              SizedBox(
                width: unitWidth * 1.1,
                height: unitHeight * 2 + 8, // Spans both rows + spacing
                child: SquareWidget(
                  square: board[5],
                  isSelectable: false,
                  isSelected: selectedIndex == 5,
                  onTap: () {},
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
