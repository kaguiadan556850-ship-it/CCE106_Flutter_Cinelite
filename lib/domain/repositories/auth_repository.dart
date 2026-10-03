import '../entities/app_user.dart';

abstract class AuthRepository {
  /// True if a real Firebase project is connected. When false, the
  /// implementation runs in local "offline mode" (any credentials
  /// succeed) so the app stays usable without Firebase configured.
  bool get isCloudConnected;

  AppUser? get currentUser;

  Future<AppUser> signIn({required String email, required String password});

  Future<AppUser> register({required String email, required String password});

  Future<void> signOut();
}
