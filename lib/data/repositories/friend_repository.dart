import '../../models/app_user.dart';
import '../../models/friend_status.dart';

abstract interface class FriendRepository {
  /// Friends of [userId] with their check-in for today.
  Future<List<FriendStatus>> getFriendsToday(String userId);

  /// All of [userId]'s friends, alphabetically.
  Future<List<AppUser>> getFriends(String userId);

  /// Adds a friend for [userId]. With a backend this becomes a friend
  /// request/invite using [contact] (email or phone).
  Future<AppUser> addFriend(
    String userId, {
    required String displayName,
    String? contact,
  });
}
