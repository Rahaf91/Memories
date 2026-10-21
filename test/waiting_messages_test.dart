import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memories/app/app.dart';
import 'package:memories/app/dependencies.dart';
import 'package:memories/models/app_language.dart';
import 'package:memories/models/scheduled_letter.dart';
import 'package:memories/screens/home/home_screen.dart';
import 'package:memories/screens/letters/letter_screen.dart';
import 'package:memories/screens/waiting/create_message_screen.dart';
import 'package:memories/screens/waiting/waiting_messages_screen.dart';
import 'package:memories/services/media_picker.dart';
import 'package:memories/widgets/common/media_image.dart';
import 'package:memories/widgets/letters/letter_card.dart';

import 'letter_flow_test.dart' show FakeClock;
import 'test_helpers.dart';

/// Returns a fixed path instead of opening the photo library.
class FakeMediaPicker implements MediaPicker {
  @override
  Future<String?> pickImage() async => '/tmp/waiting-message.jpg';
}

void main() {
  late FakeClock clock;
  late AppDependencies deps;

  Future<void> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1206, 2622);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    clock = FakeClock(DateTime(2026, 10, 5, 9)); // Monday 9:00
    deps = AppDependencies.local(clock: clock, mediaPicker: FakeMediaPicker());
    await tester.pumpWidget(MemoriesApp(dependencies: deps));
    await tester.pumpAndSettle();
    await addFriend(tester, deps, 'Noor Hassan');
  }

  const title = 'For your birthday';
  const body = 'Happy birthday. I wrote this months ago and meant every word.';

  Future<void> createMessage(WidgetTester tester) async {
    await tapIn(tester, HomeScreen, 'Create Message');
    expect(find.byType(CreateMessageScreen), findsOneWidget);

    await tester.tap(find.text('Choose recipient'));
    await settle(tester);
    expect(find.text('Future you'), findsOneWidget);
    await tester.tap(find.text('Noor Hassan'));
    await settle(tester);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), title);
    await tester.enterText(fields.at(1), body);

    // Optional image (from the fake picker).
    await tapIn(tester, CreateMessageScreen, 'Add an image');
    expect(
      find.descendant(
        of: find.byType(CreateMessageScreen),
        matching: find.byType(MediaImage),
      ),
      findsOneWidget,
    );

    // Defaults: tomorrow (Tue, Oct 6) at 9:00 AM.
    expect(
      find.text('Tuesday, October 6, 2026', skipOffstage: false),
      findsOneWidget,
    );
    // The formatter separates "AM" with a narrow no-break space.
    await tester.scrollUntilVisible(
      find.textContaining('9:00'),
      200,
      scrollable: scrollableIn(CreateMessageScreen),
    );
    expect(find.textContaining('9:00'), findsOneWidget);

    await tapPrimary(tester, 'Schedule message');
    expect(find.byType(CreateMessageScreen), findsNothing);
  }

  Finder inCard(String text) => find.descendant(
    of: find.byType(LetterCard),
    matching: find.textContaining(text),
  );

  testWidgets('create → save → locked → time reached → ready → first open → '
      'opened → close → reopen normally', (tester) async {
    await pump(tester);
    await createMessage(tester);
    expect(find.text('Message scheduled'), findsOneWidget);

    // Appears immediately in Waiting Messages with recipient, title,
    // scheduled date/time, and state.
    await tapSeeAll(tester, HomeScreen, 'Waiting Messages');
    expect(find.byType(WaitingMessagesScreen), findsOneWidget);
    expect(inCard('Waiting message'.toUpperCase()), findsOneWidget);
    expect(inCard(title), findsOneWidget);
    expect(inCard('To Noor'), findsOneWidget);
    expect(inCard('Opens Tue, Oct 6'), findsOneWidget);
    expect(inCard('Waiting'), findsWidgets);

    final me = await pumpUntilDone(tester, deps.createService.currentUser());
    final stored = (await pumpUntilDone(
      tester,
      deps.lettersService.waitingMessages(me.id),
    )).single;
    expect(stored.kind, LetterKind.message);
    expect(stored.recipient.displayName, 'Noor Hassan');
    expect(stored.imageUrls, ['/tmp/waiting-message.jpg']);
    expect(stored.openAt, DateTime(2026, 10, 6, 9));
    expect(stored.createdAt, DateTime(2026, 10, 5, 9));
    expect(stored.toMap()['status'], 'scheduled');

    // LOCKED: content hidden; can't open early.
    expect(find.text(body, skipOffstage: false), findsNothing);
    await tester.tap(find.text(title));
    await tester.pump();
    expect(find.byType(LetterScreen), findsNothing);
    expect(find.textContaining('This message opens'), findsOneWidget);
    await settleTimers(tester);

    // Scheduled time reached → READY, without reloading.
    clock.advance(const Duration(days: 1, seconds: 1));
    await tester.pump(const Duration(days: 1, seconds: 1));
    await tester.pump(const Duration(milliseconds: 400));
    expect(inCard('Ready to open'), findsWidgets);

    // FIRST OPEN: reveal; image first; saved only when it completes.
    await tester.tap(find.text(title));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(
      tester.widget<LetterScreen>(find.byType(LetterScreen)).reveal,
      isTrue,
    );
    final imageFade = tester.widget<FadeTransition>(
      find
          .ancestor(
            of: find.descendant(
              of: find.byType(LetterScreen),
              matching: find.byType(MediaImage),
            ),
            matching: find.byType(FadeTransition),
          )
          .first,
    );
    await tester.pump(const Duration(milliseconds: 500));
    expect(imageFade.opacity.value, greaterThan(0.9)); // image already in
    expect((await deps.lettersService.getLetter(stored.id))!.openedAt, isNull);
    await tester.pumpAndSettle();

    // OPENED: saved with the first-opened date/time.
    final opened = (await deps.lettersService.getLetter(stored.id))!;
    expect(opened.openedAt, clock.now());
    expect(opened.toMap()['status'], 'opened');
    expect(find.text(body), findsOneWidget);
    expect(find.textContaining('First opened'), findsOneWidget);

    // Close → card shows Opened.
    await tapBack(tester);
    expect(inCard('Opened'), findsWidgets);

    // REOPEN normally (no special animation).
    await tester.tap(find.text(title));
    await tester.pumpAndSettle();
    expect(
      tester.widget<LetterScreen>(find.byType(LetterScreen)).reveal,
      isFalse,
    );
    expect(
      (await deps.lettersService.getLetter(stored.id))!.openedAt,
      opened.openedAt,
    );
    await tapBack(tester);
    await settleTimers(tester);
  });

  testWidgets('rejects an opening time in the past', (tester) async {
    await pump(tester);
    await tapIn(tester, HomeScreen, 'Create Message');
    await tester.tap(find.text('Choose recipient'));
    await settle(tester);
    await tester.tap(find.text('Future you'));
    await settle(tester);
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), title);
    await tester.enterText(fields.at(1), body);

    // The form stays open past the chosen time (tomorrow 9:00 AM).
    clock.advance(const Duration(days: 2));
    await tapPrimary(tester, 'Schedule message');
    expect(find.byType(CreateMessageScreen), findsOneWidget);
    expect(
      find.text('Choose a time in the future.', skipOffstage: false),
      findsOneWidget,
    );
  });

  testWidgets('Arabic: title and ready status', (tester) async {
    await pump(tester);
    await pumpUntilDone(tester, deps.settings.setLanguage(AppLanguage.arabic));
    await settle(tester);
    final me = await pumpUntilDone(tester, deps.createService.currentUser());
    final f = deps.createService.scheduleLetter(
      kind: LetterKind.message,
      recipient: me,
      title: title,
      body: body,
      openAt: clock.now().add(const Duration(minutes: 1)),
    );
    await pumpUntilDone(tester, f);
    await tapSeeAll(
      tester,
      HomeScreen,
      'رسائل في الانتظار',
      seeAll: 'عرض الكل',
    );
    expect(inCard('في الانتظار'), findsWidgets); // locked status
    await tester.tap(find.byTooltip('رجوع').last); // Arabic "Back"
    await settle(tester);
    clock.advance(const Duration(minutes: 2));
    await tester.pump(const Duration(minutes: 2));
    await settle(tester);

    await tapSeeAll(
      tester,
      HomeScreen,
      'رسائل في الانتظار',
      seeAll: 'عرض الكل',
    );
    expect(find.byType(WaitingMessagesScreen), findsOneWidget);
    expect(find.text('رسائل في الانتظار'), findsWidgets);
    expect(find.text('إنشاء رسالة'), findsWidgets);
    expect(inCard('جاهزة للفتح'), findsWidgets);
    expect(inCard('إلى نفسك في المستقبل'), findsOneWidget);
  });
}
