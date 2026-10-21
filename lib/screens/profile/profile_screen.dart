import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/app_navigator.dart';
import '../../app/dependencies.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/l10n.dart';
import '../../models/app_user.dart';
import '../../widgets/common/app_card.dart';
import '../../widgets/common/screen_header.dart';
import '../../widgets/common/status_bar_scrim.dart';
import '../../widgets/common/user_avatar.dart';

/// Profile tab: the account, Friends, and Settings.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AppUser? _user;
  int _friendCount = 0;
  late final Listenable _changes = AppScope.of(context).dataChanges;

  @override
  void initState() {
    super.initState();
    _load();
    _changes.addListener(_load);
  }

  @override
  void dispose() {
    _changes.removeListener(_load);
    super.dispose();
  }

  Future<void> _load() async {
    final service = AppScope.of(context).friendsService;
    final user = await service.currentUser();
    final friends = await service.friendsToday();
    if (!mounted) return;
    setState(() {
      _user = user;
      _friendCount = friends.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final padding = MediaQuery.paddingOf(context);
    final user = _user;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Stack(
          children: [
            ListView(
              padding: EdgeInsets.only(
                top: padding.top + AppSpacing.xl,
                bottom: padding.bottom + AppSpacing.xl,
              ),
              children: [
                ScreenHeader(title: l.profileTitle),
                const SizedBox(height: AppSpacing.xl),
                if (user != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding,
                    ),
                    child: AppCard(
                      elevated: true,
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Row(
                        children: [
                          UserAvatar(user: user, size: 64),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.displayName,
                                  style: AppTypography.of(context).cardTitle,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  l.friendsCount(_friendCount),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.xl),
                _ProfileRow(
                  icon: Icons.people_outline_rounded,
                  title: l.friendsTitle,
                  subtitle: l.friendsCount(_friendCount),
                  onTap: () => AppNavigator.openFriends(context),
                ),
                const SizedBox(height: AppSpacing.md),
                _ProfileRow(
                  icon: Icons.settings_outlined,
                  title: l.settings,
                  subtitle: l.settingsSubtitle,
                  onTap: () => AppNavigator.openSettings(context),
                ),
              ],
            ),
            const StatusBarScrim(),
          ],
        ),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Semantics(
        button: true,
        label: title,
        child: AppCard(
          onTap: onTap,
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.accentSoft,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(icon, color: AppColors.accent),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: textTheme.titleMedium),
                    Text(
                      subtitle,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
