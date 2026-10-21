import 'message_reaction.dart';

/// Delivery state of a message, as seen by its sender.
enum MessageStatus {
  sending('sending'),
  sent('sent'),
  read('read'),
  failed('failed');

  const MessageStatus(this.value);

  final String value;

  static MessageStatus fromValue(String value) =>
      MessageStatus.values.firstWhere((s) => s.value == value);
}

/// A single text message in a conversation.
///
/// Attachments (memories, Open When letters, capsules) will be added as
/// optional fields later; text-only for now.
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.text,
    required this.sentAt,
    this.status = MessageStatus.sent,
    this.reactions = const [],
  });

  final String id;
  final String conversationId;
  final String senderId;
  final String text;
  final DateTime sentAt;
  final MessageStatus status;
  final List<MessageReaction> reactions;

  bool isFrom(String userId) => senderId == userId;

  /// [userId]'s reaction, if any.
  MessageReaction? reactionBy(String userId) {
    for (final r in reactions) {
      if (r.userId == userId) return r;
    }
    return null;
  }

  ChatMessage copyWith({
    MessageStatus? status,
    List<MessageReaction>? reactions,
  }) => ChatMessage(
    id: id,
    conversationId: conversationId,
    senderId: senderId,
    text: text,
    sentAt: sentAt,
    status: status ?? this.status,
    reactions: reactions ?? this.reactions,
  );

  factory ChatMessage.fromMap(Map<String, dynamic> map) => ChatMessage(
    id: map['id'] as String,
    conversationId: map['conversation_id'] as String,
    senderId: map['sender_id'] as String,
    text: map['text'] as String,
    sentAt: DateTime.parse(map['sent_at'] as String),
    status: MessageStatus.fromValue(map['status'] as String? ?? 'sent'),
    reactions: (map['reactions'] as List? ?? const [])
        .map((r) => MessageReaction.fromMap(r as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'conversation_id': conversationId,
    'sender_id': senderId,
    'text': text,
    'sent_at': sentAt.toIso8601String(),
    'status': status.value,
    'reactions': reactions.map((r) => r.toMap()).toList(),
  };
}
