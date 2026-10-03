// GENERATED-STYLE FILE — REPLACE ME.
//
// This is a placeholder. This project has no real Firebase project wired
// up yet, so the values below are dummy strings. Firebase.initializeApp()
// is called inside a try/catch in main.dart, so the app still runs fine
// without real credentials — it just falls back to local-only mode
// (see AuthRepositoryImpl / BookingRepositoryImpl "offline mode" branches).
//
// To connect a real Firebase project:
//   1. Create a project at https://console.firebase.google.com
//   2. Install the CLI tools:
//        dart pub global activate flutterfire_cli
//   3. From this project's root folder, run:
//        flutterfire configure
//      This logs you into Firebase, lets you pick/create a project, and
//      REGENERATES this exact file (lib/firebase_options.dart) with your
//      real API keys for each platform you select (Android/iOS/Web/etc).
//   4. In the Firebase console, enable:
//        - Authentication -> Sign-in method -> Email/Password
//        - Firestore Database -> Create database (start in test mode
//          while developing)
//   5. Re-run `flutter pub get` and `flutter run`.
//
// Until you do that, the app runs in "offline mode": login accepts any
// email/password locally, and bookings are saved to the local sqflite
// database only (BookingRepositoryImpl skips the Firestore sync step).

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return web;
    }
  }

  static const web = FirebaseOptions(
    apiKey: 'REPLACE_ME',
    appId: 'REPLACE_ME',
    messagingSenderId: 'REPLACE_ME',
    projectId: 'cinelite-replace-me',
    authDomain: 'cinelite-replace-me.firebaseapp.com',
    storageBucket: 'cinelite-replace-me.appspot.com',
  );

  static const android = FirebaseOptions(
    apiKey: 'REPLACE_ME',
    appId: 'REPLACE_ME',
    messagingSenderId: 'REPLACE_ME',
    projectId: 'cinelite-replace-me',
    storageBucket: 'cinelite-replace-me.appspot.com',
  );

  static const ios = FirebaseOptions(
    apiKey: 'REPLACE_ME',
    appId: 'REPLACE_ME',
    messagingSenderId: 'REPLACE_ME',
    projectId: 'cinelite-replace-me',
    storageBucket: 'cinelite-replace-me.appspot.com',
    iosBundleId: 'com.example.cinelite',
  );
}
