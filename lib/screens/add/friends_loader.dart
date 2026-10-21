import 'package:flutter/widgets.dart';

import '../../app/app_navigator.dart';
import '../../app/dependencies.dart';
import '../../models/app_user.dart';

/// Loads the user's friends once for people pickers in create forms, and
/// lets the picker add a friend on the spot.
mixin FriendsLoader<T extends StatefulWidget> on State<T> {
  /// Null while loading.
  List<AppUser>? friends;

  @override
  void initState() {
    super.initState();
    AppScope.of(context).createService.getFriends().then(
      (value) {
        if (mounted) setState(() => friends = value);
      },
      onError: (Object e) {
        debugPrint('Loading friends failed: $e');
        if (mounted) setState(() => friends = const []);
      },
    );
  }

  /// Opens Add Friend; the new friend joins [friends] and is returned so the
  /// picker can select it.
  Future<AppUser?> addFriendFromPicker() async {
    final friend = await AppNavigator.openAddFriend(context);
    if (friend != null && mounted) {
      setState(() => friends = [...?friends, friend]);
    }
    return friend;
  }
}
