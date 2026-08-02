import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran_mobile_app/src/core/settings/models/user_settings.dart';
import 'package:quran_mobile_app/src/core/settings/settings_repository.dart';
import 'package:quran_mobile_app/src/core/settings/settings_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('UserSettings Model Tests', () {
    test('Default UserSettings values should be correctly initialized', () {
      const settings = UserSettings();
      expect(settings.arabicFontFamily, equals('Amiri'));
      expect(settings.arabicFontSize, equals(24.0));
      expect(settings.translationFontSize, equals(16.0));
      expect(settings.showTranslation, isTrue);
      expect(settings.defaultReciterId, equals('parhizgar'));
      expect(settings.playbackSpeed, equals(1.0));
      expect(settings.themeMode, equals('system'));
      expect(settings.appLanguage, equals('fa'));
    });

    test('UserSettings toMap and fromMap conversion works accurately', () {
      const settings = UserSettings(
        arabicFontFamily: 'Scheherazade New',
        arabicFontSize: 30.0,
        translationFontSize: 20.0,
        showTranslation: false,
        defaultReciterId: 'alafasy',
        playbackSpeed: 1.25,
        themeMode: 'dark',
        appLanguage: 'en',
      );

      final map = settings.toMap();
      final restored = UserSettings.fromMap(map);

      expect(restored.arabicFontFamily, equals('Scheherazade New'));
      expect(restored.arabicFontSize, equals(30.0));
      expect(restored.translationFontSize, equals(20.0));
      expect(restored.showTranslation, isFalse);
      expect(restored.defaultReciterId, equals('alafasy'));
      expect(restored.playbackSpeed, equals(1.25));
      expect(restored.themeMode, equals('dark'));
      expect(restored.appLanguage, equals('en'));
    });

    test('UserSettings copyWith updates specific fields correctly', () {
      const initial = UserSettings();
      final updated = initial.copyWith(
        arabicFontSize: 28.0,
        themeMode: 'sepia',
      );

      expect(updated.arabicFontSize, equals(28.0));
      expect(updated.themeMode, equals('sepia'));
      expect(updated.arabicFontFamily, equals(initial.arabicFontFamily));
    });
  });

  group('SettingsRepository & SettingsNotifier Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('SettingsNotifier loads default settings initially and supports updates', () async {
      final repository = SettingsRepository();
      final notifier = SettingsNotifier(repository);
      await Future<void>.delayed(Duration.zero);

      expect(notifier.state.arabicFontSize, equals(24.0));

      await notifier.updateArabicFontSize(28.0);
      expect(notifier.state.arabicFontSize, equals(28.0));

      await notifier.updateThemeMode('sepia');
      expect(notifier.state.themeMode, equals('sepia'));

      await notifier.updateReciter('alafasy');
      expect(notifier.state.defaultReciterId, equals('alafasy'));

      // Test reset functionality
      await notifier.resetToDefaults();
      expect(notifier.state.arabicFontSize, equals(24.0));
      expect(notifier.state.themeMode, equals('system'));
      expect(notifier.state.defaultReciterId, equals('parhizgar'));
    });
  });
}
