import '../../models/app_user.dart';
import '../../models/scheduled_letter.dart';

/// Converts between [ScheduledLetter] and rows of `public.open_when`:
/// id, user_id, kind, recipient_name, title, body, image_url, open_at,
/// status, opened_at, note, created_at.
///
/// Friends aren't Supabase accounts yet, so the recipient is stored by name;
/// `recipient_name = null` means the author wrote to their future self.
abstract final class LetterRows {
  static const columns =
      'id,user_id,kind,recipient_name,title,body,image_url,open_at,status,'
      'opened_at,note,created_at';

  /// Row to insert. `user_id` must be the signed-in user (`auth.uid()`),
  /// or Row Level Security rejects it.
  static Map<String, dynamic> toInsert(
    ScheduledLetter letter, {
    required String userId,
  }) {
    final note = letter.note?.trim();
    return {
      'user_id': userId,
      'kind': letter.kind.value,
      'recipient_name': letter.isToSelf ? null : letter.recipient.displayName,
      'title': letter.title,
      'body': letter.body,
      'image_url': letter.imageUrls.isEmpty ? null : letter.imageUrls.first,
      'open_at': letter.openAt.toUtc().toIso8601String(),
      'status': 'scheduled',
      'note': (note == null || note.isEmpty) ? null : note,
    };
  }

  /// Fields to set on the first opening.
  static Map<String, dynamic> openedUpdate(DateTime at) => {
    'status': 'opened',
    'opened_at': at.toUtc().toIso8601String(),
  };

  /// [author] is the signed-in user (RLS only returns their own rows).
  static ScheduledLetter fromRow(
    Map<String, dynamic> row, {
    required AppUser author,
  }) {
    final recipientName = (row['recipient_name'] as String?)?.trim();
    final toSelf = recipientName == null || recipientName.isEmpty;
    final imageUrl = row['image_url'] as String?;
    final openedAt = _time(row['opened_at']);
    return ScheduledLetter(
      id: '${row['id']}',
      kind: LetterKind.fromValue(row['kind'] as String?),
      author: author,
      recipient: toSelf
          ? author
          : AppUser(id: 'recipient:$recipientName', displayName: recipientName),
      title: row['title'] as String? ?? '',
      body: row['body'] as String? ?? '',
      openAt: _time(row['open_at']) ?? DateTime.now(),
      createdAt: _time(row['created_at']) ?? DateTime.now(),
      // A row marked opened without a time still counts as opened.
      openedAt:
          openedAt ??
          (row['status'] == 'opened' ? _time(row['created_at']) : null),
      note: row['note'] as String?,
      imageUrls: [if (imageUrl != null && imageUrl.isNotEmpty) imageUrl],
    );
  }

  /// timestamptz → local time.
  static DateTime? _time(Object? value) =>
      value is String ? DateTime.tryParse(value)?.toLocal() : null;
}
