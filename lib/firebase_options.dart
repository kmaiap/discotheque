import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

// Opções de inicialização do Firebase para Web, Android e iOS
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
      default:
        return web;
    }
  }

  // Configuração para execução Web
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDemoKeyDiscothequeWeb123456789',
    appId: '1:1234567890:web:abcdef123456',
    messagingSenderId: '1234567890',
    projectId: 'discotheque-app',
    authDomain: 'discotheque-app.firebaseapp.com',
    storageBucket: 'discotheque-app.appspot.com',
  );

  // Configuração para execução Android
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDemoKeyDiscothequeAndroid12345',
    appId: '1:1234567890:android:abcdef123456',
    messagingSenderId: '1234567890',
    projectId: 'discotheque-app',
    storageBucket: 'discotheque-app.appspot.com',
  );

  // Configuração para execução iOS
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDemoKeyDiscothequeIos123456789',
    appId: '1:1234567890:ios:abcdef123456',
    messagingSenderId: '1234567890',
    projectId: 'discotheque-app',
    storageBucket: 'discotheque-app.appspot.com',
    iosBundleId: 'com.discotheque.app',
  );
}

