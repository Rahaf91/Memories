import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'pressable.dart';

/// Round icon button with an optional small dot indicating unread items.
class BadgeIconButton extends StatelessWidget {
  const BadgeIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.showBadge = false,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool showBadge;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tooltip,
      child: Pressable(
        onTap: onPressed,
        pressedScale: 0.92,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.75),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.surface),
          ),
          child: Stack(
            children: [
              Center(child: Icon(icon, size: 22)),
              PositionedDirectional(
                top: 9,
                end: 9,
                child: AnimatedScale(
                  scale: showBadge ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 1.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
