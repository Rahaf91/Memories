import 'package:flutter/foundation.dart';

import '../../models/memory.dart';
import '../../models/memory_filter.dart';
import '../../services/memories_service.dart';

enum MemoriesStatus { loading, ready, error }

class MemoriesController extends ChangeNotifier {
  MemoriesController(this._service, {this._changes}) {
    _changes?.addListener(load);
  }

  final Listenable? _changes;

  @override
  void dispose() {
    _changes?.removeListener(load);
    super.dispose();
  }

  final MemoriesService _service;

  MemoriesStatus status = MemoriesStatus.loading;
  MemoriesOverview? overview;
  MemoryFilter filter = MemoryFilter.all;

  List<Memory> get visibleMemories {
    final data = overview;
    if (data == null) return const [];
    return MemoriesService.applyFilter(data.memories, filter, data.user.id);
  }

  /// Loads (or silently refreshes, if data is already shown).
  Future<void> load() async {
    if (overview == null) {
      status = MemoriesStatus.loading;
      notifyListeners();
    }
    try {
      overview = await _service.loadOverview();
      status = MemoriesStatus.ready;
    } catch (e, st) {
      debugPrint('Memories load failed: $e\n$st');
      if (overview == null) status = MemoriesStatus.error;
    }
    notifyListeners();
  }

  void selectFilter(MemoryFilter value) {
    if (value == filter) return;
    filter = value;
    notifyListeners();
  }

  Future<void> toggleReaction(Memory memory) async {
    final data = overview;
    if (data == null) return;

    final reacted = !memory.hasReacted;
    _replace(
      memory.copyWith(
        hasReacted: reacted,
        reactionCount: memory.reactionCount + (reacted ? 1 : -1),
      ),
    );
    try {
      await _service.setReaction(memory.id, data.user.id, reacted: reacted);
    } catch (e) {
      debugPrint('Saving reaction failed: $e');
      _replace(memory);
    }
  }

  void _replace(Memory updated) {
    final data = overview;
    if (data == null) return;
    overview = data.copyWith(
      memories: [
        for (final m in data.memories) m.id == updated.id ? updated : m,
      ],
    );
    notifyListeners();
  }
}
