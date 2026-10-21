import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Small rounded label. With [frosted], it blurs what's behind it so it
/// reads well on top of photos.
class LabelChip extends StatelessWidget {
  const LabelChip({
    super.key,
    required this.label,
    this.icon,
    this.frosted = false,
  });

  final String label;
  final IconData? icon;
  final bool frosted;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: frosted
            ? AppColors.surface.withValues(alpha: 0.72)
            : AppColors.accentSoft,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: AppColors.accentDeep),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.accentDeep,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (!frosted) return content;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: content,
      ),
    );
  }
}
