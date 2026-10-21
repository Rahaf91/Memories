import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Display styles. Latin text uses the bundled serif; Arabic uses the
/// system font with no letter-spacing (tracking breaks joined letters).
///
/// Use `AppTypography.of(context)` so styles follow the app language.
class AppTypography {
  const AppTypography._({required this.isArabic});

  static const _latin = AppTypography._(isArabic: false);
  static const _arabic = AppTypography._(isArabic: true);

  static const serifFamily = 'InstrumentSerif';

  static AppTypography of(BuildContext context) =>
      forLanguage(Localizations.localeOf(context).languageCode);

  static AppTypography forLanguage(String languageCode) =>
      languageCode == 'ar' ? _arabic : _latin;

  final bool isArabic;

  TextStyle get displayTitle => isArabic
      ? const TextStyle(
          fontSize: 34,
          height: 1.2,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        )
      : const TextStyle(
          fontFamily: serifFamily,
          fontSize: 44,
          height: 1.0,
          letterSpacing: -0.5,
          color: AppColors.textPrimary,
        );

  TextStyle get featuredQuote => isArabic
      ? const TextStyle(
          fontSize: 22,
          height: 1.45,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        )
      : const TextStyle(
          fontFamily: serifFamily,
          fontStyle: FontStyle.italic,
          fontSize: 26,
          height: 1.15,
          color: AppColors.textPrimary,
        );

  TextStyle get cardTitle => isArabic
      ? const TextStyle(
          fontSize: 20,
          height: 1.35,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        )
      : const TextStyle(
          fontFamily: serifFamily,
          fontSize: 24,
          height: 1.1,
          color: AppColors.textPrimary,
        );

  /// Small section label. Latin is upper-cased and tracked by
  /// [OverlineText]; Arabic stays as-is.
  TextStyle get overline => TextStyle(
    fontSize: isArabic ? 13 : 11,
    fontWeight: FontWeight.w600,
    letterSpacing: isArabic ? 0 : 1.4,
    color: AppColors.textSecondary,
  );
}
