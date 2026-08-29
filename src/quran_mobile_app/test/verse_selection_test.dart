import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_mobile_app/src/core/settings/models/user_settings.dart';
import 'package:quran_mobile_app/src/core/settings/settings_provider.dart';
import 'package:quran_mobile_app/src/core/settings/settings_repository.dart';
import 'package:quran_mobile_app/src/features/tafsir/tafsir_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Verse Selection & Pre-Selected Interpretation Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Default verse tap action is showTafsir and default edition is fa.noor', () {
      const settings = UserSettings();
      expect(settings.defaultVerseTapAction, equals('showTafsir'));
      expect(settings.defaultTafsirEdition, equals('fa.noor'));
    });

    test('Configuring default verse tap action updates settings correctly', () async {
      final repo = SettingsRepository();
      final notifier = SettingsNotifier(repo);
      await Future<void>.delayed(Duration.zero);

      await notifier.updateDefaultVerseTapAction('playAudio');
      expect(notifier.state.defaultVerseTapAction, equals('playAudio'));

      await notifier.updateDefaultVerseTapAction('showMenu');
      expect(notifier.state.defaultVerseTapAction, equals('showMenu'));
    });

    test('Configuring default Tafsir edition updates settings correctly', () async {
      final repo = SettingsRepository();
      final notifier = SettingsNotifier(repo);
      await Future<void>.delayed(Duration.zero);

      await notifier.updateDefaultTafsirEdition('fa.nemoneh');
      expect(notifier.state.defaultTafsirEdition, equals('fa.nemoneh'));

      await notifier.updateDefaultTafsirEdition('fa.almizan');
      expect(notifier.state.defaultTafsirEdition, equals('fa.almizan'));

      await notifier.updateDefaultTafsirEdition('en.ibnkathir');
      expect(notifier.state.defaultTafsirEdition, equals('en.ibnkathir'));
    });

    test('selectedTafsirEditionProvider respects override and falls back to default setting', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Initially null override
      expect(container.read(selectedTafsirEditionProvider), isNull);

      // Set override
      container.read(selectedTafsirEditionProvider.notifier).state = 'fa.nemoneh';
      expect(container.read(selectedTafsirEditionProvider), equals('fa.nemoneh'));

      // Clear override
      container.read(selectedTafsirEditionProvider.notifier).state = null;
      expect(container.read(selectedTafsirEditionProvider), isNull);
    });
  });
}
