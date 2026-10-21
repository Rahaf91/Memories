import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/l10n.dart';
import '../../models/scheduled_letter.dart';

/// Small pill with a letter's status: Waiting / Ready to open / Opened
/// (في الانتظار / جاهزة للفتح / تم فتحها).
class LetterStatusPill extends StatelessWidget {
  const LetterStatusPill({super.key, required this.state});

  final LetterState state;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final (IconData icon, String label, bool filled) = switch (state) {
      LetterState.locked => (
        Icons.lock_outline_rounded,
        l.statusWaiting,
        false,
      ),
      LetterState.ready ||
      LetterState.opening => (Icons.lock_open_rounded, l.readyToOpen, true),
      LetterState.opened => (Icons.drafts_outlined, l.statusOpened, false),
    };
    final fg = filled ? AppColors.onAccent : AppColors.textSecondary;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 320),
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: ScaleTransition(
          scale: Tween(begin: 0.92, end: 1.0).animate(anim),
          child: child,
        ),
      ),
      child: Container(
        key: ValueKey(state),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: filled
              ? AppColors.accent
              : AppColors.surface.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium
                  ?.copyWith(color: fg, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
