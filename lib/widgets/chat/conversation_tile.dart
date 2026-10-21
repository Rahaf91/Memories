import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/date_format.dart';
import '../../l10n/l10n.dart';
import '../../models/conversation.dart';
import '../../models/mood.dart';
import '../common/mood_avatar.dart';
import '../common/mood_face.dart';
import '../common/pressable.dart';
import '../home/mood_style.dart';

/// One row in the conversation list.
class ConversationTile extends StatelessWidget {
  const ConversationTile({
    super.key,
    required this.conversation,
    required this.viewerId,
    required this.onTap,
    this.peerMood,
  });

  final Conversation conversation;
  final String viewerId;
  final Mood? peerMood;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final last = conversation.lastMessage;
    final unread = conversation.unreadCount;
    final hasUnread = unread > 0;
    final preview = last == null
        ? l.sayHello
        : last.isFrom(viewerId)
        ? l.youPrefix(last.text)
        : last.text;

    return Semantics(
      button: true,
      // One clear spoken summary instead of each text piece separately.
      excludeSemantics: true,
      label: [
        conversation.title,
        if (hasUnread) l.unreadCount(unread),
        if (peerMood != null) l.feelingMood(l.mood(peerMood!)),
        preview,
      ].join(', '),
      child: Pressable(
        onTap: onTap,
        pressedScale: 0.985,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              MoodAvatar(
                user: conversation.peer,
                size: 52,
                showRing: false,
                showMoodBadge: false,
                isOnline: conversation.isPeerOnline,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            conversation.peer.firstName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleMedium,
                          ),
                        ),
                        if (peerMood != null) ...[
                          const SizedBox(width: 6),
                          Semantics(
                            label: l.feelingMood(l.mood(peerMood!)),
                            child: MoodFace(
                              mood: peerMood!,
                              color: peerMood!.deepColor,
                              size: 15,
                              showOutline: true,
                            ),
                          ),
                        ],
                        const Spacer(),
                        if (last != null)
                          Text(
                            formatChatTime(l, last.sentAt),
                            style: textTheme.labelMedium?.copyWith(
                              color: hasUnread
                                  ? AppColors.accent
                                  : AppColors.textTertiary,
                              fontWeight: hasUnread
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            preview,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium?.copyWith(
                              color: hasUnread
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                              fontWeight: hasUnread
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          transitionBuilder: (child, anim) =>
                              ScaleTransition(scale: anim, child: child),
                          child: hasUnread
                              ? Container(
                                  key: ValueKey(unread),
                                  margin: const EdgeInsetsDirectional.only(
                                    start: AppSpacing.sm,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 20,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent,
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.pill,
                                    ),
                                  ),
                                  child: Text(
                                    '$unread',
                                    textAlign: TextAlign.center,
                                    style: textTheme.labelSmall?.copyWith(
                                      color: AppColors.onAccent,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
