import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile_app/src/features/parables/data/quran_parables_data.dart';
import 'package:quran_mobile_app/src/features/parables/models/quran_parable_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QuranParablesData & Model Tests', () {
    test('Contains curated profound Quranic parables', () {
      final list = QuranParablesData.allParables;
      expect(list.length, greaterThanOrEqualTo(6));

      for (final p in list) {
        expect(p.id.isNotEmpty, isTrue);
        expect(p.titleFa.isNotEmpty, isTrue);
        expect(p.titleEn.isNotEmpty, isTrue);
        expect(p.surahNumber, inInclusiveRange(1, 114));
        expect(p.verseNumber, greaterThan(0));
        expect(p.surahNameFa.isNotEmpty, isTrue);
        expect(p.arabicVerse.isNotEmpty, isTrue);
        expect(p.translationFa.isNotEmpty, isTrue);
        expect(p.translationEn.isNotEmpty, isTrue);
        expect(p.allegorySubjectFa.isNotEmpty, isTrue);
        expect(p.moralLessonFa.isNotEmpty, isTrue);
        expect(p.symbolicMeaningFa.isNotEmpty, isTrue);
      }
    });

    test('QuranParable serialization round-trip', () {
      final sample = QuranParablesData.allParables.first;
      final map = sample.toMap();
      final restored = QuranParable.fromMap(map);

      expect(restored.id, sample.id);
      expect(restored.surahNumber, sample.surahNumber);
      expect(restored.verseNumber, sample.verseNumber);
      expect(restored.titleFa, sample.titleFa);
      expect(restored.symbolicMeaningFa, sample.symbolicMeaningFa);
    });
  });
}
