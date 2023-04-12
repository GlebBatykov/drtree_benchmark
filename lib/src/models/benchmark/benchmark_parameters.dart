part of drtree_benchmark;

class BenchmarkParameters {
  final PointsParameters pointsParameters;

  final List<String>? arguments;

  const BenchmarkParameters({
    required this.pointsParameters,
    this.arguments,
  });
}

class PointsParameters {
  final int pointsCount;

  final int rectanglesCount;

  const PointsParameters({
    required this.pointsCount,
    required this.rectanglesCount,
  });

  @override
  bool operator ==(other) {
    if (other is PointsParameters) {
      return pointsCount == other.pointsCount &&
          rectanglesCount == other.rectanglesCount;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(pointsCount, rectanglesCount);
}
