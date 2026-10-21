import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/l10n.dart';

/// Label shown above a form field, with an optional "Optional" tag.
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key, this.optional = false});

  final String text;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelLarge;
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        bottom: AppSpacing.sm,
        start: 2,
      ),
      // Wraps instead of overflowing with long labels or large text sizes.
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: text,
              style: style?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (optional)
              TextSpan(
                text: '   ${context.l10n.optional}',
                style: style?.copyWith(color: AppColors.textTertiary),
              ),
          ],
        ),
      ),
    );
  }
}

/// Error line under custom (non-TextField) form fields.
class FieldError extends StatelessWidget {
  const FieldError(this.text, {super.key});

  final String? text;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 180),
      alignment: AlignmentDirectional.topStart,
      child: text == null
          ? const SizedBox(width: double.infinity)
          : Padding(
              padding: const EdgeInsetsDirectional.only(
                top: 6,
                start: AppSpacing.lg,
              ),
              child: Text(
                text!,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: AppColors.error),
              ),
            ),
    );
  }
}

/// Shared box styling for tappable, input-like fields (date, people).
BoxDecoration fieldBoxDecoration({bool hasError = false}) => BoxDecoration(
  color: AppColors.surface,
  borderRadius: BorderRadius.circular(AppRadius.md),
  border: Border.all(color: hasError ? AppColors.error : AppColors.border),
);
