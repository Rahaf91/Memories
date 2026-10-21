import 'app_user.dart';
import 'mood.dart';

/// Who can see a memory.
enum MemoryVisibility {
  private('private', 'Private'),

  /// Visible to all of the owner's friends.
  friends('friends', 'Friends'),

  /// Visible to the people it was shared with.

  shared('shared', 'Shared'),
  capsule('capsule', 'Capsule');

  const MemoryVisibility(this.value, this.label);

  final String value;
  final String label;

  static MemoryVisibility fromValue(String value) =>
      MemoryVisibility.values.firstWhere((v) => v.value == value);
}

/// A saved memory: one or more photos with a story and the people in it.
class Memory {
  const Memory({
    required this.id,
    required this.title,
    required this.owner,
    required this.imageUrls,
    required this.takenAt,
    this.caption,
    this.sharedWith = const [],
    this.visibility = MemoryVisibility.private,
    this.capsuleTitle,
    this.location,
    this.reactionCount = 0,
    this.commentCount = 0,
    this.hasReacted = false,
    this.mood,
  });

  final String id;
  final String title;
  final String? caption;
  final AppUser owner;

  /// Photo URLs; the first one is the cover.
  final List<String> imageUrls;
  final DateTime takenAt;

  /// People the owner shared this memory with.
  final List<AppUser> sharedWith;
  final MemoryVisibility visibility;

  /// Set when the memory belongs to a shared capsule.
  final String? capsuleTitle;
  final String? location;

  final int reactionCount;
  final int commentCount;

  /// Whether the current user has reacted.
  final bool hasReacted;

  /// How the owner felt (stored with the memory).
  final Mood? mood;

  String? get coverUrl => imageUrls.isEmpty ? null : imageUrls.first;

  /// Everyone involved (owner + shared-with), minus [userId].
  List<AppUser> peopleExcept(String userId) =>
      [owner, ...sharedWith].where((u) => u.id != userId).toList();

  Memory copyWith({bool? hasReacted, int? reactionCount}) => Memory(
    id: id,
    title: title,
    caption: caption,
    owner: owner,
    imageUrls: imageUrls,
    takenAt: takenAt,
    sharedWith: sharedWith,
    visibility: visibility,
    capsuleTitle: capsuleTitle,
    location: location,
    reactionCount: reactionCount ?? this.reactionCount,
    commentCount: commentCount,
    hasReacted: hasReacted ?? this.hasReacted,
    mood: mood,
  );

  factory Memory.fromMap(Map<String, dynamic> map) => Memory(
    id: map['id'] as String,
    title: map['title'] as String,
    caption: map['caption'] as String?,
    owner: AppUser.fromMap(map['owner'] as Map<String, dynamic>),
    imageUrls: List<String>.from(map['image_urls'] as List),
    takenAt: DateTime.parse(map['taken_at'] as String),
    sharedWith: (map['shared_with'] as List? ?? const [])
        .map((u) => AppUser.fromMap(u as Map<String, dynamic>))
        .toList(),
    visibility: MemoryVisibility.fromValue(map['visibility'] as String),
    capsuleTitle: map['capsule_title'] as String?,
    location: map['location'] as String?,
    reactionCount: map['reaction_count'] as int? ?? 0,
    commentCount: map['comment_count'] as int? ?? 0,
    hasReacted: map['has_reacted'] as bool? ?? false,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'caption': caption,
    'owner': owner.toMap(),
    'image_urls': imageUrls,
    'taken_at': takenAt.toIso8601String(),
    'shared_with': sharedWith.map((u) => u.toMap()).toList(),
    'visibility': visibility.value,
    'capsule_title': capsuleTitle,
    'location': location,
    'reaction_count': reactionCount,
    'comment_count': commentCount,
    'has_reacted': hasReacted,
  };
}
