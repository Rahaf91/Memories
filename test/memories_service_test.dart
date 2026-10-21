import 'package:flutter_test/flutter_test.dart';
import 'package:memories/models/app_user.dart';
import 'package:memories/models/memory.dart';
import 'package:memories/models/memory_filter.dart';
import 'package:memories/services/memories_service.dart';

void main() {
  const me = AppUser(id: 'me', displayName: 'Me');
  const friend = AppUser(id: 'f1', displayName: 'Friend One');
  final now = DateTime(2026, 10, 4);

  Memory memory(
    String id, {
    AppUser owner = me,
    List<AppUser> sharedWith = const [],
    MemoryVisibility visibility = MemoryVisibility.private,
  }) => Memory(
    id: id,
    title: id,
    owner: owner,
    sharedWith: sharedWith,
    visibility: visibility,
    imageUrls: const [],
    takenAt: now,
  );

  final all = [
    memory('a'),
    memory('b', sharedWith: [friend], visibility: MemoryVisibility.shared),
    memory(
      'c',
      owner: friend,
      sharedWith: [me],
      visibility: MemoryVisibility.shared,
    ),
    memory('d', visibility: MemoryVisibility.capsule),
  ];

  List<String> ids(MemoryFilter f) =>
      MemoriesService.applyFilter(all, f, me.id).map((m) => m.id).toList();

  test('filters memories', () {
    expect(ids(MemoryFilter.all), ['a', 'b', 'c', 'd']);
    expect(ids(MemoryFilter.friends), ['c']);
    expect(ids(MemoryFilter.shared), ['b', 'c', 'd']);
    expect(ids(MemoryFilter.capsules), ['d']);
  });

  test('peopleExcept removes the viewer', () {
    expect(all[2].peopleExcept(me.id).map((u) => u.id), [friend.id]);
    expect(all[0].peopleExcept(me.id), isEmpty);
  });
}
