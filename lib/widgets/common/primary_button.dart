import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'pressable.dart';

/// Full-width plum pill button. Shows a spinner while [busy].
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.busy = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !busy;
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      excludeSemantics: true,
      child: Pressable(
        onTap: enabled ? onPressed : null,
        pressedScale: 0.98,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: enabled
                ? AppColors.accent
                : AppColors.accent.withValues(alpha: busy ? 0.85 : 0.4),
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: busy
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.onAccent,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 20, color: AppColors.onAccent),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(color: AppColors.onAccent),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
