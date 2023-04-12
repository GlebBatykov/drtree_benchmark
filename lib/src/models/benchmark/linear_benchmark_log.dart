import 'package:json_annotation/json_annotation.dart';

import '../../drtree_benchmark.dart';
import '../points/benchmark_point.dart';
import 'benchmark_log.dart';

part 'linear_benchmark_log.g.dart';

@JsonSerializable()
class LinearBenchmarkLog extends BenchmarkLog {
  LinearBenchmarkLog({
    required super.compileType,
    required super.time,
    required super.memory,
    required super.times,
    required super.memories,
    required super.iterations,
    required super.pointsCount,
    super.points,
  }) : super(benchmarkType: BenchmarkType.linear);

  factory LinearBenchmarkLog.fromJson(Map<String, Object?> json) =>
      _$LinearBenchmarkLogFromJson(json);

  Map<String, Object?> toJson() => _$LinearBenchmarkLogToJson(this);
}
