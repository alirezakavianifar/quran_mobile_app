import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile_app/src/core/utils/persian_digit_converter.dart';

void main() {
  group('PersianDigitConverter Unit Tests', () {
    test('toPersian converts English digits to Persian digits', () {
      expect(PersianDigitConverter.toPersian('1234567890'), '۱۲۳۴۵۶۷۸۹۰');
      expect(PersianDigitConverter.toPersian('Surah 2 Verse 255'), 'Surah ۲ Verse ۲۵۵');
    });

    test('toEnglish converts Persian digits to English digits', () {
      expect(PersianDigitConverter.toEnglish('۱۲۳۴۵۶۷۸۹۰'), '1234567890');
      expect(PersianDigitConverter.toEnglish('سوره ۲ آیه ۲۵۵'), 'سوره 2 آیه 255');
    });

    test('formatAyahKey formats surahId and verseNumber correctly', () {
      expect(PersianDigitConverter.formatAyahKey(2, 255, isPersian: true), '۲:۲۵۵');
      expect(PersianDigitConverter.formatAyahKey(2, 255, isPersian: false), '2:255');
    });

    test('handles empty input gracefully', () {
      expect(PersianDigitConverter.toPersian(''), '');
      expect(PersianDigitConverter.toEnglish(''), '');
    });
  });
}
