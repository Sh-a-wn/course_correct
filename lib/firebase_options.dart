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
    apiKey: 'AIzaSyB9CcH5iwLizNnoYk_AN4tbbXlEBdOGYxQ',
    appId: '1:379140133762:web:6edc524d877dc72b2ef59b',
    messagingSenderId: '379140133762',
    projectId: 'course-correct-b0de5',
    authDomain: 'course-correct-b0de5.firebaseapp.com',
    storageBucket: 'course-correct-b0de5.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA8Vn1thTWFgnyql9sgc2euF52_MsBPeuM',
    appId: '1:379140133762:android:e70f915603442b132ef59b',
    messagingSenderId: '379140133762',
    projectId: 'course-correct-b0de5',
    storageBucket: 'course-correct-b0de5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC9BJKWO6SX5TvtrqzMsKkryPLYhz5L-i0',
    appId: '1:379140133762:ios:29f4d58d0b594c932ef59b',
    messagingSenderId: '379140133762',
    projectId: 'course-correct-b0de5',
    storageBucket: 'course-correct-b0de5.appspot.com',
    iosClientId: '379140133762-kvhtsvopqsanv7f1e79q76hpp2dqr1ml.apps.googleusercontent.com',
    iosBundleId: 'com.example.courseCorrect',
  );
}
