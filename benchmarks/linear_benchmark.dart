import 'package:args/args.dart';
import 'package:benchmark_runner/benchmark_runner.dart';
import 'package:dart_utils/dart_utils.dart';
import 'package:drtree/drtree.dart';
import 'package:drtree_benchmark/drtree_benchmark.dart';

class LinearBenchmark extends SyncBenchmark<List<Point>> {
  final List<Point> _points;

  final Rectangle _rectangle;

  LinearBenchmark(List<Point> points, Rectangle rectangle)
      : _points = points,
        _rectangle = rectangle;

  @override
  List<Point> run() {
    final part = <Point>[];

    for (var i = 0; i < _points.length; i++) {
      if (_points[i].enters(_rectangle)) {
        part.add(_points[i]);
      }
    }

    return part;
  }
}

const inputOptionName = 'input';
const inputOptionAbbr = 'i';

const outputOptionName = 'output';
const outputOptionAbbr = 'o';

const compileTypeOptionName = 'compile-type';
const compileTypeOptionAbbr = 'c';

const logPointsOptionName = 'log-points';
const logPointsOptionAbbr = 'l';

final parser = ArgParser()
  ..addOption(
    inputOptionName,
    abbr: inputOptionAbbr,
  )
  ..addOption(
    outputOptionName,
    abbr: outputOptionAbbr,
  )
  ..addOption(
    compileTypeOptionName,
    abbr: compileTypeOptionAbbr,
  )
  ..addOption(
    logPointsOptionName,
    abbr: logPointsOptionAbbr,
    defaultsTo: 'false',
  );

final reader = PointsReader();

const writer = FileWriter();

const runner = BenchmarkRunner();

CompileType getCompileType(String value) =>
    CompileType.values.firstWhere((e) => e.name == value);

LinearBenchmarkLog runBenchmark({
  required BenchmarkPoints points,
  required CompileType compileType,
  required bool logPoints,
}) {
  final result = runner.runSync(
      benchmarks: points.rectangles
          .map((e) => LinearBenchmark(
              points.points, Rectangle.fromPoints([e.first, e.second])))
          .toList());

  return LinearBenchmarkLog(
    compileType: compileType,
    time: result.time.microseconds,
    memory: result.memory.bytes,
    times: result.times.map((e) => e.microseconds).toList(),
    memories: result.memories.map((e) => e.bytes).toList(),
    iterations: points.rectangles.length,
    pointsCount: result.values.map((e) => e.length).toList().sum(),
    points: logPoints
        ? result.values
            .map((e) => e.map((e) => BenchmarkPoint(x: e.x, y: e.y)).toList())
            .toList()
        : null,
  );
}

Future<void> writeLog(String path, LinearBenchmarkLog log) async {
  final json = log.toJson();

  await writer.writeJson(path, json);
}

void main(List<String> args) async {
  final result = parser.parse(args);

  final input = result[inputOptionName];
  final output = result[outputOptionName];
  final compileType = getCompileType(result[compileTypeOptionName]);
  final logPoints = result[logPointsOptionName] == 'true';

  final points = await reader.read(input);

  final log = runBenchmark(
    points: points,
    compileType: compileType,
    logPoints: logPoints,
  );

  await writeLog(output, log);
}
