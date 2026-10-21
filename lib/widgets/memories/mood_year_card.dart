import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/date_format.dart';
import '../../l10n/l10n.dart';
import '../../models/monthly_mood.dart';
import '../common/app_card.dart';
import '../common/overline_text.dart';
import '../home/mood_style.dart';

/// Featured entry point to the Mood Year screen, with a 12-month preview.
/// Months without check-ins are hollow.
class MoodYearCard extends StatelessWidget {
  const MoodYearCard({
    super.key,
    required this.months,
    required this.onTap,
    this.now,
  });

  final List<MonthlyMood> months;
  final VoidCallback onTap;
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final current = now ?? DateTime.now();
    final year = months.isEmpty ? current.year : months.first.year;

    return AppCard(
      onTap: onTap,
      color: AppColors.accentSoft,
      borderColor: AppColors.accent.withValues(alpha: 0.12),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OverlineText('$year'),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l.moodYearTitle,
                      style: AppTypography.of(context).cardTitle,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l.moodYearSubtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: AppColors.accentDeep,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              for (final m in months)
                Expanded(
                  child: _MonthIndicator(
                    month: m,
                    label: monthInitial(l, m.month),
                    isCurrent:
                        m.year == current.year && m.month == current.month,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MonthIndicator extends StatelessWidget {
  const _MonthIndicator({
    required this.month,
    required this.label,
    required this.isCurrent,
  });

  final MonthlyMood month;
  final String label;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final mood = month.dominantMood;
    return Column(
      children: [
        Container(
          width: 18,
          height: 18,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isCurrent ? AppColors.accentDeep : Colors.transparent,
              width: 1.2,
            ),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: mood?.color,
              border: mood == null
                  ? Border.all(color: AppColors.accent.withValues(alpha: 0.25))
                  : null,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.clip,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: isCurrent ? AppColors.accentDeep : AppColors.textTertiary,
            fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
