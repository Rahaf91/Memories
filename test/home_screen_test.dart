import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memories/screens/friends/add_friend_screen.dart';
import 'package:memories/screens/home/home_screen.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('new account: Home shows clean empty states', (tester) async {
    await pumpApp(tester);
    final scroll = scrollableIn(HomeScreen);

    expect(find.text('Memories'), findsWidgets);
    // The mood card has no heading; the faces appear on their own.
    expect(find.text('How are you today?'), findsNothing);
    expect(find.text('Amazing'), findsNothing);
    for (final mood in ['Happy', 'Good', 'Okay', 'Sad', 'Very Bad']) {
      expect(find.text(mood), findsOneWidget);
    }
    // No back button on a main tab.
    expect(find.byType(BackButton), findsNothing);

    for (final text in [
      'No friends added yet',
      'No scheduled messages yet',
      'No memories yet',
      'No waiting messages yet',
    ]) {
      final inHome = find.descendant(
        of: find.byType(HomeScreen),
        matching: find.text(text),
      );
      await tester.scrollUntilVisible(inHome, 300, scrollable: scroll);
      expect(inHome, findsOneWidget);
    }
    expect(
      find.descendant(
        of: find.byType(HomeScreen),
        matching: find.text('Create Message'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('selecting a mood shows the confirmation line', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Good'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Feeling Good today'), findsOneWidget);
  });

  testWidgets('Add Friend from the empty state, then back to Home', (
    tester,
  ) async {
    await pumpApp(tester);
    await tapIn(tester, HomeScreen, 'Add Friend');
    expect(find.byType(AddFriendScreen), findsOneWidget);

    // Back returns to Home without adding anyone.
    await tapBack(tester);
    expect(find.byType(AddFriendScreen), findsNothing);
    // Includes content built just below the fold.
    Finder inHome(String t) => find.descendant(
      of: find.byType(HomeScreen),
      matching: find.text(t, skipOffstage: false),
    );
    expect(inHome('No friends added yet'), findsOneWidget);

    // Add for real this time.
    await tapIn(tester, HomeScreen, 'Add Friend');
    await tester.enterText(find.byType(TextFormField).first, 'Noor Hassan');
    await tapPrimary(tester, 'Add Friend');
    expect(find.byType(AddFriendScreen), findsNothing);
    expect(find.text('Noor added'), findsOneWidget);
    // Scroll back up to Friends Today: Noor replaces the empty state.
    tester.state<ScrollableState>(scrollableIn(HomeScreen)).position.jumpTo(0);
    await settle(tester);
    expect(inHome('Friends Today'), findsOneWidget);
    expect(inHome('No friends added yet'), findsNothing);
    expect(inHome('Noor'), findsOneWidget);
    await settleTimers(tester);
  });
}
