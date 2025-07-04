// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MatchImpl _$$MatchImplFromJson(Map<String, dynamic> json) => _$MatchImpl(
      id: json['id'] as String,
      tournamentId: json['tournamentId'] as String,
      round: (json['round'] as num).toInt(),
      player1Id: json['player1Id'] as String,
      player2Id: json['player2Id'] as String?,
      result: $enumDecodeNullable(_$MatchResultEnumMap, json['result']) ??
          MatchResult.pending,
      reportedBy: json['reportedBy'] as String?,
      reportedAt:
          const TimestampConverter().fromJson(json['reportedAt'] as Timestamp?),
    );

Map<String, dynamic> _$$MatchImplToJson(_$MatchImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tournamentId': instance.tournamentId,
      'round': instance.round,
      'player1Id': instance.player1Id,
      'player2Id': instance.player2Id,
      'result': _$MatchResultEnumMap[instance.result]!,
      'reportedBy': instance.reportedBy,
      'reportedAt': const TimestampConverter().toJson(instance.reportedAt),
    };

const _$MatchResultEnumMap = {
  MatchResult.player1Win: 'player1_win',
  MatchResult.player2Win: 'player2_win',
  MatchResult.draw: 'draw',
  MatchResult.bye: 'bye',
  MatchResult.pending: 'pending',
};
