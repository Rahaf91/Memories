import '../../models/moment.dart';
import '../repositories/moment_repository.dart';
import 'mock_data.dart';

/// Moments shared with the user. Starts empty; friends' shares arrive from
/// the backend later.
class MockMomentRepository implements MomentRepository {
  List<Moment> _moments = const [];

  @override
  Future<List<Moment>> getRecentMoments(String userId, {int limit = 20}) async {
    await mockDelay();
    return _moments.take(limit).toList();
  }

  @override
  Future<void> setReaction(
    String momentId,
    String userId, {
    required bool reacted,
  }) async {
    _moments = [
      for (final m in _moments)
        if (m.id == momentId && m.hasReacted != reacted)
          m.copyWith(
            hasReacted: reacted,
            reactionCount: m.reactionCount + (reacted ? 1 : -1),
          )
        else
          m,
    ];
  }
}
