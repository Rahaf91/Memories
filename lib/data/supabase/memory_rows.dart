import '../../models/app_user.dart';
import '../../models/memory.dart';
import '../../models/mood.dart';

/// Converts between [Memory] and rows of the memories table
/// (`public.memorise`):
/// id, user_id, title, description, memory_date, mood, image_url,
/// created_at.
abstract final class MemoryRows {
  static const columns =
      'id,user_id,title,description,memory_date,mood,image_url,created_at';

  /// Row to insert. `user_id` must be the signed-in user (`auth.uid()`),
  /// or Row Level Security rejects it.
  static Map<String, dynamic> toInsert(
    Memory memory, {
    required String userId,
  }) {
    final caption = memory.caption?.trim();
    return {
      'user_id': userId,
      'title': memory.title,
      'description': (caption == null || caption.isEmpty) ? null : caption,
      'memory_date': dateOnly(memory.takenAt),
      'mood': memory.mood?.value,
      'image_url': memory.coverUrl, // null until Storage is connected
    };
  }

  static Memory fromRow(Map<String, dynamic> row, {required AppUser owner}) {
    final imageUrl = row['image_url'] as String?;
    final mood = row['mood'] as String?;
    return Memory(
      id: '${row['id']}',
      title: row['title'] as String? ?? '',
      caption: row['description'] as String?,
      owner: owner,
      imageUrls: [if (imageUrl != null && imageUrl.isNotEmpty) imageUrl],
      takenAt:
          parseDate(row['memory_date'] as String?) ??
          parseDate(row['created_at'] as String?) ??
          DateTime.now(),
      mood: mood == null ? null : _moodOrNull(mood),
    );
  }

  /// `2026-10-05` (the calendar day, no time zone).
  static String dateOnly(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  /// Reads the calendar day from a `date` or `timestamptz` value without
  /// converting time zones, so a memory never shifts to the previous or
  /// next day.
  static DateTime? parseDate(String? value) {
    if (value == null || value.length < 10) return null;
    final y = int.tryParse(value.substring(0, 4));
    final m = int.tryParse(value.substring(5, 7));
    final d = int.tryParse(value.substring(8, 10));
    if (y == null || m == null || d == null) return null;
    return DateTime(y, m, d);
  }

  static Mood? _moodOrNull(String value) {
    for (final mood in Mood.values) {
      if (mood.value == value) return mood;
    }
    return null;
  }
}
