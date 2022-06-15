class Coordinate {
  double? x;
  double? y;

  Coordinate({this.x, this.y});

  factory Coordinate.fromList(List<double> l) {
    return Coordinate(
      x: l.first,
      y: l.last,
    );
  }

  List<double> toList() {
    return [x ?? 0, y ?? 0];
  }
}
