// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TournamentImpl _$$TournamentImplFromJson(Map<String, dynamic> json) =>
    _$TournamentImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      maxPlayers: (json['maxPlayers'] as num).toInt(),
      currentRound: (json['currentRound'] as num?)?.toInt() ?? 0,
      totalRounds: (json['totalRounds'] as num).toInt(),
      drawHandling:
          $enumDecodeNullable(_$DrawHandlingEnumMap, json['drawHandling']) ??
              DrawHandling.bothLose,
      status: $enumDecodeNullable(_$TournamentStatusEnumMap, json['status']) ??
          TournamentStatus.registration,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp?),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Timestamp?),
    );

Map<String, dynamic> _$$TournamentImplToJson(_$TournamentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'maxPlayers': instance.maxPlayers,
      'currentRound': instance.currentRound,
      'totalRounds': instance.totalRounds,
      'drawHandling': _$DrawHandlingEnumMap[instance.drawHandling]!,
      'status': _$TournamentStatusEnumMap[instance.status]!,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };

const _$DrawHandlingEnumMap = {
  DrawHandling.bothLose: 'both_lose',
  DrawHandling.drawPoint: 'draw_point',
};

const _$TournamentStatusEnumMap = {
  TournamentStatus.registration: 'registration',
  TournamentStatus.inProgress: 'in_progress',
  TournamentStatus.completed: 'completed',
};
