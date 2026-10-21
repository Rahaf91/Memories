import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/app_user.dart';
import '../../models/scheduled_letter.dart';
import '../repositories/auth_repository.dart';
import '../repositories/letter_repository.dart';
import '../repositories/media_repository.dart';
import 'letter_rows.dart';
import 'supabase_tables.dart';

/// Open When letters and Waiting Messages in `public.open_when`.
///
/// RLS limits every query to rows where `user_id = auth.uid()`. Locked vs.
/// ready is never stored: it's derived from `open_at` and the clock.
/// `status`/`opened_at` record the first opening.
class SupabaseLetterRepository implements LetterRepository {
  SupabaseLetterRepository({
    required this._auth,
    required this._media,
    SupabaseClient? client,
  }) : _client = client ?? Supabase.instance.client;

  final AuthRepository _auth;

  /// Turns stored photo paths into signed URLs for display.
  final MediaRepository _media;
  final SupabaseClient _client;

  SupabaseQueryBuilder get _table => _client.from(SupabaseTables.openWhen);

  AppUser _signedInUser() {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Not signed in');
    return user;
  }

  Future<List<ScheduledLetter>> _toLetters(
    List<Map<String, dynamic>> rows,
    AppUser author,
  ) async {
    final refs = {
      for (final row in rows)
        if ((row['image_url'] as String?)?.isNotEmpty ?? false)
          row['image_url'] as String,
    }.toList();
    final urls = await _media.displayUrls(refs);
    final display = {for (var i = 0; i < refs.length; i++) refs[i]: urls[i]};
    return [
      for (final row in rows)
        LetterRows.fromRow({
          ...row,
          'image_url': display[row['image_url']],
        }, author: author),
    ];
  }

  /// All of the user's rows, soonest unlock first.
  Future<List<ScheduledLetter>> _all(String userId) async {
    final author = _signedInUser();
    final rows = await _table
        .select(LetterRows.columns)
        .eq('user_id', userId)
        .order('open_at', ascending: true);
    return _toLetters(rows, author);
  }

  @override
  Future<List<ScheduledLetter>> getLetters(String userId) => _all(userId);

  /// Letters the user wrote (all rows are theirs under RLS).
  @override
  Future<List<ScheduledLetter>> getScheduledLetters(String userId) =>
      _all(userId);

  /// Letters addressed to the user: the ones written to their future self.
  @override
  Future<List<ScheduledLetter>> getInbox(String userId) async =>
      (await _all(userId)).where((l) => l.isToSelf).toList();

  @override
  Future<ScheduledLetter?> getLetter(String letterId) async {
    final author = _signedInUser();
    final row = await _table
        .select(LetterRows.columns)
        .eq('id', letterId)
        .maybeSingle();
    if (row == null) return null;
    return (await _toLetters([row], author)).single;
  }

  @override
  Future<ScheduledLetter> scheduleLetter(ScheduledLetter letter) async {
    final author = _signedInUser();
    final row = await _table
        .insert(LetterRows.toInsert(letter, userId: author.id))
        .select(LetterRows.columns)
        .single();
    return (await _toLetters([row], author)).single;
  }

  @override
  Future<ScheduledLetter> markOpened(
    String letterId, {
    required DateTime at,
  }) async {
    // Only the first opening is recorded (opened_at still empty).
    await _table
        .update(LetterRows.openedUpdate(at))
        .eq('id', letterId)
        .isFilter('opened_at', null);
    final letter = await getLetter(letterId);
    if (letter == null) throw StateError('Unknown letter $letterId');
    return letter;
  }
}
