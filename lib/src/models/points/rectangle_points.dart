import 'package:json_annotation/json_annotation.dart';

import 'benchmark_point.dart';

part 'rectangle_points.g.dart';

@JsonSerializable()
class RectanglePoints {
  final BenchmarkPoint first;

  final BenchmarkPoint second;

  RectanglePoints({
    required this.first,
    required this.second,
  });

  factory RectanglePoints.fromJson(Map<String, Object?> json) =>
      _$RectanglePointsFromJson(json);

  Map<String, Object?> toJson() => _$RectanglePointsToJson(this);

  @override
  bool operator ==(other) {
    if (other is RectanglePoints) {
      return first == other.first && second == other.second;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(first, second);
}
