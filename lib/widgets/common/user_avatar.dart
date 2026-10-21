import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/app_user.dart';
import 'media_image.dart';

/// Circular avatar: the user's photo once uploaded, otherwise a neutral
/// circle with their initials.
///
/// When [ringColor] is set, a thin ring is drawn with a small gap.
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.user,
    this.size = 48,
    this.ringColor,
    this.ringWidth = 2,
    this.borderColor,
  });

  final AppUser user;

  /// Diameter of the photo itself (ring is drawn outside it).
  final double size;
  final Color? ringColor;
  final double ringWidth;

  /// Solid border directly around the photo, e.g. for overlapping stacks.
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final photo = mediaImageProvider(user.avatarUrl);
    Widget avatar = CircleAvatar(
      radius: size / 2,
      backgroundColor: AppColors.surfaceMuted,
      foregroundImage: photo,
      onForegroundImageError: photo != null ? (_, _) {} : null,
      child: Text(
        user.initials,
        style: TextStyle(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
          fontSize: size * 0.36,
          letterSpacing: 0.3,
        ),
      ),
    );

    if (borderColor != null) {
      avatar = DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor!, width: 2),
        ),
        child: avatar,
      );
    }

    if (ringColor == null) return avatar;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.all(ringWidth + 1.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ringColor!, width: ringWidth),
      ),
      child: avatar,
    );
  }
}
