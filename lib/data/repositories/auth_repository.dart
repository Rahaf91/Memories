import '../../models/app_user.dart';

/// Why an auth request failed. Repositories translate provider-specific
/// errors (e.g. Supabase error codes) into these.
enum AuthFailureReason {
  invalidCredentials,
  emailNotConfirmed,
  emailInUse,
  weakPassword,
  invalidEmail,
  rateLimited,
  network,
  unknown,
}

class AuthFailure implements Exception {
  const AuthFailure(this.reason, [this.debugMessage]);

  final AuthFailureReason reason;

  /// Provider message, for logs only (not shown to users).
  final String? debugMessage;

  @override
  String toString() => 'AuthFailure($reason, $debugMessage)';
}

/// Outcome of a successful sign-up request.
enum SignUpResult {
  /// The account is active and the user is signed in.
  signedIn,

  /// The account must be confirmed by email before signing in.
  confirmationRequired,
}

/// Authentication: who is signed in, and signing in/up/out.
abstract interface class AuthRepository {
  /// The signed-in user right now (null when signed out).
  AppUser? get currentUser;

  /// Same as [currentUser]; kept async for callers that await it.
  Future<AppUser?> getCurrentUser();

  /// Emits the current user immediately, then on every sign-in/out.
  Stream<AppUser?> authStateChanges();

  /// Throws [AuthFailure].
  Future<SignUpResult> signUp({
    required String email,
    required String password,
    required String displayName,
  });

  /// Throws [AuthFailure].
  Future<void> signIn({required String email, required String password});

  Future<void> signOut();
}
