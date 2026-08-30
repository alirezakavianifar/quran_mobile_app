import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile_app/src/features/divisions/data/quran_divisions_data.dart';
import 'package:quran_mobile_app/src/features/divisions/models/juz_division_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QuranDivisionsData & Juz Tests', () {
    test('Contains exactly 30 Juz with valid sequential numbers', () {
      final juzList = QuranDivisionsData.allJuzList;
      expect(juzList.length, 30);

      for (int i = 0; i < 30; i++) {
        final juz = juzList[i];
        expect(juz.juzNumber, i + 1);
        expect(juz.nameAr.isNotEmpty, isTrue);
        expect(juz.nameFa.isNotEmpty, isTrue);
        expect(juz.nameEn.isNotEmpty, isTrue);
        expect(juz.startSurahNumber, inInclusiveRange(1, 114));
        expect(juz.startVerseNumber, greaterThan(0));
        expect(juz.startPageNumber, inInclusiveRange(1, 604));
        expect(juz.endPageNumber, inInclusiveRange(juz.startPageNumber, 604));
        expect(juz.startAyahSnippet.isNotEmpty, isTrue);
        expect(juz.versesCount, greaterThan(0));
      }
    });

    test('First Juz begins on Page 1 and Last Juz ends on Page 604', () {
      final juz1 = QuranDivisionsData.allJuzList.first;
      final juz30 = QuranDivisionsData.allJuzList.last;

      expect(juz1.juzNumber, 1);
      expect(juz1.startPageNumber, 1);
      expect(juz1.startSurahNumber, 1);
      expect(juz1.startVerseNumber, 1);

      expect(juz30.juzNumber, 30);
      expect(juz30.endPageNumber, 604);
      expect(juz30.startSurahNumber, 78);
    });

    test('JuzInfo serialization round-trip', () {
      final sample = QuranDivisionsData.allJuzList.first;
      final map = sample.toMap();
      final restored = JuzInfo.fromMap(map);

      expect(restored.juzNumber, sample.juzNumber);
      expect(restored.nameAr, sample.nameAr);
      expect(restored.startSurahNumber, sample.startSurahNumber);
      expect(restored.endPageNumber, sample.endPageNumber);
    });
  });

  group('Chronological Revelation Order Tests', () {
    test('Contains all 114 Surahs with unique sequential revelation orders (1 to 114)', () {
      final revList = QuranDivisionsData.revelationOrderList;
      expect(revList.length, 114);

      final orderNumbers = <int>{};
      final surahNumbers = <int>{};

      for (int i = 0; i < 114; i++) {
        final item = revList[i];
        expect(item.revelationOrder, i + 1);
        orderNumbers.add(item.revelationOrder);
        surahNumbers.add(item.surahNumber);
        expect(item.surahNumber, inInclusiveRange(1, 114));
        expect(item.nameFa.isNotEmpty, isTrue);
        expect(item.nameAr.isNotEmpty, isTrue);
        expect(item.verseCount, greaterThan(0));
      }

      expect(orderNumbers.length, 114);
      expect(surahNumbers.length, 114);
    });

    test('First revealed Surah is Al-Alaq (#96) and Last is An-Nasr (#110)', () {
      final first = QuranDivisionsData.revelationOrderList.first;
      final last = QuranDivisionsData.revelationOrderList.last;

      expect(first.revelationOrder, 1);
      expect(first.surahNumber, 96);
      expect(first.isMakki, isTrue);

      expect(last.revelationOrder, 114);
      expect(last.surahNumber, 110);
      expect(last.isMakki, isFalse);
    });
  });
}
