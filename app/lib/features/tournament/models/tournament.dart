import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'tournament.freezed.dart';
part 'tournament.g.dart';

@freezed
class Tournament with _$Tournament {
  const factory Tournament({
    required String id,
    required String name,
    required int maxPlayers,
    @Default(0) int currentRound,
    required int totalRounds,
    @Default(DrawHandling.bothLose) DrawHandling drawHandling,
    @Default(TournamentStatus.registration) TournamentStatus status,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  }) = _Tournament;

  factory Tournament.fromJson(Map<String, dynamic> json) =>
      _$TournamentFromJson(json);
}

enum DrawHandling {
  @JsonValue('both_lose')
  bothLose,
  @JsonValue('draw_point')
  drawPoint,
}

enum TournamentStatus {
  @JsonValue('registration')
  registration,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
}

class TimestampConverter implements JsonConverter<DateTime?, Timestamp?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Timestamp? timestamp) => timestamp?.toDate();

  @override
  Timestamp? toJson(DateTime? date) =>
      date != null ? Timestamp.fromDate(date) : null;
}