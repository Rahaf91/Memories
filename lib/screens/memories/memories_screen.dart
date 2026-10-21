import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/app_navigator.dart';
import '../../app/dependencies.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/l10n.dart';
import '../../models/memory.dart';
import '../../services/memories_service.dart';
import '../../widgets/common/badge_icon_button.dart';
import '../../widgets/common/coming_soon.dart';
import '../../widgets/common/empty_state_card.dart';
import '../../widgets/common/screen_header.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/common/status_bar_scrim.dart';
import '../../widgets/memories/memory_card.dart';
import '../../widgets/memories/memory_filter_chips.dart';
import '../../widgets/memories/month_summary_card.dart';
import '../../widgets/memories/mood_year_card.dart';
import '../add/create_actions.dart';
import 'memories_controller.dart';

class MemoriesScreen extends StatefulWidget {
  const MemoriesScreen({super.key});

  @override
  State<MemoriesScreen> createState() => _MemoriesScreenState();
}

class _MemoriesScreenState extends State<MemoriesScreen> {
  late final MemoriesController _controller;

  @override
  void initState() {
    super.initState();
    final deps = AppScope.of(context);
    _controller = MemoriesController(
      deps.memoriesService,
      changes: deps.dataChanges,
    )..load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openMemory(Memory memory, String viewerId) async {
    await AppNavigator.openMemoryDetail(
      context,
      memory: memory,
      viewerId: viewerId,
    );
    // Pick up reactions made on the detail screen.
    if (mounted) _controller.load();
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
                  MemoriesStatus.loading => const Center(
                    key: ValueKey('loading'),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  MemoriesStatus.error => Center(
                    key: const ValueKey('error'),
                    child: TextButton(
                      onPressed: _controller.load,
                      child: Text(context.l10n.loadError),
                    ),
                  ),
                  MemoriesStatus.ready => _buildContent(
                    context,
                    _controller.overview!,
                  ),
                },
              ),
            ),
            const StatusBarScrim(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, MemoriesOverview data) {
    final l = context.l10n;
    const gutter = EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding);
    final padding = MediaQuery.paddingOf(context);
    final memories = _controller.visibleMemories;
    final hasAny = data.memories.isNotEmpty;

    return RefreshIndicator(
      key: const ValueKey('content'),
      color: AppColors.accent,
      edgeOffset: padding.top,
      onRefresh: _controller.load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(
          top: padding.top + AppSpacing.xl,
          bottom: padding.bottom + AppSpacing.xl,
        ),
        children: [
          ScreenHeader(
            title: l.navMemories,
            subtitle: l.memoriesSubtitle,
            actions: [
              BadgeIconButton(
                icon: Icons.search_rounded,
                tooltip: l.search,
                onPressed: () => showComingSoon(context, l.search),
              ),
              BadgeIconButton(
                icon: Icons.tune_rounded,
                tooltip: l.filter,
                onPressed: () => showComingSoon(context, l.filter),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          MemoryFilterChips(
            selected: _controller.filter,
            onSelected: _controller.selectFilter,
          ),
          const SizedBox(height: AppSpacing.xl),
          Padding(
            padding: gutter,
            child: MonthSummaryCard(summary: data.summary),
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: gutter,
            child: MoodYearCard(
              months: data.moodYear,
              onTap: () => AppNavigator.openMoodYear(context),
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          SectionHeader(
            title: l.recentMemories,
            subtitle: hasAny ? l.memoriesCount(memories.length) : null,
          ),
          const SizedBox(height: AppSpacing.lg),
          if (!hasAny)
            Padding(
              padding: gutter,
              child: EmptyStateCard(
                icon: Icons.photo_library_outlined,
                title: l.memoriesEmptyTitle,
                message: l.memoriesEmptyBody,
                actionLabel: l.addMemory,
                onAction: () => CreateActions.addMemory(context),
              ),
            )
          else
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              switchInCurve: Curves.easeOutCubic,
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween(
                    begin: const Offset(0, 0.02),
                    end: Offset.zero,
                  ).animate(anim),
                  child: child,
                ),
              ),
              layoutBuilder: (current, previous) => Stack(
                alignment: Alignment.topCenter,
                children: [...previous, ?current],
              ),
              child: Column(
                key: ValueKey(_controller.filter),
                children: [
                  if (memories.isEmpty)
                    Padding(
                      padding: gutter.copyWith(top: AppSpacing.md),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          l.filterEmpty,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  for (final memory in memories)
                    Padding(
                      padding: gutter.copyWith(bottom: AppSpacing.lg),
                      child: MemoryCard(
                        memory: memory,
                        viewerId: data.user.id,
                        onTap: () => _openMemory(memory, data.user.id),
                        onReact: () => _controller.toggleReaction(memory),
                        onComment: () => _openMemory(memory, data.user.id),
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
