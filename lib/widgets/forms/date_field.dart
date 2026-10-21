import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/date_format.dart';
import '../../l10n/l10n.dart';
import 'field_label.dart';

/// What a [DateField] picks.
enum DateFieldMode { date, time, dateAndTime }

/// Labeled date/time input that opens an iOS-style wheel picker in a
/// sheet.
class DateField extends StatelessWidget {
  const DateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.minimumDate,
    this.maximumDate,
    this.helper,
    this.errorText,
    this.includeTime = false,
    this.mode,
  });

  final String label;
  final DateTime value;
  final ValueChanged<DateTime> onChanged;
  final DateTime? minimumDate;
  final DateTime? maximumDate;

  /// Short hint shown on the right, e.g. "in 7 days".
  final String? helper;
  final String? errorText;

  /// Also pick a time of day (e.g. when a letter unlocks).
  final bool includeTime;

  /// Explicit mode; overrides [includeTime].
  final DateFieldMode? mode;

  DateFieldMode get _mode =>
      mode ?? (includeTime ? DateFieldMode.dateAndTime : DateFieldMode.date);

  Future<void> _pick(BuildContext context) async {
    var picked = value;
    final result = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: AppColors.background,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            0,
            AppSpacing.screenPadding,
            AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(label, style: Theme.of(context).textTheme.titleLarge),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(sheetContext).pop(picked),
                    child: Text(context.l10n.done),
                  ),
                ],
              ),
              SizedBox(
                height: 216,
                child: CupertinoDatePicker(
                  mode: switch (_mode) {
                    DateFieldMode.date => CupertinoDatePickerMode.date,
                    DateFieldMode.time => CupertinoDatePickerMode.time,
                    DateFieldMode.dateAndTime =>
                      CupertinoDatePickerMode.dateAndTime,
                  },
                  initialDateTime: value,
                  minimumDate: minimumDate,
                  maximumDate: maximumDate,
                  onDateTimeChanged: (d) => picked = d,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (result != null) onChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label),
        Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.md),
            onTap: () => _pick(context),
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              decoration: fieldBoxDecoration(hasError: errorText != null),
              child: Row(
                children: [
                  Icon(
                    _mode == DateFieldMode.time
                        ? Icons.schedule_rounded
                        : Icons.calendar_today_outlined,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(switch (_mode) {
                      DateFieldMode.date => formatFullDate(context.l10n, value),
                      DateFieldMode.time => formatTime(context.l10n, value),
                      DateFieldMode.dateAndTime => formatDateTime(
                        context.l10n,
                        value,
                      ),
                    }, style: textTheme.bodyLarge),
                  ),
                  if (helper != null)
                    Text(
                      helper!,
                      style: textTheme.labelMedium?.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        FieldError(errorText),
      ],
    );
  }
}
