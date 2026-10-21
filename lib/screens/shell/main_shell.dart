import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/l10n.dart';
import '../../widgets/common/app_bottom_nav.dart';
import '../add/add_screen.dart';
import '../chat/chat_list_screen.dart';
import '../home/home_screen.dart';
import '../memories/memories_screen.dart';
import '../profile/profile_screen.dart';
import 'main_tab_controller.dart';

/// Top-level scaffold hosting the five main tabs. Tabs have no back
/// button; secondary screens are pushed above this shell.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final _tabs = MainTabController();

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainTabScope(controller: _tabs, child: const _ShellBody());
  }
}

class _ShellBody extends StatelessWidget {
  const _ShellBody();

  static Widget _pageFor(MainTab tab) => switch (tab) {
    MainTab.home => const HomeScreen(),
    MainTab.memories => const MemoriesScreen(),
    MainTab.add => const AddScreen(),
    MainTab.chat => const ChatListScreen(),
    MainTab.profile => const ProfileScreen(),
  };

  static AppNavItem _itemFor(MainTab tab, AppLocalizations l) => switch (tab) {
    MainTab.home => AppNavItem(
      label: l.navHome,
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    MainTab.memories => AppNavItem(
      label: l.navMemories,
      icon: Icons.photo_library_outlined,
      activeIcon: Icons.photo_library_rounded,
    ),
    MainTab.add => AppNavItem(
      label: l.navAdd,
      icon: Icons.add_rounded,
      activeIcon: Icons.add_rounded,
      isPrimaryAction: true,
    ),
    MainTab.chat => AppNavItem(
      label: l.navChat,
      icon: Icons.chat_bubble_outline_rounded,
      activeIcon: Icons.chat_bubble_rounded,
    ),
    MainTab.profile => AppNavItem(
      label: l.navProfile,
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
    ),
  };

  @override
  Widget build(BuildContext context) {
    // Rebuilds whenever the selected tab changes.
    final tabs = MainTabScope.of(context);
    final selected = tabs.value;

    return Scaffold(
      // Lets content scroll behind the floating navigation bar.
      extendBody: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          for (final tab in MainTab.values)
            TabPage(
              key: ValueKey(tab),
              active: tab == selected,
              child: _pageFor(tab),
            ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        items: [for (final tab in MainTab.values) _itemFor(tab, context.l10n)],
        currentIndex: selected.index,
        onTap: (i) {
          final tab = MainTab.values[i];
          if (tab == selected) return;
          HapticFeedback.selectionClick();
          tabs.select(tab);
        },
      ),
    );
  }
}

/// Keeps a tab alive (like IndexedStack) and cross-fades it in or out.
///
/// The fade sits *outside* [TickerMode]: muting tickers on a hidden tab
/// must not freeze its own fade-out, or the old tab stays painted on top.
@visibleForTesting
class TabPage extends StatelessWidget {
  const TabPage({super.key, required this.active, required this.child});

  final bool active;
  final Widget child;

  static const _duration = Duration(milliseconds: 260);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: active ? 1 : 0,
      duration: _duration,
      curve: Curves.easeOut,
      child: AnimatedSlide(
        offset: active ? Offset.zero : const Offset(0, 0.015),
        duration: _duration,
        curve: Curves.easeOutCubic,
        child: IgnorePointer(
          ignoring: !active,
          // Hidden tabs are invisible to VoiceOver too.
          child: ExcludeSemantics(
            excluding: !active,
            // Pause the hidden tab's own animations (spinners, etc.).
            child: TickerMode(enabled: active, child: child),
          ),
        ),
      ),
    );
  }
}
