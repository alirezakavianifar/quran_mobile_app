import '../models/tajweed_rule_model.dart';

class TajweedRulesData {
  static const List<TajweedRule> allRules = [
    // 1. Ghunnah (غنه)
    TajweedRule(
      type: TajweedRuleType.ghunnah,
      nameAr: 'الغُنَّة',
      nameFa: 'غُنّه (صدای خیشومی نون و میم مشدد)',
      nameEn: 'Ghunnah (Nasalization)',
      colorHex: '#E53935', // Red
      descriptionFa: 'صدای موزون و کشیده‌ای از انتهای بینی (خیشوم) که در نون و میم مشدد به مدت ۲ حرکت ایجاد می‌شود.',
      descriptionEn: 'A resonant nasal sound produced from the nose for the duration of 2 vowel counts on Noon and Meem with Shaddah.',
      letters: ['نّ', 'مّ'],
      examples: [
        TajweedExample(
          arabicText: 'إِنَّ الْإِنسَانَ لَفِي خُسْرٍ',
          highlightSnippet: 'إِنَّ',
          surahNumber: 103,
          verseNumber: 2,
          explanation: 'غنه در نون مشدد کلمه «إِنَّ»',
        ),
        TajweedExample(
          arabicText: 'عَمَّ يَتَسَاءَلُونَ',
          highlightSnippet: 'عَمَّ',
          surahNumber: 78,
          verseNumber: 1,
          explanation: 'غنه در میم مشدد کلمه «عَمَّ»',
        ),
      ],
    ),

    // 2. Qalqalah (قلقله)
    TajweedRule(
      type: TajweedRuleType.qalqalah,
      nameAr: 'القَلْقَلَة',
      nameFa: 'قَلقَله (ارتعاش و تکانش حروف ساکن)',
      nameEn: 'Qalqalah (Echoing / Bouncing)',
      colorHex: '#1E88E5', // Blue
      descriptionFa: 'ایجاد ارتعاش و انعکاس صوتی هنگام تلفظ پنج حرف «ق، ط، ب، ج، د» (قُطب جَد) در حالت سکون.',
      descriptionEn: 'An echoing or rebounding sound on five specific consonants when they are in a state of Sukoon: Qaf, Ta, Ba, Jeem, Dal.',
      letters: ['ق', 'ط', 'ب', 'ج', 'د'],
      examples: [
        TajweedExample(
          arabicText: 'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ',
          highlightSnippet: 'الْفَلَقِ',
          surahNumber: 113,
          verseNumber: 1,
          explanation: 'قلقله در حرف «ق» هنگام وقف بر آخر آیه',
        ),
        TajweedExample(
          arabicText: 'قُلْ هُوَ اللَّهُ أَحَدٌ',
          highlightSnippet: 'أَحَدٌ',
          surahNumber: 112,
          verseNumber: 1,
          explanation: 'قلقله در حرف «د» هنگام وقف بر «أَحَد»',
        ),
        TajweedExample(
          arabicText: 'تَبَّتْ يَدَا أَبِي لَهَبٍ وَتَبَّ',
          highlightSnippet: 'وَتَبَّ',
          surahNumber: 111,
          verseNumber: 1,
          explanation: 'قلقله کبری در حرف «ب» مشدد هنگام وقف',
        ),
      ],
    ),

    // 3. Ikhfa (اخفاء)
    TajweedRule(
      type: TajweedRuleType.ikhfa,
      nameAr: 'الإِخْفَاء',
      nameFa: 'اخفاء (پوشاندن و تلفظ پنهان نون ساکن)',
      nameEn: 'Ikhfa (Concealment)',
      colorHex: '#43A047', // Green
      descriptionFa: 'پنهان کردن نون ساکن یا تنوین در محل تلفظ ۱۵ حرف مابقی همراه با غنه ۲ حرکتی بین اظهار و ادغام.',
      descriptionEn: 'Concealing the sound of Noon Sakinah or Tanween between clear pronunciation and assimilation with a 2-beat nasalization before 15 letters.',
      letters: ['ت', 'ث', 'ج', 'د', 'ذ', 'ز', 'س', 'ش', 'ص', 'ض', 'ط', 'ظ', 'ف', 'ق', 'ك'],
      examples: [
        TajweedExample(
          arabicText: 'مِن قَبْلُ',
          highlightSnippet: 'مِن قَبْلُ',
          surahNumber: 2,
          verseNumber: 25,
          explanation: 'اخفاء نون ساکنه قبل از حرف «ق»',
        ),
        TajweedExample(
          arabicText: 'كُنتُمْ خَيْرَ أُمَّةٍ',
          highlightSnippet: 'كُنتُمْ',
          surahNumber: 3,
          verseNumber: 110,
          explanation: 'اخفاء نون ساکنه قبل از حرف «ت»',
        ),
      ],
    ),

    // 4. Idgham (ادغام)
    TajweedRule(
      type: TajweedRuleType.idgham,
      nameAr: 'الإِدْغَام',
      nameFa: 'ادغام (درهم آمیختن نون ساکن در حروف یَرْمَلُون)',
      nameEn: 'Idgham (Assimilation / Merging)',
      colorHex: '#FB8C00', // Orange
      descriptionFa: 'ادغام نون ساکنه یا تنوین در یکی از حروف ششگانه «ی، ر، م، ل، و، ن» (یَرْمَلُون)؛ با غنه (ینمو) یا بدون غنه (رل).',
      descriptionEn: 'Merging Noon Sakinah or Tanween completely into one of the six Yarmaloon letters (Yaa, Raa, Meem, Laam, Waw, Noon).',
      letters: ['ی', 'ر', 'م', 'ل', 'و', 'ن'],
      examples: [
        TajweedExample(
          arabicText: 'مَن يَقُولُ',
          highlightSnippet: 'مَن يَقُولُ',
          surahNumber: 2,
          verseNumber: 8,
          explanation: 'ادغام با غنه نون ساکنه در حرف «ی»',
        ),
        TajweedExample(
          arabicText: 'مِّن رَّبِّهِمْ',
          highlightSnippet: 'مِّن رَّبِّهِمْ',
          surahNumber: 2,
          verseNumber: 5,
          explanation: 'ادغام بدون غنه نون ساکنه در حرف «ر»',
        ),
      ],
    ),

    // 5. Madd (مد)
    TajweedRule(
      type: TajweedRuleType.madd,
      nameAr: 'المَدّ',
      nameFa: 'مَدّ (کشش و امتداد صوت حروف مدی)',
      nameEn: 'Madd (Prolongation / Elongation)',
      colorHex: '#8E24AA', // Purple
      descriptionFa: 'کشش صوت حروف مد (الف ماقبل مفتوح، واو ماقبل مضموم، یاء ماقبل مکسور) بین ۴ تا ۶ حرکت در مد متصل، منفصل یا لازم.',
      descriptionEn: 'Prolongation of sound on the three Madd letters (Alif, Waw, Yaa) for 4 to 6 counts due to Hamzah or Sukoon.',
      letters: ['آ', 'ـَا', 'ـُو', 'ـِي'],
      examples: [
        TajweedExample(
          arabicText: 'إِذَا جَاءَ نَصْرُ اللَّهِ',
          highlightSnippet: 'جَاءَ',
          surahNumber: 110,
          verseNumber: 1,
          explanation: 'مد متصل واجب (۴ تا ۵ حرکت) به دلیل آمدن همزه پس از الف مد در یک کلمه',
        ),
        TajweedExample(
          arabicText: 'قُلْ يَا أَيُّهَا الْكَافِرُونَ',
          highlightSnippet: 'يَا أَيُّهَا',
          surahNumber: 109,
          verseNumber: 1,
          explanation: 'مد منفصل جایز (۴ تا ۵ حرکت) بین دو کلمه',
        ),
      ],
    ),

    // 6. Iqlab (اقلاب)
    TajweedRule(
      type: TajweedRuleType.iqlab,
      nameAr: 'الإِقْلَاب',
      nameFa: 'اقلاب (تبدیل نون ساکن به میم قبل از باء)',
      nameEn: 'Iqlab (Conversion to Meem)',
      colorHex: '#8D6E63', // Brown / Amber
      descriptionFa: 'تبدیل نون ساکنه یا تنوین به حرف میم مخفی همراه با غنه هنگامی که قبل از حرف «ب» قرار می‌گیرد.',
      descriptionEn: 'Transforming Noon Sakinah or Tanween into a hidden Meem with Ghunnah when followed immediately by the letter Ba.',
      letters: ['ب', 'ۘم'],
      examples: [
        TajweedExample(
          arabicText: 'مِن بَعْدِ',
          highlightSnippet: 'مِنۢ بَعْدِ',
          surahNumber: 2,
          verseNumber: 27,
          explanation: 'اقلاب نون ساکنه به میم مخفی قبل از حرف «ب»',
        ),
        TajweedExample(
          arabicText: 'عَلِيمٌ بِذَاتِ الصُّدُورِ',
          highlightSnippet: 'عَلِيمٌۢ بِذَاتِ',
          surahNumber: 3,
          verseNumber: 119,
          explanation: 'اقلاب تنوین رفع به میم قبل از «ب»',
        ),
      ],
    ),
  ];
}
