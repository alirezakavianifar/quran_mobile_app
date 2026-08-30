class DailyAyahItem {
  final int surahNumber;
  final int verseNumber;
  final String surahNameFa;
  final String surahNameEn;
  final String arabicText;
  final String translationFa;
  final String translationEn;
  final String theme;

  const DailyAyahItem({
    required this.surahNumber,
    required this.verseNumber,
    required this.surahNameFa,
    required this.surahNameEn,
    required this.arabicText,
    required this.translationFa,
    required this.translationEn,
    required this.theme,
  });
}

class DailyAyahCurator {
  static const List<DailyAyahItem> curatedAyahs = [
    DailyAyahItem(
      surahNumber: 2,
      verseNumber: 152,
      surahNameFa: 'بقره',
      surahNameEn: 'Al-Baqarah',
      arabicText: 'فَاذْكُرُونِي أَذْكُرْكُمْ وَاشْكُرُوا لِي وَلَا تَكْفُرُونِ',
      translationFa: 'پس مرا یاد کنید تا شما را یاد کنم، و شکر مرا به جا آورید و ناسپاسی نکنید.',
      translationEn: 'So remember Me; I will remember you. And be grateful to Me and do not deny Me.',
      theme: 'ذکر و شکرگزاری',
    ),
    DailyAyahItem(
      surahNumber: 94,
      verseNumber: 6,
      surahNameFa: 'شرح',
      surahNameEn: 'Ash-Sharh',
      arabicText: 'إِنَّ مَعَ الْعُسْرِ يُسْرًا',
      translationFa: 'مسلماً با هر سختی، آسانی است.',
      translationEn: 'Indeed, with hardship will be ease.',
      theme: 'امید و گشایش',
    ),
    DailyAyahItem(
      surahNumber: 3,
      verseNumber: 159,
      surahNameFa: 'آل عمران',
      surahNameEn: 'Ali \'Imran',
      arabicText: 'فَإِذَا عَزَمْتَ فَتَوَكَّلْ عَلَى اللَّهِ ۚ إِنَّ اللَّهَ يُحِبُّ الْمُتَوَكِّلِينَ',
      translationFa: 'پس چون تصمیم گرفتی، بر خدا توکل کن؛ زیرا خدا توکل‌کنندگان را دوست دارد.',
      translationEn: 'And when you have decided, then rely upon Allah. Indeed, Allah loves those who rely [upon Him].',
      theme: 'توکل و اراده',
    ),
    DailyAyahItem(
      surahNumber: 39,
      verseNumber: 53,
      surahNameFa: 'زمر',
      surahNameEn: 'Az-Zumar',
      arabicText: 'قُلْ يَا عِبَادِيَ الَّذِينَ أَسْرَفُوا عَلَىٰ أَنفُسِهِمْ لَا تَقْنَطُوا مِن رَّحْمَةِ اللَّهِ',
      translationFa: 'بگو: ای بندگان من که بر خویشتن زیاده‌روی کرده‌اید، از رحمت خدا نومید نشوید.',
      translationEn: 'Say, "O My servants who have transgressed against themselves, do not despair of the mercy of Allah."',
      theme: 'رحمت بی‌کران',
    ),
    DailyAyahItem(
      surahNumber: 2,
      verseNumber: 186,
      surahNameFa: 'بقره',
      surahNameEn: 'Al-Baqarah',
      arabicText: 'وَإِذَا سَأَلَكَ عِبَادِي عَنِّي فَإِنِّي قَرِيبٌ ۖ أُجِيبُ دَعْوَةَ الدَّاعِ إِذَا دَعَانِ',
      translationFa: 'و هنگامی که بندگانم از تو درباره من بپرسند، [بگو:] من نزدیکم؛ دعای دعاکننده را هنگامی که مرا می‌خواند، اجابت می‌کنم.',
      translationEn: 'And when My servants ask you concerning Me, indeed I am near. I respond to the invocation of the supplicant when he calls upon Me.',
      theme: 'اجابت دعا',
    ),
    DailyAyahItem(
      surahNumber: 65,
      verseNumber: 3,
      surahNameFa: 'طلاق',
      surahNameEn: 'At-Talaq',
      arabicText: 'وَيَرْزُقْهُ مِنْ حَيْثُ لَا يَحْتَسِبُ ۚ وَمَن يَتَوَكَّلْ عَلَى اللَّهِ فَهُوَ حَسْبُهُ',
      translationFa: 'و او را از جایی که گمان ندارد روزی می‌دهد؛ و هر کس بر خدا توکل کند، او برایش کافی است.',
      translationEn: 'And will provide for him from where he does not expect. And whoever relies upon Allah - then He is sufficient for him.',
      theme: 'رزق و کفایت الهی',
    ),
    DailyAyahItem(
      surahNumber: 13,
      verseNumber: 28,
      surahNameFa: 'رعد',
      surahNameEn: 'Ar-Ra\'d',
      arabicText: 'أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ',
      translationFa: 'آگاه باشید که با یاد خدا دل‌ها آرامش می‌یابد.',
      translationEn: 'Unquestionably, by the remembrance of Allah hearts are assured.',
      theme: 'آرامش دل‌ها',
    ),
  ];

  static DailyAyahItem getTodayAyah() {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final index = dayOfYear % curatedAyahs.length;
    return curatedAyahs[index];
  }
}
