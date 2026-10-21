import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/l10n.dart';
import '../../models/mood.dart';
import '../../widgets/add/create_action_card.dart';
import '../../widgets/common/mood_face.dart';
import '../../widgets/common/screen_header.dart';
import '../../widgets/common/status_bar_scrim.dart';
import 'create_actions.dart';

/// The Add tab: entry point to every create flow.
class AddScreen extends StatelessWidget {
  const AddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final padding = MediaQuery.paddingOf(context);

    // Order: Add Memory, Create Message, Add Friend, then the rest.
    final cards = [
      CreateActionCard(
        icon: const Icon(Icons.add_photo_alternate_outlined),
        title: l.addMemory,
        description: l.addMemoryDescription,
        onTap: () => CreateActions.addMemory(context),
      ),
      CreateActionCard(
        icon: const Icon(Icons.hourglass_empty_rounded),
        title: l.createMessage,
        description: l.waitingMessagesDescription,
        onTap: () => CreateActions.createMessage(context),
      ),
      CreateActionCard(
        icon: const Icon(Icons.person_add_alt_outlined),
        title: l.addFriend,
        description: l.addFriendSubtitle,
        onTap: () => CreateActions.addFriend(context),
      ),
      CreateActionCard(
        icon: const Icon(Icons.schedule_send_outlined),
        title: l.openWhenTitle,
        description: l.openWhenDescription,
        onTap: () => CreateActions.createOpenWhen(context),
      ),
      CreateActionCard(
        icon: const MoodFace(
          mood: Mood.good,
          color: AppColors.accent,
          size: 24,
          showOutline: true,
        ),
        title: l.moodCheckInTitle,
        description: l.moodCheckInDescription,
        onTap: () => CreateActions.moodCheckIn(context),
      ),
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Stack(
          children: [
            ListView(
              padding: EdgeInsets.only(
                top: padding.top + AppSpacing.xl,
                bottom: padding.bottom + AppSpacing.xl,
              ),
              children: [
                ScreenHeader(title: l.createTitle, subtitle: l.createSubtitle),
                const SizedBox(height: AppSpacing.xxl),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: _CardGrid(cards: cards),
                ),
                const SizedBox(height: AppSpacing.xl),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.lock_outline_rounded,
                        size: 15,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          l.createFootnote,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textTertiary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const StatusBarScrim(),
          ],
        ),
      ),
    );
  }
}

/// Two cards per row; an odd last card spans the full width.
class _CardGrid extends StatelessWidget {
  const _CardGrid({required this.cards});

  final List<Widget> cards;

  static const double _cardHeight = 196;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < cards.length; i += 2) ...[
          if (i > 0) const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: _cardHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: cards[i]),
                if (i + 1 < cards.length) ...[
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: cards[i + 1]),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}
