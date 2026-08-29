import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/user_settings.dart';
import 'settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

class SettingsNotifier extends StateNotifier<UserSettings> {
  final SettingsRepository _repository;

  SettingsNotifier(this._repository) : super(const UserSettings()) {
    _init();
  }

  Future<void> _init() async {
    final savedSettings = await _repository.loadSettings();
    state = savedSettings;
  }

  Future<void> updateSettings(UserSettings updated) async {
    state = updated;
    await _repository.saveSettings(updated);
  }

  Future<void> updateArabicFontSize(double size) async {
    updateSettings(state.copyWith(arabicFontSize: size));
  }

  Future<void> updateTranslationFontSize(double size) async {
    updateSettings(state.copyWith(translationFontSize: size));
  }

  Future<void> updateArabicFontFamily(String family) async {
    updateSettings(state.copyWith(arabicFontFamily: family));
  }

  Future<void> updateShowTranslation(bool show) async {
    updateSettings(state.copyWith(showTranslation: show));
  }

  Future<void> updateShowTransliteration(bool show) async {
    updateSettings(state.copyWith(showTransliteration: show));
  }

  Future<void> updateReciter(String reciterId) async {
    updateSettings(state.copyWith(defaultReciterId: reciterId));
  }

  Future<void> updatePlaybackSpeed(double speed) async {
    updateSettings(state.copyWith(playbackSpeed: speed));
  }

  Future<void> updateAutoScrollAudio(bool autoScroll) async {
    updateSettings(state.copyWith(autoScrollAudio: autoScroll));
  }

  Future<void> updateThemeMode(String mode) async {
    updateSettings(state.copyWith(themeMode: mode));
  }

  Future<void> updateAppLanguage(String lang) async {
    updateSettings(state.copyWith(appLanguage: lang));
  }

  Future<void> updateHybridSearch(bool enabled) async {
    updateSettings(state.copyWith(hybridSearchEnabled: enabled));
  }

  Future<void> updateAutoSyncWifiOnly(bool wifiOnly) async {
    updateSettings(state.copyWith(autoSyncWifiOnly: wifiOnly));
  }

  Future<void> updateDefaultVerseTapAction(String action) async {
    updateSettings(state.copyWith(defaultVerseTapAction: action));
  }

  Future<void> updateDefaultTafsirEdition(String editionId) async {
    updateSettings(state.copyWith(defaultTafsirEdition: editionId));
  }

  Future<void> resetToDefaults() async {
    const defaults = UserSettings();
    state = defaults;
    await _repository.saveSettings(defaults);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, UserSettings>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return SettingsNotifier(repository);
});
