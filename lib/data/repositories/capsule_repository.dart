import '../../models/shared_capsule.dart';

abstract interface class CapsuleRepository {
  /// Capsules [userId] participates in, most recently updated first.
  Future<List<SharedCapsule>> getCapsules(String userId);

  /// Creates a capsule and returns it as stored (with its final id).
  Future<SharedCapsule> createCapsule(SharedCapsule capsule);
}
