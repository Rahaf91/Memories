import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/l10n.dart';
import '../../models/app_user.dart';
import '../../models/story.dart';
import '../common/media_image.dart';
import '../common/pressable.dart';
import '../common/user_avatar.dart';

/// Horizontal row of recent stories, led by an "add yours" tile.
class StoriesRow extends StatelessWidget {
  const StoriesRow({
    super.key,
    required this.currentUser,
    required this.stories,
    required this.onAddStory,
    required this.onStoryTap,
  });

  static const double _tileWidth = 74;
  static const double _tileHeight = 98;

  final AppUser currentUser;
  final List<Story> stories;
  final VoidCallback onAddStory;
  final ValueChanged<Story> onStoryTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _tileHeight + 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        itemCount: stories.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _AddStoryTile(user: currentUser, onTap: onAddStory);
          }
          final story = stories[index - 1];
          return _StoryTile(story: story, onTap: () => onStoryTap(story));
        },
      ),
    );
  }
}

class _TileLabel extends StatelessWidget {
  const _TileLabel(this.text, {this.muted = false});

  final String text;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: StoriesRow._tileWidth,
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: muted ? AppColors.textTertiary : AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _StoryTile extends StatelessWidget {
  const _StoryTile({required this.story, required this.onTap});

  final Story story;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const radius = 20.0;
    return Pressable(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: StoriesRow._tileWidth,
            height: StoriesRow._tileHeight,
            padding: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius + 3),
              border: Border.all(
                color: story.isSeen ? AppColors.stone : AppColors.accent,
                width: story.isSeen ? 1 : 1.8,
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                MediaImage(
                  source: story.imageUrl,
                  borderRadius: BorderRadius.circular(radius),
                ),
                PositionedDirectional(
                  start: 6,
                  bottom: 6,
                  child: UserAvatar(
                    user: story.author,
                    size: 24,
                    borderColor: AppColors.surface,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _TileLabel(story.author.firstName, muted: story.isSeen),
        ],
      ),
    );
  }
}

class _AddStoryTile extends StatelessWidget {
  const _AddStoryTile({required this.user, required this.onTap});

  final AppUser user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: StoriesRow._tileWidth,
            height: StoriesRow._tileHeight,
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(23),
              border: Border.all(color: AppColors.surface),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UserAvatar(user: user, size: 36),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    size: 16,
                    color: AppColors.onAccent,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _TileLabel(context.l10n.yourStory),
        ],
      ),
    );
  }
}
