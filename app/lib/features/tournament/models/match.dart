import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'match.freezed.dart';
part 'match.g.dart';

@freezed
class Match with _$Match {
  const factory Match({
    required String id,
    required String tournamentId,
    required int round,
    required String player1Id,
    String? player2Id, // null の場合は不戦勝
    @Default(MatchResult.pending) MatchResult result,
    String? reportedBy,
    @TimestampConverter() DateTime? reportedAt,
  }) = _Match;

  factory Match.fromJson(Map<String, dynamic> json) =>
      _$MatchFromJson(json);
}

enum MatchResult {
  @JsonValue('player1_win')
  player1Win,
  @JsonValue('player2_win')
  player2Win,
  @JsonValue('draw')
  draw,
  @JsonValue('bye')
  bye,
  @JsonValue('pending')
  pending,
}

class TimestampConverter implements JsonConverter<DateTime?, Timestamp?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Timestamp? timestamp) => timestamp?.toDate();

  @override
  Timestamp? toJson(DateTime? date) =>
      date != null ? Timestamp.fromDate(date) : null;
}