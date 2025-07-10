import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../core/services/firebase_service.dart';
import '../models/match.dart';

abstract class MatchRepository {
  Future<Match> createMatch(Match match);
  Future<Match?> getMatch(String id);
  Future<void> updateMatch(Match match);
  Future<void> deleteMatch(String id);
  Future<List<Match>> getMatchesByTournament(String tournamentId);
  Future<List<Match>> getMatchesByTournamentAndRound(String tournamentId, int round);
  Stream<List<Match>> watchMatchesByTournament(String tournamentId);
  Stream<List<Match>> watchMatchesByTournamentAndRound(String tournamentId, int round);
  Stream<Match?> watchMatch(String id);
  Future<void> createMatches(List<Match> matches);
}

class FirestoreMatchRepository implements MatchRepository {
  CollectionReference get _collection => FirebaseService.matches;

  @override
  Future<Match> createMatch(Match match) async {
    try {
      final docRef = _collection.doc(match.id);
      await docRef.set(match.toJson());
      return match;
    } catch (e) {
      debugPrint('Error creating match: $e');
      rethrow;
    }
  }

  @override
  Future<Match?> getMatch(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) return null;
      
      final data = doc.data() as Map<String, dynamic>;
      return Match.fromJson(data);
    } catch (e) {
      debugPrint('Error getting match: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateMatch(Match match) async {
    try {
      final matchWithTimestamp = match.copyWith(
        reportedAt: match.result != MatchResult.pending ? DateTime.now() : null,
      );
      
      await _collection.doc(match.id).update(matchWithTimestamp.toJson());
    } catch (e) {
      debugPrint('Error updating match: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteMatch(String id) async {
    try {
      await _collection.doc(id).delete();
    } catch (e) {
      debugPrint('Error deleting match: $e');
      rethrow;
    }
  }

  @override
  Future<List<Match>> getMatchesByTournament(String tournamentId) async {
    try {
      final query = await _collection
          .where('tournamentId', isEqualTo: tournamentId)
          .orderBy('round')
          .get();
      
      return query.docs.map((doc) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          return Match.fromJson(data);
        } catch (e) {
          debugPrint('Error parsing match data: $e');
          return null;
        }
      }).where((match) => match != null).cast<Match>().toList();
    } catch (e) {
      debugPrint('Error getting matches by tournament: $e');
      return [];
    }
  }

  @override
  Future<List<Match>> getMatchesByTournamentAndRound(String tournamentId, int round) async {
    try {
      final query = await _collection
          .where('tournamentId', isEqualTo: tournamentId)
          .where('round', isEqualTo: round)
          .get();
      
      return query.docs.map((doc) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          return Match.fromJson(data);
        } catch (e) {
          debugPrint('Error parsing match data: $e');
          return null;
        }
      }).where((match) => match != null).cast<Match>().toList();
    } catch (e) {
      debugPrint('Error getting matches by tournament and round: $e');
      return [];
    }
  }

  @override
  Stream<List<Match>> watchMatchesByTournament(String tournamentId) {
    return _collection
        .where('tournamentId', isEqualTo: tournamentId)
        .orderBy('round')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          return Match.fromJson(data);
        } catch (e) {
          debugPrint('Error parsing match data: $e');
          return null;
        }
      }).where((match) => match != null).cast<Match>().toList();
    });
  }

  @override
  Stream<List<Match>> watchMatchesByTournamentAndRound(String tournamentId, int round) {
    return _collection
        .where('tournamentId', isEqualTo: tournamentId)
        .where('round', isEqualTo: round)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          return Match.fromJson(data);
        } catch (e) {
          debugPrint('Error parsing match data: $e');
          return null;
        }
      }).where((match) => match != null).cast<Match>().toList();
    });
  }

  @override
  Stream<Match?> watchMatch(String id) {
    return _collection.doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      
      try {
        final data = doc.data() as Map<String, dynamic>;
        return Match.fromJson(data);
      } catch (e) {
        debugPrint('Error parsing match data: $e');
        return null;
      }
    });
  }

  // 追加のヘルパーメソッド
  Future<bool> matchExists(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      return doc.exists;
    } catch (e) {
      debugPrint('Error checking match existence: $e');
      return false;
    }
  }

  Future<List<Match>> getPlayerMatches(String tournamentId, String playerId) async {
    try {
      // player1Id または player2Id が一致するマッチを取得
      final query1 = await _collection
          .where('tournamentId', isEqualTo: tournamentId)
          .where('player1Id', isEqualTo: playerId)
          .get();
      
      final query2 = await _collection
          .where('tournamentId', isEqualTo: tournamentId)
          .where('player2Id', isEqualTo: playerId)
          .get();
      
      final matches = <Match>[];
      
      for (final doc in query1.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          matches.add(Match.fromJson(data));
        } catch (e) {
          debugPrint('Error parsing match data: $e');
        }
      }
      
      for (final doc in query2.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          matches.add(Match.fromJson(data));
        } catch (e) {
          debugPrint('Error parsing match data: $e');
        }
      }
      
      // ラウンド順でソート
      matches.sort((a, b) => a.round.compareTo(b.round));
      return matches;
    } catch (e) {
      debugPrint('Error getting player matches: $e');
      return [];
    }
  }

  @override
  Future<void> createMatches(List<Match> matches) async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      
      for (final match in matches) {
        final docRef = _collection.doc(match.id);
        batch.set(docRef, match.toJson());
      }
      
      await batch.commit();
    } catch (e) {
      debugPrint('Error creating matches batch: $e');
      rethrow;
    }
  }

  Future<void> deleteMatchesByTournamentAndRound(String tournamentId, int round) async {
    try {
      final query = await _collection
          .where('tournamentId', isEqualTo: tournamentId)
          .where('round', isEqualTo: round)
          .get();
      
      final batch = FirebaseFirestore.instance.batch();
      
      for (final doc in query.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
    } catch (e) {
      debugPrint('Error deleting matches by tournament and round: $e');
      rethrow;
    }
  }
}