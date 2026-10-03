import 'package:firebase_core/firebase_core.dart';

/// `Firebase.initializeApp()` succeeds even when `firebase_options.dart`
/// still has the dummy `REPLACE_ME` values — it only registers the app
/// locally and doesn't validate credentials until you make an actual
/// call. So `Firebase.apps.isNotEmpty` alone is NOT a reliable signal
/// that Firebase is really usable; every remote data source should
/// check this instead.
bool isRealFirebaseConfigured() {
  if (Firebase.apps.isEmpty) return false;
  final apiKey = Firebase.app().options.apiKey;
  return apiKey.isNotEmpty && apiKey != 'REPLACE_ME';
}
