import 'package:flutter/material.dart';

import '../../app/app_navigator.dart';
import '../../app/dependencies.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/l10n.dart';
import '../../models/app_user.dart';
import '../../models/memory.dart';
import '../../widgets/common/empty_state_card.dart';
import '../../widgets/memories/memory_card.dart';
import '../add/create_actions.dart';

/// Memories shared between the user and one friend.
class OurStoryScreen extends StatefulWidget {
  const OurStoryScreen({super.key, required this.friend});

  final AppUser friend;

  @override
  State<OurStoryScreen> createState() => _OurStoryScreenState();
}

class _OurStoryScreenState extends State<OurStoryScreen> {
  List<Memory>? _memories;
  String? _viewerId;
  late final Listenable _changes = AppScope.of(context).dataChanges;

  @override
  void initState() {
    super.initState();
    _load();
    _changes.addListener(_load);
  }

  @override
  void dispose() {
    _changes.removeListener(_load);
    super.dispose();
  }

  Future<void> _load() async {
    final service = AppScope.of(context).friendsService;
    final me = await service.currentUser();
    final memories = await service.memoriesWith(widget.friend.id);
    if (!mounted) return;
    setState(() {
      _viewerId = me.id;
      _memories = memories;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final memories = _memories;
    return Scaffold(
      appBar: AppBar(),
      body: memories == null
          ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.sm,
                AppSpacing.screenPadding,
                AppSpacing.xxl,
              ),
              children: [
                Text(
                  l.ourStory,
                  style: AppTypography.of(context).displayTitle
                      .copyWith(fontSize: 38),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l.ourStorySubtitle(widget.friend.firstName),
                  style: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.xl),
                if (memories.isEmpty)
                  EmptyStateCard(
                    icon: Icons.auto_stories_outlined,
                    title: l.ourStoryEmptyTitle,
                    message: l.ourStoryEmptyBody(widget.friend.firstName),
                    actionLabel: l.addMemory,
                    onAction: () => CreateActions.addMemory(context),
                  ),
                for (final m in memories)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: MemoryCard(
                      memory: m,
                      viewerId: _viewerId!,
                      onTap: () => AppNavigator.openMemoryDetail(
                        context,
                        memory: m,
                        viewerId: _viewerId!,
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
