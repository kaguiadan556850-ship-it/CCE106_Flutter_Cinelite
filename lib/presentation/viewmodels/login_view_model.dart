import 'package:flutter/material.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

enum LoginStatus { idle, loading, success, error }

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  LoginViewModel(this._authRepository);

  LoginStatus status = LoginStatus.idle;
  String? errorMessage;
  AppUser? user;

  bool get isCloudConnected => _authRepository.isCloudConnected;

  Future<bool> login({required String email, required String password}) async {
    status = LoginStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      user = await _authRepository.signIn(email: email, password: password);
      status = LoginStatus.success;
      notifyListeners();
      return true;
    } catch (e) {
      // Firebase throws FirebaseAuthException for unknown users; fall
      // back to registering them so the demo flow never dead-ends.
      try {
        user = await _authRepository.register(email: email, password: password);
        status = LoginStatus.success;
        notifyListeners();
        return true;
      } catch (e2) {
        status = LoginStatus.error;
        errorMessage = e2.toString();
        notifyListeners();
        return false;
      }
    }
  }
}
