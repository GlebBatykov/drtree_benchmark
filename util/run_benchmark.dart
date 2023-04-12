import 'dart:io';

import 'package:args/args.dart';
import 'package:drtree_benchmark/drtree_benchmark.dart';

const pointsGeneratorPath = 'generate_points.dart';
const assetsFolderPath = '../assets';
const logFolderPath = '../logs';

const linearBenchmarkEntryPointPath = '../benchmarks/linear_benchmark.dart';
const linearBenchmarkExecutablePath = '../benchmarks/linear_benchmark.exe';

const drtreeBenchmarkEntryPointPath = '../benchmarks/drtree_banchmark.dart';
const drtreeBenchmarkExecutablePath = '../benchmarks/drtree_banchmark.exe';

const runModeOptionName = 'run-mode';
const runModeOptionAbbr = 'r';

const compileTypeOptionName = 'compile-type';
const compileTypeOptionAbbr = 'c';

const regeneratePointsOptionName = 'regenerate-points';
const regeneratePointsOptionAbbr = 'g';

final parser = ArgParser()
  ..addOption(
    runModeOptionName,
    abbr: runModeOptionAbbr,
    defaultsTo: defaultRunMode.name,
    allowed: RunMode.values.map((e) => e.name),
  )
  ..addOption(
    compileTypeOptionName,
    abbr: compileTypeOptionAbbr,
    defaultsTo: defaultCompileType.name,
    allowed: CompileType.values.map((e) => e.name),
  )
  ..addOption(
    regeneratePointsOptionName,
    abbr: regeneratePointsOptionAbbr,
    defaultsTo: 'false',
    allowed: [
      'true',
      'false',
    ],
  );

RunMode getRunMode(String value) =>
    RunMode.values.firstWhere((e) => e.name == value);

CompileType getCompileMode(String value) =>
    CompileType.values.firstWhere((e) => e.name == value);

bool getRegeneratePoints(String value) => value == 'true';

const linearParameters = <BenchmarkParameters>[
  BenchmarkParameters(
    pointsParameters: PointsParameters(
      pointsCount: 100,
      rectanglesCount: 10,
    ),
  ),
  BenchmarkParameters(
    pointsParameters: PointsParameters(
      pointsCount: 500,
      rectanglesCount: 25,
    ),
  ),
  BenchmarkParameters(
    pointsParameters: PointsParameters(
      pointsCount: 1000,
      rectanglesCount: 50,
    ),
  ),
  BenchmarkParameters(
    pointsParameters: PointsParameters(
      pointsCount: 2500,
      rectanglesCount: 100,
    ),
  ),
  BenchmarkParameters(
    pointsParameters: PointsParameters(
      pointsCount: 5000,
      rectanglesCount: 100,
    ),
  ),
  BenchmarkParameters(
    pointsParameters: PointsParameters(
      pointsCount: 10000,
      rectanglesCount: 100,
    ),
  ),
  BenchmarkParameters(
    pointsParameters: PointsParameters(
      pointsCount: 100000,
      rectanglesCount: 100,
    ),
  )
];

final drtreeParameters = <BenchmarkParameters>[
  BenchmarkParameters(
    pointsParameters: PointsParameters(
      pointsCount: 100,
      rectanglesCount: 10,
    ),
    arguments: createDrtreeArguments(3, 7),
  ),
  BenchmarkParameters(
    pointsParameters: PointsParameters(
      pointsCount: 500,
      rectanglesCount: 25,
    ),
    arguments: createDrtreeArguments(3, 7),
  ),
  BenchmarkParameters(
    pointsParameters: PointsParameters(
      pointsCount: 1000,
      rectanglesCount: 100,
    ),
    arguments: createDrtreeArguments(3, 7),
  ),
  BenchmarkParameters(
    pointsParameters: PointsParameters(
      pointsCount: 2500,
      rectanglesCount: 100,
    ),
    arguments: createDrtreeArguments(4, 8),
  ),
  BenchmarkParameters(
    pointsParameters: PointsParameters(
      pointsCount: 5000,
      rectanglesCount: 100,
    ),
    arguments: createDrtreeArguments(4, 8),
  ),
  BenchmarkParameters(
    pointsParameters: PointsParameters(
      pointsCount: 10000,
      rectanglesCount: 100,
    ),
    arguments: createDrtreeArguments(5, 12),
  ),
  BenchmarkParameters(
    pointsParameters: PointsParameters(
      pointsCount: 100000,
      rectanglesCount: 100,
    ),
    arguments: createDrtreeArguments(5, 12),
  ),
];

List<String> createDrtreeArguments(int minChildCount, int maxChildCount) => [
      '-m',
      minChildCount.toString(),
      '-a',
      maxChildCount.toString(),
    ];

Future<void> generatePoints(RunMode mode, bool regeneratePoints) async {
  late List<PointsParameters> parameters;

  switch (mode) {
    case RunMode.all:
      parameters = [
        ...linearParameters.map((e) => e.pointsParameters),
        ...drtreeParameters.map((e) => e.pointsParameters),
      ];
      break;
    case RunMode.linear:
      parameters = linearParameters.map((e) => e.pointsParameters).toList();
      break;
    case RunMode.drtree:
      parameters = drtreeParameters.map((e) => e.pointsParameters).toList();
  }

  parameters = parameters.toSet().toList();

  final futures = <Future>[];

  for (var i = 0; i < parameters.length; i++) {
    final pointsCount = parameters[i].pointsCount;

    final rectanglesCount = parameters[i].rectanglesCount;

    final pointsPath = getPointsPath(pointsCount, rectanglesCount);

    final pointsPathFile = File.fromUri(Uri.file(pointsPath));

    if (regeneratePoints || !await pointsPathFile.exists()) {
      final future = Process.run(
        'dart',
        [
          pointsGeneratorPath,
          '-p',
          pointsPath,
          '-c',
          pointsCount.toString(),
          '-q',
          rectanglesCount.toString(),
          '-r',
          pointsCount.toString(),
        ],
        runInShell: true,
      );

      futures.add(future);
    }
  }

  await Future.wait(futures);
}

