import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../common/app_card.dart';

/// Large card on the Create screen: line icon, title, short description.
class CreateActionCard extends StatelessWidget {
  const CreateActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  /// Usually an [Icon]; any widget that fits a 24px box works.
  final Widget icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: title,
      child: AppCard(
        onTap: onTap,
        elevated: true,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.accentSoft,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Center(
                    child: IconTheme(
                      data: const IconThemeData(
                        color: AppColors.accent,
                        size: 24,
                      ),
                      child: icon,
                    ),
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
            const Spacer(),
            Text(
              title,
              style: AppTypography.of(context).cardTitle.copyWith(fontSize: 23),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: AppColors.textSecondary, height: 1.35),
            ),
          ],
        ),
      ),
    );
  }
}
