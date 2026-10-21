import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/app_user.dart';
import '../../models/memory.dart';
import '../../models/memory_summary.dart';
import '../repositories/auth_repository.dart';
import '../repositories/media_repository.dart';
import '../repositories/memory_repository.dart';
import 'memory_rows.dart';
import 'supabase_tables.dart';

/// Memories stored in Supabase (table [SupabaseTables.memories],
/// i.e. `public.memorise`).
///
/// Row Level Security allows each user to read and write only rows where
/// `user_id = auth.uid()`; every insert sets `user_id` to the signed-in
/// user accordingly.
class SupabaseMemoryRepository implements MemoryRepository {
  SupabaseMemoryRepository({
    required this._auth,
    required this._media,
    SupabaseClient? client,
  }) : _client = client ?? Supabase.instance.client;

  final AuthRepository _auth;

  /// Turns stored photo paths into signed URLs for display.
  final MediaRepository _media;
  final SupabaseClient _client;

  /// Reactions aren't stored in the table yet; kept for this session.
  final Map<String, bool> _reacted = {};

  SupabaseQueryBuilder get _table => _client.from(SupabaseTables.memories);

  AppUser _signedInUser() {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Not signed in');
    return user;
  }

  Memory _fromRow(Map<String, dynamic> row, AppUser owner) {
    final memory = MemoryRows.fromRow(row, owner: owner);
    final reacted = _reacted[memory.id];
    return reacted == null
        ? memory
        : memory.copyWith(hasReacted: reacted, reactionCount: reacted ? 1 : 0);
  }

  /// Maps rows to memories, swapping each stored photo path for a signed
  /// URL (one request for all of them).
  Future<List<Memory>> _toMemories(
    List<Map<String, dynamic>> rows,
    AppUser owner,
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
        _fromRow({...row, 'image_url': display[row['image_url']]}, owner),
    ];
  }

  @override
  Future<List<Memory>> getMemories(String userId) async {
    final owner = _signedInUser();
    final rows = await _table
        .select(MemoryRows.columns)
        .eq('user_id', userId)
        .order('memory_date', ascending: false)
        .order('created_at', ascending: false);
    return _toMemories(rows, owner);
  }

  @override
  Future<Memory?> getMemory(String memoryId) async {
    final owner = _signedInUser();
    final row = await _table
        .select(MemoryRows.columns)
        .eq('id', memoryId)
        .maybeSingle();
    if (row == null) return null;
    return (await _toMemories([row], owner)).single;
  }

  @override
  Future<Memory> createMemory(Memory memory) async {
    final owner = _signedInUser();
    final row = await _table
        .insert(MemoryRows.toInsert(memory, userId: owner.id))
        .select(MemoryRows.columns)
        .single();
    return (await _toMemories([row], owner)).single;
  }

  @override
  Future<MemorySummary> getMonthSummary(String userId, DateTime month) async {
    final memories = await getMemories(userId);
    final inMonth = memories
        .where(
          (m) => m.takenAt.year == month.year && m.takenAt.month == month.month,
        )
        .toList();
    final people = {
      for (final m in inMonth)
        for (final p in m.peopleExcept(userId)) p.id,
    };
    return MemorySummary(
      month: DateTime(month.year, month.month),
      memoryCount: inMonth.length,
      peopleCount: people.length,
      previewImageUrls: memories
          .map((m) => m.coverUrl)
          .whereType<String>()
          .take(4)
          .toList(),
    );
  }

  @override
  Future<void> setReaction(
    String memoryId,
    String userId, {
    required bool reacted,
  }) async {
    _reacted[memoryId] = reacted;
  }
}
