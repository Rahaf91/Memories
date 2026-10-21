import '../../models/shared_capsule.dart';
import '../repositories/capsule_repository.dart';
import 'mock_data.dart';

class MockCapsuleRepository implements CapsuleRepository {
  /// Starts empty; capsules are created by the user.
  List<SharedCapsule> _capsules = [];

  @override
  Future<List<SharedCapsule>> getCapsules(String userId) async {
    await mockDelay();
    return _capsules
        .where((c) => c.participants.any((p) => p.id == userId))
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  @override
  Future<SharedCapsule> createCapsule(SharedCapsule capsule) async {
    await mockDelay();
    final stored = SharedCapsule(
      id: 'capsule-${DateTime.now().microsecondsSinceEpoch}',
      title: capsule.title,
      participants: capsule.participants,
      memoryCount: 0,
      previewImageUrls: const [],
      updatedAt: DateTime.now(),
      description: capsule.description,
      revealAt: capsule.revealAt,
    );
    _capsules = [stored, ..._capsules];
    return stored;
  }
}
