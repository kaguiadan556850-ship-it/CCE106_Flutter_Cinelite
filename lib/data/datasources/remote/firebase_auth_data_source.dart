import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../../core/firebase/firebase_status.dart';

/// Thin wrapper over firebase_auth. Confined to the data layer — the
/// domain/presentation layers only ever see [AppUser] via
/// AuthRepository, never this class or firebase_auth's User type.
class FirebaseAuthDataSource {
  fb.FirebaseAuth? _auth;

  bool get isAvailable => isRealFirebaseConfigured();

  fb.FirebaseAuth? get _instance {
    if (!isAvailable) return null;
    return _auth ??= fb.FirebaseAuth.instance;
  }

  fb.User? get currentUser => _instance?.currentUser;

  Future<fb.User> signIn(String email, String password) async {
    final auth = _instance;
    if (auth == null) {
      throw StateError('Firebase is not configured.');
    }
    final cred = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user!;
  }

  Future<fb.User> register(String email, String password) async {
    final auth = _instance;
    if (auth == null) {
      throw StateError('Firebase is not configured.');
    }
    final cred = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user!;
  }

  Future<void> signOut() async {
    await _instance?.signOut();
  }
}

