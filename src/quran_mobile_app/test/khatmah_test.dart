import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran_mobile_app/src/features/khatmah/data/khatmah_repository.dart';
import 'package:quran_mobile_app/src/features/khatmah/models/khatmah_model.dart';
import 'package:quran_mobile_app/src/features/khatmah/presentation/khatmah_notifier.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('KhatmahPlan Model Tests', () {
    test('Calculates progress ratio and daily targets accurately', () {
      final now = DateTime.now();
      final plan = KhatmahPlan(
        id: 'plan_1',
        title: '30 Days Khatmah',
        targetDays: 30,
        startDate: now,
        targetDate: now.add(const Duration(days: 30)),
        completedPages: 151,
        totalPages: 604,
      );

      expect(plan.progressRatio, closeTo(0.25, 0.01));
      expect(plan.remainingPages, 453);
      expect(plan.dailyTargetPages, inInclusiveRange(15, 16));
      expect(plan.isCompleted, isFalse);
    });

    test('Serialization toMap and fromMap works seamlessly', () {
      final now = DateTime.now();
      final plan = KhatmahPlan(
        id: 'test_id',
        title: 'Ramadan Khatmah',
        targetDays: 30,
        startDate: now,
        targetDate: now.add(const Duration(days: 30)),
        completedPages: 50,
        lastReadPage: 50,
        streakDays: 3,
        pagesReadToday: 10,
      );

      final map = plan.toMap();
      final restored = KhatmahPlan.fromMap(map);

      expect(restored.id, 'test_id');
      expect(restored.title, 'Ramadan Khatmah');
      expect(restored.targetDays, 30);
      expect(restored.completedPages, 50);
      expect(restored.lastReadPage, 50);
      expect(restored.streakDays, 3);
      expect(restored.pagesReadToday, 10);
    });
  });

  group('KhatmahNotifier Unit Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Creates a new plan and updates state and storage', () async {
      final repository = KhatmahRepository();
      final notifier = KhatmahNotifier(repository);
      await Future<void>.delayed(Duration.zero);

      expect(notifier.state, isNull);

      await notifier.createPlan(
        title: 'My 60 Day Khatmah',
        targetDays: 60,
      );

      expect(notifier.state, isNotNull);
      expect(notifier.state!.title, 'My 60 Day Khatmah');
      expect(notifier.state!.targetDays, 60);
      expect(notifier.state!.completedPages, 0);

      // Log progress
      await notifier.logPageRead(20);
      expect(notifier.state!.completedPages, 20);
      expect(notifier.state!.lastReadPage, 20);
      expect(notifier.state!.streakDays, 1);

      // Add more pages
      await notifier.addPagesCompleted(10);
      expect(notifier.state!.completedPages, 30);
      expect(notifier.state!.lastReadPage, 30);

      // Delete plan
      await notifier.deleteActivePlan();
      expect(notifier.state, isNull);
    });
  });
}
