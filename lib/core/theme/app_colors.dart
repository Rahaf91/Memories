import 'package:flutter/material.dart';

/// Central color palette. Change colors here, never inside widgets.
abstract final class AppColors {
  // Surfaces
  static const background = Color(0xFFF7F4EF); // warm off-white
  static const surface = Color(0xFFFFFDFA);
  static const surfaceMuted = Color(0xFFF0ECE5);
  static const beige = Color(0xFFEFE6DA);
  static const stone = Color(0xFFD9D2C7);
  static const border = Color(0xFFE6E0D7);

  // Text
  static const textPrimary = Color(0xFF1F1C1A); // charcoal
  static const textSecondary = Color(0xFF6E6862);
  static const textTertiary = Color(0xFFA19A92);

  // Accent (muted plum / lavender)
  static const accent = Color(0xFF6E5E8F);
  static const accentDeep = Color(0xFF4E4168);
  static const accentSoft = Color(0xFFECE7F3);
  static const lavenderMist = Color(0xFFEDE7F1);
  static const onAccent = Color(0xFFFFFFFF);

  // Mood tones: muted, never saturated. Only shown for a selected/recorded
  // mood; unselected faces stay monochrome.
  static const moodAmazing = Color(0xFFC6A052); // muted gold
  static const moodGood = Color(0xFF7FA084); // muted green
  static const moodOkay = Color(0xFFA9A39B); // soft gray
  static const moodSad = Color(0xFF7D97B5); // muted blue
  static const moodVeryBad = Color(0xFFB66F66); // muted red

  // Presence
  static const online = Color(0xFF6F9E84);

  // Chat bubbles
  static const bubbleReceived = Color(0xFFEFEBE5); // soft neutral gray
  static const bubbleSent = accent;

  // Overlays
  static const scrim = Color(0x8C1F1C1A);
  static const shadow = Color(0x141F1C1A);

  // Feedback
  static const error = Color(0xFFB4534B);
}

/// Soft background treatments. Kept subtle on purpose.
abstract final class AppGradients {
  static const hero = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.lavenderMist, AppColors.beige, AppColors.background],
    stops: [0.0, 0.55, 1.0],
  );

  static const featured = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF1E9DE), Color(0xFFE9E2EF)],
  );

  /// Darkens the bottom of photos so overlaid text stays legible.
  static const photoScrim = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x001F1C1A), Color(0x991F1C1A)],
    stops: [0.45, 1.0],
  );
}
