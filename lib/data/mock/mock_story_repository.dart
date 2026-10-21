import '../../models/story.dart';
import '../repositories/story_repository.dart';
import 'mock_data.dart';

/// Friends' stories. Starts empty.
class MockStoryRepository implements StoryRepository {
  @override
  Future<List<Story>> getRecentStories(String userId) async {
    await mockDelay();
    return const [];
  }
}
