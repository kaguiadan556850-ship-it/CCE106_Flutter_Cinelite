import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/firebase_auth_data_source.dart';

/// When Firebase is configured (see lib/firebase_options.dart), this
/// delegates to real Firebase Auth. When it isn't, [isCloudConnected]
/// is false and sign-in/register succeed locally with a synthetic
/// [AppUser] so the rest of the app (and the booking flow, which wants
/// *a* userId to tag records with) keeps working without a backend.
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _remote;
  AppUser? _offlineUser;

  AuthRepositoryImpl(this._remote);

  @override
  bool get isCloudConnected => _remote.isAvailable;

  @override
  AppUser? get currentUser {
    if (isCloudConnected) {
      final u = _remote.currentUser;
      return u == null ? null : AppUser(uid: u.uid, email: u.email);
    }
    return _offlineUser;
  }

  @override
  Future<AppUser> signIn({required String email, required String password}) async {
    if (isCloudConnected) {
      final u = await _remote.signIn(email, password);
      return AppUser(uid: u.uid, email: u.email);
    }
    // Offline mode: accept any non-empty credentials.
    final user = AppUser(uid: 'offline-${email.hashCode}', email: email);
    _offlineUser = user;
    return user;
  }

  @override
  Future<AppUser> register({required String email, required String password}) async {
    if (isCloudConnected) {
      final u = await _remote.register(email, password);
      return AppUser(uid: u.uid, email: u.email);
    }
    final user = AppUser(uid: 'offline-${email.hashCode}', email: email);
    _offlineUser = user;
    return user;
  }

  @override
  Future<void> signOut() async {
    if (isCloudConnected) {
      await _remote.signOut();
    }
    _offlineUser = null;
  }
}
