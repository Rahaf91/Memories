import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/dependencies.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../data/repositories/auth_repository.dart';
import '../../l10n/l10n.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/forms/app_text_field.dart';

/// Email + password sign-in and sign-up.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _signUp = false;
  bool _busy = false;
  bool _showPassword = false;
  String? _error;
  String? _info;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  void _toggleMode() {
    setState(() {
      _signUp = !_signUp;
      _error = null;
      _info = null;
    });
  }

  String _messageFor(AuthFailureReason reason, AppLocalizations l) =>
      switch (reason) {
        AuthFailureReason.invalidCredentials => l.authErrorInvalidCredentials,
        AuthFailureReason.emailNotConfirmed => l.authErrorEmailNotConfirmed,
        AuthFailureReason.emailInUse => l.authErrorEmailInUse,
        AuthFailureReason.weakPassword => l.authErrorWeakPassword,
        AuthFailureReason.invalidEmail => l.emailInvalid,
        AuthFailureReason.rateLimited => l.authErrorRateLimited,
        AuthFailureReason.network => l.authErrorNetwork,
        AuthFailureReason.unknown => l.authErrorUnknown,
      };

  Future<void> _submit() async {
    if (_busy) return;
    setState(() {
      _error = null;
      _info = null;
    });
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final l = context.l10n;
    final auth = AppScope.of(context).auth;
    setState(() => _busy = true);
    try {
      if (_signUp) {
        final result = await auth.signUp(
          email: _email.text,
          password: _password.text,
          displayName: _name.text,
        );
        if (result == SignUpResult.confirmationRequired && mounted) {
          // Account created; it must be confirmed by email first.
          setState(() {
            _signUp = false;
            _password.clear();
            _info = l.confirmEmailSent;
          });
        }
      } else {
        await auth.signIn(email: _email.text, password: _password.text);
      }
      // On success the app switches to the signed-in screens by itself.
    } on AuthFailure catch (e) {
      debugPrint('Auth failed: $e');
      HapticFeedback.lightImpact();
      if (mounted) setState(() => _error = _messageFor(e.reason, l));
    } catch (e) {
      debugPrint('Auth failed: $e');
      if (mounted) setState(() => _error = l.authErrorUnknown);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final type = AppTypography.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(gradient: AppGradients.hero),
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: AutofillGroup(
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    AppSpacing.xxxl,
                    AppSpacing.screenPadding,
                    AppSpacing.xxl,
                  ),
                  children: [
                    Text(l.appName, style: type.displayTitle),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l.authSubtitle,
                      style: textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        _signUp ? l.authSignUpTitle : l.authSignInTitle,
                        key: ValueKey(_signUp),
                        style: type.cardTitle,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 220),
                      alignment: AlignmentDirectional.topStart,
                      child: _signUp
                          ? Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.xl,
                              ),
                              child: AppTextField(
                                label: l.fieldYourName,
                                controller: _name,
                                hint: l.yourNameHint,
                                maxLength: 60,
                                autofillHints: const [AutofillHints.name],
                                textCapitalization: TextCapitalization.words,
                                validator: AppTextField.required(
                                  l.nameRequired,
                                ),
                              ),
                            )
                          : const SizedBox(width: double.infinity),
                    ),
                    AppTextField(
                      label: l.fieldEmail,
                      controller: _email,
                      hint: 'name@example.com',
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      autofillHints: const [AutofillHints.email],
                      validator: (v) => _emailPattern.hasMatch((v ?? '').trim())
                          ? null
                          : l.emailInvalid,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AppTextField(
                      label: l.fieldPassword,
                      controller: _password,
                      obscureText: !_showPassword,
                      textCapitalization: TextCapitalization.none,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submit(),
                      autofillHints: [
                        _signUp
                            ? AutofillHints.newPassword
                            : AutofillHints.password,
                      ],
                      suffix: IconButton(
                        tooltip: _showPassword
                            ? l.hidePassword
                            : l.showPassword,
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textTertiary,
                        ),
                        onPressed: () =>
                            setState(() => _showPassword = !_showPassword),
                      ),
                      validator: (v) {
                        final value = v ?? '';
                        if (value.isEmpty) return l.passwordRequired;
                        if (_signUp && value.length < 6) {
                          return l.passwordTooShort;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _Banner(message: _error, isError: true),
                    _Banner(message: _info, isError: false),
                    PrimaryButton(
                      label: _signUp ? l.signUp : l.signIn,
                      busy: _busy,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            _signUp ? l.haveAccount : l.noAccount,
                            style: textTheme.bodyMedium,
                          ),
                        ),
                        TextButton(
                          onPressed: _busy ? null : _toggleMode,
                          child: Text(_signUp ? l.signIn : l.signUp),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Quiet inline message: an error, or helpful info (e.g. check your email).
class _Banner extends StatelessWidget {
  const _Banner({required this.message, required this.isError});

  final String? message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final text = message;
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      alignment: AlignmentDirectional.topStart,
      child: text == null
          ? const SizedBox(width: double.infinity)
          : Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: Semantics(
                liveRegion: true,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: isError
                        ? AppColors.error.withValues(alpha: 0.08)
                        : AppColors.accentSoft,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        isError
                            ? Icons.error_outline_rounded
                            : Icons.mark_email_read_outlined,
                        size: 20,
                        color: isError ? AppColors.error : AppColors.accent,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          text,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: isError
                                    ? AppColors.error
                                    : AppColors.accentDeep,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
