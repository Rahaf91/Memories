import 'package:flutter/material.dart';

import '../../app/app_navigator.dart';
import '../../app/dependencies.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/l10n.dart';
import '../../models/friend_status.dart';
import '../../widgets/common/empty_state_card.dart';
import '../../widgets/common/mood_avatar.dart';
import '../add/create_actions.dart';

/// All friends. Reached from Home ("See all") and Profile.
class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  List<FriendStatus>? _friends;
  late final Listenable _changes = AppScope.of(context).dataChanges;

  @override
  void initState() {
    super.initState();
    _load();
    _changes.addListener(_load);
  }

  @override
  void dispose() {
    _changes.removeListener(_load);
    super.dispose();
  }

  Future<void> _load() async {
    final friends = await AppScope.of(context).friendsService.friendsToday();
    if (mounted) setState(() => _friends = friends);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final friends = _friends;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: l.addFriend,
            icon: const Icon(Icons.person_add_alt_outlined),
            onPressed: () => CreateActions.addFriend(context),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: friends == null
          ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
          : ListView(
              padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    AppSpacing.sm,
                    AppSpacing.screenPadding,
                    AppSpacing.xl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.friendsTitle,
                        style: AppTypography.of(context).displayTitle
                            .copyWith(fontSize: 38),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        friends.isEmpty
                            ? l.friendsSubtitle
                            : l.friendsCount(friends.length),
                        style: Theme.of(context).textTheme.bodyLarge
                            ?.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                if (friends.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding,
                    ),
                    child: EmptyStateCard(
                      icon: Icons.people_outline_rounded,
                      title: l.friendsEmptyTitle,
                      message: l.friendsEmptyBody,
                      actionLabel: l.addFriend,
                      actionIcon: Icons.person_add_alt_outlined,
                      onAction: () => CreateActions.addFriend(context),
                    ),
                  ),
                for (final (i, f) in friends.indexed) ...[
                  if (i > 0)
                    const Divider(
                      indent: AppSpacing.screenPadding + 48 + AppSpacing.md,
                      endIndent: AppSpacing.screenPadding,
                    ),
                  ListTile(
                    onTap: () =>
                        AppNavigator.openFriendProfile(context, f.friend),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding,
                      vertical: AppSpacing.xs,
                    ),
                    leading: MoodAvatar(
                      user: f.friend,
                      mood: f.todayMood,
                      size: 44,
                      showRing: f.todayMood != null,
                    ),
                    title: Text(
                      f.friend.displayName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      f.todayMood == null
                          ? l.noMoodToday
                          : l.feelingMood(l.mood(f.todayMood!)),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}
