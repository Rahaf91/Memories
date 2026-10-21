import '../../models/scheduled_letter.dart';
import '../repositories/letter_repository.dart';
import 'mock_data.dart';

/// Letters kept in memory for the current app session. Starts empty.
class MockLetterRepository implements LetterRepository {
  final List<ScheduledLetter> _letters = [];
  int _nextId = 0;

  @override
  Future<List<ScheduledLetter>> getScheduledLetters(String userId) async {
    await mockDelay();
    return _letters.where((l) => l.author.id == userId).toList()
      ..sort((a, b) => a.openAt.compareTo(b.openAt));
  }

  @override
  Future<List<ScheduledLetter>> getInbox(String userId) async {
    await mockDelay();
    return _letters.where((l) => l.recipient.id == userId).toList()
      ..sort((a, b) => a.openAt.compareTo(b.openAt));
  }

  @override
  Future<List<ScheduledLetter>> getLetters(String userId) async {
    await mockDelay();
    return _letters
        .where((l) => l.author.id == userId || l.recipient.id == userId)
        .toList()
      ..sort((a, b) => a.openAt.compareTo(b.openAt));
  }

  @override
  Future<ScheduledLetter?> getLetter(String letterId) async {
    for (final l in _letters) {
      if (l.id == letterId) return l;
    }
    return null;
  }

  @override
  Future<ScheduledLetter> scheduleLetter(ScheduledLetter letter) async {
    await mockDelay();
    final stored = ScheduledLetter(
      id: 'letter-${_nextId++}',
      author: letter.author,
      recipient: letter.recipient,
      title: letter.title,
      body: letter.body,
      openAt: letter.openAt,
      createdAt: letter.createdAt,
      kind: letter.kind,
      note: letter.note,
      imageUrls: letter.imageUrls,
      audioUrl: letter.audioUrl,
      audioDuration: letter.audioDuration,
    );
    _letters.add(stored);
    return stored;
  }

  @override
  Future<ScheduledLetter> markOpened(
    String letterId, {
    required DateTime at,
  }) async {
    final i = _letters.indexWhere((l) => l.id == letterId);
    if (i < 0) throw StateError('Unknown letter $letterId');
    final letter = _letters[i];
    if (letter.openedAt != null) return letter; // first opening wins
    return _letters[i] = letter.copyWith(openedAt: at);
  }
}
