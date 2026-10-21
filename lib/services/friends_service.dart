import '../data/repositories/auth_repository.dart';
import '../data/repositories/friend_repository.dart';
import '../data/repositories/memory_repository.dart';
import '../models/app_user.dart';
import '../models/friend_status.dart';
import '../models/memory.dart';
import 'data_changes.dart';

/// Friends list, adding friends, and per-friend history ("Our Story").
class FriendsService {
  FriendsService({
    required this._auth,
    required this._friends,
    required this._memories,
    required this._changes,
  });

  final AuthRepository _auth;
  final FriendRepository _friends;
  final MemoryRepository _memories;
  final DataChanges _changes;

  Future<AppUser> currentUser() async {
    final user = await _auth.getCurrentUser();
    if (user == null) throw StateError('No signed-in user');
    return user;
  }

  /// Friends with today's mood.
  Future<List<FriendStatus>> friendsToday() async =>
      _friends.getFriendsToday((await currentUser()).id);

  Future<FriendStatus?> statusOf(String friendId) async {
    for (final f in await friendsToday()) {
      if (f.friend.id == friendId) return f;
    }
    return null;
  }

  Future<AppUser> addFriend(String displayName, {String? contact}) async {
    final user = await currentUser();
    final trimmedContact = contact?.trim();
    final friend = await _friends.addFriend(
      user.id,
      displayName: displayName,
      contact: (trimmedContact == null || trimmedContact.isEmpty)
          ? null
          : trimmedContact,
    );
    _changes.emit(DataTopic.friends);
    return friend;
  }

  /// Memories that involve both the user and [friendId], newest first.
  Future<List<Memory>> memoriesWith(String friendId) async {
    final user = await currentUser();
    final all = await _memories.getMemories(user.id);
    return all
        .where((m) => m.peopleExcept(user.id).any((p) => p.id == friendId))
        .toList();
  }
}
