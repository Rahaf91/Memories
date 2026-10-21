import 'mood.dart';

/// The most frequent mood for one month (used by "Your Mood Year").
class MonthlyMood {
  const MonthlyMood({
    required this.year,
    required this.month,
    this.dominantMood,
    this.checkInCount = 0,
  });

  final int year;

  /// 1–12.
  final int month;

  /// Null when there were no check-ins (or the month hasn't happened yet).
  final Mood? dominantMood;
  final int checkInCount;

  factory MonthlyMood.fromMap(Map<String, dynamic> map) => MonthlyMood(
    year: map['year'] as int,
    month: map['month'] as int,
    dominantMood: map['dominant_mood'] == null
        ? null
        : Mood.fromValue(map['dominant_mood'] as String),
    checkInCount: map['check_in_count'] as int? ?? 0,
  );

  Map<String, dynamic> toMap() => {
    'year': year,
    'month': month,
    'dominant_mood': dominantMood?.value,
    'check_in_count': checkInCount,
  };
}
