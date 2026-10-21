import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memories/app/app.dart';
import 'package:memories/app/dependencies.dart';
import 'package:memories/data/mock/mock_auth_repository.dart';
import 'package:memories/data/mock/mock_memory_repository.dart';
import 'package:memories/models/mood.dart';
import 'package:memories/screens/add/add_memory/add_memory_screen.dart';
import 'package:memories/screens/add/add_screen.dart';
import 'package:memories/screens/memories/memories_screen.dart';
import 'package:memories/screens/shell/main_tab_controller.dart';

import 'test_helpers.dart';

/// The same storage across two app launches stands in for the database.
void main() {
  late MockMemoryRepository storage;
  late MockAuthRepository auth;

  Future<AppDependencies> launch(WidgetTester tester) async {
    final deps = AppDependencies.local(
      authRepository: auth,
      memoryRepository: (_, _) => storage,
    );
    await tester.pumpWidget(MemoriesApp(dependencies: deps));
    await settle(tester);
    return deps;
  }

  testWidgets('add memory → save → shown on Memories → restart → still there', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1206, 2622);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    storage = MockMemoryRepository();
    auth = MockAuthRepository(); // signed in

    final deps = await launch(tester);

    // Today's mood is stored with the memory (the form has no picker).
    await tester.tap(find.text('Good'));
    await settle(tester);

    await openTab(tester, 'Add');
    await tapIn(tester, AddScreen, 'Add Memory');
    expect(find.byType(AddMemoryScreen), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, 'First walk');
    await tapPrimary(tester, 'Save memory');

    // Back on the Memories tab, showing the new memory.
    expect(find.byType(AddMemoryScreen), findsNothing);
    expect(find.text('Memory saved'), findsOneWidget);
    final onMemories = find.descendant(
      of: find.byType(MemoriesScreen),
      matching: find.text('First walk'),
    );
    await tester.scrollUntilVisible(
      onMemories,
      300,
      scrollable: scrollableIn(MemoriesScreen),
    );
    expect(onMemories, findsOneWidget);
    // The Memories tab is the one selected.
    expect(
      MainTabScope.maybeRead(tester.element(find.byType(MemoriesScreen)))!
          .value,
      MainTab.memories,
    );

    final me = deps.auth.user!;
    final stored = await pumpUntilDone(tester, storage.getMemories(me.id));
    expect(stored.single.title, 'First walk');
    expect(stored.single.owner.id, me.id);
    expect(stored.single.mood, Mood.good);
    await settleTimers(tester);

    // RESTART: a fresh app over the same storage.
    await tester.pumpWidget(const SizedBox());
    await launch(tester);
    await openTab(tester, 'Memories');
    await tester.scrollUntilVisible(
      onMemories,
      300,
      scrollable: scrollableIn(MemoriesScreen),
    );
    expect(onMemories, findsOneWidget);
    await settleTimers(tester);
  });
}
