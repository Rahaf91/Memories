import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/date_format.dart';
import '../../l10n/l10n.dart';
import '../../models/moment.dart';
import '../common/app_card.dart';
import '../common/overline_text.dart';
import '../common/user_avatar.dart';

/// Featured card for an "Open When" letter someone sent the user: sender,
/// unlock date, lock state.
class OpenWhenCard extends StatelessWidget {
  const OpenWhenCard({super.key, required this.moment, this.onTap, this.now});

  final Moment moment;
  final VoidCallback? onTap;
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final current = now ?? DateTime.now();
    final locked = moment.isLockedAt(current);
    final unlockAt = moment.unlockAt;
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      onTap: onTap,
      gradient: AppGradients.featured,
      borderColor: AppColors.accent.withValues(alpha: 0.12),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              OverlineText(l.openWhenTitle),
              const Spacer(),
              StatusPill(locked: locked),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(moment.title, style: AppTypography.of(context).featuredQuote),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              UserAvatar(
                user: moment.author,
                size: 30,
                borderColor: AppColors.surface,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  l.fromName(moment.author.firstName),
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (unlockAt != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      locked
                          ? l.opensOn(formatShortDate(l, unlockAt))
                          : l.ready,
                      style: textTheme.labelLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (locked)
                      Text(
                        formatDaysUntil(l, unlockAt, now: current),
                        style: textTheme.labelMedium?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// "Sealed" / "Open now" pill.
class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.locked});

  final bool locked;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: locked
            ? AppColors.surface.withValues(alpha: 0.7)
            : AppColors.accent,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            locked ? Icons.lock_outline_rounded : Icons.lock_open_rounded,
            size: 14,
            color: locked ? AppColors.textSecondary : AppColors.onAccent,
          ),
          const SizedBox(width: 6),
          Text(
            locked ? l.statusWaiting : l.readyToOpen,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: locked ? AppColors.textSecondary : AppColors.onAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
