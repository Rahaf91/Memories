import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/app_navigator.dart';
import '../../app/dependencies.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/l10n.dart';
import '../../widgets/chat/conversation_tile.dart';
import '../../widgets/chat/mood_today_strip.dart';
import '../../widgets/common/app_card.dart';
import '../../widgets/common/badge_icon_button.dart';
import '../../widgets/common/coming_soon.dart';
import '../../widgets/common/empty_state_card.dart';
import '../../widgets/common/screen_header.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/common/status_bar_scrim.dart';
import '../add/create_actions.dart';
import 'chat_list_controller.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late final ChatListController _controller;

  @override
  void initState() {
    super.initState();
    final deps = AppScope.of(context);
    _controller = ChatListController(
      deps.chatService,
      changes: deps.dataChanges,
    )..start();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Stack(
          children: [
            ListenableBuilder(
              listenable: _controller,
              builder: (context, _) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: switch (_controller.status) {
                  ChatListStatus.loading => const Center(
                    key: ValueKey('loading'),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  ChatListStatus.error => Center(
                    key: const ValueKey('error'),
                    child: Text(context.l10n.loadError),
                  ),
                  ChatListStatus.ready => _buildContent(context),
                },
              ),
            ),
            const StatusBarScrim(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final l = context.l10n;
    const gutter = EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding);
    final padding = MediaQuery.paddingOf(context);
    final user = _controller.user!;
    final moods = _controller.moodByUser;
    final conversations = _controller.conversations;
    final unread = _controller.totalUnread;
    final hasFriends = _controller.friends.isNotEmpty;

    return ListView(
      key: const ValueKey('content'),
      padding: EdgeInsets.only(
        top: padding.top + AppSpacing.xl,
        bottom: padding.bottom + AppSpacing.xl,
      ),
      children: [
        ScreenHeader(
          title: l.chatTitle,
          subtitle: l.chatSubtitle,
          actions: [
            BadgeIconButton(
              icon: Icons.search_rounded,
              tooltip: l.search,
              onPressed: () => showComingSoon(context, l.search),
            ),
            BadgeIconButton(
              icon: Icons.add_comment_outlined,
              tooltip: l.newMessage,
              onPressed: () => CreateActions.startChat(context),
            ),
          ],
        ),

        // Mood Today
        const SizedBox(height: AppSpacing.xxl),
        SectionHeader(
          title: l.moodTodayTitle,
          subtitle: moods.isEmpty
              ? null
              : l.friendsCheckedIn(moods.length, _controller.friends.length),
        ),
        const SizedBox(height: AppSpacing.md),
        Padding(
          padding: gutter,
          child: moods.isEmpty
              ? _MoodTodayEmpty(
                  hasFriends: hasFriends,
                  onAddFriend: () => CreateActions.addFriend(context),
                )
              : MoodTodayStrip(
                  friends: _controller.moodToday,
                  onTap: (f) =>
                      AppNavigator.openFriendProfile(context, f.friend),
                ),
        ),

        // Messages
        const SizedBox(height: AppSpacing.xxl),
        SectionHeader(
          title: l.messagesTitle,
          subtitle: conversations.isEmpty
              ? null
              : unread == 0
              ? l.allCaughtUp
              : l.unreadCount(unread),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (conversations.isEmpty)
          Padding(
            padding: gutter.copyWith(top: AppSpacing.sm),
            child: EmptyStateCard(
              icon: Icons.chat_bubble_outline_rounded,
              title: l.conversationsEmptyTitle,
              message: l.conversationsEmptyBody,
              actionLabel: l.startChat,
              actionIcon: Icons.add_comment_outlined,
              onAction: () => CreateActions.startChat(context),
            ),
          ),
        for (final (i, c) in conversations.indexed) ...[
          if (i > 0)
            const Divider(
              indent: AppSpacing.screenPadding + 52 + AppSpacing.md,
              endIndent: AppSpacing.screenPadding,
            ),
          ConversationTile(
            key: ValueKey(c.id),
            conversation: c,
            viewerId: user.id,
            peerMood: moods[c.peer.id],
            onTap: () => AppNavigator.openConversation(
              context,
              conversation: c,
              viewerId: user.id,
            ),
          ),
        ],
      ],
    );
  }
}

/// Compact empty state for Mood Today.
class _MoodTodayEmpty extends StatelessWidget {
  const _MoodTodayEmpty({required this.hasFriends, required this.onAddFriend});

  final bool hasFriends;
  final VoidCallback onAddFriend;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          const Icon(
            Icons.sentiment_neutral_outlined,
            color: AppColors.textTertiary,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              l.moodTodayEmpty,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          if (!hasFriends)
            TextButton(onPressed: onAddFriend, child: Text(l.addFriend)),
        ],
      ),
    );
  }
}
