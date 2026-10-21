import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../l10n/l10n.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/shell/main_shell.dart';
import '../services/auth_controller.dart';
import 'dependencies.dart';

/// Shows the sign-in screen when signed out and the app when signed in.
///
/// The app is rebuilt per signed-in user, so every screen loads that
/// user's data. Signing out closes any open screens first.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final AuthController _auth = AppScope.of(context).auth;
  AuthStatus? _lastStatus;

  @override
  void initState() {
    super.initState();
    _auth.addListener(_onAuthChanged);
  }

  @override
  void dispose() {
    _auth.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    final status = _auth.status;
    if (status == AuthStatus.signedOut && _lastStatus == AuthStatus.signedIn) {
      // Leave Settings (or any pushed screen) when the session ends.
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
    _lastStatus = status;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _lastStatus ??= _auth.status;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: switch (_auth.status) {
        AuthStatus.unknown => const _Splash(key: ValueKey('splash')),
        AuthStatus.signedOut => const AuthScreen(key: ValueKey('auth')),
        AuthStatus.signedIn => MainShell(key: ValueKey(_auth.user!.id)),
      },
    );
  }
}

class _Splash extends StatelessWidget {
  const _Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppGradients.hero),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.appName,
                style: AppTypography.of(context).displayTitle,
              ),
              const SizedBox(height: AppSpacing.xl),
              const SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