String getPointsPath(int pointsCount, int rectanglesCount) =>
    '$assetsFolderPath/${pointsCount}_points_${rectanglesCount}_rectangles.json';

Future<void> runBenchmark(RunMode runMode, CompileType compileMode) async {
  final folderName = getFolderName();

  final folderPath = '$logFolderPath/$folderName - ${compileMode.name}';

  switch (runMode) {
    case RunMode.all:
      await runLinearBenchmark(folderPath, compileMode);
      await runDrtreeBenchmark(folderPath, compileMode);
      break;
    case RunMode.linear:
      await runLinearBenchmark(folderPath, compileMode);
      break;
    case RunMode.drtree:
      await runDrtreeBenchmark(folderPath, compileMode);
  }
}

String getFolderName() {
  final now = DateTime.now();

  return '${now.day}.${now.month}.${now.year} - ${now.hour}.${now.minute}.${now.second}.${now.millisecond}';
}

Future<void> runLinearBenchmark(String folderPath, CompileType mode) async {
  for (var i = 0; i < linearParameters.length; i++) {
    final parameter = linearParameters[i];

    final pointsCount = parameter.pointsParameters.pointsCount;

    final rectanglesCount = parameter.pointsParameters.rectanglesCount;

    final logFileName =
        '${pointsCount}_points_${rectanglesCount}_rectangles.json';

    final logPath = '$folderPath/linear/$logFileName';

    final pointsPath = getPointsPath(pointsCount, rectanglesCount);

    switch (mode) {
      case CompileType.jit:
        await runBenchmarkInJIT(
          entryPointPath: linearBenchmarkEntryPointPath,
          pointsPath: pointsPath,
          logPath: logPath,
          parameters: parameter,
        );
        break;
      case CompileType.aot:
        await runBenchmarkInAOT(
          entryPointPath: linearBenchmarkEntryPointPath,
          executablePath: linearBenchmarkExecutablePath,
          pointsPath: pointsPath,
          logPath: logPath,
          parameters: parameter,
        );
    }
  }
}

Future<void> runDrtreeBenchmark(String folderPath, CompileType mode) async {
  for (var i = 0; i < drtreeParameters.length; i++) {
    final parameter = drtreeParameters[i];

    final pointsCount = parameter.pointsParameters.pointsCount;

    final rectanglesCount = parameter.pointsParameters.rectanglesCount;

    final logFileName =
        '${pointsCount}_points_${rectanglesCount}_rectangles.json';

    final logPath = '$folderPath/drtree/$logFileName';

    final pointsPath = getPointsPath(pointsCount, rectanglesCount);

    switch (mode) {
      case CompileType.jit:
        await runBenchmarkInJIT(
          entryPointPath: drtreeBenchmarkEntryPointPath,
          pointsPath: pointsPath,
          logPath: logPath,
          parameters: parameter,
        );
        break;
      case CompileType.aot:
        await runBenchmarkInAOT(
          entryPointPath: drtreeBenchmarkEntryPointPath,
          executablePath: drtreeBenchmarkExecutablePath,
          pointsPath: pointsPath,
          logPath: logPath,
          parameters: parameter,
        );
    }
  }
}

Future<void> runBenchmarkInJIT({
  required String entryPointPath,
  required String pointsPath,
  required String logPath,
  required BenchmarkParameters parameters,
}) async {
  final process = await Process.start(
    'dart',
    [
      entryPointPath,
      '-i',
      pointsPath,
      '-o',
      logPath,
      '-c',
      CompileType.jit.name,
      ...parameters.arguments ?? [],
    ],
    runInShell: true,
  );

  process.stdout.listen((event) => stdout.add(event));
  process.stderr.listen((event) => stderr.add(event));

  await process.exitCode;
}

Future<void> runBenchmarkInAOT({
  required String entryPointPath,
  required String executablePath,
  required String pointsPath,
  required String logPath,
  required BenchmarkParameters parameters,
}) async {
  await Process.run(
    'dart',
    [
      'compile',
      'exe',
      entryPointPath,
    ],
    runInShell: true,
  );

  final process = await Process.start(
    executablePath,
    [
      '-i',
      pointsPath,
      '-o',
      logPath,
      '-c',
      CompileType.aot.name,
      ...parameters.arguments ?? [],
    ],
  );

  process.stdout.listen((event) => stdout.add(event));
  process.stderr.listen((event) => stderr.add(event));

  await process.exitCode;
}

void main(List<String> args) async {
  final result = parser.parse(args);

  final runMode = getRunMode(result[runModeOptionName]);
  final compileType = getCompileMode(result[compileTypeOptionName]);
  final regeneratePoints =
      getRegeneratePoints(result[regeneratePointsOptionName]);

  await generatePoints(runMode, regeneratePoints);

  await runBenchmark(runMode, compileType);
}
