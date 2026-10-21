import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/dependencies.dart';
import '../../l10n/l10n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/date_format.dart';
import '../../models/app_user.dart';
import '../../models/memory.dart';
import '../../widgets/common/app_card.dart';
import '../../widgets/common/media_image.dart';
import '../../widgets/common/coming_soon.dart';
import '../../widgets/common/engagement_actions.dart';
import '../../widgets/common/glass_icon_button.dart';
import '../../widgets/common/label_chip.dart';
import '../../widgets/common/overline_text.dart';
import '../../widgets/common/user_avatar.dart';
import '../../widgets/memories/memory_card.dart';
import '../../widgets/memories/memory_visibility_style.dart';

/// Placeholder detail view for a single memory.
class MemoryDetailScreen extends StatefulWidget {
  const MemoryDetailScreen({
    super.key,
    required this.memory,
    required this.viewerId,
  });

  /// Shown immediately; the screen keeps its own copy for reactions.
  final Memory memory;
  final String viewerId;

  @override
  State<MemoryDetailScreen> createState() => _MemoryDetailScreenState();
}

class _MemoryDetailScreenState extends State<MemoryDetailScreen> {
  late Memory _memory = widget.memory;
  int _page = 0;

  Future<void> _toggleReaction() async {
    final before = _memory;
    final reacted = !before.hasReacted;
    setState(() {
      _memory = before.copyWith(
        hasReacted: reacted,
        reactionCount: before.reactionCount + (reacted ? 1 : -1),
      );
    });
    try {
      await AppScope.of(context).memoriesService
          .setReaction(before.id, widget.viewerId, reacted: reacted);
    } catch (_) {
      if (mounted) setState(() => _memory = before);
    }
  }

  @override
  Widget build(BuildContext context) {
    final memory = _memory;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              stretch: true,
              expandedHeight: screenHeight * 0.52,
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.background,
              leadingWidth: 64,
              leading: Padding(
                padding: const EdgeInsetsDirectional.only(start: AppSpacing.lg),
                child: Center(
                  child: GlassIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    tooltip: MaterialLocalizations.of(context)
                        .backButtonTooltip,
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ),
              ),
              actions: [
                GlassIconButton(
                  icon: Icons.ios_share_rounded,
                  tooltip: context.l10n.share,
                  onPressed: () => showComingSoon(context, context.l10n.share),
                ),
                const SizedBox(width: AppSpacing.sm),
                GlassIconButton(
                  icon: Icons.more_horiz_rounded,
                  tooltip: context.l10n.more,
                  onPressed: () =>
                      showComingSoon(context, context.l10n.moreOptions),
                ),
                const SizedBox(width: AppSpacing.lg),
              ],
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [StretchMode.zoomBackground],
                background: _PhotoPager(
                  memory: memory,
                  page: _page,
                  onPageChanged: (i) => setState(() => _page = i),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _DetailBody(
                memory: memory,
                viewerId: widget.viewerId,
                onReact: _toggleReaction,
              ),
            ),
          ],
        ),
        bottomNavigationBar: const _CommentComposer(),
      ),
    );
  }
}

class _PhotoPager extends StatelessWidget {
  const _PhotoPager({
    required this.memory,
    required this.page,
    required this.onPageChanged,
  });

  final Memory memory;
  final int page;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final urls = memory.imageUrls;
    return Stack(
      fit: StackFit.expand,
      children: [
        Hero(
          tag: memoryHeroTag(memory.id),
          child: PageView.builder(
            itemCount: urls.isEmpty ? 1 : urls.length,
            onPageChanged: onPageChanged,
            itemBuilder: (_, i) =>
                MediaImage(source: urls.isEmpty ? null : urls[i]),
          ),
        ),
        if (urls.length > 1)
          Positioned(
            bottom: AppSpacing.lg,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < urls.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: i == page ? 18 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(
                          alpha: i == page ? 0.95 : 0.55,
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({
    required this.memory,
    required this.viewerId,
    required this.onReact,
  });

  final Memory memory;
  final String viewerId;
  final VoidCallback onReact;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final people = memory.peopleExcept(viewerId);
    final meta = [
      formatFullDate(l, memory.takenAt),
      ?memory.location,
    ].join(' · ');

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.xl,
        AppSpacing.screenPadding,
        AppSpacing.xxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              LabelChip(
                label: l.visibility(memory.visibility),
                icon: memory.visibility.icon,
              ),
              if (memory.capsuleTitle != null)
                LabelChip(label: memory.capsuleTitle!),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            memory.title,
            style: AppTypography.of(context).displayTitle
                .copyWith(fontSize: 38),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            meta,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          if (memory.caption != null)
            Text(
              memory.caption!,
              style: textTheme.bodyLarge?.copyWith(
                fontSize: 17,
                height: 1.5,
                color: AppColors.textPrimary,
              ),
            ),
          const SizedBox(height: AppSpacing.xl),
          OverlineText(l.withOverline),
          const SizedBox(height: AppSpacing.md),
          if (people.isEmpty)
            Text(l.onlyYou, style: textTheme.bodyMedium)
          else
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [for (final p in people) _PersonChip(user: p)],
            ),
          const SizedBox(height: AppSpacing.xl),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Row(
              children: [
                ReactionButton(
                  active: memory.hasReacted,
                  count: memory.reactionCount,
                  onTap: onReact,
                ),
                EngagementAction(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: '${memory.commentCount}',
                ),
                const Spacer(),
                EngagementAction(
                  icon: Icons.bookmark_border_rounded,
                  onTap: () => showComingSoon(context, l.save),
                ),
              ],
            ),
          ),
          const Divider(),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Text(l.commentsTitle, style: textTheme.titleLarge),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '${memory.commentCount}',
                style: textTheme.titleLarge?.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            color: AppColors.surfaceMuted,
            borderColor: Colors.transparent,
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Row(
              children: [
                const Icon(Icons.forum_outlined, color: AppColors.textTertiary),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    l.commentsPlaceholder,
                    style: textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonChip extends StatelessWidget {
  const _PersonChip({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 4, 14, 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          UserAvatar(user: user, size: 28),
          const SizedBox(width: AppSpacing.sm),
          Text(
            user.displayName,
            style: Theme.of(context).textTheme.labelLarge
                ?.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

/// Visual placeholder for the future comment input.
class _CommentComposer extends StatelessWidget {
  const _CommentComposer();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.md,
            AppSpacing.screenPadding,
            AppSpacing.sm,
          ),
          child: GestureDetector(
            onTap: () => showComingSoon(context, context.l10n.commentsTitle),
            child: Container(
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      context.l10n.addCommentHint,
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(color: AppColors.textTertiary),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_upward_rounded,
                    size: 20,
                    color: AppColors.textTertiary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
