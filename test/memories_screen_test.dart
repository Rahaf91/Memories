import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memories/screens/add/add_memory/add_memory_screen.dart';
import 'package:memories/screens/memories/memories_screen.dart';
import 'package:memories/screens/memory_detail/memory_detail_screen.dart';
import 'package:memories/screens/mood_year/mood_year_screen.dart';
import 'package:memories/widgets/memories/memory_filter_chips.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('empty Memories → add one → detail → back', (tester) async {
    await pumpApp(tester);
    await openTab(tester, 'Memories');
    final scroll = scrollableIn(MemoriesScreen);

    Finder chip(String label) => find.descendant(
      of: find.byType(MemoryFilterChips),
      matching: find.text(label),
    );
    for (final f in ['All', 'Friends', 'Shared']) {
      expect(chip(f), findsOneWidget);
    }
    expect(find.textContaining('This month'.toUpperCase()), findsOneWidget);
    expect(find.text('Your Mood Year'), findsOneWidget);

    // Mood Year opens and returns with back.
    await tester.tap(find.text('Your Mood Year'));
    await tester.pumpAndSettle();
    expect(find.byType(MoodYearScreen), findsOneWidget);
    await tapBack(tester);
    expect(find.byType(MoodYearScreen), findsNothing);

    await tapIn(tester, MemoriesScreen, 'Add Memory');
    expect(find.byType(AddMemoryScreen), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, 'First walk');
    await tapPrimary(tester, 'Save memory');

    expect(find.byType(AddMemoryScreen), findsNothing);
    expect(find.text('Memory saved'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('First walk'),
      300,
      scrollable: scroll,
    );
    expect(find.text('Only you'), findsOneWidget);

    await tapIn(tester, MemoriesScreen, 'First walk');
    expect(find.byType(MemoryDetailScreen), findsOneWidget);
    expect(find.text('Comments'), findsOneWidget);
    await tapBack(tester);
    expect(find.byType(MemoryDetailScreen), findsNothing);
    expect(find.byType(MemoriesScreen), findsOneWidget);

    // A private memory isn't in "Shared".
    tester.state<ScrollableState>(scroll).position.jumpTo(0);
    await tester.pumpAndSettle();
    await tester.ensureVisible(chip('Shared'));
    await tester.pumpAndSettle();
    await tester.tap(chip('Shared'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Nothing here yet.'),
      300,
      scrollable: scroll,
    );
    expect(find.text('First walk'), findsNothing);
    await settleTimers(tester);
  });
}
