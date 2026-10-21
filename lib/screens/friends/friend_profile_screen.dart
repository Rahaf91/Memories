import 'package:flutter/material.dart';

import '../../app/app_navigator.dart';
import '../../app/dependencies.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/l10n.dart';
import '../../models/app_user.dart';
import '../../models/friend_status.dart';
import '../../widgets/common/app_card.dart';
import '../../widgets/common/empty_state_card.dart';
import '../../widgets/common/mood_avatar.dart';
import '../../widgets/common/primary_button.dart';

/// A friend's profile: mood today, shared memories, and quick actions.
class FriendProfileScreen extends StatefulWidget {
  const FriendProfileScreen({super.key, required this.friend});

  final AppUser friend;

  @override
  State<FriendProfileScreen> createState() => _FriendProfileScreenState();
}

class _FriendProfileScreenState extends State<FriendProfileScreen> {
  FriendStatus? _status;
  int _sharedCount = 0;

  @override
  void initState() {
    super.initState();
    final service = AppScope.of(context).friendsService;
    service.statusOf(widget.friend.id).then((s) {
      if (mounted) setState(() => _status = s);
    });
    service.memoriesWith(widget.friend.id).then((m) {
      if (mounted) setState(() => _sharedCount = m.length);
    });
  }

  Future<void> _message() async {
    final chat = AppScope.of(context).chatService;
    final me = await chat.currentUser();
    final conversation = await chat.startConversation(me.id, widget.friend);
    if (!mounted) return;
    await AppNavigator.openConversation(
      context,
      conversation: conversation,
      viewerId: me.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final mood = _status?.todayMood;

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.md,
          AppSpacing.screenPadding,
          AppSpacing.xxl,
        ),
        children: [
          Center(
            child: MoodAvatar(
              user: widget.friend,
              mood: mood,
              size: 96,
              showRing: mood != null,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            widget.friend.displayName,
            textAlign: TextAlign.center,
            style: AppTypography.of(context).cardTitle.copyWith(fontSize: 30),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            mood == null ? l.noMoodToday : l.feelingMood(l.mood(mood)),
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: l.message,
            icon: Icons.chat_bubble_outline_rounded,
            onPressed: _message,
          ),
          const SizedBox(height: AppSpacing.xl),
          AppCard(
            onTap: () => AppNavigator.openOurStory(context, widget.friend),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.accentSoft,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Icon(
                    Icons.auto_stories_outlined,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.ourStory, style: textTheme.titleMedium),
                      Text(
                        '$_sharedCount ${l.sharedMemoriesStat(_sharedCount)}',
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
          ),
          if (_sharedCount == 0) ...[
            const SizedBox(height: AppSpacing.md),
            EmptyStateCard(
              icon: Icons.photo_library_outlined,
              title: l.ourStoryEmptyTitle,
              message: l.ourStoryEmptyBody(widget.friend.firstName),
            ),
          ],
        ],
      ),
    );
  }
}
