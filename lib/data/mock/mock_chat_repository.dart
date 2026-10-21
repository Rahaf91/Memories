import 'dart:async';

import '../../models/app_user.dart';
import '../../models/chat_message.dart';
import '../../models/conversation.dart';
import '../../models/message_reaction.dart';
import '../repositories/chat_repository.dart';
import 'mock_data.dart';

/// In-memory chat that behaves like a realtime backend: every change is
/// pushed to the open streams. Starts with no conversations.
class MockChatRepository implements ChatRepository {
  final Map<String, Conversation> _conversations = {};

  /// Which account each conversation belongs to.
  final Map<String, String> _ownerOf = {};
  final Map<String, List<ChatMessage>> _messages = {};

  /// Emits the id of each conversation that changed.
  final _changes = StreamController<String>.broadcast();
  int _nextId = 0;

  @override
  Stream<List<Conversation>> watchConversations(String userId) async* {
    await mockDelay();
    yield _conversationList(userId);
    yield* _changes.stream.map((_) => _conversationList(userId));
  }

  @override
  Stream<List<ChatMessage>> watchMessages(String conversationId) async* {
    await mockDelay();
    yield _messageList(conversationId);
    yield* _changes.stream
        .where((id) => id == conversationId)
        .map((_) => _messageList(conversationId));
  }

  @override
  Future<Conversation> startConversation(String userId, AppUser peer) async {
    final id = 'conv-$userId-${peer.id}';
    final existing = _conversations[id];
    if (existing != null) return existing;
    final conversation = Conversation(
      id: id,
      participants: [peer],
      updatedAt: DateTime.now(),
    );
    _conversations[id] = conversation;
    _ownerOf[id] = userId;
    _messages[id] = [];
    _changes.add(id);
    return conversation;
  }

  @override
  Future<ChatMessage> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
  }) async {
    final message = ChatMessage(
      id: 'msg-${_nextId++}',
      conversationId: conversationId,
      senderId: senderId,
      text: text,
      sentAt: DateTime.now(),
      status: MessageStatus.sending,
    );
    _append(message);

    // Simulate the server accepting it.
    await Future.delayed(const Duration(milliseconds: 450));
    final sent = message.copyWith(status: MessageStatus.sent);
    _replace(sent);
    return sent;
  }

  @override
  Future<void> markAsRead(String conversationId, String userId) async {
    final convo = _conversations[conversationId];
    if (convo == null || convo.unreadCount == 0) return;
    _conversations[conversationId] = convo.copyWith(unreadCount: 0);
    _changes.add(conversationId);
  }

  @override
  Future<void> setReaction({
    required String conversationId,
    required String messageId,
    required String userId,
    ReactionType? type,
  }) async {
    final list = _messages[conversationId];
    if (list == null) return;
    final index = list.indexWhere((m) => m.id == messageId);
    if (index < 0) return;
    final message = list[index];
    final others = message.reactions.where((r) => r.userId != userId);
    list[index] = message.copyWith(
      reactions: [
        ...others,
        if (type != null)
          MessageReaction(
            userId: userId,
            type: type,
            createdAt: DateTime.now(),
          ),
      ],
    );
    _changes.add(conversationId);
  }

  // Internals -------------------------------------------------------------

  /// [userId]'s conversations (each account sees only its own).
  List<Conversation> _conversationList(String userId) =>
      _conversations.values.where((c) => _ownerOf[c.id] == userId).toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

  List<ChatMessage> _messageList(String conversationId) =>
      List.unmodifiable(_messages[conversationId] ?? const []);

  void _append(ChatMessage message) {
    final id = message.conversationId;
    (_messages[id] ??= []).add(message);
    final convo = _conversations[id];
    if (convo != null) {
      // Messages from the other person are unread until the chat is opened.
      final incoming = convo.participants.any((p) => p.id == message.senderId);
      _conversations[id] = convo.copyWith(
        lastMessage: message,
        updatedAt: message.sentAt,
        unreadCount: convo.unreadCount + (incoming ? 1 : 0),
      );
    }
    _changes.add(id);
  }

  void _replace(ChatMessage message) {
    final list = _messages[message.conversationId];
    if (list == null) return;
    final index = list.indexWhere((m) => m.id == message.id);
    if (index < 0) return;
    list[index] = message;
    final convo = _conversations[message.conversationId];
    if (convo?.lastMessage?.id == message.id) {
      _conversations[message.conversationId] = convo!.copyWith(
        lastMessage: message,
      );
    }
    _changes.add(message.conversationId);
  }
}
