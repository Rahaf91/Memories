import '../repositories/settings_repository.dart';

/// Keeps settings for the current app session only. Swap for a
/// shared_preferences- or backend-backed implementation to persist them.
class InMemorySettingsRepository implements SettingsRepository {
  String? _languageCode;

  @override
  Future<String?> getLanguageCode() async => _languageCode;

  @override
  Future<void> setLanguageCode(String code) async => _languageCode = code;
}
