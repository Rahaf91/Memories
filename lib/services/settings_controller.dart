import 'package:flutter/widgets.dart';

import '../data/repositories/settings_repository.dart';
import '../models/app_language.dart';

/// App-wide settings the UI reacts to (currently the language).
class SettingsController extends ChangeNotifier {
  SettingsController(this._repository);

  final SettingsRepository _repository;

  AppLanguage _language = AppLanguage.english;
  AppLanguage get language => _language;
  Locale get locale => Locale(_language.code);

  Future<void> load() async {
    _language = AppLanguage.fromCode(await _repository.getLanguageCode());
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage language) async {
    if (language == _language) return;
    _language = language;
    notifyListeners();
    await _repository.setLanguageCode(language.code);
  }
}
