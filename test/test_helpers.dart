import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memories/app/app.dart';
import 'package:memories/app/dependencies.dart';
import 'package:memories/widgets/common/app_bottom_nav.dart';
import 'package:memories/widgets/common/section_header.dart';

/// Pumps the app on an iPhone-sized screen with fresh, empty local data.
Future<AppDependencies> pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1206, 2622);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  final deps = AppDependencies.local();
  await tester.pumpWidget(MemoriesApp(dependencies: deps));
  await tester.pumpAndSettle();
  return deps;
}

/// Settles animations and lets simulated network latency (mockDelay)
/// complete. pumpAndSettle alone stops once nothing is animating.
Future<void> settle(WidgetTester tester) async {
  await tester.pumpAndSettle();
  await tester.pump(const Duration(seconds: 1));
  await tester.pumpAndSettle();
}

/// Taps a bottom-navigation tab by its (English) label.
Future<void> openTab(WidgetTester tester, String label) async {
  // Only inside the bar: hidden tabs may still report stale labels to the
  // finder (e.g. the Profile title), even though VoiceOver can't reach them.
  await tester.tap(
    find.descendant(
      of: find.byType(AppBottomNav),
      matching: find.bySemanticsLabel(label),
    ),
  );
  await settle(tester);
}

/// Adds a friend through the service (for tests that need one).
Future<void> addFriend(
  WidgetTester tester,
  AppDependencies deps,
  String name,
) async {
  final future = deps.friendsService.addFriend(name);
  await tester.pump(const Duration(seconds: 1));
  await future;
  await tester.pumpAndSettle();
}

/// Lets snackbar timers run out so no timers are left pending.
Future<void> settleTimers(WidgetTester tester) =>
    tester.pump(const Duration(seconds: 5));

/// Taps the iOS back chevron in the current top bar.
Future<void> tapBack(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Back').last);
  await settle(tester);
}

/// Scrollable of the given screen type (first = main vertical list).
Finder scrollableIn(Type screen) => find
    .descendant(of: find.byType(screen), matching: find.byType(Scrollable))
    .first;

/// Taps the primary (bottom) button of a form screen.
Future<void> tapPrimary(WidgetTester tester, String label) async {
  await tester.tap(find.bySemanticsLabel(label).last);
  await settle(tester);
}

/// Finds [text] inside [screen] (scrolling to build it if needed), brings
/// it into view, and taps it.
Future<void> tapIn(WidgetTester tester, Type screen, String text) async {
  final matches = find.descendant(
    of: find.byType(screen),
    matching: find.text(text),
  );
  if (matches.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      matches,
      300,
      scrollable: scrollableIn(screen),
    );
  }
  final target = matches.last;
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await settle(tester);
}

/// Taps the "See all" action of the section titled [sectionTitle].
Future<void> tapSeeAll(
  WidgetTester tester,
  Type screen,
  String sectionTitle, {
  String seeAll = 'See all',
}) async {
  final title = find.descendant(
    of: find.byType(screen),
    matching: find.text(sectionTitle),
  );
  await tester.scrollUntilVisible(title, 300, scrollable: scrollableIn(screen));
  final action = find.descendant(
    of: find.ancestor(of: title, matching: find.byType(SectionHeader)),
    matching: find.text(seeAll),
  );
  await tester.ensureVisible(action);
  await tester.pumpAndSettle();
  await tester.tap(action);
  await settle(tester);
}

/// Awaits [future] while advancing fake time, so mock latency
/// (Future.delayed) completes inside testWidgets.
Future<T> pumpUntilDone<T>(WidgetTester tester, Future<T> future) async {
  T? result;
  Object? error;
  var done = false;
  future.then(
    (v) {
      result = v;
      done = true;
    },
    onError: (Object e) {
      error = e;
      done = true;
    },
  );
  for (var i = 0; i < 50 && !done; i++) {
    await tester.pump(const Duration(milliseconds: 200));
  }
  if (error != null) throw error!;
  if (!done) throw StateError('Future did not complete');
  return result as T;
}
