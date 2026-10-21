import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Compact icon + count action (comments, saves, …).
class EngagementAction extends StatelessWidget {
  const EngagementAction({
    super.key,
    required this.icon,
    this.label,
    this.onTap,
  });

  final IconData icon;
  final String? label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textSecondary,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        visualDensity: VisualDensity.compact,
      ),
      icon: Icon(icon, size: 20),
      label: label == null ? const SizedBox.shrink() : Text(label!),
    );
  }
}

/// Reaction toggle with a small pop when activated.
class ReactionButton extends StatelessWidget {
  const ReactionButton({
    super.key,
    required this.active,
    required this.count,
    this.onTap,
  });

  final bool active;
  final int count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.accent : AppColors.textSecondary;
    return TextButton.icon(
      onPressed: onTap == null
          ? null
          : () {
              HapticFeedback.lightImpact();
              onTap!();
            },
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        visualDensity: VisualDensity.compact,
      ),
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        transitionBuilder: (child, anim) => ScaleTransition(
          scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
          child: child,
        ),
        child: Icon(
          active ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          key: ValueKey(active),
          size: 20,
          color: color,
        ),
      ),
      label: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Text('$count', key: ValueKey(count)),
      ),
    );
  }
}
