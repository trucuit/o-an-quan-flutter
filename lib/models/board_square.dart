class BoardSquare {
  final int index;
  final bool isMandarin;
  int citizenCount;
  bool hasMandarin;

  BoardSquare({
    required this.index,
    required this.isMandarin,
    required this.citizenCount,
    required this.hasMandarin,
  });

  int get value => citizenCount + (hasMandarin ? 5 : 0);

  bool get isEmpty => citizenCount == 0 && !hasMandarin;

  BoardSquare copyWith({
    int? citizenCount,
    bool? hasMandarin,
  }) {
    return BoardSquare(
      index: index,
      isMandarin: isMandarin,
      citizenCount: citizenCount ?? this.citizenCount,
      hasMandarin: hasMandarin ?? this.hasMandarin,
    );
  }
}
