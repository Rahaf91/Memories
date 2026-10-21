import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/date_format.dart';
import '../../l10n/l10n.dart';
import '../../models/moment.dart';
import '../common/app_card.dart';
import '../common/engagement_actions.dart';
import '../common/media_image.dart';
import '../common/user_avatar.dart';

/// Photo-led card for a memory a friend shared.
class MomentCard extends StatelessWidget {
  const MomentCard({
    super.key,
    required this.moment,
    this.onTap,
    this.onReact,
    this.onComment,
    this.onSave,
  });

  final Moment moment;
  final VoidCallback? onTap;
  final VoidCallback? onReact;
  final VoidCallback? onComment;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final name = moment.author.firstName;
    final headline = l.sharedMemoryWithYou(name);
    // Bold the name wherever the translation places it.
    final at = headline.indexOf(name);

    return AppCard(
      onTap: onTap,
      elevated: true,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.md,
            ),
            child: Row(
              children: [
                UserAvatar(user: moment.author, size: 38),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        at < 0
                            ? TextSpan(text: headline)
                            : TextSpan(
                                children: [
                                  TextSpan(text: headline.substring(0, at)),
                                  TextSpan(
                                    text: name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: headline.substring(at + name.length),
                                  ),
                                ],
                              ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        timeAgo(l, moment.createdAt),
                        style: textTheme.labelMedium?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  tooltip: l.more,
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(
                    Icons.more_horiz_rounded,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: MediaImage(
                source: moment.imageUrl,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(moment.title, style: AppTypography.of(context).cardTitle),
                if (moment.caption != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    moment.caption!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Row(
              children: [
                ReactionButton(
                  active: moment.hasReacted,
                  count: moment.reactionCount,
                  onTap: onReact,
                ),
                EngagementAction(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: moment.commentCount > 0
                      ? '${moment.commentCount}'
                      : null,
                  onTap: onComment,
                ),
                const Spacer(),
                EngagementAction(
                  icon: Icons.bookmark_border_rounded,
                  onTap: onSave,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
