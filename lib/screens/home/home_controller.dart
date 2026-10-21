import 'package:flutter/foundation.dart';

import '../../models/moment.dart';
import '../../models/mood.dart';
import '../../services/home_service.dart';

enum HomeStatus { loading, ready, error }

/// Holds Home screen state and keeps business logic out of widgets.
class HomeController extends ChangeNotifier {
  HomeController(this._service, {this._changes}) {
    _changes?.addListener(load);
  }

  final Listenable? _changes;

  @override
  void dispose() {
    _changes?.removeListener(load);
    super.dispose();
  }

  final HomeService _service;

  HomeStatus status = HomeStatus.loading;
  HomeData? data;
  Mood? selectedMood;

  Future<void> load() async {
    status = data == null ? HomeStatus.loading : status;
    notifyListeners();
    try {
      data = await _service.loadHome();
      selectedMood = data!.todayMood;
      status = HomeStatus.ready;
    } catch (e, st) {
      debugPrint('Home load failed: $e\n$st');
      status = HomeStatus.error;
    }
    notifyListeners();
  }

  Future<void> selectMood(Mood mood) async {
    final user = data?.user;
    if (user == null || mood == selectedMood) return;

    final previous = selectedMood;
    selectedMood = mood; // optimistic update
    notifyListeners();
    try {
      await _service.setTodayMood(user.id, mood);
    } catch (e) {
      debugPrint('Saving mood failed: $e');
      selectedMood = previous;
      notifyListeners();
    }
  }

  Future<void> toggleReaction(Moment moment) async {
    final current = data;
    if (current == null) return;

    final reacted = !moment.hasReacted;
    _replacePost(
      moment.copyWith(
        hasReacted: reacted,
        reactionCount: moment.reactionCount + (reacted ? 1 : -1),
      ),
    );
    try {
      await _service.setReaction(moment.id, current.user.id, reacted: reacted);
    } catch (e) {
      debugPrint('Saving reaction failed: $e');
      _replacePost(moment);
    }
  }

  void _replacePost(Moment updated) {
    final current = data;
    if (current == null) return;
    data = current.copyWith(
      posts: [for (final p in current.posts) p.id == updated.id ? updated : p],
    );
    notifyListeners();
  }
}
