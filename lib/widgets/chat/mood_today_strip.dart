import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/l10n.dart';
import '../../models/friend_status.dart';
import '../common/app_card.dart';
import '../common/mood_avatar.dart';
import '../common/pressable.dart';

/// Compact card showing friends' moods today (Chat tab).
class MoodTodayStrip extends StatelessWidget {
  const MoodTodayStrip({super.key, required this.friends, this.onTap});

  final List<FriendStatus> friends;
  final ValueChanged<FriendStatus>? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: SizedBox(
        height: 108,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          itemCount: friends.length,
          separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.lg),
          itemBuilder: (context, i) {
            final f = friends[i];
            return Pressable(
              onTap: onTap == null ? null : () => onTap!(f),
              child: SizedBox(
                width: 60,
                child: Column(
                  children: [
                    MoodAvatar(user: f.friend, mood: f.todayMood, size: 48),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      f.friend.firstName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.labelMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      f.todayMood == null
                          ? context.l10n.notYet
                          : context.l10n.mood(f.todayMood!),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.labelSmall?.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
