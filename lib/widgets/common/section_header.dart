import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/l10n.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onSeeAll,
    this.actionLabel,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onSeeAll;

  /// Overrides the default "See all" label.
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: textTheme.titleLarge),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: AppSpacing.md,
                  top: AppSpacing.xs,
                  bottom: AppSpacing.xs,
                ),
                child: Text(
                  actionLabel ?? context.l10n.seeAll,
                  style: textTheme.labelLarge?.copyWith(
                    color: AppColors.accent,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
