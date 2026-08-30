import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran_mobile_app/src/features/tasbih/data/tasbih_repository.dart';
import 'package:quran_mobile_app/src/features/tasbih/models/dhikr_model.dart';
import 'package:quran_mobile_app/src/features/tasbih/presentation/tasbih_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DhikrModel & Presets Tests', () {
    test('Fatima Zahra preset has correct 3 stages with 34-33-33 counts', () {
      final fz = DhikrItem.getFatimaZahra();
      expect(fz.stages.length, 3);
      expect(fz.stages[0].targetCount, 34);
      expect(fz.stages[1].targetCount, 33);
      expect(fz.stages[2].targetCount, 33);
      expect(fz.currentStage.arabicText, 'اللَّهُ أَكْبَرُ');
    });

    test('Weekday dhikr returns valid preset for any day', () {
      final saturday = DhikrItem.getWeekdayDhikr(DateTime(2026, 3, 21)); // Saturday
      expect(saturday.stages.first.arabicText, 'يَا رَبَّ الْعَالَمِينَ');
    });

    test('Serialization and fromMap works seamlessly', () {
      final salawat = DhikrItem.getSalawat();
      final map = salawat.toMap();
      final restored = DhikrItem.fromMap(map);
      expect(restored.id, salawat.id);
      expect(restored.titleFa, salawat.titleFa);
      expect(restored.stages.length, 1);
    });
  });

  group('TasbihNotifier & Multi-Stage Progression Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Advances across stages in Fatima Zahra (34 -> 33 -> 33 -> complete)', () async {
      final repo = TasbihRepository();
      final notifier = TasbihNotifier(repo);
      await Future<void>.delayed(Duration.zero);

      // Start at stage 0 (Allahu Akbar, target 34)
      expect(notifier.state.activeDhikr.currentStageIndex, 0);
      expect(notifier.state.activeDhikr.currentCount, 0);

      // Increment 33 times
      for (int i = 0; i < 33; i++) {
        await notifier.increment();
      }
      expect(notifier.state.activeDhikr.currentStageIndex, 0);
      expect(notifier.state.activeDhikr.currentCount, 33);

      // 34th increment should advance to stage 1 (Alhamdulillah)
      await notifier.increment();
      expect(notifier.state.activeDhikr.currentStageIndex, 1);
      expect(notifier.state.activeDhikr.currentCount, 0);
      expect(notifier.state.activeDhikr.currentStage.arabicText, 'الْحَمْدُ لِلَّهِ');

      // Increment 33 times on stage 1 -> advances to stage 2 (Subhanallah)
      for (int i = 0; i < 33; i++) {
        await notifier.increment();
      }
      expect(notifier.state.activeDhikr.currentStageIndex, 2);
      expect(notifier.state.activeDhikr.currentCount, 0);
      expect(notifier.state.activeDhikr.currentStage.arabicText, 'سُبْحَانَ اللَّهِ');

      // Increment 33 times on stage 2 -> full cycle celebration!
      for (int i = 0; i < 33; i++) {
        await notifier.increment();
      }
      expect(notifier.state.isCompletedCelebration, isTrue);
      expect(notifier.state.activeDhikr.currentStageIndex, 0);
      expect(notifier.state.lifetimeTotal, 34 + 33 + 33);
    });

    test('Custom Dhikr creation and reset', () async {
      final repo = TasbihRepository();
      final notifier = TasbihNotifier(repo);
      await Future<void>.delayed(Duration.zero);

      await notifier.createCustomDhikr(
        titleFa: 'ناد علی',
        titleEn: 'Nad Ali',
        arabicText: 'نَادِ عَلِيّاً مَظْهَرَ الْعَجَائِبِ',
        targetCount: 7,
      );

      expect(notifier.state.activeDhikr.titleFa, 'ناد علی');
      expect(notifier.state.activeDhikr.currentStageTarget, 7);

      await notifier.increment();
      expect(notifier.state.activeDhikr.currentCount, 1);

      await notifier.reset();
      expect(notifier.state.activeDhikr.currentCount, 0);
    });
  });
}
