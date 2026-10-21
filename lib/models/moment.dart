import 'app_user.dart';

/// Kinds of moments that can appear in the home feed.
enum MomentType {
  /// A friend shared a memory (photos, text) with the user.
  sharedMemory('shared_memory'),

  /// A sealed "Open When…" message that unlocks at [Moment.unlockAt].
  openWhen('open_when');

  const MomentType(this.value);

  final String value;

  static MomentType fromValue(String value) =>
      MomentType.values.firstWhere((t) => t.value == value);
}

/// An item shared with the user: a memory post or an "Open When" letter.
class Moment {
  const Moment({
    required this.id,
    required this.type,
    required this.author,
    required this.title,
    required this.createdAt,
    this.caption,
    this.imageUrl,
    this.unlockAt,
    this.isOpened = false,
    this.reactionCount = 0,
    this.commentCount = 0,
    this.hasReacted = false,
  });

  final String id;
  final MomentType type;
  final AppUser author;
  final String title;
  final String? caption;
  final String? imageUrl;
  final DateTime createdAt;

  /// When an "Open When" moment becomes available. Null = available now.
  final DateTime? unlockAt;
  final bool isOpened;

  final int reactionCount;
  final int commentCount;

  /// Whether the current user has reacted.
  final bool hasReacted;

  bool isLockedAt(DateTime now) => unlockAt != null && now.isBefore(unlockAt!);

  Moment copyWith({bool? hasReacted, int? reactionCount, bool? isOpened}) =>
      Moment(
        id: id,
        type: type,
        author: author,
        title: title,
        caption: caption,
        imageUrl: imageUrl,
        createdAt: createdAt,
        unlockAt: unlockAt,
        isOpened: isOpened ?? this.isOpened,
        reactionCount: reactionCount ?? this.reactionCount,
        commentCount: commentCount,
        hasReacted: hasReacted ?? this.hasReacted,
      );

  factory Moment.fromMap(Map<String, dynamic> map) => Moment(
    id: map['id'] as String,
    type: MomentType.fromValue(map['type'] as String),
    author: AppUser.fromMap(map['author'] as Map<String, dynamic>),
    title: map['title'] as String,
    caption: map['caption'] as String?,
    imageUrl: map['image_url'] as String?,
    createdAt: DateTime.parse(map['created_at'] as String),
    unlockAt: map['unlock_at'] == null
        ? null
        : DateTime.parse(map['unlock_at'] as String),
    isOpened: map['is_opened'] as bool? ?? false,
    reactionCount: map['reaction_count'] as int? ?? 0,
    commentCount: map['comment_count'] as int? ?? 0,
    hasReacted: map['has_reacted'] as bool? ?? false,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'type': type.value,
    'author': author.toMap(),
    'title': title,
    'caption': caption,
    'image_url': imageUrl,
    'created_at': createdAt.toIso8601String(),
    'unlock_at': unlockAt?.toIso8601String(),
    'is_opened': isOpened,
    'reaction_count': reactionCount,
    'comment_count': commentCount,
    'has_reacted': hasReacted,
  };
}
