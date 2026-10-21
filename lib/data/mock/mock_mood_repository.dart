import '../../models/monthly_mood.dart';
import '../../models/mood.dart';
import '../../models/mood_entry.dart';
import '../repositories/mood_repository.dart';
import 'mock_data.dart';

/// Mood check-ins recorded on this device, kept in memory. Starts empty.
class MockMoodRepository implements MoodRepository {
  final List<MoodEntry> _entries = [];

  @override
  Future<MoodEntry?> getTodayMood(String userId) async {
    await mockDelay();
    final now = DateTime.now();
    for (final e in _entries.reversed) {
      if (e.userId == userId && _sameDay(e.createdAt, now)) return e;
    }
    return null;
  }

  @override
  Future<MoodEntry> setTodayMood(
    String userId,
    Mood mood, {
    String? note,
  }) async {
    final now = DateTime.now();
    // One check-in per day: replace today's.
    _entries.removeWhere(
      (e) => e.userId == userId && _sameDay(e.createdAt, now),
    );
    final entry = MoodEntry(
      id: 'mood-$userId-${now.microsecondsSinceEpoch}',
      userId: userId,
      mood: mood,
      createdAt: now,
      note: note,
    );
    _entries.add(entry);
    return entry;
  }

  @override
  Future<List<MonthlyMood>> getMoodYear(String userId, int year) async {
    await mockDelay();
    return [
      for (var month = 1; month <= 12; month++) _summarize(userId, year, month),
    ];
  }

  MonthlyMood _summarize(String userId, int year, int month) {
    final entries = _entries.where(
      (e) =>
          e.userId == userId &&
          e.createdAt.year == year &&
          e.createdAt.month == month,
    );
    if (entries.isEmpty) return MonthlyMood(year: year, month: month);

    final counts = <Mood, int>{};
    for (final e in entries) {
      counts[e.mood] = (counts[e.mood] ?? 0) + 1;
    }
    final dominant = counts.entries
        .reduce((a, b) => b.value > a.value ? b : a)
        .key;
    return MonthlyMood(
      year: year,
      month: month,
      dominantMood: dominant,
      checkInCount: entries.length,
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
