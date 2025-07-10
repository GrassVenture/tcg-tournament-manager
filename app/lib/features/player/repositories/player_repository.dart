import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../core/services/firebase_service.dart';
import '../models/player.dart';

abstract class PlayerRepository {
  Future<Player> createPlayer(Player player);
  Future<Player?> getPlayer(String id);
  Future<void> updatePlayer(Player player);
  Future<void> deletePlayer(String id);
  Future<List<Player>> getPlayersByTournament(String tournamentId);
  Stream<List<Player>> watchPlayersByTournament(String tournamentId);
  Stream<Player?> watchPlayer(String id);
  Future<void> deactivatePlayer(String playerId);
}

class FirestorePlayerRepository implements PlayerRepository {
  CollectionReference get _collection => FirebaseService.players;

  @override
  Future<Player> createPlayer(Player player) async {
    try {
      final docRef = _collection.doc(player.id);
      final playerWithTimestamp = player.copyWith(
        joinedAt: DateTime.now(),
      );
      
      await docRef.set(playerWithTimestamp.toJson());
      return playerWithTimestamp;
    } catch (e) {
      debugPrint('Error creating player: $e');
      rethrow;
    }
  }

  @override
  Future<Player?> getPlayer(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) return null;
      
      final data = doc.data() as Map<String, dynamic>;
      return Player.fromJson(data);
    } catch (e) {
      debugPrint('Error getting player: $e');
      rethrow;
    }
  }

  @override
  Future<void> updatePlayer(Player player) async {
    try {
      await _collection.doc(player.id).update(player.toJson());
    } catch (e) {
      debugPrint('Error updating player: $e');
      rethrow;
    }
  }

  @override
  Future<void> deletePlayer(String id) async {
    try {
      await _collection.doc(id).delete();
    } catch (e) {
      debugPrint('Error deleting player: $e');
      rethrow;
    }
  }

  @override
  Future<List<Player>> getPlayersByTournament(String tournamentId) async {
    try {
      final query = await _collection
          .where('tournamentId', isEqualTo: tournamentId)
          .where('isActive', isEqualTo: true)
          .orderBy('joinedAt')
          .get();
      
      return query.docs.map((doc) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          return Player.fromJson(data);
        } catch (e) {
          debugPrint('Error parsing player data: $e');
          return null;
        }
      }).where((player) => player != null).cast<Player>().toList();
    } catch (e) {
      debugPrint('Error getting players by tournament: $e');
      return [];
    }
  }

  @override
  Stream<List<Player>> watchPlayersByTournament(String tournamentId) {
    return _collection
        .where('tournamentId', isEqualTo: tournamentId)
        .where('isActive', isEqualTo: true)
        .orderBy('joinedAt')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          return Player.fromJson(data);
        } catch (e) {
          debugPrint('Error parsing player data: $e');
          return null;
        }
      }).where((player) => player != null).cast<Player>().toList();
    });
  }

  @override
  Stream<Player?> watchPlayer(String id) {
    return _collection.doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      
      try {
        final data = doc.data() as Map<String, dynamic>;
        return Player.fromJson(data);
      } catch (e) {
        debugPrint('Error parsing player data: $e');
        return null;
      }
    });
  }

  // 追加のヘルパーメソッド
  Future<bool> playerExists(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      return doc.exists;
    } catch (e) {
      debugPrint('Error checking player existence: $e');
      return false;
    }
  }

  Future<bool> isPlayerNameTaken(String tournamentId, String name) async {
    try {
      final query = await _collection
          .where('tournamentId', isEqualTo: tournamentId)
          .where('name', isEqualTo: name)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();
      
      return query.docs.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking player name: $e');
      return false;
    }
  }

  Future<int> getTournamentPlayerCount(String tournamentId) async {
    try {
      final query = await _collection
          .where('tournamentId', isEqualTo: tournamentId)
          .where('isActive', isEqualTo: true)
          .get();
      
      return query.docs.length;
    } catch (e) {
      debugPrint('Error getting player count: $e');
      return 0;
    }
  }

  @override
  Future<void> deactivatePlayer(String playerId) async {
    try {
      await _collection.doc(playerId).update({'isActive': false});
    } catch (e) {
      debugPrint('Error deactivating player: $e');
      rethrow;
    }
  }
}