import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'pressable.dart';

/// Rounded surface used for all cards in the app.
///
/// Tappable cards get a subtle press-down scale.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.color = AppColors.surface,
    this.gradient,
    this.borderColor = AppColors.border,
    this.elevated = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color color;

  /// Overrides [color] when set.
  final Gradient? gradient;
  final Color borderColor;

  /// Adds a very soft drop shadow.
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      pressedScale: 0.985,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: gradient == null ? color : null,
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: borderColor),
          boxShadow: elevated
              ? const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 24,
                    offset: Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: child,
      ),
    );
  }
}
