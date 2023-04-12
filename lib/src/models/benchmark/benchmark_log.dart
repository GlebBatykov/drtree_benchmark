import 'package:drtree_benchmark/drtree_benchmark.dart';

abstract class BenchmarkLog {
  final BenchmarkType benchmarkType;

  final CompileType compileType;

  final int time;

  final int memory;

  final List<int> times;

  final List<int> memories;

  final int iterations;

  final int pointsCount;

  final List<List<BenchmarkPoint>>? points;

  BenchmarkLog({
    required this.benchmarkType,
    required this.compileType,
    required this.time,
    required this.memory,
    required this.times,
    required this.memories,
    required this.iterations,
    required this.pointsCount,
    required this.points,
  });
}
