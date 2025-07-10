import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../firebase_options.dart';

class FirebaseService {
  static FirebaseFirestore? _firestore;
  static bool _initialized = false;

  static FirebaseFirestore get firestore {
    if (_firestore == null) {
      throw Exception('Firebase not initialized. Call initializeFirebase() first.');
    }
    return _firestore!;
  }

  static bool get isInitialized => _initialized;

  static Future<void> initializeFirebase() async {
    if (_initialized) return;

    try {
      debugPrint('Firebase初期化を開始します...');
      
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      _firestore = FirebaseFirestore.instance;
      
      // 開発環境でのFirestoreエミュレータ設定（必要に応じて）
      // _firestore!.useFirestoreEmulator('localhost', 8080);
      
      _initialized = true;
      debugPrint('Firebase initialization successful!');
      debugPrint('Firestore instance created: ${_firestore != null}');
    } catch (e) {
      debugPrint('Firebase initialization failed: $e');
      _initialized = false;
      rethrow;
    }
  }

  // Firestoreのコレクション参照を取得するヘルパーメソッド
  static CollectionReference get tournaments => firestore.collection('tournaments');
  static CollectionReference get players => firestore.collection('players');
  static CollectionReference get matches => firestore.collection('matches');
}