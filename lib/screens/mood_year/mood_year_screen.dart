import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/l10n.dart';

/// Placeholder for the month-by-month mood history.
class MoodYearScreen extends StatelessWidget {
  const MoodYearScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          Text(
            l.moodYearTitle,
            style: AppTypography.of(context).displayTitle
                .copyWith(fontSize: 38),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l.moodYearSubtitle,
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          Center(
            child: Column(
              children: [
                const Icon(
                  Icons.calendar_view_month_outlined,
                  size: 36,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l.comingSoon,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
