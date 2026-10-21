import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../common/primary_button.dart';

/// Shared layout for create flows: back chevron (and swipe-back), title,
/// scrolling fields, and a primary action that rises with the keyboard.
class FormScreenScaffold extends StatelessWidget {
  const FormScreenScaffold({
    super.key,
    required this.title,
    required this.formKey,
    required this.fields,
    required this.primaryLabel,
    required this.onPrimary,
    this.subtitle,
    this.primaryIcon,
    this.busy = false,
  });

  final String title;
  final String? subtitle;
  final GlobalKey<FormState> formKey;
  final List<Widget> fields;
  final String primaryLabel;
  final IconData? primaryIcon;

  /// Null disables the primary button.
  final VoidCallback? onPrimary;
  final bool busy;

  /// Vertical space between fields.
  static const double fieldGap = AppSpacing.xl;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        // Default leading = BackButton (themed as an iOS chevron).
        appBar: AppBar(),
        // The action bar lives in the body (not bottomNavigationBar) so it
        // rises with the keyboard.
        body: Column(
          children: [
            Expanded(
              child: Form(
                key: formKey,
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    AppSpacing.sm,
                    AppSpacing.screenPadding,
                    AppSpacing.xxl,
                  ),
                  children: [
                    Text(
                      title,
                      style: AppTypography.of(context).displayTitle
                          .copyWith(fontSize: 38),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        subtitle!,
                        style: textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xxl),
                    for (var i = 0; i < fields.length; i++) ...[
                      if (i > 0) const SizedBox(height: fieldGap),
                      fields[i],
                    ],
                  ],
                ),
              ),
            ),
            DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.background,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                    vertical: AppSpacing.md,
                  ),
                  child: PrimaryButton(
                    label: primaryLabel,
                    icon: primaryIcon,
                    busy: busy,
                    onPressed: onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
