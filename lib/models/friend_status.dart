import 'app_user.dart';
import 'mood.dart';

/// A friend together with what they shared today (shown in "Friends Today").
class FriendStatus {
  const FriendStatus({
    required this.friend,
    this.todayMood,
    this.note,
    this.updatedAt,
  });

  final AppUser friend;

  /// Null when the friend hasn't checked in today.
  final Mood? todayMood;

  /// Optional short status, e.g. "At the beach".
  final String? note;
  final DateTime? updatedAt;

  bool get hasCheckedIn => todayMood != null;

  factory FriendStatus.fromMap(Map<String, dynamic> map) => FriendStatus(
    friend: AppUser.fromMap(map['friend'] as Map<String, dynamic>),
    todayMood: map['today_mood'] == null
        ? null
        : Mood.fromValue(map['today_mood'] as String),
    note: map['note'] as String?,
    updatedAt: map['updated_at'] == null
        ? null
        : DateTime.parse(map['updated_at'] as String),
  );

  Map<String, dynamic> toMap() => {
    'friend': friend.toMap(),
    'today_mood': todayMood?.value,
    'note': note,
    'updated_at': updatedAt?.toIso8601String(),
  };
}
