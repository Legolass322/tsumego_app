class Coord implements Comparable<Coord> {
  final int x;
  final int y;
  const Coord(this.x, this.y);

  List<Coord> around() {
    // TODO: adjust to custom board sizes
    return [
      if (x + 1 < 19) Coord(x + 1, y),
      if (y + 1 < 19) Coord(x, y + 1),
      if (x - 1 >= 0) Coord(x - 1, y),
      if (y - 1 >= 0) Coord(x, y - 1),
    ];
  }

  @override
  bool operator==(other) => other is Coord && hashCode == other.hashCode;
  @override
  int get hashCode {
    return x * 19 + y;
  }
  @override
  int compareTo(Coord other) {
    return other.hashCode - hashCode;
  }
}