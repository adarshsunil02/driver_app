// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'API_KEY_HERE',
    appId: '1:349583206100:web:263292ae89ad7fa78a7d41',
    messagingSenderId: '349583206100',
    projectId: 'taxi-4fc44',
    authDomain: 'taxi-4fc44.firebaseapp.com',
    databaseURL: 'https://taxi-4fc44-default-rtdb.firebaseio.com',
    storageBucket: 'taxi-4fc44.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'API_KEY_HERE',
    appId: '1:349583206100:android:70eef4d672f95dc08a7d41',
    messagingSenderId: '349583206100',
    projectId: 'taxi-4fc44',
    databaseURL: 'https://taxi-4fc44-default-rtdb.firebaseio.com',
    storageBucket: 'taxi-4fc44.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'API_KEY_HERE',
    appId: '1:349583206100:ios:2f2cc7f372fd844e8a7d41',
    messagingSenderId: '349583206100',
    projectId: 'taxi-4fc44',
    databaseURL: 'https://taxi-4fc44-default-rtdb.firebaseio.com',
    storageBucket: 'taxi-4fc44.appspot.com',
    iosBundleId: 'com.example.driverapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAPt6xfSihyyrH7pwCcE4ptpFsBAnv7S0Q',
    appId: '1:349583206100:ios:2f2cc7f372fd844e8a7d41',
    messagingSenderId: '349583206100',
    projectId: 'taxi-4fc44',
    databaseURL: 'https://taxi-4fc44-default-rtdb.firebaseio.com',
    storageBucket: 'taxi-4fc44.appspot.com',
    iosBundleId: 'com.example.driverapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'API_KEY_HERE',
    appId: '1:349583206100:web:3861a099d6f96d418a7d41',
    messagingSenderId: '349583206100',
    projectId: 'taxi-4fc44',
    authDomain: 'taxi-4fc44.firebaseapp.com',
    databaseURL: 'https://taxi-4fc44-default-rtdb.firebaseio.com',
    storageBucket: 'taxi-4fc44.appspot.com',
  );
}
