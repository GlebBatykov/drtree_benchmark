// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rectangle_points.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RectanglePoints _$RectanglePointsFromJson(Map<String, dynamic> json) =>
    RectanglePoints(
      first: BenchmarkPoint.fromJson(json['first'] as Map<String, dynamic>),
      second: BenchmarkPoint.fromJson(json['second'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RectanglePointsToJson(RectanglePoints instance) =>
    <String, dynamic>{
      'first': instance.first,
      'second': instance.second,
    };
