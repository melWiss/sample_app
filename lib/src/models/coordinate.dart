class Coordinate {
  int? x;
  int? y;

  Coordinate({this.x, this.y});

  factory Coordinate.fromList(List<int> l) {
    return Coordinate(
      x: l.first,
      y: l.last,
    );
  }

  List<int> toList() {
    return [x ?? 0, y ?? 0];
  }
}
