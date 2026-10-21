import 'package:flutter/foundation.dart';

/// What kind of data changed.
enum DataTopic { memories, moods, capsules, letters, friends, chat }

/// App-wide signal that data was created or updated, so screens showing
/// it can refresh. A backend's realtime events can feed this later.
class DataChanges extends ChangeNotifier {
  DataTopic? _last;

  /// The most recent topic that changed.
  DataTopic? get last => _last;

  void emit(DataTopic topic) {
    _last = topic;
    notifyListeners();
  }
}
