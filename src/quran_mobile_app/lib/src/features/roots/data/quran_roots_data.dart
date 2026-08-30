import '../models/quran_root_model.dart';

class QuranRootsData {
  static const List<QuranRootWord> allRoots = [
    // 1. R-H-M (ر ح م)
    QuranRootWord(
      id: 'r-h-m',
      lettersAr: 'ر-ح-م',
      transliteration: 'R-H-M',
      occurrencesCount: 339,
      coreMeaningFa: 'رحمت، مهربانی، بخشایش و عطوفت',
      coreMeaningEn: 'Mercy, Compassion, and Benevolence',
      derivedForms: [
        RootDerivedForm(arabicWord: 'رَحْمَة', meaningFa: 'رحمت و بخشایش', meaningEn: 'Mercy', grammaticalType: 'اسم مصدر'),
        RootDerivedForm(arabicWord: 'الرَّحْمَن', meaningFa: 'بسیار بخشاینده', meaningEn: 'The Most Merciful', grammaticalType: 'صفت مشبهه'),
        RootDerivedForm(arabicWord: 'الرَّحِيم', meaningFa: 'همواره مهربان', meaningEn: 'The Especially Merciful', grammaticalType: 'صفت مشبهه'),
        RootDerivedForm(arabicWord: 'يَرْحَمُ', meaningFa: 'رحم می‌کند', meaningEn: 'He shows mercy', grammaticalType: 'فعل مضارع'),
        RootDerivedForm(arabicWord: 'أَرْحَام', meaningFa: 'خویشاوندان و رَحِم‌ها', meaningEn: 'Wombs / Kinship', grammaticalType: 'جمع مکسر'),
      ],
      sampleVerses: [
        RootVerseSample(
          surahNumber: 1,
          verseNumber: 1,
          surahNameFa: 'فاتحه',
          surahNameEn: 'Al-Fatihah',
          arabicSnippet: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
          translationFa: 'به نام خداوند بخشنده مهربان',
          translationEn: 'In the name of Allah, the Entirely Merciful, the Especially Merciful.',
        ),
        RootVerseSample(
          surahNumber: 21,
          verseNumber: 107,
          surahNameFa: 'انبیاء',
          surahNameEn: 'Al-Anbiya',
          arabicSnippet: 'وَمَا أَرْسَلْنَاكَ إِلَّا رَحْمَةً لِّلْعَالَمِينَ',
          translationFa: 'و ما تو را جز رحمتی برای جهانیان نفرستادیم.',
          translationEn: 'And We have not sent you, [O Muhammad], except as a mercy to the worlds.',
        ),
      ],
    ),

    // 2. A-L-M (ع ل م)
    QuranRootWord(
      id: 'a-l-m',
      lettersAr: 'ع-ل-م',
      transliteration: 'A-L-M',
      occurrencesCount: 854,
      coreMeaningFa: 'علم، آگاهی، دانستن و شناخت',
      coreMeaningEn: 'Knowledge, Science, and Awareness',
      derivedForms: [
        RootDerivedForm(arabicWord: 'عِلْم', meaningFa: 'دانش و معرفت', meaningEn: 'Knowledge', grammaticalType: 'اسم مصدر'),
        RootDerivedForm(arabicWord: 'عَلِيم', meaningFa: 'بسیار دانا', meaningEn: 'All-Knowing', grammaticalType: 'صفت مشبهه'),
        RootDerivedForm(arabicWord: 'يَعْلَمُ', meaningFa: 'می‌داند', meaningEn: 'He knows', grammaticalType: 'فعل مضارع'),
        RootDerivedForm(arabicWord: 'عَلَّمَ', meaningFa: 'آموزش داد', meaningEn: 'He taught', grammaticalType: 'فعل ماضی باب تفعیل'),
        RootDerivedForm(arabicWord: 'عَالَمِين', meaningFa: 'جهانیان', meaningEn: 'Worlds / Universes', grammaticalType: 'اسم جمع'),
      ],
      sampleVerses: [
        RootVerseSample(
          surahNumber: 96,
          verseNumber: 4,
          surahNameFa: 'علق',
          surahNameEn: 'Al-Alaq',
          arabicSnippet: 'الَّذِي عَلَّمَ بِالْقَلَمِ • عَلَّمَ الْإِنسَانَ مَا لَمْ يَعْلَمْ',
          translationFa: 'همان که به وسیله قلم آموخت • به انسان آنچه را نمی‌دانست یاد داد.',
          translationEn: 'Who taught by the pen • Taught man that which he knew not.',
        ),
        RootVerseSample(
          surahNumber: 20,
          verseNumber: 114,
          surahNameFa: 'طه',
          surahNameEn: 'Ta-Ha',
          arabicSnippet: 'وَقُل رَّبِّ زِدْنِي عِلْمًا',
          translationFa: 'و بگو: پروردگارا! دانش مرا بیفزای.',
          translationEn: 'And say: "My Lord, increase me in knowledge."',
        ),
      ],
    ),

    // 3. S-B-R (ص ب ر)
    QuranRootWord(
      id: 's-b-r',
      lettersAr: 'ص-ب-ر',
      transliteration: 'S-B-R',
      occurrencesCount: 103,
      coreMeaningFa: 'شکیبایی، استقامت و خویشتن‌داری',
      coreMeaningEn: 'Patience, Steadfastness, and Endurance',
      derivedForms: [
        RootDerivedForm(arabicWord: 'صَبْر', meaningFa: 'شکیبایی و استواری', meaningEn: 'Patience', grammaticalType: 'اسم مصدر'),
        RootDerivedForm(arabicWord: 'الصَّابِرِين', meaningFa: 'شکیبایان', meaningEn: 'The Patient ones', grammaticalType: 'اسم فاعل جمع'),
        RootDerivedForm(arabicWord: 'اصْبِرْ', meaningFa: 'شکیبا باش', meaningEn: 'Be patient', grammaticalType: 'فعل امر'),
        RootDerivedForm(arabicWord: 'صَبُور', meaningFa: 'بسیار شکیبا', meaningEn: 'Most Patient', grammaticalType: 'صفت مبالغه'),
      ],
      sampleVerses: [
        RootVerseSample(
          surahNumber: 2,
          verseNumber: 153,
          surahNameFa: 'بقره',
          surahNameEn: 'Al-Baqarah',
          arabicSnippet: 'إِنَّ اللَّهَ مَعَ الصَّابِرِينَ',
          translationFa: 'همانا خداوند با شکیبایان است.',
          translationEn: 'Indeed, Allah is with the patient.',
        ),
        RootVerseSample(
          surahNumber: 103,
          verseNumber: 3,
          surahNameFa: 'عصر',
          surahNameEn: 'Al-Asr',
          arabicSnippet: 'وَتَوَاصَوْا بِالْحَقِّ وَتَوَاصَوْا بِالصَّبْرِ',
          translationFa: 'و یکدیگر را به حق و به شکیبایی سفارش کردند.',
          translationEn: 'And advised each other to truth and advised each other to patience.',
        ),
      ],
    ),

    // 4. KH-L-Q (خ ل ق)
    QuranRootWord(
      id: 'kh-l-q',
      lettersAr: 'خ-ل-ق',
      transliteration: 'KH-L-Q',
      occurrencesCount: 261,
      coreMeaningFa: 'آفرینش، ابداع و پدید آوردن',
      coreMeaningEn: 'Creation, Fashioning, and Originating',
      derivedForms: [
        RootDerivedForm(arabicWord: 'خَلْق', meaningFa: 'آفرینش و مخلوقات', meaningEn: 'Creation', grammaticalType: 'اسم مصدر'),
        RootDerivedForm(arabicWord: 'الخَالِق', meaningFa: 'آفریننده', meaningEn: 'The Creator', grammaticalType: 'اسم فاعل'),
        RootDerivedForm(arabicWord: 'خَلَقَ', meaningFa: 'آفرید', meaningEn: 'He created', grammaticalType: 'فعل ماضی'),
        RootDerivedForm(arabicWord: 'خَلَّاق', meaningFa: 'بسیار آفریننده', meaningEn: 'All-Creating', grammaticalType: 'صفت مبالغه'),
      ],
      sampleVerses: [
        RootVerseSample(
          surahNumber: 96,
          verseNumber: 1,
          surahNameFa: 'علق',
          surahNameEn: 'Al-Alaq',
          arabicSnippet: 'اقْرَأْ بِاسْمِ رَبِّكَ الَّذِي خَلَقَ',
          translationFa: 'بخوان به نام پروردگارت که [جهان را] آفرید.',
          translationEn: 'Recite in the name of your Lord who created.',
        ),
        RootVerseSample(
          surahNumber: 59,
          verseNumber: 24,
          surahNameFa: 'حشر',
          surahNameEn: 'Al-Hashr',
          arabicSnippet: 'هُوَ اللَّهُ الْخَالِقُ الْبَارِئُ الْمُصَوِّرُ',
          translationFa: 'اوست خداوند آفریننده، هستی‌بخش و نگارنده سیمای موجودات.',
          translationEn: 'He is Allah, the Creator, the Inventor, the Fashioner.',
        ),
      ],
    ),

    // 5. H-D-Y (ه د ي)
    QuranRootWord(
      id: 'h-d-y',
      lettersAr: 'ه-د-ي',
      transliteration: 'H-D-Y',
      occurrencesCount: 316,
      coreMeaningFa: 'هدایت، راهنمایی و نشان دادن مسیر حق',
      coreMeaningEn: 'Guidance, Leading to the Right Path',
      derivedForms: [
        RootDerivedForm(arabicWord: 'هُدًى', meaningFa: 'هدایت و راهنمایی', meaningEn: 'Guidance', grammaticalType: 'اسم مصدر'),
        RootDerivedForm(arabicWord: 'الهَادِي', meaningFa: 'هدایت‌کننده', meaningEn: 'The Guide', grammaticalType: 'اسم فاعل'),
        RootDerivedForm(arabicWord: 'اهْدِنَا', meaningFa: 'ما را هدایت کن', meaningEn: 'Guide us', grammaticalType: 'فعل امر دعایی'),
        RootDerivedForm(arabicWord: 'مُهْتَدِين', meaningFa: 'ره‌یافتگان', meaningEn: 'The rightly guided', grammaticalType: 'اسم فاعل جمع'),
      ],
      sampleVerses: [
        RootVerseSample(
          surahNumber: 1,
          verseNumber: 6,
          surahNameFa: 'فاتحه',
          surahNameEn: 'Al-Fatihah',
          arabicSnippet: 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
          translationFa: 'ما را به راه راست هدایت فرما.',
          translationEn: 'Guide us to the straight path.',
        ),
        RootVerseSample(
          surahNumber: 2,
          verseNumber: 2,
          surahNameFa: 'بقره',
          surahNameEn: 'Al-Baqarah',
          arabicSnippet: 'ذَٰلِكَ الْكِتَابُ لَا رَيْبَ ۛ فِيهِ ۛ هُدًى لِّلْمُتَّقِينَ',
          translationFa: 'این کتابی است که هیچ شکی در آن نیست؛ مایه هدایت پرهیزگاران است.',
          translationEn: 'This is the Book about which there is no doubt, a guidance for those conscious of Allah.',
        ),
      ],
    ),

    // 6. N-S-R (ن ص ر)
    QuranRootWord(
      id: 'n-s-r',
      lettersAr: 'ن-ص-ر',
      transliteration: 'N-S-R',
      occurrencesCount: 158,
      coreMeaningFa: 'پیروزی، نصرت و یاری‌رسانی',
      coreMeaningEn: 'Victory, Support, and Aid',
      derivedForms: [
        RootDerivedForm(arabicWord: 'نَصْر', meaningFa: 'پیروزی و یاری', meaningEn: 'Victory / Help', grammaticalType: 'اسم مصدر'),
        RootDerivedForm(arabicWord: 'النَّصِير', meaningFa: 'بسیار یاری‌رسان', meaningEn: 'The Ultimate Helper', grammaticalType: 'صفت مشبهه'),
        RootDerivedForm(arabicWord: 'يَنصُرْكُمْ', meaningFa: 'شما را یاری می‌کند', meaningEn: 'He will help you', grammaticalType: 'فعل مضارع'),
        RootDerivedForm(arabicWord: 'أَنصَار', meaningFa: 'یاران', meaningEn: 'Supporters / Helpers', grammaticalType: 'جمع مکسر'),
      ],
      sampleVerses: [
        RootVerseSample(
          surahNumber: 110,
          verseNumber: 1,
          surahNameFa: 'نصر',
          surahNameEn: 'An-Nasr',
          arabicSnippet: 'إِذَا جَاءَ نَصْرُ اللَّهِ وَالْفَتْحُ',
          translationFa: 'هنگامی که یاری خدا و پیروزی فرا رسد...',
          translationEn: 'When the victory of Allah has come and the conquest...',
        ),
        RootVerseSample(
          surahNumber: 47,
          verseNumber: 7,
          surahNameFa: 'محمد',
          surahNameEn: 'Muhammad',
          arabicSnippet: 'إِن تَنصُرُوا اللَّهَ يَنصُرْكُمْ وَيُثَبِّتْ أَقْدَامَكُمْ',
          translationFa: 'اگر خدا را یاری کنید، شما را یاری می‌کند و گام‌هایتان را استوار می‌سازد.',
          translationEn: 'If you support Allah, He will support you and plant firmly your feet.',
        ),
      ],
    ),
  ];
}
