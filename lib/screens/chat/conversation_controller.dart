import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../models/chat_message.dart';
import '../../models/conversation.dart';
import '../../models/message_reaction.dart';
import '../../models/mood.dart';
import '../../services/chat_service.dart';
import 'conversation_items.dart';

class ConversationController extends ChangeNotifier {
  ConversationController(
    this._service, {
    required this.conversation,
    required this.viewerId,
  });

  final ChatService _service;
  final Conversation conversation;
  final String viewerId;
  StreamSubscription<List<ChatMessage>>? _sub;

  bool loading = true;
  List<ChatMessage> messages = const [];
  List<ConversationItem> items = const [];
  Mood? peerMood;

  void start() {
    _service.markAsRead(conversation.id, viewerId);
    _sub = _service.watchMessages(conversation.id).listen((list) {
      final hadIncoming =
          list.length > messages.length &&
          list.isNotEmpty &&
          !list.last.isFrom(viewerId);
      messages = list;
      items = buildConversationItems(list, viewerId);
      loading = false;
      notifyListeners();
      // Anything that arrives while the chat is open is read immediately.
      if (hadIncoming) _service.markAsRead(conversation.id, viewerId);
    });
    _service.friendsToday(viewerId).then((friends) {
      for (final f in friends) {
        if (f.friend.id == conversation.peer.id) {
          peerMood = f.todayMood;
          notifyListeners();
        }
      }
    });
  }

  Future<void> send(String text) =>
      _service.send(conversation.id, viewerId, text);

  Future<void> react(ChatMessage message, ReactionType type) =>
      _service.toggleReaction(message, viewerId, type);

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
