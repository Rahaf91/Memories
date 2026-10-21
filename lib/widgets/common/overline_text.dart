import 'package:flutter/material.dart';

import '../../core/theme/app_typography.dart';

/// Small section label ("THIS MONTH", "WITH", …). Upper-cases Latin text;
/// Arabic has no case and must not be letter-spaced.
class OverlineText extends StatelessWidget {
  const OverlineText(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final type = AppTypography.of(context);
    return Text(
      type.isArabic ? text : text.toUpperCase(),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: type.overline.copyWith(color: color),
    );
  }
}
