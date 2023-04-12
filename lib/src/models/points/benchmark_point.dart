import 'package:json_annotation/json_annotation.dart';
import 'package:drtree/drtree.dart';

part 'benchmark_point.g.dart';

@JsonSerializable()
class BenchmarkPoint extends Point {
  BenchmarkPoint({
    required super.x,
    required super.y,
  });

  factory BenchmarkPoint.fromJson(Map<String, Object?> json) =>
      _$BenchmarkPointFromJson(json);

  Map<String, Object?> toJson() => _$BenchmarkPointToJson(this);
}
