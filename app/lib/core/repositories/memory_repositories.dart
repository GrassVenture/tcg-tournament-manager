// 開発用メモリ内Repository実装（Firebase設定完了まで使用）

import 'dart:async';
import 'package:flutter/foundation.dart';

import '../../features/tournament/models/tournament.dart';
import '../../features/tournament/models/match.dart';
import '../../features/tournament/repositories/tournament_repository.dart';
import '../../features/tournament/repositories/match_repository.dart';
import '../../features/player/models/player.dart';
import '../../features/player/repositories/player_repository.dart';

class MemoryTournamentRepository implements TournamentRepository {
  static final Map<String, Tournament> _tournaments = {};
  static final StreamController<Tournament?> _tournamentController = StreamController.broadcast();
  
  @override
  Future<Tournament> createTournament(Tournament tournament) async {
    _tournaments[tournament.id] = tournament;
    _tournamentController.add(tournament);
    debugPrint('Created tournament: ${tournament.name}');
    return tournament;
  }

  @override
  Future<Tournament?> getTournament(String id) async {
    return _tournaments[id];
  }

  @override
  Future<void> updateTournament(Tournament tournament) async {
    _tournaments[tournament.id] = tournament;
    _tournamentController.add(tournament);
    debugPrint('Updated tournament: ${tournament.name}');
  }

  @override
  Future<void> deleteTournament(String id) async {
    _tournaments.remove(id);
  }

  @override
  Stream<Tournament?> watchTournament(String id) {
    return _tournamentController.stream
        .where((tournament) => tournament?.id == id)
        .map((tournament) => tournament);
  }

  @override
  Stream<List<Tournament>> watchAllTournaments() {
    return Stream.value(_tournaments.values.toList());
  }
}

class MemoryPlayerRepository implements PlayerRepository {
  static final Map<String, Player> _players = {};
  static final StreamController<List<Player>> _playersController = StreamController.broadcast();

  @override
  Future<Player> createPlayer(Player player) async {
    _players[player.id] = player;
    _notifyPlayersChanged();
    debugPrint('Created player: ${player.name}');
    return player;
  }

  @override
  Future<Player?> getPlayer(String id) async {
    return _players[id];
  }

  @override
  Future<void> updatePlayer(Player player) async {
    _players[player.id] = player;
    _notifyPlayersChanged();
  }

  @override
  Future<void> deletePlayer(String id) async {
    _players.remove(id);
    _notifyPlayersChanged();
  }

  @override
  Future<List<Player>> getPlayersByTournament(String tournamentId) async {
    return _players.values
        .where((player) => player.tournamentId == tournamentId && player.isActive)
        .toList();
  }

  @override
  Stream<List<Player>> watchPlayersByTournament(String tournamentId) {
    return _playersController.stream.map((players) =>
        players.where((player) => 
            player.tournamentId == tournamentId && player.isActive).toList());
  }

  @override
  Stream<Player?> watchPlayer(String id) {
    return _playersController.stream
        .map((players) {
          try {
            return players.firstWhere((p) => p.id == id);
          } catch (e) {
            return null;
          }
        });
  }

  @override
  Future<void> deactivatePlayer(String playerId) async {
    final player = _players[playerId];
    if (player != null) {
      _players[playerId] = player.copyWith(isActive: false);
      _notifyPlayersChanged();
    }
  }

  void _notifyPlayersChanged() {
    _playersController.add(_players.values.toList());
  }
}

class MemoryMatchRepository implements MatchRepository {
  static final Map<String, Match> _matches = {};
  static final StreamController<List<Match>> _matchesController = StreamController.broadcast();

  @override
  Future<Match> createMatch(Match match) async {
    _matches[match.id] = match;
    _notifyMatchesChanged();
    debugPrint('Created match: ${match.id}');
    return match;
  }

  @override
  Future<Match?> getMatch(String id) async {
    return _matches[id];
  }

  @override
  Future<void> updateMatch(Match match) async {
    _matches[match.id] = match;
    _notifyMatchesChanged();
    debugPrint('Updated match: ${match.id} - ${match.result}');
  }

  @override
  Future<void> deleteMatch(String id) async {
    _matches.remove(id);
    _notifyMatchesChanged();
  }

  @override
  Future<List<Match>> getMatchesByTournament(String tournamentId) async {
    return _matches.values
        .where((match) => match.tournamentId == tournamentId)
        .toList();
  }

  @override
  Future<List<Match>> getMatchesByTournamentAndRound(String tournamentId, int round) async {
    return _matches.values
        .where((match) => match.tournamentId == tournamentId && match.round == round)
        .toList();
  }

  @override
  Stream<List<Match>> watchMatchesByTournament(String tournamentId) {
    return _matchesController.stream.map((matches) =>
        matches.where((match) => match.tournamentId == tournamentId).toList());
  }

  @override
  Stream<List<Match>> watchMatchesByTournamentAndRound(String tournamentId, int round) {
    return _matchesController.stream.map((matches) =>
        matches.where((match) => 
            match.tournamentId == tournamentId && match.round == round).toList());
  }

  @override
  Stream<Match?> watchMatch(String id) {
    return _matchesController.stream
        .map((matches) {
          try {
            return matches.firstWhere((m) => m.id == id);
          } catch (e) {
            return null;
          }
        });
  }

  @override
  Future<void> createMatches(List<Match> matches) async {
    for (final match in matches) {
      _matches[match.id] = match;
    }
    _notifyMatchesChanged();
    debugPrint('Created ${matches.length} matches');
  }

  void _notifyMatchesChanged() {
    _matchesController.add(_matches.values.toList());
  }
}