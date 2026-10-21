import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memories/screens/add/add_memory/add_memory_screen.dart';
import 'package:memories/screens/add/add_screen.dart';
import 'package:memories/screens/add/mood_check_in/mood_check_in_screen.dart';
import 'package:memories/screens/add/open_when/open_when_form_screen.dart';
import 'package:memories/screens/friends/add_friend_screen.dart';
import 'package:memories/screens/home/home_screen.dart';
import 'package:memories/widgets/add/create_action_card.dart';

import 'test_helpers.dart';

void main() {
  Finder inAdd(Finder f) =>
      find.descendant(of: find.byType(AddScreen), matching: f);

  testWidgets(
    'Create shows the actions in order; Add Memory goes back to Create',
    (tester) async {
      await pumpApp(tester);
      await openTab(tester, 'Add');
      expect(inAdd(find.text('Create')), findsOneWidget);
      // Requested order first, then the remaining actions.
      const order = [
        'Add Memory',
        'Create Message',
        'Add Friend',
        'Open When',
        'Mood Check-in',
      ];
      final positions = [
        for (final t in order)
          tester.getTopLeft(
            find.ancestor(
              of: inAdd(find.text(t)),
              matching: find.byType(CreateActionCard),
            ),
          ),
      ];
      for (var i = 1; i < positions.length; i++) {
        final prev = positions[i - 1], cur = positions[i];
        // Next card is either to the right on the same row, or on a later row.
        expect(
          cur.dy > prev.dy + 1 ||
              (cur.dy - prev.dy).abs() < 1 && cur.dx > prev.dx,
          isTrue,
          reason: '${order[i]} should come after ${order[i - 1]}',
        );
      }
      expect(find.byType(BackButton), findsNothing);

      await tester.tap(inAdd(find.text('Add Memory')));
      await tester.pumpAndSettle();
      expect(find.byType(AddMemoryScreen), findsOneWidget);
      await tapPrimary(tester, 'Save memory');
      expect(find.text('Give this memory a title.'), findsOneWidget);

      await tapBack(tester);
      expect(find.byType(AddMemoryScreen), findsNothing);
      expect(find.byType(AddScreen), findsOneWidget);
    },
  );

  testWidgets('Open When: add a friend from the picker, then schedule', (
    tester,
  ) async {
    await pumpApp(tester);
    await openTab(tester, 'Add');
    await tester.tap(inAdd(find.text('Open When')));
    await tester.pumpAndSettle();
    expect(find.byType(OpenWhenFormScreen), findsOneWidget);

    await tapPrimary(tester, 'Schedule');
    expect(find.text('Choose who this is for.'), findsOneWidget);

    // No friends yet: the picker offers "Future you" and Add Friend.
    await tester.tap(find.text('Choose recipient'));
    await tester.pumpAndSettle();
    expect(find.text('Future you'), findsOneWidget);
    await tester.tap(find.text('Add Friend').last);
    await tester.pumpAndSettle();
    expect(find.byType(AddFriendScreen), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, 'Noor Hassan');
    await tapPrimary(tester, 'Add Friend');

    // Back on the form with Noor selected.
    expect(find.byType(OpenWhenFormScreen), findsOneWidget);
    expect(find.text('Noor'), findsOneWidget);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'you miss home');
    await tester.enterText(fields.at(1), 'Call me. I mean it.');
    await tapPrimary(tester, 'Schedule');
    expect(find.byType(OpenWhenFormScreen), findsNothing);
    expect(find.text('Open When scheduled'), findsOneWidget);

    // Home now summarizes the scheduled message.
    await openTab(tester, 'Home');
    await tester.scrollUntilVisible(
      find.text('1 scheduled message'),
      300,
      scrollable: scrollableIn(HomeScreen),
    );
    await settleTimers(tester);
  });

  testWidgets('Mood Check-in is a screen with back; saving updates Home', (
    tester,
  ) async {
    await pumpApp(tester);
    await openTab(tester, 'Add');
    await tester.tap(inAdd(find.text('Mood Check-in')));
    await tester.pumpAndSettle();
    expect(find.byType(MoodCheckInScreen), findsOneWidget);
    expect(find.byTooltip('Back'), findsOneWidget);
    expect(
      find.textContaining('Want to say something', findRichText: true),
      findsOneWidget,
    );

    // Save is disabled until a mood is chosen.
    await tapPrimary(tester, 'Save check-in');
    expect(find.byType(MoodCheckInScreen), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Sad').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).last, 'Long day.');
    await tapPrimary(tester, 'Save check-in');
    expect(find.byType(MoodCheckInScreen), findsNothing);
    expect(find.text('Check-in saved'), findsOneWidget);

    await openTab(tester, 'Home');
    expect(find.textContaining('Feeling Sad today'), findsOneWidget);
    await settleTimers(tester);
  });
}
