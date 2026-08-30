import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran_mobile_app/src/features/analytics/data/reading_activity_repository.dart';
import 'package:quran_mobile_app/src/features/analytics/presentation/reading_analytics_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DailyActivity Model & Intensity Tests', () {
    test('Intensity level scales properly based on activity points', () {
      const empty = DailyActivity(dateKey: '2026-08-30', versesRead: 0);
      expect(empty.intensityLevel, 0);

      const light = DailyActivity(dateKey: '2026-08-30', versesRead: 5);
      expect(light.intensityLevel, 1);

      const moderate = DailyActivity(dateKey: '2026-08-30', versesRead: 20);
      expect(moderate.intensityLevel, 2);

      const heavy = DailyActivity(dateKey: '2026-08-30', versesRead: 45);
      expect(heavy.intensityLevel, 3);

      const intense = DailyActivity(dateKey: '2026-08-30', versesRead: 100);
      expect(intense.intensityLevel, 4);
    });

    test('DailyActivity serialization round-trip', () {
      const sample = DailyActivity(
        dateKey: '2026-08-30',
        versesRead: 15,
        pagesCompleted: 2,
        listeningMinutes: 20,
      );
      final map = sample.toMap();
      final restored = DailyActivity.fromMap(map);

      expect(restored.dateKey, sample.dateKey);
      expect(restored.versesRead, sample.versesRead);
      expect(restored.pagesCompleted, sample.pagesCompleted);
      expect(restored.listeningMinutes, sample.listeningMinutes);
    });
  });

  group('ReadingActivityRepository & Streak Calculation Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('calculateCurrentStreak computes consecutive days correctly', () async {
      final repo = ReadingActivityRepository();
      final now = DateTime.now();

      final d0 = DateFormat('yyyy-MM-dd').format(now);
      final d1 = DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 1)));
      final d2 = DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 2)));

      final activities = {
        d0: DailyActivity(dateKey: d0, versesRead: 10),
        d1: DailyActivity(dateKey: d1, versesRead: 15),
        d2: DailyActivity(dateKey: d2, versesRead: 20),
      };

      final streak = await repo.calculateCurrentStreak(activities);
      expect(streak, 3);
    });

    test('Logging verses and pages updates ReadingAnalyticsNotifier state', () async {
      final repo = ReadingActivityRepository();
      final notifier = ReadingAnalyticsNotifier(repo);
      await Future<void>.delayed(Duration.zero);

      expect(notifier.state.totalVersesRead, 0);

      await notifier.logVerseRead(count: 7);
      expect(notifier.state.totalVersesRead, 7);
      expect(notifier.state.currentStreak, 1);

      await notifier.logPageCompleted();
      expect(notifier.state.totalPagesCompleted, 1);
    });
  });
}
