import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/app_user.dart';
import '../../models/mood.dart';
import '../home/mood_style.dart';
import 'mood_face.dart';
import 'user_avatar.dart';

/// Avatar with optional mood ring + mood-face badge and presence dot.
///
/// The face badge is drawn in the mood's color (it's that person's chosen
/// mood); with no mood, the ring is a faint neutral outline.
class MoodAvatar extends StatelessWidget {
  const MoodAvatar({
    super.key,
    required this.user,
    this.mood,
    this.size = 56,
    this.showRing = true,
    this.showMoodBadge = true,
    this.isOnline = false,
  });

  final AppUser user;
  final Mood? mood;
  final double size;
  final bool showRing;
  final bool showMoodBadge;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final m = mood;
    final badge = (size * 0.4).clamp(16.0, 24.0);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        UserAvatar(
          user: user,
          size: size,
          ringColor: showRing ? (m?.color ?? AppColors.stone) : null,
          ringWidth: m == null ? 1 : 2,
        ),
        if (showMoodBadge && m != null)
          PositionedDirectional(
            end: -2,
            bottom: -2,
            child: Container(
              width: badge,
              height: badge,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: Center(
                child: MoodFace(
                  mood: m,
                  color: m.deepColor,
                  size: badge * 0.68,
                ),
              ),
            ),
          )
        else if (isOnline)
          PositionedDirectional(
            end: 1,
            bottom: 1,
            child: Container(
              width: (size * 0.26).clamp(10.0, 14.0),
              height: (size * 0.26).clamp(10.0, 14.0),
              decoration: BoxDecoration(
                color: AppColors.online,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.background, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}
