import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/dependencies.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/date_format.dart';
import '../../l10n/l10n.dart';
import '../../models/conversation.dart';
import '../../models/message_reaction.dart';
import '../../widgets/chat/chat_attachment_sheet.dart';
import '../../widgets/chat/message_bubble.dart';
import '../../widgets/chat/message_composer.dart';
import '../../widgets/chat/reaction_menu.dart';
import '../../widgets/common/coming_soon.dart';
import '../../widgets/common/mood_avatar.dart';
import '../../widgets/common/mood_face.dart';
import '../../widgets/common/overline_text.dart';
import '../../widgets/home/mood_style.dart';
import 'conversation_controller.dart';
import 'conversation_items.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({
    super.key,
    required this.conversation,
    required this.viewerId,
  });

  final Conversation conversation;
  final String viewerId;

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  late final ConversationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConversationController(
      AppScope.of(context).chatService,
      conversation: widget.conversation,
      viewerId: widget.viewerId,
    )..start();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openReactions(
    BuildContext bubbleContext,
    MessageItem item,
  ) async {
    final message = item.message;
    final result = await showReactionMenu(
      bubbleContext,

      current: message.reactionBy(widget.viewerId)?.type,
    );
    switch (result) {
      case ReactionPicked(:final type):
        _controller.react(message, type);
      case CopyPicked():
        await Clipboard.setData(ClipboardData(text: message.text));
        if (mounted) showCopied();
      case null:
        break;
    }
  }

  void showCopied() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(context.l10n.copied),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 1),
        ),
      );
  }

  Future<void> _attach() async {
    final choice = await showChatAttachmentSheet(context);
    if (choice != null && mounted) {
      showComingSoon(context, choice.label(context.l10n));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,

          title: ListenableBuilder(
            listenable: _controller,
            builder: (context, _) => _Header(
              conversation: widget.conversation,
              controller: _controller,
            ),
          ),
          actions: [
            IconButton(
              tooltip: context.l10n.more,
              icon: const Icon(Icons.more_horiz_rounded),
              onPressed: () =>
                  showComingSoon(context, context.l10n.chatOptions),
            ),
            const SizedBox(width: AppSpacing.xs),
          ],
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(),
          ),
        ),
        // Composer lives in the body so it rises with the keyboard.
        body: Column(
          children: [
            Expanded(
              child: ListenableBuilder(
                listenable: _controller,
                builder: (context, _) {
                  if (_controller.loading) {
                    return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  }
                  final items = _controller.items;
                  return ListView.builder(
                    // Newest at the bottom, anchored to the composer.
                    reverse: true,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[items.length - 1 - index];
                      return switch (item) {
                        DayItem(:final day) => _DaySeparator(day: day),
                        MessageItem() => Align(
                          key: ValueKey(item.message.id),
                          alignment: item.isMine
                              ? AlignmentDirectional.centerEnd
                              : AlignmentDirectional.centerStart,
                          child: MessageBubble(
                            message: item.message,
                            isMine: item.isMine,
                            viewerId: widget.viewerId,
                            startsGroup: item.startsGroup,
                            endsGroup: item.endsGroup,
                            onLongPress: (ctx) => _openReactions(ctx, item),
                            onDoubleTap: () => _controller.react(
                              item.message,
                              ReactionType.love,
                            ),
                          ),
                        ),
                      };
                    },
                  );
                },
              ),
            ),
            MessageComposer(onSend: _controller.send, onAttach: _attach),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.conversation, required this.controller});

  final Conversation conversation;
  final ConversationController controller;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final mood = controller.peerMood;
    final status = [
      if (mood != null) l.feelingMood(l.mood(mood)),
      if (conversation.isPeerOnline) l.online,
    ].join(' · ');

    return Row(
      children: [
        MoodAvatar(
          user: conversation.peer,
          size: 38,
          showRing: false,
          showMoodBadge: false,
          isOnline: conversation.isPeerOnline,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                conversation.peer.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleMedium,
              ),
              if (status.isNotEmpty)
                Row(
                  children: [
                    if (mood != null) ...[
                      MoodFace(
                        mood: mood,
                        color: mood.deepColor,
                        size: 13,
                        showOutline: true,
                      ),
                      const SizedBox(width: 5),
                    ],
                    Flexible(
                      child: Text(
                        status,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.labelMedium?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DaySeparator extends StatelessWidget {
  const _DaySeparator({required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl, bottom: AppSpacing.sm),
      child: Center(
        child: OverlineText(
          formatChatDay(context.l10n, day),
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
}
