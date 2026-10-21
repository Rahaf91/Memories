import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/date_format.dart';
import '../../l10n/l10n.dart';
import '../../models/chat_message.dart';
import '../../models/message_reaction.dart';
import 'reaction_icon.dart';

/// A chat bubble with grouped corners, reactions, and a quiet timestamp
/// under the last message of a group. Sent messages sit on the end side
/// (right in English, left in Arabic).
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.isMine,
    required this.viewerId,
    this.startsGroup = true,
    this.endsGroup = true,
    this.onLongPress,
    this.onDoubleTap,
  });

  final ChatMessage message;
  final bool isMine;
  final String viewerId;

  /// First / last bubble in a run from the same sender.
  final bool startsGroup;
  final bool endsGroup;

  /// Receives the bubble's context so a menu can be positioned near it.
  final ValueChanged<BuildContext>? onLongPress;
  final VoidCallback? onDoubleTap;

  static const _big = Radius.circular(20);
  static const _small = Radius.circular(6);

  BorderRadiusDirectional get _radius => isMine
      ? BorderRadiusDirectional.only(
          topStart: _big,
          bottomStart: _big,
          topEnd: startsGroup ? _big : _small,
          bottomEnd: endsGroup ? _big : _small,
        )
      : BorderRadiusDirectional.only(
          topEnd: _big,
          bottomEnd: _big,
          topStart: startsGroup ? _big : _small,
          bottomStart: endsGroup ? _big : _small,
        );

  String _statusLabel(AppLocalizations l) => switch (message.status) {
    MessageStatus.sending => l.sending,
    MessageStatus.sent => l.sent,
    MessageStatus.read => l.read,
    MessageStatus.failed => l.notSent,
  };

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final hasReactions = message.reactions.isNotEmpty;
    final maxWidth = MediaQuery.sizeOf(context).width * 0.74;

    final bubble = Builder(
      builder: (bubbleContext) => GestureDetector(
        onLongPress: onLongPress == null
            ? null
            : () => onLongPress!(bubbleContext),
        onDoubleTap: onDoubleTap,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: message.status == MessageStatus.sending ? 0.7 : 1,
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isMine ? AppColors.bubbleSent : AppColors.bubbleReceived,
              borderRadius: _radius,
            ),
            child: Text(
              message.text,
              style: textTheme.bodyLarge?.copyWith(
                fontSize: 15.5,
                height: 1.35,
                color: isMine ? AppColors.onAccent : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );

    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: isMine ? AppSpacing.xxxl : 0,
        end: isMine ? 0 : AppSpacing.xxxl,
        top: startsGroup ? AppSpacing.md : 2,
        bottom: hasReactions ? 14 : 0,
      ),
      child: Column(
        crossAxisAlignment: isMine
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              bubble,
              if (hasReactions)
                PositionedDirectional(
                  bottom: -16,
                  end: isMine ? null : -4,
                  start: isMine ? -4 : null,
                  child: _ReactionSummary(
                    reactions: message.reactions,
                    viewerId: viewerId,
                  ),
                ),
            ],
          ),
          if (endsGroup)
            Padding(
              padding: EdgeInsets.only(
                top: hasReactions ? 6 : 4,
                left: 4,
                right: 4,
              ),
              child: Text(
                [
                  formatTime(l, message.sentAt),
                  if (isMine) _statusLabel(l),
                ].join(' · '),
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Small pill under a bubble listing reactions (and a count when > 1).
class _ReactionSummary extends StatelessWidget {
  const _ReactionSummary({required this.reactions, required this.viewerId});

  final List<MessageReaction> reactions;
  final String viewerId;

  @override
  Widget build(BuildContext context) {
    final types = <ReactionType>{for (final r in reactions) r.type};
    final mine = reactions.any((r) => r.userId == viewerId);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.6, end: 1),
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutBack,
      builder: (_, scale, child) => Transform.scale(scale: scale, child: child),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: mine
                ? AppColors.accent.withValues(alpha: 0.35)
                : AppColors.border,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final t in types)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.5),
                child: ReactionIcon(
                  type: t,
                  size: 13,
                  color: mine ? AppColors.accent : AppColors.textSecondary,
                ),
              ),
            if (reactions.length > 1)
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 3),
                child: Text(
                  '${reactions.length}',
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(color: AppColors.textSecondary),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
