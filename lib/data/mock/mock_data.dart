import '../../models/app_user.dart';

/// The signed-in account used by the local repositories until real
/// authentication exists. There are no sample friends or content: the app
/// starts like a brand-new account.
abstract final class MockUsers {
  static const me = AppUser(id: 'user-me', displayName: 'Rahaf');
}

/// Simulated network latency so loading states are exercised.
Future<void> mockDelay() => Future.delayed(const Duration(milliseconds: 350));
