/// Device-level preferences (language, …).
abstract interface class SettingsRepository {
  /// Saved language code, or null to use the default (English).
  Future<String?> getLanguageCode();

  Future<void> setLanguageCode(String code);
}
