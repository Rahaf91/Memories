import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memories/data/mock/mock_capsule_repository.dart';
import 'package:memories/data/mock/mock_chat_repository.dart';
import 'package:memories/data/mock/mock_data.dart';
import 'package:memories/data/mock/mock_friend_repository.dart';
import 'package:memories/data/mock/mock_memory_repository.dart';
import 'package:memories/data/mock/mock_moment_repository.dart';
import 'package:memories/data/mock/mock_story_repository.dart';
import 'package:memories/widgets/common/media_image.dart';

import 'test_helpers.dart';

/// The app ships with no sample people, content, or photos.
void main() {
  test('local repositories start empty', () async {
    final id = MockUsers.me.id;
    expect(MockUsers.me.avatarUrl, isNull);
    expect(await MockFriendRepository().getFriends(id), isEmpty);
    expect(await MockMemoryRepository().getMemories(id), isEmpty);
    expect(await MockMomentRepository().getRecentMoments(id), isEmpty);
    expect(await MockStoryRepository().getRecentStories(id), isEmpty);
    expect(await MockCapsuleRepository().getCapsules(id), isEmpty);
    expect(await MockChatRepository().watchConversations(id).first, isEmpty);
  });

  test('media references resolve to network or file providers', () {
    expect(mediaImageProvider(null), isNull);
    expect(mediaImageProvider(''), isNull);
    expect(
      mediaImageProvider('https://cdn.example/a.jpg'),
      isA<NetworkImage>(),
    );
    expect(mediaImageProvider('/tmp/picked.jpg'), isA<FileImage>());
  });

  testWidgets('no main tab renders a photo or a back button', (tester) async {
    await pumpApp(tester);
    final photos = find.byWidgetPredicate(
      (w) =>
          (w is Image && w.image is! AssetImage) ||
          (w is CircleAvatar && w.foregroundImage != null),
    );
    for (final tab in ['Home', 'Memories', 'Add', 'Chat', 'Profile']) {
      await openTab(tester, tab);
      expect(photos, findsNothing, reason: '$tab tab');
      expect(find.byType(BackButton), findsNothing, reason: '$tab tab');
    }
    expect(find.byType(MediaPlaceholder), findsWidgets);
  });
}
