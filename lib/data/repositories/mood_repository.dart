import '../../models/monthly_mood.dart';
import '../../models/mood.dart';
import '../../models/mood_entry.dart';

abstract interface class MoodRepository {
  /// The mood [userId] recorded today, or null if none yet.
  Future<MoodEntry?> getTodayMood(String userId);

  /// Records (or replaces) today's mood for [userId].
  Future<MoodEntry> setTodayMood(String userId, Mood mood, {String? note});

  /// Twelve entries (January–December) summarizing [year].
  Future<List<MonthlyMood>> getMoodYear(String userId, int year);
}
