// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerImpl _$$PlayerImplFromJson(Map<String, dynamic> json) => _$PlayerImpl(
      id: json['id'] as String,
      tournamentId: json['tournamentId'] as String,
      name: json['name'] as String,
      joinedAt:
          const TimestampConverter().fromJson(json['joinedAt'] as Timestamp?),
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$PlayerImplToJson(_$PlayerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tournamentId': instance.tournamentId,
      'name': instance.name,
      'joinedAt': const TimestampConverter().toJson(instance.joinedAt),
      'isActive': instance.isActive,
    };
