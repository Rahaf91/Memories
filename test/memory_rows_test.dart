import 'package:flutter_test/flutter_test.dart';
import 'package:memories/data/supabase/memory_rows.dart';
import 'package:memories/models/app_user.dart';
import 'package:memories/models/memory.dart';
import 'package:memories/models/mood.dart';

void main() {
  const owner = AppUser(id: 'auth-uid-123', displayName: 'Rahaf');

  test('insert row matches public.memories and RLS (user_id = auth.uid())', () {
    final row = MemoryRows.toInsert(
      Memory(
        id: '',
        title: 'First walk',
        caption: '  Cold air, warm coffee.  ',
        owner: owner,
        imageUrls: const [],
        takenAt: DateTime(2026, 10, 5, 23, 30),
        mood: Mood.amazing,
      ),
      userId: owner.id,
    );
    expect(row, {
      'user_id': 'auth-uid-123',
      'title': 'First walk',
      'description': 'Cold air, warm coffee.',
      'memory_date': '2026-10-05',
      'mood': 'amazing',
      'image_url': null,
    });
  });

  test('empty description and no mood are sent as null', () {
    final row = MemoryRows.toInsert(
      Memory(
        id: '',
        title: 'T',
        caption: '   ',
        owner: owner,
        imageUrls: const [],
        takenAt: DateTime(2026, 1, 2),
      ),
      userId: owner.id,
    );
    expect(row['description'], isNull);
    expect(row['mood'], isNull);
    expect(row['memory_date'], '2026-01-02');
  });

  test('rows map back to memories without shifting the day', () {
    for (final date in [
      '2026-10-05', // date column
      '2026-10-05T00:00:00+00:00', // timestamptz at midnight UTC
      '2026-10-05T23:59:00-08:00',
    ]) {
      final memory = MemoryRows.fromRow({
        'id': 42,
        'user_id': owner.id,
        'title': 'First walk',
        'description': 'Cold air.',
        'memory_date': date,
        'mood': 'good',
        'image_url': null,
        'created_at': '2026-10-05T10:00:00Z',
      }, owner: owner);
      expect(memory.takenAt, DateTime(2026, 10, 5), reason: date);
      expect(memory.id, '42');
      expect(memory.caption, 'Cold air.');
      expect(memory.mood, Mood.good);
      expect(memory.imageUrls, isEmpty);
      expect(memory.owner.id, owner.id);
    }
  });
}
