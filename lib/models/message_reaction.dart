/// The small set of reactions available on a message. Rendered as quiet
/// line icons, never emoji.
enum ReactionType {
  love('love', 'Love'),
  agree('agree', 'Agree'),
  haha('haha', 'Haha'),
  sad('sad', 'Sad');

  const ReactionType(this.value, this.label);

  /// Stable identifier stored in the database.
  final String value;
  final String label;

  static ReactionType fromValue(String value) =>
      ReactionType.values.firstWhere((r) => r.value == value);
}

/// One person's reaction to a message. A person has at most one reaction
/// per message.
class MessageReaction {
  const MessageReaction({
    required this.userId,
    required this.type,
    required this.createdAt,
  });

  final String userId;
  final ReactionType type;
  final DateTime createdAt;

  factory MessageReaction.fromMap(Map<String, dynamic> map) => MessageReaction(
    userId: map['user_id'] as String,
    type: ReactionType.fromValue(map['type'] as String),
    createdAt: DateTime.parse(map['created_at'] as String),
  );

  Map<String, dynamic> toMap() => {
    'user_id': userId,
    'type': type.value,
    'created_at': createdAt.toIso8601String(),
  };
}
