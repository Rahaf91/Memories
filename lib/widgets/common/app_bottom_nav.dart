import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'pressable.dart';

class AppNavItem {
  const AppNavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    this.isPrimaryAction = false,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;

  /// Rendered as a filled accent button (used for "Add").
  final bool isPrimaryAction;
}

/// Floating bottom navigation. The active tab expands into a soft pill
/// showing its label.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  static const double barHeight = 64;

  final List<AppNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    // viewPadding is the device's fixed home-indicator area. Unlike
    // `padding`, it doesn't shrink while the keyboard animates, so the bar
    // stays put. The bar dips 6pt into that area, but never below a small
    // margin: negative padding crashes the layout.
    final safeBottom = MediaQuery.viewPaddingOf(context).bottom;
    final bottomGap = safeBottom > 0
        ? math.max(safeBottom - 6, AppSpacing.sm)
        : AppSpacing.lg;
    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, bottomGap),
      child: Container(
        height: barHeight,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 30,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var i = 0; i < items.length; i++)
              items[i].isPrimaryAction
                  ? _PrimaryButton(
                      item: items[i],
                      selected: i == currentIndex,
                      onTap: () => onTap(i),
                    )
                  : _flexIfSelected(
                      i == currentIndex,
                      _NavTab(
                        item: items[i],
                        selected: i == currentIndex,
                        onTap: () => onTap(i),
                      ),
                    ),
          ],
        ),
      ),
    );
  }
}

/// Only the active tab may shrink (truncating its label) on narrow screens
/// or large text sizes; inactive tabs are icon-only and keep their size.
Widget _flexIfSelected(bool selected, Widget child) =>
    selected ? Flexible(child: child) : child;

class _NavTab extends StatelessWidget {
  const _NavTab({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final AppNavItem item;
  final bool selected;
  final VoidCallback onTap;

  static const _duration = Duration(milliseconds: 260);

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.accentDeep : AppColors.textTertiary;
    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      excludeSemantics: true,
      child: Pressable(
        onTap: onTap,
        pressedScale: 0.92,
        child: AnimatedContainer(
          duration: _duration,
          curve: Curves.easeOutCubic,
          height: 44,
          padding: EdgeInsets.symmetric(
            horizontal: selected ? AppSpacing.lg : AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: selected ? AppColors.accentSoft : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: _duration,
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: Icon(
                  selected ? item.activeIcon : item.icon,
                  key: ValueKey(selected),
                  color: color,
                  size: 22,
                ),
              ),
              Flexible(
                child: AnimatedSize(
                  duration: _duration,
                  curve: Curves.easeOutCubic,
                  child: selected
                      ? Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: AppSpacing.sm,
                          ),
                          child: Text(
                            item.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: color,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final AppNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: item.label,
      excludeSemantics: true,
      selected: selected,
      child: Pressable(
        onTap: onTap,
        pressedScale: 0.9,
        // Active state: a soft lavender halo and a deeper plum fill.
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.all(selected ? 4 : 0),
          decoration: BoxDecoration(
            color: selected ? AppColors.accentSoft : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            width: selected ? 44 : 48,
            height: selected ? 44 : 48,
            decoration: BoxDecoration(
              color: selected ? AppColors.accentDeep : AppColors.accent,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(item.icon, color: AppColors.onAccent, size: 24),
          ),
        ),
      ),
    );
  }
}
