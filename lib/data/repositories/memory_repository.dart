import '../../models/memory.dart';
import '../../models/memory_summary.dart';

abstract interface class MemoryRepository {
  /// Memories visible to [userId] (their own and ones shared with them),
  /// newest first.
  Future<List<Memory>> getMemories(String userId);

  Future<Memory?> getMemory(String memoryId);

  /// Saves a new memory and returns it as stored (with its final id).
  Future<Memory> createMemory(Memory memory);

  /// Totals for the calendar month containing [month].
  Future<MemorySummary> getMonthSummary(String userId, DateTime month);

  Future<void> setReaction(
    String memoryId,
    String userId, {
    required bool reacted,
  });
}
