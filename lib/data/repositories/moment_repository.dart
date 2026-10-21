import '../../models/moment.dart';

abstract interface class MomentRepository {
  /// Recent moments shared with [userId], newest first.
  Future<List<Moment>> getRecentMoments(String userId, {int limit = 20});

  /// Adds or removes [userId]'s reaction on a moment.
  Future<void> setReaction(
    String momentId,
    String userId, {
    required bool reacted,
  });
}
