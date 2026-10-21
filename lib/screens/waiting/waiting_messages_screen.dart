import 'package:flutter/material.dart';

import '../../app/app_navigator.dart';
import '../../app/dependencies.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/l10n.dart';
import '../../models/scheduled_letter.dart';
import '../../widgets/common/empty_state_card.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/letters/letter_card.dart';
import '../add/create_actions.dart';

/// "Waiting Messages": every scheduled message the user wrote or received,
/// with its live state, and the main "Create Message" action.
class WaitingMessagesScreen extends StatefulWidget {
  const WaitingMessagesScreen({super.key});

  @override
  State<WaitingMessagesScreen> createState() => _WaitingMessagesScreenState();
}

class _WaitingMessagesScreenState extends State<WaitingMessagesScreen> {
  List<ScheduledLetter>? _messages;
  String? _viewerId;
  late final Listenable _changes = AppScope.of(context).dataChanges;

  @override
  void initState() {
    super.initState();
    _load();
    // Refresh after creating or opening a message.
    _changes.addListener(_load);
  }

  @override
  void dispose() {
    _changes.removeListener(_load);
    super.dispose();
  }

  Future<void> _load() async {
    final deps = AppScope.of(context);
    final me = await deps.createService.currentUser();
    final messages = await deps.lettersService.waitingMessages(me.id);
    if (!mounted) return;
    setState(() {
      _viewerId = me.id;
      _messages = messages;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final messages = _messages;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: l.createMessage,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => CreateActions.createMessage(context),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: messages == null
          ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
          : ListView(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.sm,
                AppSpacing.screenPadding,
                MediaQuery.paddingOf(context).bottom + AppSpacing.xxl,
              ),
              children: [
                Text(
                  l.waitingMessagesTitle,
                  style: AppTypography.of(context).displayTitle
                      .copyWith(fontSize: 38),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l.waitingMessagesSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                  label: l.createMessage,
                  icon: Icons.edit_outlined,
                  onPressed: () => CreateActions.createMessage(context),
                ),
                const SizedBox(height: AppSpacing.xl),
                if (messages.isEmpty)
                  EmptyStateCard(
                    icon: Icons.hourglass_empty_rounded,
                    title: l.waitingEmptyTitle,
                    message: l.waitingEmptyBody,
                  ),
                for (final m in messages)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: LetterCard(
                      key: ValueKey(m.id),
                      letter: m,
                      viewerId: _viewerId!,
                      onTap: () => AppNavigator.openLetter(
                        context,
                        m,
                        viewerId: _viewerId!,
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
