import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran_mobile_app/src/core/settings/models/user_settings.dart';
import 'package:quran_mobile_app/src/core/settings/settings_provider.dart';
import 'package:quran_mobile_app/src/core/settings/settings_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Keep Screen On (WakeLock) Settings Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('KeepScreenOn defaults to true', () {
      const settings = UserSettings();
      expect(settings.keepScreenOn, isTrue);
    });

    test('Toggling keepScreenOn persists and updates notifier state', () async {
      final repository = SettingsRepository();
      final notifier = SettingsNotifier(repository);
      await Future<void>.delayed(Duration.zero);

      expect(notifier.state.keepScreenOn, isTrue);

      await notifier.updateKeepScreenOn(false);
      expect(notifier.state.keepScreenOn, isFalse);

      await notifier.updateKeepScreenOn(true);
      expect(notifier.state.keepScreenOn, isTrue);
    });
  });
}
