import '../data/repositories/auth_repository.dart';
import '../data/repositories/chat_repository.dart';
import '../data/repositories/friend_repository.dart';
import '../models/app_user.dart';
import '../models/chat_message.dart';
import '../models/conversation.dart';
import '../models/friend_status.dart';
import '../models/message_reaction.dart';

/// Chat use cases: conversation list, messages, sending, reactions.
class ChatService {
  ChatService({
    required this._auth,
    required this._chat,
    required this._friends,
  });

  final AuthRepository _auth;
  final ChatRepository _chat;
  final FriendRepository _friends;

  Future<AppUser> currentUser() async {
    final user = await _auth.getCurrentUser();
    if (user == null) throw StateError('No signed-in user');
    return user;
  }

  Stream<List<Conversation>> watchConversations(String userId) =>
      _chat.watchConversations(userId);

  Stream<List<ChatMessage>> watchMessages(String conversationId) =>
      _chat.watchMessages(conversationId);

  /// Friends with today's mood, for "Mood Today" and chat headers.
  Future<List<FriendStatus>> friendsToday(String userId) =>
      _friends.getFriendsToday(userId);

  /// Sends [text] (trimmed). Returns null if there was nothing to send.
  Future<ChatMessage?> send(
    String conversationId,
    String senderId,
    String text,
  ) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return Future.value(null);
    return _chat.sendMessage(
      conversationId: conversationId,
      senderId: senderId,
      text: trimmed,
    );
  }

  /// All friends (for starting a chat).
  Future<List<AppUser>> friends(String userId) => _friends.getFriends(userId);

  /// Opens (or creates) the one-to-one chat with [peer].
  Future<Conversation> startConversation(String userId, AppUser peer) =>
      _chat.startConversation(userId, peer);

  Future<void> markAsRead(String conversationId, String userId) =>
      _chat.markAsRead(conversationId, userId);

  /// Applies [type] as [userId]'s reaction; choosing the same reaction
  /// again removes it.
  Future<void> toggleReaction(
    ChatMessage message,
    String userId,
    ReactionType type,
  ) {
    final current = message.reactionBy(userId)?.type;
    return _chat.setReaction(
      conversationId: message.conversationId,
      messageId: message.id,
      userId: userId,
      type: current == type ? null : type,
    );
  }
}
