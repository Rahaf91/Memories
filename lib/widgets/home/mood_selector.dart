import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/l10n.dart';
import '../../models/mood.dart';
import '../common/mood_face.dart';
import 'mood_style.dart';

/// Five circular mood faces. Unselected faces are white with a thin
/// outline; only the selected one takes on its muted color.
///
/// Stateless: the parent owns the selection. Used on Home and in the
/// Mood Check-in flow.
class MoodSelector extends StatelessWidget {
  const MoodSelector({
    super.key,
    required this.selected,
    required this.onSelected,
    this.moods = Mood.values,
    this.size = 54,
  });

  final Mood? selected;
  final ValueChanged<Mood> onSelected;
  final List<Mood> moods;

  /// Diameter of each face button.
  final double size;

  @override
  Widget build(BuildContext context) {
    // Each face gets an equal share of the width, so the row never
    // overflows on narrow screens.
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final mood in moods)
          Expanded(
            child: MoodOption(
              mood: mood,
              size: size,
              selected: mood == selected,
              onTap: () {
                HapticFeedback.selectionClick();
                onSelected(mood);
              },
            ),
          ),
      ],
    );
  }
}

/// A single mood face button with its label.
class MoodOption extends StatelessWidget {
  const MoodOption({
    super.key,
    required this.mood,
    required this.selected,
    required this.onTap,
    this.size = 54,
  });

  static const _duration = Duration(milliseconds: 320);

  final Mood mood;
  final bool selected;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: context.l10n.mood(mood),
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              AnimatedScale(
                scale: selected ? 1.08 : 1,
                duration: _duration,
                curve: Curves.easeOutBack,
                child: AnimatedContainer(
                  duration: _duration,
                  curve: Curves.easeOutCubic,
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? mood.tint : AppColors.surface,
                    border: Border.all(
                      color: selected
                          ? mood.color.withValues(alpha: 0.7)
                          : AppColors.border,
                      width: selected ? 1.5 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: mood.color.withValues(
                          alpha: selected ? 0.38 : 0,
                        ),
                        blurRadius: selected ? 18 : 0,
                        spreadRadius: selected ? 1 : 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: TweenAnimationBuilder<Color?>(
                      tween: ColorTween(
                        end: selected
                            ? mood.deepColor
                            : AppColors.textSecondary,
                      ),
                      duration: _duration,
                      builder: (_, color, _) => MoodFace(
                        mood: mood,
                        color: color ?? AppColors.textSecondary,
                        size: size * 0.62,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              AnimatedDefaultTextStyle(
                duration: _duration,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: selected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
                child: Text(
                  context.l10n.mood(mood),
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
