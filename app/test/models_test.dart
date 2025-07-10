import 'package:flutter_test/flutter_test.dart';
import 'package:tcg_tournament_manager/features/tournament/models/tournament.dart';
import 'package:tcg_tournament_manager/features/tournament/models/match.dart';
import 'package:tcg_tournament_manager/features/player/models/player.dart';

void main() {
  group('Data Models JSON Serialization', () {
    test('Tournament model serialization', () {
      final tournament = Tournament(
        id: 'test_tournament',
        name: 'Test Tournament',
        maxPlayers: 16,
        currentRound: 1,
        totalRounds: 4,
        drawHandling: DrawHandling.bothLose,
        status: TournamentStatus.inProgress,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 2),
      );

      // JSON シリアライゼーションテスト
      final json = tournament.toJson();
      final deserializedTournament = Tournament.fromJson(json);

      expect(deserializedTournament.id, equals(tournament.id));
      expect(deserializedTournament.name, equals(tournament.name));
      expect(deserializedTournament.maxPlayers, equals(tournament.maxPlayers));
      expect(deserializedTournament.currentRound, equals(tournament.currentRound));
      expect(deserializedTournament.totalRounds, equals(tournament.totalRounds));
      expect(deserializedTournament.drawHandling, equals(tournament.drawHandling));
      expect(deserializedTournament.status, equals(tournament.status));
    });

    test('Player model serialization', () {
      final player = Player(
        id: 'test_player',
        tournamentId: 'test_tournament',
        name: 'Test Player',
        joinedAt: DateTime(2024, 1, 1),
        isActive: true,
      );

      // JSON シリアライゼーションテスト
      final json = player.toJson();
      final deserializedPlayer = Player.fromJson(json);

      expect(deserializedPlayer.id, equals(player.id));
      expect(deserializedPlayer.tournamentId, equals(player.tournamentId));
      expect(deserializedPlayer.name, equals(player.name));
      expect(deserializedPlayer.isActive, equals(player.isActive));
    });

    test('Match model serialization', () {
      final match = Match(
        id: 'test_match',
        tournamentId: 'test_tournament',
        round: 1,
        player1Id: 'player1',
        player2Id: 'player2',
        result: MatchResult.player1Win,
        reportedBy: 'admin',
        reportedAt: DateTime(2024, 1, 1),
      );

      // JSON シリアライゼーションテスト
      final json = match.toJson();
      final deserializedMatch = Match.fromJson(json);

      expect(deserializedMatch.id, equals(match.id));
      expect(deserializedMatch.tournamentId, equals(match.tournamentId));
      expect(deserializedMatch.round, equals(match.round));
      expect(deserializedMatch.player1Id, equals(match.player1Id));
      expect(deserializedMatch.player2Id, equals(match.player2Id));
      expect(deserializedMatch.result, equals(match.result));
      expect(deserializedMatch.reportedBy, equals(match.reportedBy));
    });

    test('Match model with bye serialization', () {
      final byeMatch = Match(
        id: 'test_bye_match',
        tournamentId: 'test_tournament',
        round: 1,
        player1Id: 'player1',
        player2Id: null, // 不戦勝
        result: MatchResult.bye,
      );

      // JSON シリアライゼーションテスト
      final json = byeMatch.toJson();
      final deserializedMatch = Match.fromJson(json);

      expect(deserializedMatch.id, equals(byeMatch.id));
      expect(deserializedMatch.tournamentId, equals(byeMatch.tournamentId));
      expect(deserializedMatch.round, equals(byeMatch.round));
      expect(deserializedMatch.player1Id, equals(byeMatch.player1Id));
      expect(deserializedMatch.player2Id, isNull);
      expect(deserializedMatch.result, equals(MatchResult.bye));
    });
  });
}