import '../../models/app_user.dart';
import '../../models/friend_status.dart';
import '../repositories/friend_repository.dart';
import 'mock_data.dart';

/// Friends added on this device, kept in memory per account. Starts empty.
class MockFriendRepository implements FriendRepository {
  final Map<String, List<AppUser>> _friendsByUser = {};
  int _nextId = 0;

  @override
  Future<List<AppUser>> getFriends(String userId) async {
    await mockDelay();
    return [...?_friendsByUser[userId]]
      ..sort((a, b) => a.displayName.compareTo(b.displayName));
  }

  @override
  Future<List<FriendStatus>> getFriendsToday(String userId) async {
    final friends = await getFriends(userId);
    // Friends' moods arrive from the backend later; none locally.
    return [for (final f in friends) FriendStatus(friend: f)];
  }

  @override
  Future<AppUser> addFriend(
    String userId, {
    required String displayName,
    String? contact,
  }) async {
    await mockDelay();
    final friend = AppUser(
      id: 'friend-${_nextId++}',
      displayName: displayName.trim(),
    );
    (_friendsByUser[userId] ??= []).add(friend);
    return friend;
  }
}
