import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/l10n.dart';
import '../../models/message_reaction.dart';
import 'reaction_icon.dart';

/// What the user picked in the reaction menu.
sealed class ReactionMenuResult {
  const ReactionMenuResult();
}

class ReactionPicked extends ReactionMenuResult {
  const ReactionPicked(this.type);
  final ReactionType type;
}

class CopyPicked extends ReactionMenuResult {
  const CopyPicked();
}

/// Shows a small floating reaction pill next to the bubble in
/// [anchorContext]. [current] is highlighted.
Future<ReactionMenuResult?> showReactionMenu(
  BuildContext anchorContext, {
  ReactionType? current,
}) {
  final box = anchorContext.findRenderObject() as RenderBox;
  final rect = box.localToGlobal(Offset.zero) & box.size;
  // Anchor to the screen side the bubble sits on (works in LTR and RTL).
  final screenWidth = MediaQuery.sizeOf(anchorContext).width;
  final alignRight = rect.center.dx > screenWidth / 2;
  HapticFeedback.mediumImpact();

  return showGeneralDialog<ReactionMenuResult>(
    context: anchorContext,
    barrierDismissible: true,
    barrierLabel: anchorContext.l10n.closeReactions,
    barrierColor: AppColors.textPrimary.withValues(alpha: 0.08),
    transitionDuration: const Duration(milliseconds: 180),
    pageBuilder: (context, _, _) {
      final media = MediaQuery.of(context);
      const menuHeight = 52.0;
      final above = rect.top - menuHeight - 8;
      final top = above > media.padding.top + 8 ? above : rect.bottom + 8;
      return Stack(
        children: [
          Positioned(
            top: top,
            left: alignRight ? null : rect.left,
            right: alignRight ? media.size.width - rect.right : null,
            child: _ReactionPill(current: current),
          ),
        ],
      );
    },
    transitionBuilder: (context, anim, _, child) => FadeTransition(
      opacity: anim,
      child: ScaleTransition(
        scale: Tween(
          begin: 0.92,
          end: 1.0,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
        alignment: alignRight ? Alignment.bottomRight : Alignment.bottomLeft,
        child: child,
      ),
    ),
  );
}

class _ReactionPill extends StatelessWidget {
  const _ReactionPill({this.current});

  final ReactionType? current;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      elevation: 0,
      shape: StadiumBorder(side: BorderSide(color: AppColors.border)),
      shadowColor: Colors.transparent,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final type in ReactionType.values)
              _MenuButton(
                label: context.l10n.reaction(type),
                selected: type == current,
                onTap: () => Navigator.of(context).pop(ReactionPicked(type)),
                child: ReactionIcon(
                  type: type,
                  size: 20,
                  color: type == current
                      ? AppColors.accent
                      : AppColors.textSecondary,
                ),
              ),
            Container(
              width: 1,
              height: 24,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              color: AppColors.border,
            ),
            _MenuButton(
              label: context.l10n.copy,
              onTap: () => Navigator.of(context).pop(const CopyPicked()),
              child: const Icon(
                Icons.copy_rounded,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.label,
    required this.onTap,
    required this.child,
    this.selected = false,
  });

  final String label;
  final VoidCallback onTap;
  final Widget child;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        radius: 22,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.accentSoft : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: child,
        ),
      ),
    );
  }
}
