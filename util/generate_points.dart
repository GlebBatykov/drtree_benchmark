import 'dart:math' hide Point;

import 'package:args/args.dart';
import 'package:dart_utils/dart_utils.dart';
import 'package:drtree_benchmark/drtree_benchmark.dart';

const pathOptionName = 'path';
const pathOptionAbbr = 'p';

const pointsCountOptionName = 'points-count';
const pointsCountOptionAbbr = 'c';

const rectanglesCountOptionName = 'rectangles-count';
const rectanglesCountOptionAbbr = 'q';

const rangeOptionName = 'range';
const rangeOptionAbbr = 'r';

final parser = ArgParser()
  ..addOption(
    pathOptionName,
    abbr: pathOptionAbbr,
  )
  ..addOption(
    pointsCountOptionName,
    abbr: pointsCountOptionAbbr,
  )
  ..addOption(
    rectanglesCountOptionName,
    abbr: rectanglesCountOptionAbbr,
  )
  ..addOption(
    rangeOptionName,
    abbr: rangeOptionAbbr,
  );

final random = Random();

final writer = FileWriter();

List<BenchmarkPoint> generatePoints(int count, int range) {
  final points = <BenchmarkPoint>[];

  for (var i = 0; i < count; i++) {
    late BenchmarkPoint point;

    do {
      point = BenchmarkPoint(
        x: random.nextInt(range).toDouble(),
        y: random.nextInt(range).toDouble(),
      );
    } while (points.contains(point));

    points.add(point);
  }

  return points;
}

List<RectanglePoints> generateRectangles(
  int count,
  List<BenchmarkPoint> points,
) {
  final rectangles = <RectanglePoints>[];

  for (var i = 0; i < count; i++) {
    late RectanglePoints rectangle;

    do {
      final first = points[random.nextInt(points.length)];

      late BenchmarkPoint second;

      do {
        second = points[random.nextInt(points.length)];
      } while (first == second);

      rectangle = RectanglePoints(
        first: first,
        second: second,
      );
    } while (rectangles.contains(rectangle));

    rectangles.add(rectangle);
  }

  return rectangles;
}

Future<void> writeToFile(String path, BenchmarkPoints points) async {
  final json = points.toJson();

  await writer.writeJson(path, json);
}

void main(List<String> args) async {
  final result = parser.parse(args);

  final path = result[pathOptionName];
  final pointsCount = int.parse(result[pointsCountOptionName]);
  final rectanglesCount = int.parse(result[rectanglesCountOptionName]);
  final range = int.parse(result[rangeOptionName]);

  final points = generatePoints(pointsCount, range);

  final rectangles = generateRectangles(rectanglesCount, points);

  await writeToFile(
    path,
    BenchmarkPoints(
      points: points,
      rectangles: rectangles,
    ),
  );
}
