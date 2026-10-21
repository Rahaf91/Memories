import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/date_format.dart';
import '../../l10n/l10n.dart';
import '../../models/memory_summary.dart';
import '../common/app_card.dart';
import '../common/media_image.dart';
import '../common/overline_text.dart';

/// Compact "This Month" card: two stats and a small 2×2 media collage.
class MonthSummaryCard extends StatelessWidget {
  const MonthSummaryCard({super.key, required this.summary, this.onTap});

  final MemorySummary summary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AppCard(
      onTap: onTap,
      elevated: true,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OverlineText(l.thisMonth(monthName(l, summary.month.month))),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    _Stat(
                      value: summary.memoryCount,
                      label: l.statMemories(summary.memoryCount),
                    ),
                    Container(
                      width: 1,
                      height: 36,
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      color: AppColors.border,
                    ),
                    _Stat(
                      value: summary.peopleCount,
                      label: l.statPeople(summary.peopleCount),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          _MiniCollage(urls: summary.previewImageUrls),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$value',
          style: AppTypography.of(context).cardTitle.copyWith(fontSize: 34),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium
              ?.copyWith(color: AppColors.textTertiary),
        ),
      ],
    );
  }
}

class _MiniCollage extends StatelessWidget {
  const _MiniCollage({required this.urls});

  final List<String> urls;

  static const double _size = 92;
  static const double _gap = 3;

  @override
  Widget build(BuildContext context) {
    String? at(int i) => i < urls.length ? urls[i] : null;
    const tile = (_size - _gap) / 2;

    Widget cell(int i) => MediaImage(
      source: at(i),
      width: tile,
      height: tile,
      showPlaceholderIcon: false,
      borderRadius: BorderRadius.circular(6),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: SizedBox(
        width: _size,
        height: _size,
        child: Column(
          children: [
            Row(
              children: [
                cell(0),
                const SizedBox(width: _gap),
                cell(1),
              ],
            ),
            const SizedBox(height: _gap),
            Row(
              children: [
                cell(2),
                const SizedBox(width: _gap),
                cell(3),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
