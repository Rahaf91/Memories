import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../core/utils/date_format.dart';
import '../l10n/l10n.dart';
import '../models/scheduled_letter.dart';
import '../screens/letters/letter_screen.dart';
import '../widgets/common/coming_soon.dart';
import 'dependencies.dart';

import '../models/app_user.dart';
import '../models/conversation.dart';
import '../models/memory.dart';
import '../screens/add/add_memory/add_memory_screen.dart';
import '../screens/add/mood_check_in/mood_check_in_screen.dart';
import '../screens/add/open_when/open_when_form_screen.dart';
import '../screens/chat/conversation_screen.dart';
import '../screens/friends/add_friend_screen.dart';
import '../screens/friends/friend_profile_screen.dart';
import '../screens/friends/friends_screen.dart';
import '../screens/friends/our_story_screen.dart';
import '../screens/memory_detail/memory_detail_screen.dart';
import '../screens/mood_year/mood_year_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/waiting/create_message_screen.dart';
import '../screens/waiting/waiting_messages_screen.dart';

/// Central place for pushing secondary screens, so screens don't build
/// each other directly. Every push uses an iOS-style route: a back chevron
/// in the top bar and the edge swipe-back gesture return to the exact
/// previous screen.
abstract final class AppNavigator {
  static Future<T?> _push<T>(BuildContext context, Widget screen) =>
      Navigator.of(context).push<T>(CupertinoPageRoute(builder: (_) => screen));

  static Future<bool> _pushForm(BuildContext context, Widget screen) async =>
      await _push<bool>(context, screen) ?? false;

  // Memories ---------------------------------------------------------------

  static Future<void> openMemoryDetail(
    BuildContext context, {
    required Memory memory,
    required String viewerId,
  }) => _push(context, MemoryDetailScreen(memory: memory, viewerId: viewerId));

  static Future<void> openMoodYear(BuildContext context) =>
      _push(context, const MoodYearScreen());

  // Create flows (complete with `true` when something was saved) -----------

  static Future<bool> openAddMemory(BuildContext context) =>
      _pushForm(context, const AddMemoryScreen());

  static Future<bool> openOpenWhen(BuildContext context) =>
      _pushForm(context, const OpenWhenFormScreen());

  /// Create a Waiting Message.
  static Future<bool> openCreateMessage(BuildContext context) =>
      _pushForm(context, const CreateMessageScreen());

  static Future<void> openWaitingMessages(BuildContext context) =>
      _push(context, const WaitingMessagesScreen());

  static Future<bool> openMoodCheckIn(BuildContext context) =>
      _pushForm(context, const MoodCheckInScreen());

  // Chat --------------------------------------------------------------------

  static Future<void> openConversation(
    BuildContext context, {
    required Conversation conversation,
    required String viewerId,
  }) => _push(
    context,
    ConversationScreen(conversation: conversation, viewerId: viewerId),
  );

  // Friends -------------------------------------------------------------------

  static Future<void> openFriends(BuildContext context) =>
      _push(context, const FriendsScreen());

  /// Completes with the new friend, or null if cancelled.
  static Future<AppUser?> openAddFriend(BuildContext context) =>
      _push<AppUser>(context, const AddFriendScreen());

  static Future<void> openFriendProfile(BuildContext context, AppUser friend) =>
      _push(context, FriendProfileScreen(friend: friend));

  static Future<void> openOurStory(BuildContext context, AppUser friend) =>
      _push(context, OurStoryScreen(friend: friend));

  // Open When letters --------------------------------------------------------

  /// Opens a letter according to its real state:
  /// locked → a short notice; ready → the first-opening reveal (the card
  /// expands into the letter); opened → a normal push.
  static Future<void> openLetter(
    BuildContext context,
    ScheduledLetter letter, {
    required String viewerId,
  }) async {
    final service = AppScope.of(context).lettersService;
    switch (service.stateOf(letter)) {
      case LetterState.locked:
        HapticFeedback.lightImpact();
        final l = context.l10n;
        showAppSnackBar(
          context,
          l.letterLockedToast(formatDateTime(l, letter.openAt)),
        );
      case LetterState.ready || LetterState.opening:
        HapticFeedback.mediumImpact();
        await Navigator.of(context).push(
          PageRouteBuilder<void>(
            // Not opaque: the screen behind stays visible while the card
            // expands over it.
            opaque: false,
            transitionDuration: const Duration(milliseconds: 550),
            reverseTransitionDuration: const Duration(milliseconds: 420),
            pageBuilder: (_, _, _) =>
                LetterScreen(letter: letter, viewerId: viewerId, reveal: true),
            transitionsBuilder: (_, _, _, child) => child,
          ),
        );
      case LetterState.opened:
        await _push(context, LetterScreen(letter: letter, viewerId: viewerId));
    }
  }

  // Settings ----------------------------------------------------------------

  static Future<void> openSettings(BuildContext context) =>
      _push(context, const SettingsScreen());
}
