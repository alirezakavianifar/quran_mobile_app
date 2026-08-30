import 'dart:math' as math;
import '../models/hijri_calendar_model.dart';

class HijriCalendarData {
  static const List<String> hijriMonthsAr = [
    'المُحَرَّم',
    'صَفَر',
    'رَبِيع الأوَّل',
    'رَبِيع الآخِر',
    'جُمَادَى الأُولَى',
    'جُمَادَى الآخِرَة',
    'رَجَب',
    'شَعْبَان',
    'رَمَضَان',
    'شَوَّال',
    'ذُو القَعْدَة',
    'ذُو الحِجَّة',
  ];

  static const List<String> hijriMonthsFa = [
    'محرم الحرام',
    'صفر المظفر',
    'ربیع الاول',
    'ربیع الثانی',
    'جمادی الاولی',
    'جمادی الثانیه',
    'رجب المرجب',
    'شعبان المعظم',
    'رمضان المبارک',
    'شوال المکرم',
    'ذی القعده',
    'ذی الحجه',
  ];

  static const List<String> hijriMonthsEn = [
    'Muharram',
    'Safar',
    'Rabi\' al-Awwal',
    'Rabi\' al-Thani',
    'Jumada al-Ula',
    'Jumada al-Akhirah',
    'Rajab',
    'Sha\'ban',
    'Ramadan',
    'Shawwal',
    'Dhu al-Qi\'dah',
    'Dhu al-Hijjah',
  ];

