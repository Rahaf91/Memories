import '../../models/app_user.dart';
import '../../models/memory.dart';
import '../../models/memory_summary.dart';
import '../repositories/memory_repository.dart';
import 'mock_data.dart';

class MockMemoryRepository implements MemoryRepository {
  /// Starts empty; memories are created by the user.
  List<Memory> _memories = [];

  bool _visibleTo(Memory m, String userId) =>
      m.owner.id == userId || m.sharedWith.any((u) => u.id == userId);

  @override
  Future<List<Memory>> getMemories(String userId) async {
    await mockDelay();
    return _memories.where((m) => _visibleTo(m, userId)).toList()
      ..sort((a, b) => b.takenAt.compareTo(a.takenAt));
  }

  @override
  Future<Memory?> getMemory(String memoryId) async {
    await mockDelay();
    for (final m in _memories) {
      if (m.id == memoryId) return m;
    }
    return null;
  }

  @override
  Future<Memory> createMemory(Memory memory) async {
    await mockDelay();
    final stored = Memory(
      id: 'memory-${DateTime.now().microsecondsSinceEpoch}',
      title: memory.title,
      caption: memory.caption,
      owner: memory.owner,
      imageUrls: memory.imageUrls,
      takenAt: memory.takenAt,
      sharedWith: memory.sharedWith,
      visibility: memory.visibility,
      capsuleTitle: memory.capsuleTitle,
      location: memory.location,
      mood: memory.mood,
    );
    _memories = [stored, ..._memories];
    return stored;
  }

  @override
  Future<MemorySummary> getMonthSummary(String userId, DateTime month) async {
    await mockDelay();
    final inMonth = _memories
        .where(
          (m) =>
              _visibleTo(m, userId) &&
              m.takenAt.year == month.year &&
              m.takenAt.month == month.month,
        )
        .toList();
    final people = <String, AppUser>{
      for (final m in inMonth)
        for (final p in m.peopleExcept(userId)) p.id: p,
    };
    // Prefer this month's covers; fill with older ones for the collage.
    final covers = [
      ...inMonth.map((m) => m.coverUrl),
      ..._memories.map((m) => m.coverUrl),
    ].whereType<String>().toSet().take(4).toList();

    return MemorySummary(
      month: DateTime(month.year, month.month),
      memoryCount: inMonth.length,
      peopleCount: people.length,
      previewImageUrls: covers,
    );
  }

  @override
  Future<void> setReaction(
    String memoryId,
    String userId, {
    required bool reacted,
  }) async {
    _memories = [
      for (final m in _memories)
        if (m.id == memoryId && m.hasReacted != reacted)
          m.copyWith(
            hasReacted: reacted,
            reactionCount: m.reactionCount + (reacted ? 1 : -1),
          )
        else
          m,
    ];
  }
}
