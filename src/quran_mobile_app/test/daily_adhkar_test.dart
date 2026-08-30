import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile_app/src/features/adhkar/data/daily_adhkar_data.dart';
import 'package:quran_mobile_app/src/features/adhkar/models/adhkar_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DailyAdhkarData & Model Tests', () {
    test('Contains authentic Adhkar across all 4 categories (morning, evening, sleep, postSalah)', () {
      final adhkar = DailyAdhkarData.allAdhkar;
      expect(adhkar.length, greaterThanOrEqualTo(8));

      final categories = adhkar.map((a) => a.category).toSet();
      expect(categories.contains(AdhkarCategory.morning), isTrue);
      expect(categories.contains(AdhkarCategory.evening), isTrue);
      expect(categories.contains(AdhkarCategory.sleep), isTrue);
      expect(categories.contains(AdhkarCategory.postSalah), isTrue);

      for (final a in adhkar) {
        expect(a.id.isNotEmpty, isTrue);
        expect(a.titleFa.isNotEmpty, isTrue);
        expect(a.titleEn.isNotEmpty, isTrue);
        expect(a.arabicText.isNotEmpty, isTrue);
        expect(a.translationFa.isNotEmpty, isTrue);
        expect(a.translationEn.isNotEmpty, isTrue);
        expect(a.targetCount, greaterThan(0));
      }
    });

    test('AdhkarItem count tracking and isCompleted property', () {
      var item = const AdhkarItem(
        id: 'test',
        category: AdhkarCategory.morning,
        titleFa: 'تست',
        titleEn: 'Test',
        arabicText: 'سبحان الله',
        translationFa: 'پاک است خدا',
        translationEn: 'Glory be to Allah',
        sourceOrBenefitFa: 'فضیلت',
        sourceOrBenefitEn: 'Benefit',
        targetCount: 3,
        currentCount: 0,
      );

      expect(item.isCompleted, isFalse);
      item = item.copyWith(currentCount: 3);
      expect(item.isCompleted, isTrue);
    });

    test('AdhkarItem serialization round-trip', () {
      final sample = DailyAdhkarData.allAdhkar.first;
      final map = sample.toMap();
      final restored = AdhkarItem.fromMap(map);

      expect(restored.id, sample.id);
      expect(restored.category, sample.category);
      expect(restored.targetCount, sample.targetCount);
    });
  });
}
