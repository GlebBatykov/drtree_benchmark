import 'package:json_annotation/json_annotation.dart';

import '../../drtree_benchmark.dart';
import '../points/benchmark_point.dart';
import 'benchmark_log.dart';

part 'drtree_benchmark_log.g.dart';

@JsonSerializable()
class DrtreeBenchmarkLog extends BenchmarkLog {
  final int createTime;

  final int createMemory;

  final int minChildCount;

  final int maxChildCount;

  DrtreeBenchmarkLog({
    required this.createTime,
    required this.createMemory,
    required this.minChildCount,
    required this.maxChildCount,
    required super.compileType,
    required super.time,
    required super.memory,
    required super.times,
    required super.memories,
    required super.iterations,
    required super.pointsCount,
    super.points,
  }) : super(benchmarkType: BenchmarkType.drtree);

  factory DrtreeBenchmarkLog.fromJson(Map<String, Object?> json) =>
      _$DrtreeBenchmarkLogFromJson(json);

  Map<String, Object?> toJson() => _$DrtreeBenchmarkLogToJson(this);
}
