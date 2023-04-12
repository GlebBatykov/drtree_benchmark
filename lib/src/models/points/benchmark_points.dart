import 'package:json_annotation/json_annotation.dart';

import 'benchmark_point.dart';
import 'rectangle_points.dart';

part 'benchmark_points.g.dart';

@JsonSerializable()
class BenchmarkPoints {
  final List<BenchmarkPoint> points;

  final List<RectanglePoints> rectangles;

  BenchmarkPoints({
    required this.points,
    required this.rectangles,
  });

  factory BenchmarkPoints.fromJson(Map<String, Object?> json) =>
      _$BenchmarkPointsFromJson(json);

  Map<String, Object?> toJson() => _$BenchmarkPointsToJson(this);
}
