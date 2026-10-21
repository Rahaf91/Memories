import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';

abstract final class AppTheme {
  /// Light theme for [locale]. Arabic drops negative letter-spacing, which
  /// would break its connected script.
  static ThemeData light(Locale locale) {
    final arabic = locale.languageCode == 'ar';
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.accent,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.accent,
          onPrimary: AppColors.onAccent,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
          error: AppColors.error,
        );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      splashFactory: InkSparkle.splashFactory,
    );

    return base.copyWith(
      textTheme: _textTheme(base.textTheme, arabic: arabic),
      // iOS-style push transitions with swipe-back on every platform.
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      // Every automatic back button is an iOS chevron (mirrors in RTL).
      actionIconTheme: ActionIconThemeData(
        backButtonIconBuilder: (_) =>
            const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: AppColors.textPrimary,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimary, size: 22),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: const TextStyle(color: AppColors.textTertiary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: 14,
        ),
        border: _inputBorder(AppColors.border),
        enabledBorder: _inputBorder(AppColors.border),
        focusedBorder: _inputBorder(AppColors.accent, width: 1.4),
        errorBorder: _inputBorder(AppColors.error),
        focusedErrorBorder: _inputBorder(AppColors.error, width: 1.4),
        errorStyle: const TextStyle(color: AppColors.error),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.accent,
        selectionColor: AppColors.accent.withValues(alpha: 0.25),
        selectionHandleColor: AppColors.accent,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: const TextStyle(color: AppColors.background),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide(color: color, width: width),
      );

  static TextTheme _textTheme(TextTheme base, {required bool arabic}) {
    double? tracking(double latin) => arabic ? 0 : latin;
    return base
        .copyWith(
          headlineMedium: base.headlineMedium?.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            letterSpacing: tracking(-0.6),
          ),
          titleLarge: base.titleLarge?.copyWith(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            letterSpacing: tracking(-0.3),
          ),
          titleMedium: base.titleMedium?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: tracking(-0.2),
          ),
          bodyLarge: base.bodyLarge?.copyWith(
            fontSize: 16,
            height: 1.4,
            letterSpacing: tracking(0.15),
          ),
          bodyMedium: base.bodyMedium?.copyWith(
            fontSize: 14,
            height: 1.4,
            color: AppColors.textSecondary,
            letterSpacing: tracking(0.25),
          ),
          bodySmall: base.bodySmall?.copyWith(letterSpacing: tracking(0.4)),
          labelLarge: base.labelLarge?.copyWith(letterSpacing: tracking(0.1)),
          labelMedium: base.labelMedium?.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: tracking(0.1),
          ),
          labelSmall: base.labelSmall?.copyWith(letterSpacing: tracking(0.5)),
        )
        .apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        );
  }
}
