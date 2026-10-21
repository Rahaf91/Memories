import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';

/// Temporary feedback for actions whose screens aren't built yet.
/// [feature] should already be localized.
void showComingSoon(BuildContext context, String feature) {
  showAppSnackBar(context, context.l10n.featureComingSoon(feature));
}

/// Short floating confirmation message.
void showAppSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
}
