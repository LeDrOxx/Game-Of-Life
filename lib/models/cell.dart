class Cell {
  int x, y;
  bool alive;

  Cell({
    required this.x,
    required this.y,
    required this.alive,
  });

  Cell copyWith({
    int? x,
    int? y,
    bool? alive,
  }) {
    return Cell(
      x: x ?? this.x,
      y: y ?? this.y,
      alive: alive ?? this.alive,
    );
  }
}