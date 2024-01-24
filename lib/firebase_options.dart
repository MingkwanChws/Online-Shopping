// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDLRzwAZ71RWxQ2zJOvdyQ3dqscbZFgHwk',
    appId: '1:219870841572:web:81fa467502205f2ca97af1',
    messagingSenderId: '219870841572',
    projectId: 'shop-eebc0',
    authDomain: 'shop-eebc0.firebaseapp.com',
    storageBucket: 'shop-eebc0.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD6onPpeHyeq78W8is7S1I3lSpHYu8gbU0',
    appId: '1:219870841572:android:979caf30fd3c244fa97af1',
    messagingSenderId: '219870841572',
    projectId: 'shop-eebc0',
    storageBucket: 'shop-eebc0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAej-5_brkS0Q3pUgSPX9IyGH1jBUvZq68',
    appId: '1:219870841572:ios:5b1df5c3b0b4d2e3a97af1',
    messagingSenderId: '219870841572',
    projectId: 'shop-eebc0',
    storageBucket: 'shop-eebc0.appspot.com',
    iosBundleId: 'com.example.onlineShop',
  );
}
