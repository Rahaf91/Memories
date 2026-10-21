import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/date_format.dart';
import '../../core/utils/people_format.dart';
import '../../l10n/l10n.dart';
import '../../models/memory.dart';
import '../common/app_card.dart';
import '../common/avatar_stack.dart';
import '../common/engagement_actions.dart';
import '../common/label_chip.dart';
import '../common/media_image.dart';
import 'memory_visibility_style.dart';

/// Hero tag shared by the card media and the detail screen media.
String memoryHeroTag(String memoryId) => 'memory-cover-$memoryId';

/// Large media-led card for a single memory.
class MemoryCard extends StatelessWidget {
  const MemoryCard({
    super.key,
    required this.memory,
    required this.viewerId,
    this.onTap,
    this.onReact,
    this.onComment,
  });

  final Memory memory;

  /// The signed-in user, so "people involved" can exclude them.
  final String viewerId;
  final VoidCallback? onTap;
  final VoidCallback? onReact;
  final VoidCallback? onComment;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final people = memory.peopleExcept(viewerId);
    final meta = [
      formatShortDate(l, memory.takenAt),
      ?memory.location,
    ].join(' · ');

    return AppCard(
      onTap: onTap,
      elevated: true,
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 5 / 4,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: memoryHeroTag(memory.id),
                  child: MediaImage(
                    source: memory.coverUrl,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                ),
                PositionedDirectional(
                  top: AppSpacing.md,
                  start: AppSpacing.md,
                  child: LabelChip(
                    label: l.visibility(memory.visibility),
                    icon: memory.visibility.icon,
                    frosted: true,
                  ),
                ),
                if (memory.imageUrls.length > 1)
                  PositionedDirectional(
                    top: AppSpacing.md,
                    end: AppSpacing.md,
                    child: LabelChip(
                      label: '${memory.imageUrls.length}',
                      icon: Icons.photo_library_outlined,
                      frosted: true,
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.sm,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(memory.title, style: AppTypography.of(context).cardTitle),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  meta,
                  style: textTheme.labelMedium?.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                if (memory.caption != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    memory.caption!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: AppSpacing.sm,
              top: AppSpacing.md,
            ),
            child: Row(
              children: [
                if (people.isNotEmpty) ...[
                  AvatarStack(users: people, size: 22, maxVisible: 3),
                  const SizedBox(width: AppSpacing.sm),
                ] else
                  const Padding(
                    padding: EdgeInsetsDirectional.only(end: 6),
                    child: Icon(
                      Icons.lock_outline_rounded,
                      size: 16,
                      color: AppColors.textTertiary,
                    ),
                  ),
                Expanded(
                  child: Text(
                    people.isEmpty
                        ? l.onlyYou
                        : l.withPeople(formatPeople(l, people)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.labelLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                ReactionButton(
                  active: memory.hasReacted,
                  count: memory.reactionCount,
                  onTap: onReact,
                ),
                EngagementAction(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: '${memory.commentCount}',
                  onTap: onComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
