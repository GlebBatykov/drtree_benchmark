// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'linear_benchmark_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LinearBenchmarkLog _$LinearBenchmarkLogFromJson(Map<String, dynamic> json) =>
    LinearBenchmarkLog(
      compileType: $enumDecode(_$CompileTypeEnumMap, json['compileType']),
      time: json['time'] as int,
      memory: json['memory'] as int,
      times: (json['times'] as List<dynamic>).map((e) => e as int).toList(),
      memories:
          (json['memories'] as List<dynamic>).map((e) => e as int).toList(),
      iterations: json['iterations'] as int,
      pointsCount: json['pointsCount'] as int,
      points: (json['points'] as List<dynamic>?)
          ?.map((e) => (e as List<dynamic>)
              .map((e) => BenchmarkPoint.fromJson(e as Map<String, dynamic>))
              .toList())
          .toList(),
    );

Map<String, dynamic> _$LinearBenchmarkLogToJson(LinearBenchmarkLog instance) =>
    <String, dynamic>{
      'compileType': _$CompileTypeEnumMap[instance.compileType]!,
      'time': instance.time,
      'memory': instance.memory,
      'times': instance.times,
      'memories': instance.memories,
      'iterations': instance.iterations,
      'pointsCount': instance.pointsCount,
      'points': instance.points,
    };

const _$CompileTypeEnumMap = {
  CompileType.jit: 'jit',
  CompileType.aot: 'aot',
};
