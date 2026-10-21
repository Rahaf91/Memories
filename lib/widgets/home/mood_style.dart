import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/mood.dart';

/// Colors for a [Mood]. Kept out of the model on purpose: models stay
/// UI-free so they can be shared with backend code.
extension MoodStyle on Mood {
  /// Muted tone used for rings, tints, and glows.
  Color get color => switch (this) {
    Mood.amazing => AppColors.moodAmazing,
    Mood.good => AppColors.moodGood,
    Mood.okay => AppColors.moodOkay,
    Mood.sad => AppColors.moodSad,
    Mood.veryBad => AppColors.moodVeryBad,
  };

  /// Darker shade of [color] for strokes, so faces stay legible.
  Color get deepColor => Color.lerp(color, AppColors.textPrimary, 0.32)!;

  /// Soft tint of [color] for selected backgrounds.
  Color get tint =>
      Color.alphaBlend(color.withValues(alpha: 0.18), AppColors.surface);
}
