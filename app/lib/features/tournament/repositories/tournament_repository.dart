import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../core/services/firebase_service.dart';
import '../models/tournament.dart';

abstract class TournamentRepository {
  Future<Tournament> createTournament(Tournament tournament);
  Future<Tournament?> getTournament(String id);
  Future<void> updateTournament(Tournament tournament);
  Future<void> deleteTournament(String id);
  Stream<Tournament?> watchTournament(String id);
  Stream<List<Tournament>> watchAllTournaments();
}

class FirestoreTournamentRepository implements TournamentRepository {
  CollectionReference get _collection => FirebaseService.tournaments;

  @override
  Future<Tournament> createTournament(Tournament tournament) async {
    try {
      final docRef = _collection.doc(tournament.id);
      final tournamentWithTimestamp = tournament.copyWith(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      await docRef.set(tournamentWithTimestamp.toJson());
      return tournamentWithTimestamp;
    } catch (e) {
      debugPrint('Error creating tournament: $e');
      rethrow;
    }
  }

  @override
  Future<Tournament?> getTournament(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) return null;
      
      final data = doc.data() as Map<String, dynamic>;
      return Tournament.fromJson(data);
    } catch (e) {
      debugPrint('Error getting tournament: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateTournament(Tournament tournament) async {
    try {
      final tournamentWithTimestamp = tournament.copyWith(
        updatedAt: DateTime.now(),
      );
      
      await _collection.doc(tournament.id).update(tournamentWithTimestamp.toJson());
    } catch (e) {
      debugPrint('Error updating tournament: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteTournament(String id) async {
    try {
      await _collection.doc(id).delete();
    } catch (e) {
      debugPrint('Error deleting tournament: $e');
      rethrow;
    }
  }

  @override
  Stream<Tournament?> watchTournament(String id) {
    return _collection.doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      
      try {
        final data = doc.data() as Map<String, dynamic>;
        return Tournament.fromJson(data);
      } catch (e) {
        debugPrint('Error parsing tournament data: $e');
        return null;
      }
    });
  }

  @override
  Stream<List<Tournament>> watchAllTournaments() {
    return _collection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          return Tournament.fromJson(data);
        } catch (e) {
          debugPrint('Error parsing tournament data: $e');
          return null;
        }
      }).where((tournament) => tournament != null).cast<Tournament>().toList();
    });
  }

  // 追加のヘルパーメソッド
  Future<bool> tournamentExists(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      return doc.exists;
    } catch (e) {
      debugPrint('Error checking tournament existence: $e');
      return false;
    }
  }

  Future<List<Tournament>> getTournamentsByStatus(TournamentStatus status) async {
    try {
      final query = await _collection
          .where('status', isEqualTo: status.name)
          .orderBy('createdAt', descending: true)
          .get();
      
      return query.docs.map((doc) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          return Tournament.fromJson(data);
        } catch (e) {
          debugPrint('Error parsing tournament data: $e');
          return null;
        }
      }).where((tournament) => tournament != null).cast<Tournament>().toList();
    } catch (e) {
      debugPrint('Error getting tournaments by status: $e');
      return [];
    }
  }
}