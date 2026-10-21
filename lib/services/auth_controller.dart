import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/repositories/auth_repository.dart';
import '../models/app_user.dart';

enum AuthStatus { unknown, signedOut, signedIn }

/// App-wide authentication state that the UI reacts to.
class AuthController extends ChangeNotifier {
  AuthController(this._repository) {
    _sub = _repository.authStateChanges().listen(_onUser);
  }

  final AuthRepository _repository;
  late final StreamSubscription<AppUser?> _sub;

  AuthStatus status = AuthStatus.unknown;
  AppUser? user;

  void _onUser(AppUser? next) {
    final nextStatus = next == null
        ? AuthStatus.signedOut
        : AuthStatus.signedIn;
    if (nextStatus == status && next?.id == user?.id) return;
    user = next;
    status = nextStatus;
    notifyListeners();
  }

  /// Throws [AuthFailure].
  Future<SignUpResult> signUp({
    required String email,
    required String password,
    required String displayName,
  }) => _repository.signUp(
    email: email,
    password: password,
    displayName: displayName,
  );

  /// Throws [AuthFailure].
  Future<void> signIn({required String email, required String password}) =>
      _repository.signIn(email: email, password: password);

  Future<void> signOut() => _repository.signOut();

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
