import 'app_user.dart';

/// A short-lived photo update shown in the "Recent" row.
class Story {
  const Story({
    required this.id,
    required this.author,
    this.imageUrl,
    required this.createdAt,
    this.isSeen = false,
  });

  final String id;
  final AppUser author;

  /// Null until the author's photo is uploaded.
  final String? imageUrl;
  final DateTime createdAt;
  final bool isSeen;

  factory Story.fromMap(Map<String, dynamic> map) => Story(
    id: map['id'] as String,
    author: AppUser.fromMap(map['author'] as Map<String, dynamic>),
    imageUrl: map['image_url'] as String?,
    createdAt: DateTime.parse(map['created_at'] as String),
    isSeen: map['is_seen'] as bool? ?? false,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'author': author.toMap(),
    'image_url': imageUrl,
    'created_at': createdAt.toIso8601String(),
    'is_seen': isSeen,
  };
}
