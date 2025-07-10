// Firebase configuration file
// APIキーを取得したら、以下の値を実際の値に置き換えてください

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDSvtmdv886NvbtKVg-xVJB2Ri2E5jf-_w',
    appId: '1:181648839714:web:c376f8426f1e2cb8d5667b',
    messagingSenderId: '181648839714',
    projectId: 'tcgtournamentmanagerdev',
    authDomain: 'tcgtournamentmanagerdev.firebaseapp.com',
    storageBucket: 'tcgtournamentmanagerdev.firebasestorage.app',
    measurementId: 'G-HE9D5LF9F5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY_HERE',
    appId: 'YOUR_ANDROID_APP_ID_HERE',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'tcgtournamentmanagerdev',
    storageBucket: 'tcgtournamentmanagerdev.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY_HERE',
    appId: 'YOUR_IOS_APP_ID_HERE',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'tcgtournamentmanagerdev',
    storageBucket: 'tcgtournamentmanagerdev.appspot.com',
    iosBundleId: 'com.example.tcgTournamentManager',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR_MACOS_API_KEY_HERE',
    appId: 'YOUR_MACOS_APP_ID_HERE',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'tcgtournamentmanagerdev',
    storageBucket: 'tcgtournamentmanagerdev.appspot.com',
    iosBundleId: 'com.example.tcgTournamentManager',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'YOUR_WINDOWS_API_KEY_HERE',
    appId: 'YOUR_WINDOWS_APP_ID_HERE',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'tcgtournamentmanagerdev',
    storageBucket: 'tcgtournamentmanagerdev.appspot.com',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'YOUR_LINUX_API_KEY_HERE',
    appId: 'YOUR_LINUX_APP_ID_HERE',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'tcgtournamentmanagerdev',
    storageBucket: 'tcgtournamentmanagerdev.appspot.com',
  );
}