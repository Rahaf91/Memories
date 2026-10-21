import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/date_format.dart';
import '../../l10n/l10n.dart';
import '../../models/scheduled_letter.dart';
import '../common/app_card.dart';
import '../common/avatar_stack.dart';
import '../common/overline_text.dart';
import 'open_when_card.dart';

/// Summary of Open When letters the user has scheduled for others.
class ScheduledLettersCard extends StatelessWidget {
  const ScheduledLettersCard({super.key, required this.letters, this.onTap});

  /// Soonest first; must not be empty.
  final List<ScheduledLetter> letters;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final next = letters.first;
    final recipients = {for (final x in letters) x.recipient.id: x.recipient};

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
              const StatusPill(locked: true),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l.scheduledMessages(letters.length),
            style: AppTypography.of(context).cardTitle,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              AvatarStack(
                users: recipients.values.toList(),
                size: 24,
                borderColor: AppColors.beige,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  l.nextOpens(
                    formatShortDate(l, next.openAt),
                    formatDaysUntil(l, next.openAt),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
