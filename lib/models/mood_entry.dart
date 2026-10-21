import 'mood.dart';

/// A mood a user recorded on a given day.
class MoodEntry {
  const MoodEntry({
    required this.id,
    required this.userId,
    required this.mood,
    required this.createdAt,
    this.note,
  });

  final String id;
  final String userId;
  final Mood mood;
  final DateTime createdAt;

  /// Optional words about the day.
  final String? note;

  factory MoodEntry.fromMap(Map<String, dynamic> map) => MoodEntry(
    id: map['id'] as String,
    userId: map['user_id'] as String,
    mood: Mood.fromValue(map['mood'] as String),
    createdAt: DateTime.parse(map['created_at'] as String),
    note: map['note'] as String?,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'user_id': userId,
    'mood': mood.value,
    'created_at': createdAt.toIso8601String(),
    'note': note,
  };
}
