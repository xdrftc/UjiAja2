import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Firebase Options untuk Android
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web belum didukung');
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError('Platform ini belum didukung');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDtpZN8Ynco5IwLe65UcZP4d8lX9ei5FD4', // GANTI
    appId: '1:705415961794:android:b7a524d6177d3a02b2af5b', // GANTI
    messagingSenderId: '705415961794', // GANTI
    projectId: 'ujiaja-c2d1e', // GANTI
    storageBucket: 'ujiaja-c2d1e.firebasestorage.app', // GANTI (opsional)
  );
}
