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
        return macos;
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
    apiKey: 'AIzaSyByyztMaBTsstzgwAdrjGPZSwKJv_zuekg',
    appId: '1:487916643240:web:59cc418726279e9cecb39d',
    messagingSenderId: '487916643240',
    projectId: 'ym-hrdc-app-2023',
    authDomain: 'ym-hrdc-app-2023.firebaseapp.com',
    storageBucket: 'ym-hrdc-app-2023.appspot.com',
    measurementId: 'G-LT7J1PPSF1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB8K7OYEpllTOYOTjL5emnIYTeUjs81g24',
    appId: '1:487916643240:android:8438a1a19ef55651ecb39d',
    messagingSenderId: '487916643240',
    projectId: 'ym-hrdc-app-2023',
    storageBucket: 'ym-hrdc-app-2023.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAHFhsphFM1SNi_slKw0PfwSjkG322uECU',
    appId: '1:487916643240:ios:a2b1e2eab54d7ef8ecb39d',
    messagingSenderId: '487916643240',
    projectId: 'ym-hrdc-app-2023',
    storageBucket: 'ym-hrdc-app-2023.appspot.com',
    iosClientId: '487916643240-rbsorkbjm64811pfma4p5emufb9j4u6q.apps.googleusercontent.com',
    iosBundleId: 'com.example.ymDaaToce',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAHFhsphFM1SNi_slKw0PfwSjkG322uECU',
    appId: '1:487916643240:ios:a2b1e2eab54d7ef8ecb39d',
    messagingSenderId: '487916643240',
    projectId: 'ym-hrdc-app-2023',
    storageBucket: 'ym-hrdc-app-2023.appspot.com',
    iosClientId: '487916643240-rbsorkbjm64811pfma4p5emufb9j4u6q.apps.googleusercontent.com',
    iosBundleId: 'com.example.ymDaaToce',
  );
}
