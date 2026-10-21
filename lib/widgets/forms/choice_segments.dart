import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'field_label.dart';

/// Labeled single-choice control rendered as a row of soft segments,
/// with an explanation of the current choice underneath.
class ChoiceSegments<T> extends StatelessWidget {
  const ChoiceSegments({
    super.key,
    required this.label,
    required this.options,
    required this.selected,
    required this.onChanged,
    required this.labelOf,
    this.iconOf,
    this.descriptionOf,
  });

  final String label;
  final List<T> options;
  final T selected;
  final ValueChanged<T> onChanged;
  final String Function(T) labelOf;
  final IconData Function(T)? iconOf;
  final String Function(T)? descriptionOf;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            children: [
              for (final option in options)
                Expanded(
                  child: Semantics(
                    button: true,
                    selected: option == selected,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (option == selected) return;
                        HapticFeedback.selectionClick();
                        onChanged(option);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                          horizontal: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: option == selected
                              ? AppColors.surface
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          boxShadow: option == selected
                              ? const [
                                  BoxShadow(
                                    color: AppColors.shadow,
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Column(
                          children: [
                            if (iconOf != null) ...[
                              Icon(
                                iconOf!(option),
                                size: 20,
                                color: option == selected
                                    ? AppColors.accent
                                    : AppColors.textTertiary,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                            ],
                            Text(
                              labelOf(option),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.labelMedium?.copyWith(
                                color: option == selected
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                                fontWeight: option == selected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (descriptionOf != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(
              top: AppSpacing.sm,
              start: 2,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                descriptionOf!(selected),
                key: ValueKey(selected),
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