  static const List<IslamicOccasion> allOccasions = [
    // 1. Muharram
    IslamicOccasion(
      titleFa: 'آغاز سال قمری (اول محرم)',
      titleEn: 'Islamic New Year (1st Muharram)',
      hijriMonth: 1,
      hijriDay: 1,
      isMajorHoliday: false,
      descriptionFa: 'آغاز ماه محرم و سال جدید هجری قمری.',
      descriptionEn: 'Start of the Islamic Hijri calendar year.',
    ),
    IslamicOccasion(
      titleFa: 'تاسوعا و عاشورای حسینی (ع)',
      titleEn: 'Day of Ashura',
      hijriMonth: 1,
      hijriDay: 10,
      isMajorHoliday: true,
      descriptionFa: 'شهادت حضرت سیدالشهداء امام حسین (ع) و یاران باوفایشان در کربلا.',
      descriptionEn: 'Martyrdom of Imam Hussain (AS) and his companions in Karbala.',
      recommendedSurah: 89, // Al-Fajr
    ),

    // 2. Safar
    IslamicOccasion(
      titleFa: 'اربعین حسینی (ع)',
      titleEn: 'Arbaeen of Imam Hussain (AS)',
      hijriMonth: 2,
      hijriDay: 20,
      isMajorHoliday: true,
      descriptionFa: 'چهلمین روز شهادت امام حسین (ع) و زیارت اربعین.',
      descriptionEn: 'The 40th day after the martyrdom of Imam Hussain (AS).',
    ),
    IslamicOccasion(
      titleFa: 'رحلت پیامبر اکرم (ص) و شهادت امام حسن مجتبی (ع)',
      titleEn: 'Demise of Prophet Muhammad (PBUH) & Martyrdom of Imam Hasan (AS)',
      hijriMonth: 2,
      hijriDay: 28,
      isMajorHoliday: true,
      descriptionFa: 'سالروز رحلت حضرت محمد مصطفی (ص) و شهادت سبط اکبر امام حسن (ع).',
      descriptionEn: 'Commemoration of the demise of Prophet Muhammad (PBUH) and Imam Hasan (AS).',
      recommendedSurah: 33, // Al-Ahzab
    ),

    // 3. Rabi' al-Awwal
    IslamicOccasion(
      titleFa: 'میلاد پیامبر اکرم (ص) و امام جعفر صادق (ع) - هفته وحدت',
      titleEn: 'Milad an-Nabi (PBUH) & Imam Sadiq (AS)',
      hijriMonth: 3,
      hijriDay: 17,
      isMajorHoliday: true,
      descriptionFa: 'ولادت با سعادت پیامبر رحمت حضرت محمد (ص) و امام جعفر صادق (ع).',
      descriptionEn: 'Birth anniversary of the Holy Prophet (PBUH) and Imam Jafar Sadiq (AS).',
      recommendedSurah: 48, // Al-Fath
    ),

    // 7. Rajab
    IslamicOccasion(
      titleFa: 'ولادت امام علی (ع) - روز پدر',
      titleEn: 'Birth of Imam Ali (AS)',
      hijriMonth: 7,
      hijriDay: 13,
      isMajorHoliday: true,
      descriptionFa: 'ولادت حضرت امیرالمؤمنین علی بن ابی‌طالب (ع) در کعبه معظمه و ایام اعتکاف.',
      descriptionEn: 'Birth of Imam Ali (AS) inside the Holy Kaaba and days of I\'tikaf.',
      recommendedSurah: 76, // Al-Insan
    ),
    IslamicOccasion(
      titleFa: 'مبعث پیامبر اکرم (ص)',
      titleEn: 'Mab\'ath (Prophethood Mission)',
      hijriMonth: 7,
      hijriDay: 27,
      isMajorHoliday: true,
      descriptionFa: 'سالروز بعثت رسول گرامی اسلام حضرت محمد مصطفی (ص) در غار حرا.',
      descriptionEn: 'The appointment of Prophet Muhammad (PBUH) to divine prophethood.',
      recommendedSurah: 96, // Al-Alaq
    ),

    // 8. Sha'ban
    IslamicOccasion(
      titleFa: 'ولادت امام زمان (عج) - نیمه شعبان',
      titleEn: 'Mid-Sha\'ban (Birth of Imam Mahdi AJ)',
      hijriMonth: 8,
      hijriDay: 15,
      isMajorHoliday: true,
      descriptionFa: 'ولادت با برکت حضرت مهدی موعود عجل الله تعالی فرجه الشریف.',
      descriptionEn: 'Birth anniversary of Imam al-Mahdi (AJ) and the night of divine forgiveness.',
      recommendedSurah: 28, // Al-Qasas
    ),

    // 9. Ramadan
    IslamicOccasion(
      titleFa: 'آغاز ماه مبارک رمضان',
      titleEn: 'First Day of Holy Ramadan',
      hijriMonth: 9,
      hijriDay: 1,
      isMajorHoliday: true,
      descriptionFa: 'آغاز ماه ضیافت الهی، نزول قرآن کریم و روزه‌داری.',
      descriptionEn: 'Commencement of the holy month of fasting and Quranic revelation.',
      recommendedSurah: 2, // Al-Baqarah
    ),
    IslamicOccasion(
      titleFa: 'شب‌های قدر (۱۹، ۲۱ و ۲۳ رمضان)',
      titleEn: 'Laylat al-Qadr (Nights of Destiny)',
      hijriMonth: 9,
      hijriDay: 21,
      isMajorHoliday: true,
      descriptionFa: 'شب قدر برتر از هزار ماه و شب نزول قرآن و مقدرات.',
      descriptionEn: 'The Night of Power, better than a thousand months.',
      recommendedSurah: 97, // Al-Qadr
    ),

    // 10. Shawwal
    IslamicOccasion(
      titleFa: 'عید سعید فطر',
      titleEn: 'Eid al-Fitr',
      hijriMonth: 10,
      hijriDay: 1,
      isMajorHoliday: true,
      descriptionFa: 'عید بندگی و جشن پایان یک ماه روزه‌داری و مهمانی خدا.',
      descriptionEn: 'Celebration marking the conclusion of the holy month of Ramadan.',
      recommendedSurah: 87, // Al-A'la
    ),

    // 12. Dhu al-Hijjah
    IslamicOccasion(
      titleFa: 'روز عرفه',
      titleEn: 'Day of Arafah',
      hijriMonth: 12,
      hijriDay: 9,
      isMajorHoliday: true,
      descriptionFa: 'روز نیایش، دعا و معرفت در صحرای عرفات.',
      descriptionEn: 'Day of repentance and profound supplication on Mount Arafat.',
    ),
    IslamicOccasion(
      titleFa: 'عید سعید قربان',
      titleEn: 'Eid al-Adha',
      hijriMonth: 12,
      hijriDay: 10,
      isMajorHoliday: true,
      descriptionFa: 'عید بزرگ قربانی، تسلیم و اخلاص در راه پروردگار.',
      descriptionEn: 'Feast of the Sacrifice and devotion to Allah.',
      recommendedSurah: 108, // Al-Kawthar
    ),
    IslamicOccasion(
      titleFa: 'عید سعید غدیر خم',
      titleEn: 'Eid al-Ghadir',
      hijriMonth: 12,
      hijriDay: 18,
      isMajorHoliday: true,
      descriptionFa: 'عید الله الاکبر و سالروز ابلاغ ولایت و امامت امیرالمؤمنین (ع).',
      descriptionEn: 'The day of declaration of Imam Ali\'s (AS) leadership at Ghadir Khumm.',
      recommendedSurah: 5, // Al-Ma'idah
    ),
  ];

