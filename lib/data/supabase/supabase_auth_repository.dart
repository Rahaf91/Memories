import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/app_user.dart';
import '../repositories/auth_repository.dart';

/// Supabase Auth (email + password). The signed-in user's id is
/// `auth.uid()`, which Row Level Security policies compare against
/// columns like `memories.user_id`.
class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository([SupabaseClient? client])
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  GoTrueClient get _auth => _client.auth;

  /// Stored in user metadata at sign-up.
  static const _nameKey = 'display_name';

  static AppUser? _toAppUser(User? user) {
    if (user == null) return null;
    final name = (user.userMetadata?[_nameKey] as String?)?.trim();
    final fallback = (user.email ?? '').split('@').first;
    return AppUser(
      id: user.id,
      displayName: (name == null || name.isEmpty) ? fallback : name,
    );
  }

  @override
  AppUser? get currentUser => _toAppUser(_auth.currentUser);

  @override
  Future<AppUser?> getCurrentUser() async => currentUser;

  @override
  Stream<AppUser?> authStateChanges() async* {
    yield currentUser;
    yield* _auth.onAuthStateChange.map(
      (state) => _toAppUser(state.session?.user),
    );
  }

  @override
  Future<SignUpResult> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final response = await _auth.signUp(
        email: email.trim(),
        password: password,
        data: {_nameKey: displayName.trim()},
      );
      // With email confirmation on, an already-registered address returns
      // a user with no identities instead of an error.
      final identities = response.user?.identities;
      if (identities != null && identities.isEmpty) {
        throw const AuthFailure(AuthFailureReason.emailInUse);
      }
      return response.session == null
          ? SignUpResult.confirmationRequired
          : SignUpResult.signedIn;
    } on AuthFailure {
      rethrow;
    } catch (e) {
      throw _translate(e);
    }
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithPassword(email: email.trim(), password: password);
    } catch (e) {
      throw _translate(e);
    }
  }

  @override
  Future<void> signOut() => _auth.signOut();

  /// Supabase error → [AuthFailure].
  static AuthFailure _translate(Object error) {
    if (error is SocketException || error is AuthRetryableFetchException) {
      return AuthFailure(AuthFailureReason.network, '$error');
    }
    if (error is AuthWeakPasswordException) {
      return AuthFailure(AuthFailureReason.weakPassword, error.message);
    }
    if (error is AuthException) {
      final reason = switch (error.code) {
        'invalid_credentials' => AuthFailureReason.invalidCredentials,
        'email_not_confirmed' => AuthFailureReason.emailNotConfirmed,
        'user_already_exists' || 'email_exists' => AuthFailureReason.emailInUse,
        'weak_password' => AuthFailureReason.weakPassword,
        'email_address_invalid' ||
        'validation_failed' => AuthFailureReason.invalidEmail,
        'over_request_rate_limit' ||
        'over_email_send_rate_limit' => AuthFailureReason.rateLimited,
        _ =>
          error.statusCode == '429'
              ? AuthFailureReason.rateLimited
              : AuthFailureReason.unknown,
      };
      return AuthFailure(reason, '${error.code}: ${error.message}');
    }
    return AuthFailure(AuthFailureReason.unknown, '$error');
  }
}
