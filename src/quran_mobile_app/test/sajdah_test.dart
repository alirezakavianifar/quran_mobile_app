import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile_app/src/features/sajdah/models/sajdah_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SajdahData & Taxonomy Tests', () {
    test('Contains exactly 4 Wajib Sajdah verses', () {
      final wajibVerses =
          SajdahData.sajdahMap.values.where((s) => s.isWajib).toList();
      expect(wajibVerses.length, 4);

      final wajibKeys = wajibVerses.map((s) => '${s.surahNumber}_${s.verseNumber}').toSet();
      expect(wajibKeys, contains('32_15'));
      expect(wajibKeys, contains('41_38'));
      expect(wajibKeys, contains('53_62'));
      expect(wajibKeys, contains('96_19'));
    });

    test('Contains exactly 11 Mustahab Sajdah verses', () {
      final mustahabVerses =
          SajdahData.sajdahMap.values.where((s) => !s.isWajib).toList();
      expect(mustahabVerses.length, 11);
    });

    test('Lookup method correctly retrieves Sajdah info', () {
      final sajdah = SajdahData.getSajdahInfo(32, 15);
      expect(sajdah, isNotNull);
      expect(sajdah!.isWajib, isTrue);
      expect(sajdah.surahNameFa, 'سجده');

      final regularAyah = SajdahData.getSajdahInfo(2, 255);
      expect(regularAyah, isNull);
    });
  });
}
