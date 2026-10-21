import '../core/clock.dart';
import '../data/repositories/letter_repository.dart';
import '../models/scheduled_letter.dart';
import 'data_changes.dart';

/// Reading and opening "Open When" letters.
class LettersService {
  LettersService({
    required this._letters,
    required this._changes,
    required this.clock,
  });

  final LetterRepository _letters;
  final DataChanges _changes;
  final Clock clock;

  /// Current stored state of [letter] (driven by the clock and openedAt).
  LetterState stateOf(ScheduledLetter letter) => letter.stateAt(clock.now());

  Future<ScheduledLetter?> getLetter(String id) => _letters.getLetter(id);

  /// Waiting Messages [userId] wrote or received: ready first, then locked
  /// by opening time, then opened (most recently opened first).
  Future<List<ScheduledLetter>> waitingMessages(String userId) async {
    final all = await _letters.getLetters(userId);
    return sortForDisplay(
      all.where((l) => l.kind == LetterKind.message).toList(),
    );
  }

  /// Ready → locked (soonest first) → opened (latest first).
  List<ScheduledLetter> sortForDisplay(List<ScheduledLetter> letters) {
    final now = clock.now();
    int rank(ScheduledLetter x) => switch (x.stateAt(now)) {
      LetterState.ready || LetterState.opening => 0,
      LetterState.locked => 1,
      LetterState.opened => 2,
    };
    return [...letters]..sort((a, b) {
      final r = rank(a).compareTo(rank(b));
      if (r != 0) return r;
      return rank(a) == 2
          ? b.openedAt!.compareTo(a.openedAt!)
          : a.openAt.compareTo(b.openAt);
    });
  }

  /// Saves the first opening. Refuses letters that are still locked.
  Future<ScheduledLetter> markOpened(ScheduledLetter letter) async {
    final now = clock.now();
    if (letter.stateAt(now) == LetterState.locked) {
      throw StateError('Letter ${letter.id} is still locked');
    }
    final updated = await _letters.markOpened(letter.id, at: now);
    _changes.emit(DataTopic.letters);
    return updated;
  }
}
