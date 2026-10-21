import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../models/app_user.dart';
import '../../models/conversation.dart';
import '../../models/friend_status.dart';
import '../../models/mood.dart';
import '../../services/chat_service.dart';

enum ChatListStatus { loading, ready, error }

class ChatListController extends ChangeNotifier {
  ChatListController(this._service, {this._changes}) {
    _changes?.addListener(_refreshFriends);
  }

  final ChatService _service;
  final Listenable? _changes;
  StreamSubscription<List<Conversation>>? _sub;

  ChatListStatus status = ChatListStatus.loading;
  AppUser? user;
  List<Conversation> conversations = const [];
  List<FriendStatus> friends = const [];

  /// Today's mood per friend id.
  Map<String, Mood> get moodByUser => {
    for (final f in friends)
      if (f.todayMood != null) f.friend.id: f.todayMood!,
  };

  /// Friends who have checked in today come first.
  List<FriendStatus> get moodToday => [
    ...friends.where((f) => f.hasCheckedIn),
    ...friends.where((f) => !f.hasCheckedIn),
  ];

  int get totalUnread => conversations.fold(0, (sum, c) => sum + c.unreadCount);

  Future<void> start() async {
    try {
      final me = await _service.currentUser();
      user = me;
      friends = await _service.friendsToday(me.id);
      _sub = _service
          .watchConversations(me.id)
          .listen(
            (list) {
              conversations = list;
              status = ChatListStatus.ready;
              notifyListeners();
            },
            onError: (Object e) {
              debugPrint('Conversations stream failed: $e');
              status = ChatListStatus.error;
              notifyListeners();
            },
          );
    } catch (e) {
      debugPrint('Chat load failed: $e');
      status = ChatListStatus.error;
      notifyListeners();
    }
  }

  /// Friends (and their moods) change when someone is added.
  Future<void> _refreshFriends() async {
    final me = user;
    if (me == null) return;
    friends = await _service.friendsToday(me.id);
    notifyListeners();
  }

  @override
  void dispose() {
    _changes?.removeListener(_refreshFriends);
    _sub?.cancel();
    super.dispose();
  }
}
