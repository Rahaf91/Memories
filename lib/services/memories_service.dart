import '../data/repositories/auth_repository.dart';
import '../data/repositories/memory_repository.dart';
import '../data/repositories/mood_repository.dart';
import '../models/app_user.dart';
import '../models/memory.dart';
import '../models/memory_filter.dart';
import '../models/memory_summary.dart';
import '../models/monthly_mood.dart';

/// Everything the Memories screen needs, loaded in one go.
class MemoriesOverview {
  const MemoriesOverview({
    required this.user,
    required this.summary,
    required this.moodYear,
    required this.memories,
  });

  final AppUser user;
  final MemorySummary summary;
  final List<MonthlyMood> moodYear;
  final List<Memory> memories;

  MemoriesOverview copyWith({List<Memory>? memories}) => MemoriesOverview(
    user: user,
    summary: summary,
    moodYear: moodYear,
    memories: memories ?? this.memories,
  );
}

/// Memory use cases for the Memories tab and Memory Detail.
class MemoriesService {
  MemoriesService({
    required this._auth,
    required this._memories,
    required this._moods,
  });

  final AuthRepository _auth;
  final MemoryRepository _memories;
  final MoodRepository _moods;

  Future<MemoriesOverview> loadOverview({DateTime? now}) async {
    final date = now ?? DateTime.now();
    final user = await _auth.getCurrentUser();
    if (user == null) {
      throw StateError('No signed-in user');
    }

    final (memories, summary, moodYear) = await (
      _memories.getMemories(user.id),
      _memories.getMonthSummary(user.id, date),
      _moods.getMoodYear(user.id, date.year),
    ).wait;

    return MemoriesOverview(
      user: user,
      summary: summary,
      moodYear: moodYear,
      memories: memories,
    );
  }

  Future<Memory?> getMemory(String memoryId) => _memories.getMemory(memoryId);

  Future<void> setReaction(
    String memoryId,
    String userId, {
    required bool reacted,
  }) => _memories.setReaction(memoryId, userId, reacted: reacted);

  /// Applies a [MemoryFilter] as seen by [userId].
  static List<Memory> applyFilter(
    List<Memory> memories,
    MemoryFilter filter,
    String userId,
  ) => switch (filter) {
    MemoryFilter.all => memories,
    MemoryFilter.friends =>
      memories.where((m) => m.owner.id != userId).toList(),
    MemoryFilter.shared =>
      memories.where((m) => m.visibility != MemoryVisibility.private).toList(),
    MemoryFilter.capsules =>
      memories.where((m) => m.visibility == MemoryVisibility.capsule).toList(),
  };
}
