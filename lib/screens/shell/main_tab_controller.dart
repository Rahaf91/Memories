import 'package:flutter/widgets.dart';

/// The five main tabs, in bottom-navigation order.
enum MainTab { home, memories, add, chat, profile }

/// The single source of truth for which main tab is selected. Both the
/// bottom navigation bar and the visible screen read from it.
class MainTabController extends ValueNotifier<MainTab> {
  MainTabController([super.value = MainTab.home]);

  void select(MainTab tab) => value = tab;
}

/// Provides the [MainTabController] to the shell (and to any screen that
/// needs to switch tabs). Dependents rebuild when the tab changes.
class MainTabScope extends InheritedNotifier<MainTabController> {
  const MainTabScope({
    super.key,
    required MainTabController controller,
    required super.child,
  }) : super(notifier: controller);

  static MainTabController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<MainTabScope>();
    assert(scope != null, 'MainTabScope not found in widget tree');
    return scope!.notifier!;
  }

  /// The controller without subscribing to changes (for callbacks), or
  /// null outside the main shell.
  static MainTabController? maybeRead(BuildContext context) =>
      context.getInheritedWidgetOfExactType<MainTabScope>()?.notifier;
}
