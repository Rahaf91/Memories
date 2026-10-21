import 'dart:async';

import '../../models/app_user.dart';
import '../repositories/auth_repository.dart';
import 'mock_data.dart';

/// In-memory auth for tests and offline runs. By default the local account
/// ([MockUsers.me]) is already signed in.
class MockAuthRepository implements AuthRepository {
  MockAuthRepository({
    bool signedIn = true,
    this.requireEmailConfirmation = false,
  }) : _user = signedIn ? MockUsers.me : null;

  /// Mirrors a Supabase project with "Confirm email" turned on.
  final bool requireEmailConfirmation;

  AppUser? _user;
  final _changes = StreamController<AppUser?>.broadcast();
  final Map<String, _Account> _accounts = {};
  int _nextId = 0;

  @override
  AppUser? get currentUser => _user;

  @override
  Future<AppUser?> getCurrentUser() async {
    await mockDelay();
    return _user;
  }

  @override
  Stream<AppUser?> authStateChanges() async* {
    yield _user;
    yield* _changes.stream;
  }

  @override
  Future<SignUpResult> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    await mockDelay();
    final key = email.trim().toLowerCase();
    if (_accounts.containsKey(key)) {
      throw const AuthFailure(AuthFailureReason.emailInUse);
    }
    if (password.length < 6) {
      throw const AuthFailure(AuthFailureReason.weakPassword);
    }
    final account = _Account(
      user: AppUser(id: 'user-${_nextId++}', displayName: displayName.trim()),
      password: password,
      confirmed: !requireEmailConfirmation,
    );
    _accounts[key] = account;
    if (requireEmailConfirmation) return SignUpResult.confirmationRequired;
    _setUser(account.user);
    return SignUpResult.signedIn;
  }

  /// Simulates the user clicking the confirmation link in their email.
  void confirmEmail(String email) =>
      _accounts[email.trim().toLowerCase()]?.confirmed = true;

  @override
  Future<void> signIn({required String email, required String password}) async {
    await mockDelay();
    final account = _accounts[email.trim().toLowerCase()];
    if (account == null || account.password != password) {
      throw const AuthFailure(AuthFailureReason.invalidCredentials);
    }
    if (!account.confirmed) {
      throw const AuthFailure(AuthFailureReason.emailNotConfirmed);
    }
    _setUser(account.user);
  }

  @override
  Future<void> signOut() async {
    await mockDelay();
    _setUser(null);
  }

  void _setUser(AppUser? user) {
    _user = user;
    _changes.add(user);
  }
}

class _Account {
  _Account({
    required this.user,
    required this.password,
    required this.confirmed,
  });

  final AppUser user;
  final String password;
  bool confirmed;
}
