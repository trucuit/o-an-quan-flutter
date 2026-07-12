/// Human-readable pit labels (no internal indices in UI copy).
abstract final class SquareNames {
  static String display(int index) {
    return switch (index) {
      11 => 'Ô Quan trái',
      5 => 'Ô Quan phải',
      0 => 'Ô dưới 1',
      1 => 'Ô dưới 2',
      2 => 'Ô dưới 3',
      3 => 'Ô dưới 4',
      4 => 'Ô dưới 5',
      10 => 'Ô trên 1',
      9 => 'Ô trên 2',
      8 => 'Ô trên 3',
      7 => 'Ô trên 4',
      6 => 'Ô trên 5',
      _ => 'Ô $index',
    };
  }
}