import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/date_format.dart';
import '../../l10n/l10n.dart';
import '../common/badge_icon_button.dart';
import '../common/overline_text.dart';

/// Top of Home: date, title, greeting, and notifications, on a soft
/// lavender-to-beige wash. Extra content (e.g. stories) goes in [bottom].
class HeroHeader extends StatelessWidget {
  const HeroHeader({
    super.key,
    required this.firstName,
    required this.hasUnreadNotifications,
    required this.onNotificationsTap,
    this.bottom,
    this.now,
  });

  final String firstName;
  final bool hasUnreadNotifications;
  final VoidCallback onNotificationsTap;
  final Widget? bottom;
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final date = now ?? DateTime.now();
    final topInset = MediaQuery.paddingOf(context).top;

    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppGradients.hero),
      child: Padding(
        padding: EdgeInsets.only(top: topInset + AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OverlineText(formatLongDate(l, date)),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          l.appName,
                          style: AppTypography.of(context).displayTitle,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          greeting(l, date, firstName),
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  BadgeIconButton(
                    icon: Icons.notifications_none_rounded,
                    tooltip: l.notifications,
                    showBadge: hasUnreadNotifications,
                    onPressed: onNotificationsTap,
                  ),
                ],
              ),
            ),
            if (bottom != null) ...[
              const SizedBox(height: AppSpacing.xl),
              bottom!,
            ],
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
