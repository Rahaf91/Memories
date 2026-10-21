/// Languages the app supports.
enum AppLanguage {
  english('en', 'English'),
  arabic('ar', 'العربية');

  const AppLanguage(this.code, this.nativeName);

  /// ISO 639-1 code, also stored in settings.
  final String code;

  /// The language's name in that language (shown the same in every locale).
  final String nativeName;

  static AppLanguage fromCode(String? code) => AppLanguage.values.firstWhere(
    (l) => l.code == code,
    orElse: () => AppLanguage.english,
  );
}
