import '../../models/scheduled_letter.dart';

abstract interface class LetterRepository {
  /// Letters [userId] has written, soonest first.
  Future<List<ScheduledLetter>> getScheduledLetters(String userId);

  /// Letters addressed to [userId] (including ones to their future self).
  Future<List<ScheduledLetter>> getInbox(String userId);

  /// Every letter [userId] wrote or received, soonest first.
  Future<List<ScheduledLetter>> getLetters(String userId);

  Future<ScheduledLetter?> getLetter(String letterId);

  /// Schedules a letter and returns it as stored (with its final id).
  Future<ScheduledLetter> scheduleLetter(ScheduledLetter letter);

  /// Records the first opening. Later calls keep the original time.
  Future<ScheduledLetter> markOpened(String letterId, {required DateTime at});
}
