enum SajdahType {
  wajib, // Obligatory Sajdah
  mustahab, // Recommended Sajdah
}

class SajdahInfo {
  final int surahNumber;
  final int verseNumber;
  final SajdahType type;
  final String surahNameFa;
  final String surahNameEn;
  final String prescribedDuaArabic;
  final String prescribedDuaTranslationFa;
  final String prescribedDuaTranslationEn;
  final String fiqhNoteFa;
  final String fiqhNoteEn;

  const SajdahInfo({
    required this.surahNumber,
    required this.verseNumber,
    required this.type,
    required this.surahNameFa,
    required this.surahNameEn,
    this.prescribedDuaArabic =
        'لَا إِلَهَ إِلَّا اللَّهُ حَقّاً حَقّاً، لَا إِلَهَ إِلَّا اللَّهُ إِيمَاناً وَتَصْدِيقاً، لَا إِلَهَ إِلَّا اللَّهُ عُبُودِيَّةً وَرِقّاً، سَجَدْتُ لَكَ يَا رَبِّ تَعَبُّداً وَرِقّاً، لَا مُسْتَنْكِفاً وَلَا مُسْتَكْبِراً، بَلْ أَنَا عَبْدٌ ذَلِيلٌ ضَعِيفٌ خَائِفٌ مُسْتَجِيرٌ.',
    this.prescribedDuaTranslationFa =
        'معبودی جز خدای یگانه نیست حقاً حقاً؛ معبودی جز خدا نیست از روی ایمان و تصدیق؛ معبودی جز خدا نیست از روی بندگی؛ پروردگارا! برای تو از روی بندگی سجده کردم، نه از روی سرکشی و تکبر، بلکه من بنده خوار، ناتوان، هراسان و پناه‌جوی تو هستم.',
    this.prescribedDuaTranslationEn =
        'There is no deity but Allah in absolute truth; there is no deity but Allah in faith and affirmation; there is no deity but Allah in servitude. I prostrate before You, my Lord, in devout worship, not out of refusal or arrogance, but as a humble, weak, and fearful servant seeking refuge.',
    required this.fiqhNoteFa,
    required this.fiqhNoteEn,
  });

  bool get isWajib => type == SajdahType.wajib;
}

