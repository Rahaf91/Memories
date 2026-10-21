import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/app_navigator.dart';
import '../../app/dependencies.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/l10n.dart';
import '../../models/scheduled_letter.dart';
import '../../services/home_service.dart';
import '../../widgets/common/coming_soon.dart';
import '../../widgets/common/empty_state_card.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/common/status_bar_scrim.dart';
import '../../widgets/home/friends_today_list.dart';
import '../../widgets/home/hero_header.dart';
import '../../widgets/home/moment_card.dart';
import '../../widgets/home/mood_check_in_card.dart';
import '../../widgets/home/open_when_card.dart';
import '../../widgets/home/scheduled_letters_card.dart';
import '../../widgets/home/stories_row.dart';
import '../../widgets/letters/letter_card.dart';
import '../add/create_actions.dart';
import 'home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeController _controller;

  @override
  void initState() {
    super.initState();
    final deps = AppScope.of(context);
    _controller = HomeController(deps.homeService, changes: deps.dataChanges)
      ..load();
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
                  HomeStatus.loading => const Center(
                    key: ValueKey('loading'),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  HomeStatus.error => _ErrorView(
                    key: const ValueKey('error'),
                    onRetry: _controller.load,
                  ),
                  HomeStatus.ready => _buildContent(context, _controller.data!),
                },
              ),
            ),
            const StatusBarScrim(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HomeData data) {
    final l = context.l10n;
    const gutter = EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding);
    final checkedIn = data.friends.where((f) => f.hasCheckedIn).length;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return RefreshIndicator(
      key: const ValueKey('content'),
      color: AppColors.accent,
      edgeOffset: MediaQuery.paddingOf(context).top,
      onRefresh: _controller.load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: bottomInset + AppSpacing.xl),
        children: [
          HeroHeader(
            firstName: data.user.firstName,
            hasUnreadNotifications: data.unreadNotifications > 0,
            onNotificationsTap: () => showComingSoon(context, l.notifications),
            bottom: StoriesRow(
              currentUser: data.user,
              stories: data.stories,
              onAddStory: () => showComingSoon(context, l.yourStory),
              onStoryTap: (s) => showComingSoon(context, s.author.firstName),
            ),
          ),
          Padding(
            padding: gutter,
            child: MoodCheckInCard(
              selected: _controller.selectedMood,
              onSelected: _controller.selectMood,
            ),
          ),

          // Friends Today
          const SizedBox(height: AppSpacing.xxxl),
          SectionHeader(
            title: l.friendsSectionTitle,
            subtitle: data.friends.isEmpty
                ? null
                : l.friendsCheckedIn(checkedIn, data.friends.length),
            onSeeAll: data.friends.isEmpty
                ? null
                : () => AppNavigator.openFriends(context),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (data.friends.isEmpty)
            Padding(
              padding: gutter,
              child: EmptyStateCard(
                icon: Icons.people_outline_rounded,
                title: l.friendsEmptyTitle,
                message: l.friendsEmptyBody,
                actionLabel: l.addFriend,
                actionIcon: Icons.person_add_alt_outlined,
                onAction: () => CreateActions.addFriend(context),
              ),
            )
          else
            FriendsTodayList(
              friends: data.friends,
              onFriendTap: (f) =>
                  AppNavigator.openFriendProfile(context, f.friend),
            ),

          // Open When
          const SizedBox(height: AppSpacing.xxxl),
          SectionHeader(title: l.openWhenTitle),
          const SizedBox(height: AppSpacing.lg),
          ..._openWhenSection(context, data, gutter),

          // Moments
          const SizedBox(height: AppSpacing.xxxl),
          SectionHeader(title: l.momentsSectionTitle),
          const SizedBox(height: AppSpacing.lg),
          if (data.posts.isEmpty)
            Padding(
              padding: gutter,
              child: EmptyStateCard(
                icon: Icons.photo_library_outlined,
                title: l.momentsEmptyTitle,
                message: l.momentsEmptyBody,
                actionLabel: l.addMemory,
                onAction: () => CreateActions.addMemory(context),
              ),
            )
          else
            for (final moment in data.posts)
              Padding(
                padding: gutter.copyWith(bottom: AppSpacing.lg),
                child: MomentCard(
                  moment: moment,
                  onTap: () => showComingSoon(context, moment.title),
                  onReact: () => _controller.toggleReaction(moment),
                  onComment: () => showComingSoon(context, l.commentsTitle),
                  onSave: () => showComingSoon(context, l.save),
                ),
              ),

          // Waiting Messages
          const SizedBox(height: AppSpacing.xxxl),
          SectionHeader(
            title: l.waitingMessagesTitle,
            onSeeAll: () => AppNavigator.openWaitingMessages(context),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (data.waitingMessages.isEmpty)
            Padding(
              padding: gutter,
              child: EmptyStateCard(
                icon: Icons.hourglass_empty_rounded,
                title: l.waitingEmptyTitle,
                message: l.waitingEmptyBody,
                actionLabel: l.createMessage,
                actionIcon: Icons.edit_outlined,
                onAction: () => CreateActions.createMessage(context),
              ),
            )
          else
            for (final m in AppScope.of(
              context,
            ).lettersService.sortForDisplay(data.waitingMessages).take(2))
              Padding(
                padding: gutter.copyWith(bottom: AppSpacing.md),
                child: LetterCard(
                  key: ValueKey(m.id),
                  letter: m,
                  viewerId: data.user.id,
                  onTap: () => AppNavigator.openLetter(
                    context,
                    m,
                    viewerId: data.user.id,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

/// Letters to the user (ready first, then by unlock time, then recently
/// opened), the legacy featured moment, a summary of letters sent to
/// others, or an empty state.
List<Widget> _openWhenSection(
  BuildContext context,
  HomeData data,
  EdgeInsets gutter,
) {
  final l = context.l10n;
  final now = AppScope.of(context).clock.now();
  int rank(ScheduledLetter x) => switch (x.stateAt(now)) {
    LetterState.ready || LetterState.opening => 0,
    LetterState.locked => 1,
    LetterState.opened => 2,
  };
  final inbox = [...data.inboxLetters]
    ..sort((a, b) {
      final r = rank(a).compareTo(rank(b));
      if (r != 0) return r;
      return rank(a) == 2
          ? b.openedAt!.compareTo(a.openedAt!)
          : a.openAt.compareTo(b.openAt);
    });

  final cards = <Widget>[
    for (final letter in inbox.take(3))
      LetterCard(
        key: ValueKey(letter.id),
        letter: letter,
        viewerId: data.user.id,
        onTap: () =>
            AppNavigator.openLetter(context, letter, viewerId: data.user.id),
      ),
    if (data.featuredOpenWhen case final moment?)
      OpenWhenCard(
        moment: moment,
        onTap: () => showComingSoon(context, l.openWhenTitle),
      ),
    if (data.scheduledLetters.isNotEmpty)
      ScheduledLettersCard(
        letters: data.scheduledLetters,
        onTap: () => CreateActions.createOpenWhen(context),
      ),
  ];

  if (cards.isEmpty) {
    cards.add(
      EmptyStateCard(
        icon: Icons.schedule_send_outlined,
        title: l.openWhenEmptyTitle,
        message: l.openWhenEmptyBody,
        actionLabel: l.createOpenWhen,
        onAction: () => CreateActions.createOpenWhen(context),
      ),
    );
  }

  return [
    for (final (i, card) in cards.indexed)
      Padding(
        padding: gutter.copyWith(top: i == 0 ? 0 : AppSpacing.md),
        child: card,
      ),
  ];
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l.loadError,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton(onPressed: onRetry, child: Text(l.tryAgain)),
          ],
        ),
      ),
    );
  }
}
