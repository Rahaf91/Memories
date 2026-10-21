import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memories/screens/friends/friends_screen.dart';
import 'package:memories/screens/home/home_screen.dart';
import 'package:memories/screens/profile/profile_screen.dart';
import 'package:memories/screens/settings/settings_screen.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('Settings switches to Arabic (RTL) and back', (tester) async {
    await pumpApp(tester);
    await openTab(tester, 'Profile');

    // Profile → Friends → back.
    await tapIn(tester, ProfileScreen, 'Friends');
    expect(find.byType(FriendsScreen), findsOneWidget);
    await tapBack(tester);
    expect(find.byType(FriendsScreen), findsNothing);

    // Profile → Settings → العربية.
    await tapIn(tester, ProfileScreen, 'Settings');
    expect(find.byType(SettingsScreen), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('العربية'));
    await tester.pumpAndSettle();

    expect(
      Directionality.of(tester.element(find.byType(SettingsScreen))),
      TextDirection.rtl,
    );
    expect(find.text('الإعدادات'), findsOneWidget);
    expect(find.text('اللغة'), findsOneWidget);

    // The back chevron still works in RTL.
    await tester.tap(find.byTooltip('رجوع').last);
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsNothing);
    expect(find.text('الملف الشخصي'), findsWidgets);

    // Home in Arabic.
    await tester.tap(find.byIcon(Icons.home_outlined));
    await settle(tester);
    expect(find.text('أصدقاء اليوم'), findsOneWidget);
    expect(find.text('سعيد'), findsOneWidget); // mood faces, no heading
    expect(find.text('كيف حالك اليوم؟'), findsNothing);
    await tester.scrollUntilVisible(
      find.descendant(
        of: find.byType(HomeScreen),
        matching: find.text('رسائل في الانتظار'),
      ),
      300,
      scrollable: scrollableIn(HomeScreen),
    );
    expect(
      Directionality.of(tester.element(find.byType(HomeScreen))),
      TextDirection.rtl,
    );

    // Back to English.
    await tester.tap(find.byIcon(Icons.person_outline_rounded));
    await settle(tester);
    await tapIn(tester, ProfileScreen, 'الإعدادات');
    await tester.tap(find.bySemanticsLabel('English'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.byType(SettingsScreen))),
      TextDirection.ltr,
    );
  });
}
