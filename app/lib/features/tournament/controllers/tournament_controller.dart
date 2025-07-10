import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/foundation.dart';

import '../models/tournament.dart';
import '../models/match.dart';
import '../usecases/swiss_pairing_usecase.dart';
import '../repositories/tournament_repository.dart';
import '../repositories/match_repository.dart';
import '../../player/models/player.dart';
import '../../player/repositories/player_repository.dart';
import '../../../core/repositories/memory_repositories.dart';
import '../../../core/services/firebase_service.dart';

class TournamentState {
  final Tournament? tournament;
  final List<Player> players;
  final List<Match> matches;
  final bool isLoading;
  final String? error;

  TournamentState({
    this.tournament,
    this.players = const [],
    this.matches = const [],
    this.isLoading = false,
    this.error,
  });

  TournamentState copyWith({
    Tournament? tournament,
    List<Player>? players,
    List<Match>? matches,
    bool? isLoading,
    String? error,
  }) {
    return TournamentState(
      tournament: tournament ?? this.tournament,
      players: players ?? this.players,
      matches: matches ?? this.matches,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class TournamentController extends StateNotifier<TournamentState> {
  final SwissPairingUseCase _swissPairingUseCase;
  final TournamentRepository _tournamentRepository;
  final PlayerRepository _playerRepository;
  final MatchRepository _matchRepository;
  
  StreamSubscription<Tournament?>? _tournamentSubscription;
  StreamSubscription<List<Player>>? _playersSubscription;
  StreamSubscription<List<Match>>? _matchesSubscription;

  TournamentController(
    this._swissPairingUseCase,
    this._tournamentRepository,
    this._playerRepository,
    this._matchRepository,
  ) : super(TournamentState());

  @override
  void dispose() {
    _tournamentSubscription?.cancel();
    _playersSubscription?.cancel();
    _matchesSubscription?.cancel();
    super.dispose();
  }

  Future<void> loadTournament(String tournamentId) async {
    if (state.tournament?.id == tournamentId) return;
    
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // 既存のサブスクリプションをキャンセル
      await _cancelSubscriptions();
      
      // 大会データをリアルタイム監視
      _tournamentSubscription = _tournamentRepository.watchTournament(tournamentId).listen(
        (tournament) {
          if (tournament != null) {
            state = state.copyWith(tournament: tournament, isLoading: false);
          } else {
            state = state.copyWith(
              error: '大会が見つかりません',
              isLoading: false,
            );
          }
        },
        onError: (error) {
          debugPrint('Tournament watch error: $error');
          state = state.copyWith(
            error: error.toString(),
            isLoading: false,
          );
        },
      );
      
      // プレイヤーデータをリアルタイム監視
      _playersSubscription = _playerRepository.watchPlayersByTournament(tournamentId).listen(
        (players) {
          state = state.copyWith(players: players);
        },
        onError: (error) {
          debugPrint('Players watch error: $error');
        },
      );
      
      // マッチデータをリアルタイム監視
      _matchesSubscription = _matchRepository.watchMatchesByTournament(tournamentId).listen(
        (matches) {
          state = state.copyWith(matches: matches);
        },
        onError: (error) {
          debugPrint('Matches watch error: $error');
        },
      );
      
    } catch (e) {
      debugPrint('Load tournament error: $e');
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }
  
  Future<void> _cancelSubscriptions() async {
    await _tournamentSubscription?.cancel();
    await _playersSubscription?.cancel();
    await _matchesSubscription?.cancel();
    _tournamentSubscription = null;
    _playersSubscription = null;
    _matchesSubscription = null;
  }

  Future<void> addPlayer(Player player) async {
    try {
      await _playerRepository.createPlayer(player);
      // リアルタイム更新により自動で状態が更新される
    } catch (e) {
      debugPrint('Add player error: $e');
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  Future<void> removePlayer(String playerId) async {
    try {
      await _playerRepository.deactivatePlayer(playerId);
      // リアルタイム更新により自動で状態が更新される
    } catch (e) {
      debugPrint('Remove player error: $e');
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  Future<void> generateNextRound() async {
    final tournament = state.tournament;
    if (tournament == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final pairings = _swissPairingUseCase.generatePairings(
        tournament: tournament,
        players: state.players,
        previousMatches: state.matches,
      );

      final updatedTournament = tournament.copyWith(
        currentRound: tournament.currentRound + 1,
        status: TournamentStatus.inProgress,
      );

      // Firestoreに同時保存
      await Future.wait([
        _tournamentRepository.updateTournament(updatedTournament),
        _matchRepository.createMatches(pairings),
      ]);
      
      state = state.copyWith(isLoading: false);
      // リアルタイム更新により自動で状態が更新される
    } catch (e) {
      debugPrint('Generate next round error: $e');
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> updateMatchResult(String matchId, MatchResult result, {String? reportedBy}) async {
    try {
      final match = state.matches.firstWhere((m) => m.id == matchId);
      final updatedMatch = match.copyWith(
        result: result,
        reportedBy: reportedBy,
        reportedAt: DateTime.now(),
      );
      
      await _matchRepository.updateMatch(updatedMatch);
      // リアルタイム更新により自動で状態が更新される
    } catch (e) {
      debugPrint('Update match result error: $e');
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  List<Match> getCurrentRoundMatches() {
    final tournament = state.tournament;
    if (tournament == null) return [];
    
    return state.matches
        .where((match) => match.round == tournament.currentRound)
        .toList();
  }

  List<PlayerStanding> getStandings() {
    final tournament = state.tournament;
    if (tournament == null) return [];

    return _calculateStandings(state.players, state.matches);
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
    
    standings.sort((a, b) => b.points.compareTo(a.points));
    return standings;
  }

  // デバッグ用のダミーデータ追加
  Future<void> addDummyPlayers() async {
    final tournamentId = state.tournament?.id ?? '';
    if (tournamentId.isEmpty) return;
    
    final dummyPlayers = [
      Player(id: '${tournamentId}_1', tournamentId: tournamentId, name: 'プレイヤー1'),
      Player(id: '${tournamentId}_2', tournamentId: tournamentId, name: 'プレイヤー2'),
      Player(id: '${tournamentId}_3', tournamentId: tournamentId, name: 'プレイヤー3'),
      Player(id: '${tournamentId}_4', tournamentId: tournamentId, name: 'プレイヤー4'),
      Player(id: '${tournamentId}_5', tournamentId: tournamentId, name: 'プレイヤー5'),
      Player(id: '${tournamentId}_6', tournamentId: tournamentId, name: 'プレイヤー6'),
      Player(id: '${tournamentId}_7', tournamentId: tournamentId, name: 'プレイヤー7'),
      Player(id: '${tournamentId}_8', tournamentId: tournamentId, name: 'プレイヤー8'),
    ];
    
    try {
      // 並列でプレイヤーを作成
      await Future.wait(
        dummyPlayers.map((player) => _playerRepository.createPlayer(player)),
      );
    } catch (e) {
      debugPrint('Add dummy players error: $e');
      state = state.copyWith(error: e.toString());
    }
  }
}

// Repository プロバイダー（Firestore実装使用、フォールバック付き）
final tournamentRepositoryProvider = Provider<TournamentRepository>((ref) {
  try {
    debugPrint('TournamentRepository初期化中...');
    debugPrint('Firebase初期化状態: ${FirebaseService.isInitialized}');
    
    if (FirebaseService.isInitialized) {
      debugPrint('FirestoreTournamentRepository を使用');
      return FirestoreTournamentRepository();
    } else {
      debugPrint('Firebase not initialized, using memory repository');
      return MemoryTournamentRepository();
    }
  } catch (e) {
    debugPrint('Error initializing tournament repository: $e');
    return MemoryTournamentRepository();
  }
});

final playerRepositoryProvider = Provider<PlayerRepository>((ref) {
  try {
    debugPrint('PlayerRepository初期化中...');
    
    if (FirebaseService.isInitialized) {
      debugPrint('FirestorePlayerRepository を使用');
      return FirestorePlayerRepository();
    } else {
      debugPrint('Firebase not initialized, using memory repository');
      return MemoryPlayerRepository();
    }
  } catch (e) {
    debugPrint('Error initializing player repository: $e');
    return MemoryPlayerRepository();
  }
});

final matchRepositoryProvider = Provider<MatchRepository>((ref) {
  try {
    debugPrint('MatchRepository初期化中...');
    
    if (FirebaseService.isInitialized) {
      debugPrint('FirestoreMatchRepository を使用');
      return FirestoreMatchRepository();
    } else {
      debugPrint('Firebase not initialized, using memory repository');
      return MemoryMatchRepository();
    }
  } catch (e) {
    debugPrint('Error initializing match repository: $e');
    return MemoryMatchRepository();
  }
});

// SwissPairingUseCase プロバイダー
final swissPairingUseCaseProvider = Provider<SwissPairingUseCase>((ref) {
  return SwissPairingUseCase();
});

// TournamentController プロバイダー
final tournamentControllerProvider = StateNotifierProvider<TournamentController, TournamentState>((ref) {
  return TournamentController(
    ref.read(swissPairingUseCaseProvider),
    ref.read(tournamentRepositoryProvider),
    ref.read(playerRepositoryProvider),
    ref.read(matchRepositoryProvider),
  );
});

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