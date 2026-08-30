import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile_app/src/features/reminders/data/daily_ayah_curator.dart';
import 'package:quran_mobile_app/src/features/reminders/models/reminder_settings_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ReminderSettings Model Tests', () {
    test('Default reminder settings are properly initialized', () {
      const settings = ReminderSettings();
      expect(settings.dailyAyahEnabled, isTrue);
      expect(settings.dailyAyahTime, '08:00');
      expect(settings.khatmahReminderEnabled, isTrue);
      expect(settings.khatmahTime, '20:00');
      expect(settings.fridayKahfReminderEnabled, isTrue);
      expect(settings.fridayKahfTime, '10:00');
      expect(settings.morningAdhkarEnabled, isFalse);
    });

    test('ReminderSettings serialization round-trip', () {
      const settings = ReminderSettings(
        dailyAyahTime: '07:30',
        khatmahTime: '21:15',
        morningAdhkarEnabled: true,
      );

      final map = settings.toMap();
      final restored = ReminderSettings.fromMap(map);

      expect(restored.dailyAyahTime, '07:30');
      expect(restored.khatmahTime, '21:15');
      expect(restored.morningAdhkarEnabled, isTrue);
    });
  });

  group('DailyAyahCurator Tests', () {
    test('Curated Ayahs catalog has valid items with Arabic and translations', () {
      final list = DailyAyahCurator.curatedAyahs;
      expect(list.length, greaterThanOrEqualTo(7));

      for (final ayah in list) {
        expect(ayah.surahNumber, inInclusiveRange(1, 114));
        expect(ayah.verseNumber, greaterThan(0));
        expect(ayah.surahNameFa.isNotEmpty, isTrue);
        expect(ayah.surahNameEn.isNotEmpty, isTrue);
        expect(ayah.arabicText.isNotEmpty, isTrue);
        expect(ayah.translationFa.isNotEmpty, isTrue);
        expect(ayah.translationEn.isNotEmpty, isTrue);
        expect(ayah.theme.isNotEmpty, isTrue);
      }
    });

    test('getTodayAyah returns valid deterministic daily ayah', () {
      final todayAyah = DailyAyahCurator.getTodayAyah();
      expect(todayAyah.surahNumber, inInclusiveRange(1, 114));
      expect(todayAyah.arabicText.isNotEmpty, isTrue);
    });
  });
}
