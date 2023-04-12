import 'package:args/args.dart';
import 'package:benchmark_runner/benchmark_runner.dart';
import 'package:dart_utils/dart_utils.dart';
import 'package:drtree/drtree.dart';
import 'package:drtree_benchmark/drtree_benchmark.dart';

class DrtreeCreateBenchmark extends SyncBenchmark<DRTree> {
  final int _minChildCount;

  final int _maxChildCount;

  final List<BenchmarkPoint> _points;

  DrtreeCreateBenchmark({
    required int minChildCount,
    required int maxChildCount,
    required List<BenchmarkPoint> points,
  })  : _minChildCount = minChildCount,
        _maxChildCount = maxChildCount,
        _points = points;

  @override
  DRTree run() {
    final tree = DRTree(
      minChildCount: _minChildCount,
      maxChildCount: _maxChildCount,
    );

    for (var i = 0; i < _points.length; i++) {
      tree.addPoint(_points[i]);
    }

    return tree;
  }
}

class DrtreeSearchBenchmark extends SyncBenchmark<List<Point>> {
  final DRTree _tree;

  final Rectangle _rectangle;

  DrtreeSearchBenchmark(DRTree tree, Rectangle rectangle)
      : _tree = tree,
        _rectangle = rectangle;

  @override
  List<Point> run() {
    final points = _tree.search(_rectangle);

    return points;
  }
}

const inputOptionName = 'input';
const inputOptionAbbr = 'i';

const outputOptionName = 'output';
const outputOptionAbbr = 'o';

const minChildCountOptionName = 'min-child-count';
const minChildCountOptionAbbr = 'm';

const maxChildCountOptionName = 'max-child-count';
const maxChildCountOptionAbbr = 'a';

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
    minChildCountOptionName,
    abbr: minChildCountOptionAbbr,
    defaultsTo: defaultMinChildCount.toString(),
  )
  ..addOption(
    maxChildCountOptionName,
    abbr: maxChildCountOptionAbbr,
    defaultsTo: defaultMaxChildCount.toString(),
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

DrtreeBenchmarkLog runBenchmark({
  required int minChildCount,
  required int maxChildCount,
  required BenchmarkPoints points,
  required CompileType compileType,
  required bool logPoints,
}) {
  final createResult = runner.runSync(benchmarks: [
    DrtreeCreateBenchmark(
      minChildCount: minChildCount,
      maxChildCount: maxChildCount,
      points: points.points,
    )
  ]);

  final tree = createResult.values.first;

  final searchResult = runner.runSync(
      benchmarks: points.rectangles
          .map((e) => DrtreeSearchBenchmark(
              tree, Rectangle.fromPoints([e.first, e.second])))
          .toList());

  return DrtreeBenchmarkLog(
    createTime: createResult.time.microseconds,
    compileType: compileType,
    createMemory: createResult.memory.bytes,
    time: searchResult.time.microseconds,
    memory: searchResult.memory.bytes,
    times: searchResult.times.map((e) => e.microseconds).toList(),
    memories: searchResult.memories.map((e) => e.bytes).toList(),
    iterations: points.rectangles.length,
    pointsCount: searchResult.values.map((e) => e.length).toList().sum(),
    points: logPoints
        ? searchResult.values
            .map((e) => e.map((e) => BenchmarkPoint(x: e.x, y: e.y)).toList())
            .toList()
        : null,
    minChildCount: minChildCount,
    maxChildCount: maxChildCount,
  );
}

Future<void> writeLog(String path, DrtreeBenchmarkLog log) async {
  final json = log.toJson();

  await writer.writeJson(path, json);
}

void main(List<String> args) async {
  final result = parser.parse(args);

  final input = result[inputOptionName];
  final output = result[outputOptionName];
  final minChildCount = int.parse(result[minChildCountOptionName]);
  final maxChildCount = int.parse(result[maxChildCountOptionName]);
  final compileType = getCompileType(result[compileTypeOptionName]);
  final logPoints = result[logPointsOptionName] == 'true';

  final points = await reader.read(input);

  final log = runBenchmark(
    minChildCount: minChildCount,
    maxChildCount: maxChildCount,
    points: points,
    compileType: compileType,
    logPoints: logPoints,
  );

  await writeLog(output, log);
}
