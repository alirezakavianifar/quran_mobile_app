import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile_app/src/features/roots/data/quran_roots_data.dart';
import 'package:quran_mobile_app/src/features/roots/models/quran_root_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QuranRootsData & Model Tests', () {
    test('Contains curated root words with valid occurrences, meanings, and derived forms', () {
      final roots = QuranRootsData.allRoots;
      expect(roots.length, greaterThanOrEqualTo(6));

      for (final r in roots) {
        expect(r.id.isNotEmpty, isTrue);
        expect(r.lettersAr.isNotEmpty, isTrue);
        expect(r.transliteration.isNotEmpty, isTrue);
        expect(r.occurrencesCount, greaterThan(0));
        expect(r.coreMeaningFa.isNotEmpty, isTrue);
        expect(r.coreMeaningEn.isNotEmpty, isTrue);
        expect(r.derivedForms.isNotEmpty, isTrue);
        expect(r.sampleVerses.isNotEmpty, isTrue);

        for (final d in r.derivedForms) {
          expect(d.arabicWord.isNotEmpty, isTrue);
          expect(d.meaningFa.isNotEmpty, isTrue);
          expect(d.meaningEn.isNotEmpty, isTrue);
          expect(d.grammaticalType.isNotEmpty, isTrue);
        }

        for (final s in r.sampleVerses) {
          expect(s.surahNumber, inInclusiveRange(1, 114));
          expect(s.verseNumber, greaterThan(0));
          expect(s.surahNameFa.isNotEmpty, isTrue);
          expect(s.arabicSnippet.isNotEmpty, isTrue);
        }
      }
    });

    test('QuranRootWord serialization round-trip', () {
      final sample = QuranRootsData.allRoots.first;
      final map = sample.toMap();
      final restored = QuranRootWord.fromMap(map);

      expect(restored.id, sample.id);
      expect(restored.lettersAr, sample.lettersAr);
      expect(restored.occurrencesCount, sample.occurrencesCount);
      expect(restored.derivedForms.length, sample.derivedForms.length);
      expect(restored.sampleVerses.length, sample.sampleVerses.length);
    });
  });
}
