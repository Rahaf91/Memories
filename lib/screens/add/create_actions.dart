import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/app_navigator.dart';
import '../../app/dependencies.dart';
import '../../l10n/l10n.dart';
import '../../widgets/chat/start_chat_sheet.dart';
import '../../widgets/common/coming_soon.dart';
import '../shell/main_tab_controller.dart';

/// Entry points shared by the Add tab and every empty-state call to
/// action: open the flow, then confirm on success.
abstract final class CreateActions {
  /// After saving, shows the Memories tab with the new memory.
  static Future<void> addMemory(BuildContext context) async {
    final saved = await AppNavigator.openAddMemory(context);
    if (!saved || !context.mounted) return;
    HapticFeedback.mediumImpact();
    MainTabScope.maybeRead(context)?.select(MainTab.memories);
    showAppSnackBar(context, context.l10n.memorySaved);
  }

  static Future<void> createOpenWhen(BuildContext context) =>
      _run(context, AppNavigator.openOpenWhen, (l) => l.letterScheduled);

  static Future<void> createMessage(BuildContext context) =>
      _run(context, AppNavigator.openCreateMessage, (l) => l.messageScheduled);

  static Future<void> moodCheckIn(BuildContext context) =>
      _run(context, AppNavigator.openMoodCheckIn, (l) => l.checkInSaved);

  static Future<void> addFriend(BuildContext context) async {
    final friend = await AppNavigator.openAddFriend(context);
    if (friend == null || !context.mounted) return;
    HapticFeedback.mediumImpact();
    showAppSnackBar(context, context.l10n.friendAdded(friend.firstName));
  }

  /// Picks a friend (or adds one) and opens the conversation.
  static Future<void> startChat(BuildContext context) async {
    final chat = AppScope.of(context).chatService;
    final me = await chat.currentUser();
    final friends = await chat.friends(me.id);
    if (!context.mounted) return;

    final choice = await showStartChatSheet(context, friends: friends);
    if (!context.mounted) return;
    switch (choice) {
      case ChatWith(:final friend):
        final conversation = await chat.startConversation(me.id, friend);
        if (!context.mounted) return;
        await AppNavigator.openConversation(
          context,
          conversation: conversation,
          viewerId: me.id,
        );
      case AddFriendInstead():
        await addFriend(context);
      case null:
        break;
    }
  }

  static Future<void> _run(
    BuildContext context,
    Future<bool> Function(BuildContext) open,
    String Function(AppLocalizations) message,
  ) async {
    final saved = await open(context);
    if (!saved || !context.mounted) return;
    HapticFeedback.mediumImpact();
    showAppSnackBar(context, message(context.l10n));
  }
}
