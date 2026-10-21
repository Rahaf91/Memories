import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/l10n.dart';
import '../../models/mood.dart';
import '../common/app_card.dart';
import 'mood_selector.dart';

/// Card wrapping the mood selector with a quiet confirmation line. No
/// heading: the faces speak for themselves.
class MoodCheckInCard extends StatelessWidget {
  const MoodCheckInCard({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final Mood? selected;
  final ValueChanged<Mood> onSelected;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final mood = selected;
    return AppCard(
      elevated: true,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MoodSelector(selected: selected, onSelected: onSelected),
          const SizedBox(height: AppSpacing.lg),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Padding(
              key: ValueKey(mood),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Text(
                mood == null ? l.moodPrompt : l.moodSharedLine(l.mood(mood)),
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
