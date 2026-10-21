import '../../models/story.dart';

abstract interface class StoryRepository {
  /// Active stories from people [userId] follows, unseen first.
  Future<List<Story>> getRecentStories(String userId);
}