class SajdahData {
  static const Map<String, SajdahInfo> sajdahMap = {
    // 4 Wajib Sajdah Verses
    '32_15': SajdahInfo(
      surahNumber: 32,
      verseNumber: 15,
      type: SajdahType.wajib,
      surahNameFa: 'سجده',
      surahNameEn: 'As-Sajdah',
      fiqhNoteFa: 'با قرائت یا شنیدن این آیه شریفه، سجده واجب فوری می‌گردد.',
      fiqhNoteEn: 'Prostration is immediately obligatory upon reciting or hearing this verse.',
    ),
    '41_38': SajdahInfo(
      surahNumber: 41,
      verseNumber: 38,
      type: SajdahType.wajib,
      surahNameFa: 'فصلت',
      surahNameEn: 'Fussilat',
      fiqhNoteFa: 'با قرائت یا شنیدن این آیه شریفه، سجده واجب فوری می‌گردد.',
      fiqhNoteEn: 'Prostration is immediately obligatory upon reciting or hearing this verse.',
    ),
    '53_62': SajdahInfo(
      surahNumber: 53,
      verseNumber: 62,
      type: SajdahType.wajib,
      surahNameFa: 'نجم',
      surahNameEn: 'An-Najm',
      fiqhNoteFa: 'با قرائت یا شنیدن این آیه شریفه، سجده واجب فوری می‌گردد (آیه پایانی سوره نجم).',
      fiqhNoteEn: 'Prostration is immediately obligatory upon reciting or hearing this verse.',
    ),
    '96_19': SajdahInfo(
      surahNumber: 96,
      verseNumber: 19,
      type: SajdahType.wajib,
      surahNameFa: 'علق',
      surahNameEn: 'Al-Alaq',
      fiqhNoteFa: 'با قرائت یا شنیدن این آیه شریفه، سجده واجب فوری می‌گردد (آیه پایانی سوره علق).',
      fiqhNoteEn: 'Prostration is immediately obligatory upon reciting or hearing this verse.',
    ),

    // 11 Mustahab Sajdah Verses
    '7_206': SajdahInfo(
      surahNumber: 7,
      verseNumber: 206,
      type: SajdahType.mustahab,
      surahNameFa: 'اعراف',
      surahNameEn: 'Al-A\'raf',
      fiqhNoteFa: 'سجده در این آیه مستحب و دارای ثواب فراوان است.',
      fiqhNoteEn: 'Prostration upon reciting this verse is recommended (Mustahab).',
    ),
    '13_15': SajdahInfo(
      surahNumber: 13,
      verseNumber: 15,
      type: SajdahType.mustahab,
      surahNameFa: 'رعد',
      surahNameEn: 'Ar-Ra\'d',
      fiqhNoteFa: 'سجده در این آیه مستحب و دارای ثواب فراوان است.',
      fiqhNoteEn: 'Prostration upon reciting this verse is recommended (Mustahab).',
    ),
    '16_50': SajdahInfo(
      surahNumber: 16,
      verseNumber: 50,
      type: SajdahType.mustahab,
      surahNameFa: 'نحل',
      surahNameEn: 'An-Nahl',
      fiqhNoteFa: 'سجده در این آیه مستحب و دارای ثواب فراوان است.',
      fiqhNoteEn: 'Prostration upon reciting this verse is recommended (Mustahab).',
    ),
    '17_109': SajdahInfo(
      surahNumber: 17,
      verseNumber: 109,
      type: SajdahType.mustahab,
      surahNameFa: 'اسراء',
      surahNameEn: 'Al-Isra',
      fiqhNoteFa: 'سجده در این آیه مستحب و دارای ثواب فراوان است.',
      fiqhNoteEn: 'Prostration upon reciting this verse is recommended (Mustahab).',
    ),
    '19_58': SajdahInfo(
      surahNumber: 19,
      verseNumber: 58,
      type: SajdahType.mustahab,
      surahNameFa: 'مریم',
      surahNameEn: 'Maryam',
      fiqhNoteFa: 'سجده در این آیه مستحب و دارای ثواب فراوان است.',
      fiqhNoteEn: 'Prostration upon reciting this verse is recommended (Mustahab).',
    ),
    '22_18': SajdahInfo(
      surahNumber: 22,
      verseNumber: 18,
      type: SajdahType.mustahab,
      surahNameFa: 'حج',
      surahNameEn: 'Al-Hajj',
      fiqhNoteFa: 'سجده در این آیه مستحب و دارای ثواب فراوان است.',
      fiqhNoteEn: 'Prostration upon reciting this verse is recommended (Mustahab).',
    ),
    '22_77': SajdahInfo(
      surahNumber: 22,
      verseNumber: 77,
      type: SajdahType.mustahab,
      surahNameFa: 'حج',
      surahNameEn: 'Al-Hajj',
      fiqhNoteFa: 'سجده در این آیه مستحب و دارای ثواب فراوان است.',
      fiqhNoteEn: 'Prostration upon reciting this verse is recommended (Mustahab).',
    ),
    '25_60': SajdahInfo(
      surahNumber: 25,
      verseNumber: 60,
      type: SajdahType.mustahab,
      surahNameFa: 'فرقان',
      surahNameEn: 'Al-Furqan',
      fiqhNoteFa: 'سجده در این آیه مستحب و دارای ثواب فراوان است.',
      fiqhNoteEn: 'Prostration upon reciting this verse is recommended (Mustahab).',
    ),
    '27_26': SajdahInfo(
      surahNumber: 27,
      verseNumber: 26,
      type: SajdahType.mustahab,
      surahNameFa: 'نمل',
      surahNameEn: 'An-Naml',
      fiqhNoteFa: 'سجده در این آیه مستحب و دارای ثواب فراوان است.',
      fiqhNoteEn: 'Prostration upon reciting this verse is recommended (Mustahab).',
    ),
    '38_24': SajdahInfo(
      surahNumber: 38,
      verseNumber: 24,
      type: SajdahType.mustahab,
      surahNameFa: 'ص',
      surahNameEn: 'Sad',
      fiqhNoteFa: 'سجده در این آیه مستحب و دارای ثواب فراوان است.',
      fiqhNoteEn: 'Prostration upon reciting this verse is recommended (Mustahab).',
    ),
    '84_21': SajdahInfo(
      surahNumber: 84,
      verseNumber: 21,
      type: SajdahType.mustahab,
      surahNameFa: 'انشقاق',
      surahNameEn: 'Al-Inshiqaq',
      fiqhNoteFa: 'سجده در این آیه مستحب و دارای ثواب فراوان است.',
      fiqhNoteEn: 'Prostration upon reciting this verse is recommended (Mustahab).',
    ),
  };

  static SajdahInfo? getSajdahInfo(int surahNumber, int verseNumber) {
    return sajdahMap['${surahNumber}_$verseNumber'];
  }
}