  /// Approximates Lunar Hijri date from standard Gregorian DateTime
  static HijriDate convertGregorianToHijri(DateTime date) {
    // Reference date: 2026-08-30 -> approx 1448-03-17 (17 Rabi al-Awwal 1448)
    final refGregorian = DateTime(2026, 8, 30);
    const refHijriYear = 1448;
    const refHijriMonth = 3;
    const refHijriDay = 17;

    final diffDays = date.difference(refGregorian).inDays;
    // Lunar cycle avg = 29.530588 days
    final totalDays = (refHijriYear * 354.367) + ((refHijriMonth - 1) * 29.53) + refHijriDay + diffDays;

    final hYear = (totalDays / 354.367).floor();
    final remDaysInYear = totalDays - (hYear * 354.367);
    var hMonth = (remDaysInYear / 29.53).floor() + 1;
    if (hMonth > 12) hMonth = 12;
    if (hMonth < 1) hMonth = 1;

    var hDay = (remDaysInYear - ((hMonth - 1) * 29.53)).round();
    if (hDay > 30) hDay = 30;
    if (hDay < 1) hDay = 1;

    return HijriDate(
      year: hYear,
      month: hMonth,
      day: hDay,
      monthNameAr: hijriMonthsAr[hMonth - 1],
      monthNameFa: hijriMonthsFa[hMonth - 1],
      monthNameEn: hijriMonthsEn[hMonth - 1],
    );
  }

  /// Calculates current Moon Phase based on synodic month cycle
  static MoonPhase calculateMoonPhase(DateTime date) {
    // Known New Moon reference epoch: 2000-01-06 18:14 UTC
    final epoch = DateTime.utc(2000, 1, 6, 18, 14);
    final diffDays = date.toUtc().difference(epoch).inSeconds / 86400.0;
    const synodicMonth = 29.53058867;
    final phaseProgress = (diffDays % synodicMonth) / synodicMonth;
    final illumination = (0.5 * (1 - math.cos(phaseProgress * 2 * math.pi))) * 100;

    String nameFa;
    String nameEn;
    String icon;

    if (phaseProgress < 0.05 || phaseProgress > 0.95) {
      nameFa = 'ماه نو (محاق)';
      nameEn = 'New Moon';
      icon = '🌑';
    } else if (phaseProgress < 0.22) {
      nameFa = 'هلال رو به بدر (هلال اول ماه)';
      nameEn = 'Waxing Crescent';
      icon = '🌒';
    } else if (phaseProgress < 0.28) {
      nameFa = 'تربیع اول';
      nameEn = 'First Quarter';
      icon = '🌓';
    } else if (phaseProgress < 0.45) {
      nameFa = 'تحدب فزاینده';
      nameEn = 'Waxing Gibbous';
      icon = '🌔';
    } else if (phaseProgress < 0.55) {
      nameFa = 'ماه کامل (بدر)';
      nameEn = 'Full Moon';
      icon = '🌕';
    } else if (phaseProgress < 0.72) {
      nameFa = 'تحدب کاهنده';
      nameEn = 'Waning Gibbous';
      icon = '🌖';
    } else if (phaseProgress < 0.78) {
      nameFa = 'تربیع دوم';
      nameEn = 'Third Quarter';
      icon = '🌗';
    } else {
      nameFa = 'هلال آخر ماه';
      nameEn = 'Waning Crescent';
      icon = '🌘';
    }

    return MoonPhase(
      phaseNameFa: nameFa,
      phaseNameEn: nameEn,
      illuminationPercent: illumination,
      icon: icon,
    );
  }
}
