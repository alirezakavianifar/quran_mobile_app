import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile_app/src/features/calendar/data/hijri_calendar_data.dart';
import 'package:quran_mobile_app/src/features/calendar/models/hijri_calendar_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HijriCalendarData & Date Conversion Tests', () {
    test('Hijri month lists contain exactly 12 authentic months', () {
      expect(HijriCalendarData.hijriMonthsAr.length, 12);
      expect(HijriCalendarData.hijriMonthsFa.length, 12);
      expect(HijriCalendarData.hijriMonthsEn.length, 12);

      expect(HijriCalendarData.hijriMonthsAr.first, 'المُحَرَّم');
      expect(HijriCalendarData.hijriMonthsAr.last, 'ذُو الحِجَّة');
    });

    test('Gregorian to Hijri date conversion returns valid HijriDate within bounds', () {
      final sampleDate = DateTime(2026, 8, 30);
      final hijri = HijriCalendarData.convertGregorianToHijri(sampleDate);

      expect(hijri.year, greaterThan(1440));
      expect(hijri.month, inInclusiveRange(1, 12));
      expect(hijri.day, inInclusiveRange(1, 30));
      expect(hijri.monthNameAr.isNotEmpty, isTrue);
      expect(hijri.monthNameFa.isNotEmpty, isTrue);
      expect(hijri.monthNameEn.isNotEmpty, isTrue);
    });

    test('Lunar Moon phase calculation returns valid phase name, percentage, and icon', () {
      final now = DateTime.now();
      final phase = HijriCalendarData.calculateMoonPhase(now);

      expect(phase.phaseNameFa.isNotEmpty, isTrue);
      expect(phase.phaseNameEn.isNotEmpty, isTrue);
      expect(phase.illuminationPercent, inInclusiveRange(0.0, 100.0));
      expect(phase.icon.isNotEmpty, isTrue);
    });

    test('Occasions catalog contains major Islamic events and recommended Surahs', () {
      final occasions = HijriCalendarData.allOccasions;
      expect(occasions.length, greaterThanOrEqualTo(10));

      final ashura = occasions.firstWhere((o) => o.hijriMonth == 1 && o.hijriDay == 10);
      expect(ashura.isMajorHoliday, isTrue);
      expect(ashura.recommendedSurah, 89); // Al-Fajr

      final ghadir = occasions.firstWhere((o) => o.hijriMonth == 12 && o.hijriDay == 18);
      expect(ghadir.isMajorHoliday, isTrue);
      expect(ghadir.recommendedSurah, 5); // Al-Ma'idah
    });

    test('HijriDate & IslamicOccasion serialization round-trip', () {
      final hDate = HijriDate(
        year: 1448,
        month: 9,
        day: 21,
        monthNameAr: 'رَمَضَان',
        monthNameFa: 'رمضان المبارک',
        monthNameEn: 'Ramadan',
      );
      final restoredDate = HijriDate.fromMap(hDate.toMap());
      expect(restoredDate.year, 1448);
      expect(restoredDate.month, 9);
      expect(restoredDate.monthNameAr, 'رَمَضَان');

      final occasion = IslamicOccasion(
        titleFa: 'شب قدر',
        titleEn: 'Laylat al-Qadr',
        hijriMonth: 9,
        hijriDay: 21,
        isMajorHoliday: true,
        descriptionFa: 'شب نزول قرآن',
        descriptionEn: 'Night of Power',
        recommendedSurah: 97,
      );
      final restoredOccasion = IslamicOccasion.fromMap(occasion.toMap());
      expect(restoredOccasion.titleFa, 'شب قدر');
      expect(restoredOccasion.recommendedSurah, 97);
    });
  });
}
