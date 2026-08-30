import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran_mobile_app/src/features/wasiyyah/data/wasiyyah_repository.dart';
import 'package:quran_mobile_app/src/features/wasiyyah/models/wasiyyah_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('IslamicWasiyyah Model & Repository Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Default IslamicWasiyyah has meaningful default creed and ethical advice', () {
      final w = IslamicWasiyyah(lastUpdated: DateTime.now());
      expect(w.spiritualTestimony.contains('اشهد ان لا اله الا الله'), isTrue);
      expect(w.khumsZakatStatus.isNotEmpty, isTrue);
      expect(w.thirdOfEstateInstructions.isNotEmpty, isTrue);
      expect(w.ethicalAdviceToHeirs.isNotEmpty, isTrue);
    });

    test('Saving and retrieving Wasiyyah from repository', () async {
      final repo = WasiyyahRepository();
      final initial = await repo.getWasiyyah();
      expect(initial.fullName, isEmpty);

      final custom = IslamicWasiyyah(
        fullName: 'علی رضایی',
        executorName: 'محمد رضایی',
        prayersToMakeUp: 30,
        fastsToMakeUp: 10,
        lastUpdated: DateTime.now(),
      );

      await repo.saveWasiyyah(custom);
      final retrieved = await repo.getWasiyyah();
      expect(retrieved.fullName, 'علی رضایی');
      expect(retrieved.executorName, 'محمد رضایی');
      expect(retrieved.prayersToMakeUp, 30);
      expect(retrieved.fastsToMakeUp, 10);
    });

    test('Formatting Wasiyyah as text returns structured sections in Persian and English', () {
      final repo = WasiyyahRepository();
      final sample = IslamicWasiyyah(
        fullName: 'احمد موسوی',
        executorName: 'حسن موسوی',
        prayersToMakeUp: 15,
        fastsToMakeUp: 5,
        lastUpdated: DateTime(2026, 8, 30),
      );

      final textFa = repo.formatAsText(sample, isPersian: true);
      expect(textFa.contains('بسم الله الرحمن الرحیم'), isTrue);
      expect(textFa.contains('احمد موسوی'), isTrue);
      expect(textFa.contains('حسن موسوی'), isTrue);
      expect(textFa.contains('نماز قضا'), isTrue);

      final textEn = repo.formatAsText(sample, isPersian: false);
      expect(textEn.contains('Islamic Spiritual & Legal Will'), isTrue);
      expect(textEn.contains('احمد موسوی'), isTrue);
    });
  });
}
