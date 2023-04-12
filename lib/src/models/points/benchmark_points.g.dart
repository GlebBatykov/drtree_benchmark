// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'benchmark_points.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BenchmarkPoints _$BenchmarkPointsFromJson(Map<String, dynamic> json) =>
    BenchmarkPoints(
      points: (json['points'] as List<dynamic>)
          .map((e) => BenchmarkPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      rectangles: (json['rectangles'] as List<dynamic>)
          .map((e) => RectanglePoints.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BenchmarkPointsToJson(BenchmarkPoints instance) =>
    <String, dynamic>{
      'points': instance.points,
      'rectangles': instance.rectangles,
    };
