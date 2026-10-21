import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memories/app/app.dart';
import 'package:memories/app/dependencies.dart';
import 'package:memories/core/clock.dart';
import 'package:memories/models/scheduled_letter.dart';
import 'package:memories/screens/add/add_screen.dart';
import 'package:memories/screens/home/home_screen.dart';
import 'package:memories/screens/letters/letter_screen.dart';
import 'package:memories/widgets/letters/letter_card.dart';

import 'test_helpers.dart';

/// A clock the test moves forward by hand.
class FakeClock extends Clock {
  FakeClock(this.current);
  DateTime current;

  @override
  DateTime now() => current;

  void advance(Duration d) => current = current.add(d);
}

void main() {
  late FakeClock clock;
  late AppDependencies deps;

  Future<ScheduledLetter> pumpWithSelfLetter(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1206, 2622);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    clock = FakeClock(DateTime(2026, 10, 5, 9));
    deps = AppDependencies.local(clock: clock);
    await tester.pumpWidget(MemoriesApp(dependencies: deps));
    await tester.pumpAndSettle();

    // Write a letter to "future me" that unlocks in one hour.
    final me = await _await(tester, deps.createService.currentUser());
    final letter = await _await(
      tester,
      deps.createService.scheduleLetter(
        recipient: me,
        title: 'you need a pause',
        body: 'Breathe. You are doing better than you think.',
        openAt: clock.now().add(const Duration(hours: 1)),
      ),
    );
    await settle(tester);
    return letter;
  }

  /// The card's title: always on screen once scrolled to, so taps land.
  final cardTitle = find.text('Open when you need a pause');

  Future<void> showCard(WidgetTester tester) async {
    await tester.scrollUntilVisible(
      cardTitle,
      300,
      scrollable: scrollableIn(HomeScreen),
    );
    await tester.ensureVisible(cardTitle);
    await tester.pumpAndSettle();
  }

  Finder inCard(String text) =>
      find.descendant(of: find.byType(LetterCard), matching: find.text(text));

  const body = 'Breathe. You are doing better than you think.';

  testWidgets('locked → ready → first-open reveal → opened → reopen normally', (
    tester,
  ) async {
    final letter = await pumpWithSelfLetter(tester);
    await showCard(tester);

    // LOCKED: content sealed (never even rendered), unlock time shown.
    expect(inCard('Open when you need a pause'), findsOneWidget);
    expect(inCard('Waiting'), findsOneWidget);
    expect(inCard('Sealed message'), findsOneWidget);
    expect(find.text(body, skipOffstage: false), findsNothing);
    expect(find.textContaining('Opens Mon, Oct 5'), findsOneWidget);

    // Tapping a locked letter doesn't open it.
    await tester.tap(cardTitle);
    await tester.pump();
    expect(find.byType(LetterScreen), findsNothing);
    expect(find.textContaining('This message opens'), findsOneWidget);
    await settleTimers(tester);

    // Time passes: the card turns READY by itself (no reload).
    clock.advance(const Duration(hours: 1, seconds: 1));
    await tester.pump(const Duration(hours: 1, seconds: 1));
    await tester.pump(const Duration(milliseconds: 400));
    expect(inCard('Ready to open'), findsWidgets);
    expect(inCard('Tap to open'), findsOneWidget);
    expect(deps.lettersService.stateOf(letter), LetterState.ready);

    // FIRST OPEN: the reveal plays; not saved as opened until it ends.
    await tester.tap(cardTitle);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300)); // card expanding
    final screen = tester.widget<LetterScreen>(find.byType(LetterScreen));
    expect(screen.reveal, isTrue);
    await tester.pump(const Duration(milliseconds: 300)); // route done
    await tester.pump(const Duration(milliseconds: 500)); // mid-reveal
    expect((await deps.lettersService.getLetter(letter.id))!.openedAt, isNull);
    await tester.pumpAndSettle();

    // OPENED: saved with the first-opened time, shown on the screen.
    final opened = (await deps.lettersService.getLetter(letter.id))!;
    expect(opened.openedAt, clock.now());
    expect(deps.lettersService.stateOf(opened), LetterState.opened);
    expect(find.text(body), findsOneWidget);
    expect(find.textContaining('First opened'), findsOneWidget);

    // Close: the card now shows the opened state and the text.
    await tapBack(tester);
    expect(find.byType(LetterScreen), findsNothing);
    expect(inCard(body), findsOneWidget);
    expect(find.textContaining('Opened Mon, Oct 5'), findsOneWidget);

    // REOPEN: a normal push, no reveal.
    await tester.tap(cardTitle);
    await tester.pumpAndSettle();
    expect(
      tester.widget<LetterScreen>(find.byType(LetterScreen)).reveal,
      isFalse,
    );
    expect(find.text(body), findsOneWidget);
    // Opening again doesn't change the first-opened time.
    expect(
      (await deps.lettersService.getLetter(letter.id))!.openedAt,
      opened.openedAt,
    );
    await tapBack(tester);
    await settleTimers(tester);
  });

  testWidgets('leaving mid-reveal keeps the letter unopened', (tester) async {
    final letter = await pumpWithSelfLetter(tester);
    clock.advance(const Duration(hours: 2));
    await tester.pump(const Duration(hours: 2));
    await showCard(tester);

    await tester.tap(cardTitle);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700)); // reveal running
    await tester.tap(find.byTooltip('Back').last);
    await tester.pumpAndSettle();

    expect(find.byType(LetterScreen), findsNothing);
    expect(
      deps.lettersService.stateOf(
        (await deps.lettersService.getLetter(letter.id))!,
      ),
      LetterState.ready,
    );
    await settleTimers(tester);
  });

  testWidgets('Open When offers "Future you" as a recipient', (tester) async {
    await pumpApp(tester);
    await openTab(tester, 'Add');
    await tester.tap(
      find.descendant(
        of: find.byType(AddScreen),
        matching: find.text('Open When'),
      ),
    );
    await settle(tester);
    await tester.tap(find.text('Choose recipient'));
    await settle(tester);
    expect(find.text('Future you'), findsOneWidget);
    await tester.tap(find.text('Future you'));
    await settle(tester);
    expect(find.text('Future you'), findsOneWidget); // selected chip
  });
}

/// Awaits a future while letting fake time (mock latency) advance.
Future<T> _await<T>(WidgetTester tester, Future<T> future) async {
  await tester.pump(const Duration(seconds: 1));
  return future;
}
