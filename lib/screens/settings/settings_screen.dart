import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/dependencies.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/l10n.dart';
import '../../models/app_language.dart';
import '../../widgets/common/app_card.dart';
import '../../widgets/common/user_avatar.dart';

/// App settings. Currently: language (English / العربية).
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final settings = AppScope.of(context).settings;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.sm,
          AppSpacing.screenPadding,
          AppSpacing.xxl,
        ),
        children: [
          Text(
            l.settings,
            style: AppTypography.of(context).displayTitle
                .copyWith(fontSize: 38),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(l.language, style: textTheme.titleLarge),
          const SizedBox(height: 2),
          Text(
            l.languageHint,
            style: textTheme.bodySmall?.copyWith(color: AppColors.textTertiary),
          ),
          const SizedBox(height: AppSpacing.md),
          ListenableBuilder(
            listenable: settings,
            builder: (context, _) => AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (final (i, language) in AppLanguage.values.indexed) ...[
                    if (i > 0) const Divider(),
                    _LanguageRow(
                      language: language,
                      selected: settings.language == language,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        settings.setLanguage(language);
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(l.account, style: textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          const _AccountCard(),
        ],
      ),
    );
  }
}

/// Signed-in user and the sign-out action.
class _AccountCard extends StatelessWidget {
  const _AccountCard();

  Future<void> _confirmSignOut(BuildContext context) async {
    final l = context.l10n;
    final auth = AppScope.of(context).auth;
    final confirmed = await showAdaptiveDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog.adaptive(
        title: Text(l.signOutConfirm),
        actions: [
          adaptiveAction(
            context: dialogContext,
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l.cancel),
          ),
          adaptiveAction(
            context: dialogContext,
            destructive: true,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l.signOut),
          ),
        ],
      ),
    );
    if (confirmed == true) await auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final user = AppScope.of(context).auth.user;
    return AppCard(
      padding: EdgeInsets.zero,
      // Own Material so the rows' tap highlights show on the card.
      child: Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            if (user != null)
              ListTile(
                leading: UserAvatar(user: user, size: 36),
                title: Text(user.displayName),
              ),
            if (user != null) const Divider(),
            ListTile(
              onTap: () => _confirmSignOut(context),
              leading: const Icon(Icons.logout_rounded, color: AppColors.error),
              title: Text(
                l.signOut,
                style: const TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dialog action styled for the platform (Cupertino on iOS).
Widget adaptiveAction({
  required BuildContext context,
  required VoidCallback onPressed,
  required Widget child,
  bool destructive = false,
}) {
  final platform = Theme.of(context).platform;
  if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
    return CupertinoDialogAction(
      onPressed: onPressed,
      isDestructiveAction: destructive,
      child: child,
    );
  }
  return TextButton(
    onPressed: onPressed,
    style: destructive
        ? TextButton.styleFrom(foregroundColor: AppColors.error)
        : null,
    child: child,
  );
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.language,
    required this.selected,
    required this.onTap,
  });

  final AppLanguage language;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: language.nativeName,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  language.nativeName,
                  // Each name is shown in its own script and direction.
                  textDirection: language == AppLanguage.arabic
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: selected
                    ? const Icon(
                        Icons.check_circle_rounded,
                        key: ValueKey(true),
                        color: AppColors.accent,
                      )
                    : const Icon(
                        Icons.radio_button_unchecked_rounded,
                        key: ValueKey(false),
                        color: AppColors.stone,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
