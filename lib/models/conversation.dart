import 'app_user.dart';
import 'chat_message.dart';

/// A chat thread, as seen by the signed-in user.
class Conversation {
  const Conversation({
    required this.id,
    required this.participants,
    required this.updatedAt,
    this.lastMessage,
    this.unreadCount = 0,
    this.isPeerOnline = false,
  });

  final String id;

  /// The other people in the conversation (excludes the viewer).
  final List<AppUser> participants;
  final ChatMessage? lastMessage;

  /// Messages the viewer hasn't read yet.
  final int unreadCount;
  final DateTime updatedAt;

  /// Presence of the other person (1:1 chats). Comes from a presence
  /// channel once a backend exists.
  final bool isPeerOnline;

  /// The other person in a one-to-one conversation.
  AppUser get peer => participants.first;

  String get title => participants.length == 1
      ? peer.displayName
      : participants.map((p) => p.firstName).join(', ');

  Conversation copyWith({
    ChatMessage? lastMessage,
    int? unreadCount,
    DateTime? updatedAt,
  }) => Conversation(
    id: id,
    participants: participants,
    lastMessage: lastMessage ?? this.lastMessage,
    unreadCount: unreadCount ?? this.unreadCount,
    updatedAt: updatedAt ?? this.updatedAt,
    isPeerOnline: isPeerOnline,
  );

  factory Conversation.fromMap(Map<String, dynamic> map) => Conversation(
    id: map['id'] as String,
    participants: (map['participants'] as List)
        .map((p) => AppUser.fromMap(p as Map<String, dynamic>))
        .toList(),
    lastMessage: map['last_message'] == null
        ? null
        : ChatMessage.fromMap(map['last_message'] as Map<String, dynamic>),
    unreadCount: map['unread_count'] as int? ?? 0,
    updatedAt: DateTime.parse(map['updated_at'] as String),
    isPeerOnline: map['is_peer_online'] as bool? ?? false,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'participants': participants.map((p) => p.toMap()).toList(),
    'last_message': lastMessage?.toMap(),
    'unread_count': unreadCount,
    'updated_at': updatedAt.toIso8601String(),
    'is_peer_online': isPeerOnline,
  };
}
