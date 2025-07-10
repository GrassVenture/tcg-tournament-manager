import 'dart:math';

import '../models/tournament.dart';
import '../models/match.dart';
import '../../player/models/player.dart';

class SwissPairingUseCase {
  List<Match> generatePairings({
    required Tournament tournament,
    required List<Player> players,
    required List<Match> previousMatches,
  }) {
    if (players.isEmpty) {
      return [];
    }

    final activePlayers = players.where((p) => p.isActive).toList();
    final currentRound = tournament.currentRound + 1;
    
    // 各プレイヤーの戦績を計算
    final playerStandings = _calculateStandings(activePlayers, previousMatches);
    
    // 勝ち点順でソート
    playerStandings.sort((a, b) => b.points.compareTo(a.points));
    
    // ペアリング生成
    final pairings = _generateSwissPairings(
      playerStandings,
      previousMatches,
      tournament.id,
      currentRound,
    );

    return pairings;
  }

  List<PlayerStanding> _calculateStandings(
    List<Player> players,
    List<Match> matches,
  ) {
    final standings = <PlayerStanding>[];
    
    for (final player in players) {
      int wins = 0;
      int losses = 0;
      int draws = 0;
      int byes = 0;
      final opponents = <String>[];
      
      for (final match in matches) {
        if (match.player1Id == player.id) {
          if (match.player2Id == null) {
            byes++;
          } else {
            opponents.add(match.player2Id!);
            switch (match.result) {
              case MatchResult.player1Win:
                wins++;
                break;
              case MatchResult.player2Win:
                losses++;
                break;
              case MatchResult.draw:
                draws++;
                break;
              case MatchResult.bye:
                byes++;
                break;
              case MatchResult.pending:
                break;
            }
          }
        } else if (match.player2Id == player.id) {
          opponents.add(match.player1Id);
          switch (match.result) {
            case MatchResult.player1Win:
              losses++;
              break;
            case MatchResult.player2Win:
              wins++;
              break;
            case MatchResult.draw:
              draws++;
              break;
            case MatchResult.bye:
              byes++;
              break;
            case MatchResult.pending:
              break;
          }
        }
      }
      
      final points = wins * 3 + draws * 1 + byes * 3;
      
      standings.add(PlayerStanding(
        player: player,
        wins: wins,
        losses: losses,
        draws: draws,
        byes: byes,
        points: points,
        opponents: opponents,
      ));
    }
    
    return standings;
  }

  List<Match> _generateSwissPairings(
    List<PlayerStanding> standings,
    List<Match> previousMatches,
    String tournamentId,
    int round,
  ) {
    final pairings = <Match>[];
    final unpaired = List<PlayerStanding>.from(standings);
    
    while (unpaired.length > 1) {
      final player1 = unpaired.removeAt(0);
      PlayerStanding? player2;
      
      // 同じ勝ち点の相手を探す
      for (int i = 0; i < unpaired.length; i++) {
        final candidate = unpaired[i];
        if (candidate.points == player1.points && 
            !player1.opponents.contains(candidate.player.id)) {
          player2 = unpaired.removeAt(i);
          break;
        }
      }
      
      // 同じ勝ち点の相手がいない場合、最も近い勝ち点の相手を探す
      if (player2 == null) {
        for (int i = 0; i < unpaired.length; i++) {
          final candidate = unpaired[i];
          if (!player1.opponents.contains(candidate.player.id)) {
            player2 = unpaired.removeAt(i);
            break;
          }
        }
      }
      
      // それでも相手がいない場合、既に対戦した相手でもペアリング
      if (player2 == null && unpaired.isNotEmpty) {
        player2 = unpaired.removeAt(0);
      }
      
      if (player2 != null) {
        pairings.add(Match(
          id: _generateMatchId(tournamentId, round, player1.player.id, player2.player.id),
          tournamentId: tournamentId,
          round: round,
          player1Id: player1.player.id,
          player2Id: player2.player.id,
          result: MatchResult.pending,
        ));
      }
    }
    
    // 奇数人数の場合、最後の1人に不戦勝を与える
    if (unpaired.length == 1) {
      final byePlayer = unpaired.first;
      pairings.add(Match(
        id: _generateMatchId(tournamentId, round, byePlayer.player.id, null),
        tournamentId: tournamentId,
        round: round,
        player1Id: byePlayer.player.id,
        player2Id: null,
        result: MatchResult.bye,
      ));
    }
    
    return pairings;
  }

  String _generateMatchId(String tournamentId, int round, String player1Id, String? player2Id) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(1000);
    return '${tournamentId}_${round}_${player1Id}_${player2Id ?? 'bye'}_${timestamp}_$random';
  }
}

class PlayerStanding {
  final Player player;
  final int wins;
  final int losses;
  final int draws;
  final int byes;
  final int points;
  final List<String> opponents;

  PlayerStanding({
    required this.player,
    required this.wins,
    required this.losses,
    required this.draws,
    required this.byes,
    required this.points,
    required this.opponents,
  });
}