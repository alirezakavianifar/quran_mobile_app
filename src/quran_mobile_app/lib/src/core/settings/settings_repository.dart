import 'package:shared_preferences/shared_preferences.dart';
import 'models/user_settings.dart';

class SettingsRepository {
  static const String _settingsKey = 'user_settings';

  Future<UserSettings> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_settingsKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        return UserSettings.fromJson(jsonString);
      }
    } catch (_) {
      // Fallback to default settings if reading fails
    }
    return const UserSettings();
  }

  Future<void> saveSettings(UserSettings settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_settingsKey, settings.toJson());
    } catch (_) {}
  }
}
