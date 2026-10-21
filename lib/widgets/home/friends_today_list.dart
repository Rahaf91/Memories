import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/l10n.dart';
import '../../models/friend_status.dart';
import '../common/mood_avatar.dart';
import '../common/pressable.dart';

/// Horizontal list of friends with a mood-tinted ring and status line.
/// The parent shows an empty state when there are no friends.
class FriendsTodayList extends StatelessWidget {
  const FriendsTodayList({super.key, required this.friends, this.onFriendTap});

  final List<FriendStatus> friends;
  final ValueChanged<FriendStatus>? onFriendTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 126,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        itemCount: friends.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final status = friends[index];
          return _FriendTile(
            status: status,
            onTap: onFriendTap == null ? null : () => onFriendTap!(status),
          );
        },
      ),
    );
  }
}

class _FriendTile extends StatelessWidget {
  const _FriendTile({required this.status, this.onTap});

  final FriendStatus status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final mood = status.todayMood;
    final subtitle = status.note ?? (mood == null ? l.notYet : l.mood(mood));

    return Pressable(
      onTap: onTap,
      child: SizedBox(
        width: 74,
        child: Column(
          children: [
            MoodAvatar(user: status.friend, mood: mood, size: 60),
            const SizedBox(height: AppSpacing.sm),
            Text(
              status.friend.firstName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.labelLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              subtitle,
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
  }
}
