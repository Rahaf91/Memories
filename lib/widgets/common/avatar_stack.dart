import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/app_user.dart';
import 'user_avatar.dart';

/// Overlapping row of small avatars, with a "+N" chip for the overflow.
class AvatarStack extends StatelessWidget {
  const AvatarStack({
    super.key,
    required this.users,
    this.size = 28,
    this.maxVisible = 4,
    this.borderColor = AppColors.surface,
  });

  final List<AppUser> users;
  final double size;
  final int maxVisible;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final visible = users.take(maxVisible).toList();
    final overflow = users.length - visible.length;
    final outer = size + 4; // avatar + border
    final step = outer * 0.68;
    final count = visible.length + (overflow > 0 ? 1 : 0);

    return SizedBox(
      height: outer,
      width: count == 0 ? 0 : step * (count - 1) + outer,
      child: Stack(
        children: [
          for (var i = 0; i < visible.length; i++)
            PositionedDirectional(
              start: i * step,
              child: UserAvatar(
                user: visible[i],
                size: size,
                borderColor: borderColor,
              ),
            ),
          if (overflow > 0)
            PositionedDirectional(
              start: visible.length * step,
              child: Container(
                width: outer,
                height: outer,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor, width: 2),
                ),
                child: Text(
                  '+$overflow',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
