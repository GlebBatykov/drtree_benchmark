// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drtree_benchmark_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DrtreeBenchmarkLog _$DrtreeBenchmarkLogFromJson(Map<String, dynamic> json) =>
    DrtreeBenchmarkLog(
      createTime: json['createTime'] as int,
      createMemory: json['createMemory'] as int,
      minChildCount: json['minChildCount'] as int,
      maxChildCount: json['maxChildCount'] as int,
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

Map<String, dynamic> _$DrtreeBenchmarkLogToJson(DrtreeBenchmarkLog instance) =>
    <String, dynamic>{
      'compileType': _$CompileTypeEnumMap[instance.compileType]!,
      'time': instance.time,
      'memory': instance.memory,
      'times': instance.times,
      'memories': instance.memories,
      'iterations': instance.iterations,
      'pointsCount': instance.pointsCount,
      'points': instance.points,
      'createTime': instance.createTime,
      'createMemory': instance.createMemory,
      'minChildCount': instance.minChildCount,
      'maxChildCount': instance.maxChildCount,
    };

const _$CompileTypeEnumMap = {
  CompileType.jit: 'jit',
  CompileType.aot: 'aot',
};
