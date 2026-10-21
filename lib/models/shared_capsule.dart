import 'app_user.dart';

/// A collection of memories that several people contribute to.
class SharedCapsule {
  const SharedCapsule({
    required this.id,
    required this.title,
    required this.participants,
    required this.memoryCount,
    required this.previewImageUrls,
    required this.updatedAt,
    this.description,
    this.revealAt,
  });

  final String id;
  final String title;
  final List<AppUser> participants;
  final int memoryCount;

  /// A few recent images used for the cover collage.
  final List<String> previewImageUrls;
  final DateTime updatedAt;
  final String? description;

  /// When contributions become visible to everyone. Null = always open.
  final DateTime? revealAt;

  factory SharedCapsule.fromMap(Map<String, dynamic> map) => SharedCapsule(
    id: map['id'] as String,
    title: map['title'] as String,
    participants: (map['participants'] as List)
        .map((p) => AppUser.fromMap(p as Map<String, dynamic>))
        .toList(),
    memoryCount: map['memory_count'] as int,
    previewImageUrls: List<String>.from(map['preview_image_urls'] as List),
    updatedAt: DateTime.parse(map['updated_at'] as String),
    description: map['description'] as String?,
    revealAt: map['reveal_at'] == null
        ? null
        : DateTime.parse(map['reveal_at'] as String),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'participants': participants.map((p) => p.toMap()).toList(),
    'memory_count': memoryCount,
    'preview_image_urls': previewImageUrls,
    'updated_at': updatedAt.toIso8601String(),
    'description': description,
    'reveal_at': revealAt?.toIso8601String(),
  };
}
