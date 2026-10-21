import '../core/clock.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/friend_repository.dart';
import '../data/mock/local_media_repository.dart';
import '../data/repositories/letter_repository.dart';
import '../data/repositories/media_repository.dart';
import '../data/repositories/memory_repository.dart';
import '../data/repositories/mood_repository.dart';
import '../models/app_user.dart';
import '../models/memory.dart';
import '../models/mood.dart';
import '../models/mood_entry.dart';
import '../models/scheduled_letter.dart';
import 'data_changes.dart';

/// Who can see a new memory, as offered in the Add Memory form.
enum MemoryPrivacy {
  private,
  friends,
  selected;

  MemoryVisibility get visibility => switch (this) {
    MemoryPrivacy.private => MemoryVisibility.private,
    MemoryPrivacy.friends => MemoryVisibility.friends,
    MemoryPrivacy.selected => MemoryVisibility.shared,
  };
}

/// Use cases behind the Add tab: creating memories, letters, capsules,
/// and mood check-ins.
class CreateService {
  CreateService({
    required this._auth,
    required this._friends,
    required this._memories,
    required this._letters,
    required this._moods,
    required this._changes,
    MediaRepository? media,
    this.clock = const Clock(),
  }) : _media = media ?? LocalMediaRepository();

  final AuthRepository _auth;
  final FriendRepository _friends;
  final MemoryRepository _memories;
  final LetterRepository _letters;
  final MoodRepository _moods;
  final DataChanges _changes;

  /// Where photos are uploaded (Supabase Storage in the app).
  final MediaRepository _media;
  final Clock clock;

  /// The signed-in user (e.g. to write to your future self).
  Future<AppUser> currentUser() => _requireUser();

  Future<AppUser> _requireUser() async {
    final user = await _auth.getCurrentUser();
    if (user == null) throw StateError('No signed-in user');
    return user;
  }

  /// People the user can tag, share with, or write to.
  Future<List<AppUser>> getFriends() async {
    final user = await _requireUser();
    return _friends.getFriends(user.id);
  }

  /// Saves a memory. With [imagePath] (a photo picked on the device), the
  /// photo is uploaded first and stored with the memory; if saving then
  /// fails, the uploaded photo is removed again.
  ///
  /// Throws [MediaUploadException] when the photo can't be uploaded.
  Future<Memory> createMemory({
    required String title,
    required DateTime date,
    required List<AppUser> people,
    required MemoryPrivacy privacy,
    String? caption,
    String? imagePath,
  }) async {
    final user = await _requireUser();
    // The form has no mood picker: use today's check-in, if any.
    final todayMood = (await _moods.getTodayMood(user.id))?.mood;
    final photo = imagePath == null
        ? null
        : await _media.uploadImage(
            imagePath,
            userId: user.id,
            folder: 'memories',
          );
    try {
      final memory = await _memories.createMemory(
        Memory(
          id: '',
          title: title.trim(),
          caption: _clean(caption),
          owner: user,
          imageUrls: [?photo],
          takenAt: date,
          sharedWith: people,
          visibility: privacy.visibility,
          mood: todayMood,
        ),
      );
      _changes.emit(DataTopic.memories);
      return memory;
    } catch (_) {
      if (photo != null) await _media.deleteImage(photo);
      rethrow;
    }
  }

  /// Schedules a letter or Waiting Message. Photos in [imageUrls] that are
  /// local files are uploaded first (and removed again if saving fails).
  ///
  /// Throws [MediaUploadException] when a photo can't be uploaded.
  Future<ScheduledLetter> scheduleLetter({
    required AppUser recipient,
    required String title,
    required String body,
    required DateTime openAt,
    String? note,
    LetterKind kind = LetterKind.openWhen,
    List<String> imageUrls = const [],
  }) async {
    if (!openAt.isAfter(clock.now())) {
      throw ArgumentError('Open date must be in the future');
    }
    final user = await _requireUser();
    final uploaded = <String>[];
    for (final path in imageUrls) {
      uploaded.add(
        await _media.uploadImage(path, userId: user.id, folder: 'messages'),
      );
    }
    try {
      final letter = await _letters.scheduleLetter(
        ScheduledLetter(
          id: '',
          author: user,
          recipient: recipient,
          title: title.trim(),
          body: body.trim(),
          openAt: openAt,
          createdAt: clock.now(),
          kind: kind,
          imageUrls: uploaded,
          note: _clean(note),
        ),
      );
      _changes.emit(DataTopic.letters);
      return letter;
    } catch (_) {
      for (final ref in uploaded) {
        await _media.deleteImage(ref);
      }
      rethrow;
    }
  }

  Future<MoodEntry?> getTodayMood() async {
    final user = await _requireUser();
    return _moods.getTodayMood(user.id);
  }

  Future<MoodEntry> checkIn(Mood mood, {String? note}) async {
    final user = await _requireUser();
    final entry = await _moods.setTodayMood(user.id, mood, note: _clean(note));
    _changes.emit(DataTopic.moods);
    return entry;
  }

  static String? _clean(String? text) {
    final t = text?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }
}
