import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Soft fade behind the status bar so scrolled content stays legible.
/// Place as the last child of a [Stack].
class StatusBarScrim extends StatelessWidget {
  const StatusBarScrim({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: top + AppSpacing.md,
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.background,
                AppColors.background.withValues(alpha: 0.85),
                AppColors.background.withValues(alpha: 0),
              ],
              stops: const [0, 0.7, 1],
            ),
          ),
        ),
      ),
    );
  }
}
