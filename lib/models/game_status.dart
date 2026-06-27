enum StatusKind {
  idle,
  pick,
  sow,
  capture,
  stop,
  refill,
  borrow,
  turn,
  gameOver,
}

class GameStatus {
  final StatusKind kind;
  final int? squareIndex;
  final int? count;
  final bool hasMandarin;
  final int? player;
  final String? winnerLabel;

  const GameStatus({
    required this.kind,
    this.squareIndex,
    this.count,
    this.hasMandarin = false,
    this.player,
    this.winnerLabel,
  });

  factory GameStatus.idle() => const GameStatus(kind: StatusKind.idle);

  factory GameStatus.pick({required int squareIndex, required int count}) =>
      GameStatus(kind: StatusKind.pick, squareIndex: squareIndex, count: count);

  factory GameStatus.sow({required int squareIndex, required int count}) =>
      GameStatus(kind: StatusKind.sow, squareIndex: squareIndex, count: count);

  factory GameStatus.capture({
    required int squareIndex,
    required int count,
    bool mandarin = false,
  }) =>
      GameStatus(
        kind: StatusKind.capture,
        squareIndex: squareIndex,
        count: count,
        hasMandarin: mandarin,
      );

  factory GameStatus.stop({String? reason}) => GameStatus(
        kind: StatusKind.stop,
        winnerLabel: reason,
      );

  factory GameStatus.refill({required int count}) =>
      GameStatus(kind: StatusKind.refill, count: count);

  factory GameStatus.borrow({required int count}) =>
      GameStatus(kind: StatusKind.borrow, count: count);

  factory GameStatus.turn({required int player}) =>
      GameStatus(kind: StatusKind.turn, player: player);

  factory GameStatus.gameOver({required String winnerLabel}) =>
      GameStatus(kind: StatusKind.gameOver, winnerLabel: winnerLabel);
}