import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../l10n/l10n.dart';
import 'auth_gate.dart';
import 'dependencies.dart';

class MemoriesApp extends StatelessWidget {
  const MemoriesApp({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      dependencies: dependencies,
      // Rebuilds with the new locale (and text direction) when the
      // language changes in Settings.
      child: ListenableBuilder(
        listenable: dependencies.settings,
        builder: (context, _) {
          final locale = dependencies.settings.locale;
          return MaterialApp(
            onGenerateTitle: (context) => context.l10n.appName,
            debugShowCheckedModeBanner: false,
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            theme: AppTheme.light(locale),
            themeMode: ThemeMode.light,
            home: const AuthGate(),
          );
        },
      ),
    );
  }
}
