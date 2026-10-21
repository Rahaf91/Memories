import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memories/app/app.dart';
import 'package:memories/app/dependencies.dart';

/// Regression: while the keyboard animates, the bottom safe-area inset
/// shrinks through tiny values (34 → 0). The bottom bar once subtracted a
/// fixed amount from it, produced negative padding, and crashed the app
/// (red screen ending in "_dependents.isEmpty").
void main() {
  for (final bottomPoints in [0.0, 1.0, 3.0, 5.9, 6.0, 34.0]) {
    testWidgets('bottom bar builds with a ${bottomPoints}pt bottom inset', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1206, 2622);
      tester.view.devicePixelRatio = 3;
      tester.view.padding = FakeViewPadding(bottom: bottomPoints * 3);
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MemoriesApp(dependencies: AppDependencies.local()),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(ErrorWidget), findsNothing);
    });
  }

  testWidgets('keyboard opening over the shell does not crash', (tester) async {
    tester.view.physicalSize = const Size(1206, 2622);
    tester.view.devicePixelRatio = 3;
    tester.view.padding = const FakeViewPadding(bottom: 34 * 3);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(MemoriesApp(dependencies: AppDependencies.local()));
    await tester.pumpAndSettle();

    // Animate the keyboard up: padding shrinks as insets grow.
    for (var inset = 0.0; inset <= 336; inset += 12) {
      tester.view.viewInsets = FakeViewPadding(bottom: inset * 3);
      await tester.pump(const Duration(milliseconds: 16));
      expect(tester.takeException(), isNull, reason: 'inset $inset');
    }
  });
}
