import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/l10n.dart';
import '../../models/memory_filter.dart';
import '../common/pressable.dart';

/// Filters shown as chips. (Capsules were replaced by Waiting Messages,
/// so memories can no longer belong to one.)
const _filters = [MemoryFilter.all, MemoryFilter.friends, MemoryFilter.shared];

/// Horizontal row of pill filters.
class MemoryFilterChips extends StatelessWidget {
  const MemoryFilterChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final MemoryFilter selected;
  final ValueChanged<MemoryFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        itemCount: _filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, i) {
          final filter = _filters[i];
          final isSelected = filter == selected;
          return Semantics(
            button: true,
            selected: isSelected,
            child: Pressable(
              onTap: () {
                if (isSelected) return;
                HapticFeedback.selectionClick();
                onSelected(filter);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.textPrimary : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.textPrimary
                        : AppColors.border,
                  ),
                ),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 220),
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: isSelected
                        ? AppColors.background
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                  child: Text(context.l10n.memoryFilter(filter)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
