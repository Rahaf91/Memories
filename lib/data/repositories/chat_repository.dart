import '../../models/app_user.dart';
import '../../models/chat_message.dart';
import '../../models/conversation.dart';
import '../../models/message_reaction.dart';

/// Chat data. Reads are live streams so a realtime backend (Supabase
/// Realtime, Firestore snapshots) can drop in without UI changes.
abstract interface class ChatRepository {
  /// [userId]'s conversations, most recent first. Emits on every change.
  Stream<List<Conversation>> watchConversations(String userId);

  /// Messages in a conversation, oldest first. Emits on every change.
  Stream<List<ChatMessage>> watchMessages(String conversationId);

  /// Returns the one-to-one conversation between [userId] and [peer],
  /// creating it if needed.
  Future<Conversation> startConversation(String userId, AppUser peer);

  /// Sends a text message and returns it once accepted by the server.
  Future<ChatMessage> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
  });

  /// Marks everything in the conversation as read for [userId].
  Future<void> markAsRead(String conversationId, String userId);

  /// Sets [userId]'s reaction on a message; null removes it.
  Future<void> setReaction({
    required String conversationId,
    required String messageId,
    required String userId,
    ReactionType? type,
  });
}
