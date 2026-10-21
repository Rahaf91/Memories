import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memories/screens/add/add_screen.dart';
import 'package:memories/screens/chat/chat_list_screen.dart';
import 'package:memories/screens/home/home_screen.dart';
import 'package:memories/screens/memories/memories_screen.dart';
import 'package:memories/screens/profile/profile_screen.dart';
import 'package:memories/screens/shell/main_shell.dart';

import 'test_helpers.dart';

/// Regression test: switching tabs must change what's on screen, not just
/// the highlighted icon (a hidden tab used to stay painted on top).
void main() {
  const screens = <String, Type>{
    'Home': HomeScreen,
    'Memories': MemoriesScreen,
    'Add': AddScreen,
    'Chat': ChatListScreen,
    'Profile': ProfileScreen,
  };

  /// A heading that only the given tab shows.
  const headings = <String, String>{
    'Home': 'Friends Today',
    'Memories': 'Everything you\'ve kept, together.',
    'Add': 'What do you want to save or share?',
    'Chat': 'Stay close to your people.',
    'Profile': 'Settings',
  };

  /// Opacity actually painted for the tab hosting [screen]: the fade owned
  /// by its [TabPage] (the first animated-opacity render object under it).
  double paintedOpacity(WidgetTester tester, Type screen) {
    final page = find
        .ancestor(
          of: find.byType(screen, skipOffstage: false),
          matching: find.byType(TabPage, skipOffstage: false),
        )
        .evaluate()
        .single;
    RenderObject? render = page.renderObject;
    while (render != null && render is! RenderAnimatedOpacity) {
      render = render is RenderObjectWithChildMixin ? render.child : null;
    }
    return (render! as RenderAnimatedOpacity).opacity.value;
  }

  testWidgets('Profile → Home → Memories → Add → Chat → Profile (×3)', (
    tester,
  ) async {
    await pumpApp(tester);
    const cycle = ['Profile', 'Home', 'Memories', 'Add', 'Chat'];

    for (var round = 0; round < 3; round++) {
      for (final tab in [...cycle, 'Profile']) {
        await openTab(tester, tab);

        for (final entry in screens.entries) {
          final expected = entry.key == tab ? 1.0 : 0.0;
          expect(
            paintedOpacity(tester, entry.value),
            expected,
            reason:
                'round $round: after tapping $tab, ${entry.key} '
                'should be ${expected == 1 ? 'visible' : 'hidden'}',
          );
        }

        // The visible, tappable heading belongs to the selected tab.
        final heading = find.descendant(
          of: find.byType(screens[tab]!),
          matching: find.text(headings[tab]!),
        );
        expect(heading.hitTestable(), findsOneWidget, reason: tab);
      }
    }
  });
}
