import '../models/quran_topic_model.dart';

class QuranTopicsData {
  static const List<QuranTopic> allTopics = [
    // 1. Justice & Ethics
    QuranTopic(
      id: 'justice_ethics',
      titleFa: 'عدالت، قسط و امانت‌داری',
      titleEn: 'Justice & Trustworthiness',
      categoryFa: 'اخلاق و جامعه',
      categoryEn: 'Ethics & Society',
      descriptionFa: 'تأکید اکید قرآن بر اقامه قسط، گواهی دادن عادلانه حتی علیه خویشتن و ادای امانات.',
      descriptionEn: 'Quranic commandments on establishing justice, fair witnessing, and returning trusts.',
      iconName: 'gavel',
      verses: [
        TopicVerseReference(
          surahNumber: 4,
          verseNumber: 135,
          surahNameFa: 'نساء',
          surahNameEn: 'An-Nisa',
          arabicText: 'يَا أَيُّهَا الَّذِينَ آمَنُوا كُونُوا قَوَّامِينَ بِالْقِسْطِ شُهَدَاءَ لِلَّهِ وَلَوْ عَلَىٰ أَنفُسِكُمْ',
          translationFa: 'ای کسانی که ایمان آورده‌اید! همواره برپا دارنده عدالت باشید، برای خدا گواهی دهید هر چند به زیان خودتان باشد.',
          translationEn: 'O you who have believed, be persistently standing firm in justice, witnesses for Allah, even if it be against yourselves.',
        ),
        TopicVerseReference(
          surahNumber: 16,
          verseNumber: 90,
          surahNameFa: 'نحل',
          surahNameEn: 'An-Nahl',
          arabicText: 'إِنَّ اللَّهَ يَأْمُرُ بِالْعَدْلِ وَالْإِحْسَانِ وَإِيتَاءِ ذِي الْقُرْبَىٰ',
          translationFa: 'خداوند به عدل و احسان و بخشش به نزدیکان فرمان می‌دهد.',
          translationEn: 'Indeed, Allah orders justice and good conduct and giving to relatives.',
        ),
      ],
    ),

    // 2. Patience & Steadfastness
    QuranTopic(
      id: 'patience_sabr',
      titleFa: 'صبر، شکیبایی و استقامت',
      titleEn: 'Patience & Perseverance',
      categoryFa: 'فضایل فردی',
      categoryEn: 'Personal Virtues',
      descriptionFa: 'پاداش بی‌پایان شکیبایان و همراهی و نصرت ویژه پروردگار با اهل صبر.',
      descriptionEn: 'The infinite reward and divine support promised to those who remain patient.',
      iconName: 'shield',
      verses: [
        TopicVerseReference(
          surahNumber: 2,
          verseNumber: 153,
          surahNameFa: 'بقره',
          surahNameEn: 'Al-Baqarah',
          arabicText: 'يَا أَيُّهَا الَّذِينَ آمَنُوا اسْتَعِينُوا بِالصَّبْرِ وَالصَّلَاةِ ۚ إِنَّ اللَّهَ مَعَ الصَّابِرِينَ',
          translationFa: 'ای کسانی که ایمان آورده‌اید! از صبر و نماز یاری جویید؛ زیرا خدا با صابران است.',
          translationEn: 'O you who have believed, seek help through patience and prayer. Indeed, Allah is with the patient.',
        ),
        TopicVerseReference(
          surahNumber: 39,
          verseNumber: 10,
          surahNameFa: 'زمر',
          surahNameEn: 'Az-Zumar',
          arabicText: 'إِنَّمَا يُوَفَّى الصَّابِرُونَ أَجْرَهُم بِغَيْرِ حِسَابٍ',
          translationFa: 'همانا صابران پاداش خود را بی‌حساب و به طور کامل دریافت خواهند کرد.',
          translationEn: 'Only those who are patient will be paid their reward in full without measure.',
        ),
      ],
    ),

    // 3. Creation, Nature & Science
    QuranTopic(
      id: 'nature_creation',
      titleFa: 'طبیعت، کیهان و شگفتی‌های آفرینش',
      titleEn: 'Creation, Cosmos & Nature',
      categoryFa: 'توحید و آفرینش',
      categoryEn: 'Monotheism & Cosmos',
      descriptionFa: 'نشانه‌های عظمت خالق در آفرینش آسمان‌ها، زمین، چرخش شب و روز، کوه‌ها و آب باران.',
      descriptionEn: 'Reflections on the signs of divine creation in the cosmos, earth, mountains, and rain.',
      iconName: 'eco',
      verses: [
        TopicVerseReference(
          surahNumber: 3,
          verseNumber: 190,
          surahNameFa: 'آل عمران',
          surahNameEn: 'Ali \'Imran',
          arabicText: 'إِنَّ فِي خَلْقِ السَّمَاوَاتِ وَالْأَرْضِ وَاخْتِلَافِ اللَّيْلِ وَالنَّهَارِ لَآيَاتٍ لِّأُولِي الْأَلْبَابِ',
          translationFa: 'مسلماً در آفرینش آسمان‌ها و زمین و آمد و رفت شب و روز، نشانه‌هایی برای خردمندان است.',
          translationEn: 'Indeed, in the creation of the heavens and the earth and the alternation of the night and the day are signs for those of understanding.',
        ),
        TopicVerseReference(
          surahNumber: 21,
          verseNumber: 30,
          surahNameFa: 'انبیاء',
          surahNameEn: 'Al-Anbiya',
          arabicText: 'وَجَعَلْنَا مِنَ الْمَاءِ كُلَّ شَيْءٍ حَيٍّ ۖ أَفَلَا يُؤْمِنُونَ',
          translationFa: 'و هر چیز زنده‌ای را از آب پدید آوردیم؛ آیا ایمان نمی‌آورند؟',
          translationEn: 'And We made from water every living thing. Then will they not believe?',
        ),
      ],
    ),

    // 4. Stories of the Prophets
    QuranTopic(
      id: 'prophets_stories',
      titleFa: 'داستان‌ها و عبرت‌های پیامبران الهی',
      titleEn: 'Stories of the Prophets',
      categoryFa: 'تاریخ و عبرت',
      categoryEn: 'History & Lessons',
      descriptionFa: 'سیره و مجاهدت‌های پیامبران اولوا العزم از جمله نوح، ابراهیم، موسی، عیسی و یوسف (ع).',
      descriptionEn: 'The exemplary struggles, dialogues, and missions of the noble Prophets of God.',
      iconName: 'auto_stories',
      verses: [
        TopicVerseReference(
          surahNumber: 12,
          verseNumber: 111,
          surahNameFa: 'یوسف',
          surahNameEn: 'Yusuf',
          arabicText: 'لَقَدْ كَانَ فِي قَصَصِهِمْ عِبْرَةٌ لِّأُولِي الْأَلْبَابِ',
          translationFa: 'در سرگذشت آنان برای خردمندان، درس عبرتی بزرگ است.',
          translationEn: 'There was certainly in their stories a lesson for those of understanding.',
        ),
        TopicVerseReference(
          surahNumber: 21,
          verseNumber: 87,
          surahNameFa: 'انبیاء',
          surahNameEn: 'Al-Anbiya',
          arabicText: 'وَذَا النُّونِ إِذ ذَّهَبَ مُغَاضِبًا فَظَنَّ أَن لَّن نَّقْدِرَ عَلَيْهِ',
          translationFa: 'و ذوالنون (یونس) را یاد کن هنگامی که خشمگین رفت...',
          translationEn: 'And [mention] the man of the fish, when he went off in anger and thought that We would not reach him...',
        ),
      ],
    ),

    // 5. Charity & Brotherhood
    QuranTopic(
      id: 'charity_brotherhood',
      titleFa: 'انفاق، احسان و برادری ایمانی',
      titleEn: 'Charity & Brotherhood',
      categoryFa: 'اخلاق و جامعه',
      categoryEn: 'Ethics & Society',
      descriptionFa: 'تأثیر معنوی انفاق پنهان و آشکار، پرهیز از منت‌گذاری و مهرورزی با نیازمندان.',
      descriptionEn: 'The profound virtues of charity, benevolence, and sincere brotherly support.',
      iconName: 'favorite',
      verses: [
        TopicVerseReference(
          surahNumber: 2,
          verseNumber: 261,
          surahNameFa: 'بقره',
          surahNameEn: 'Al-Baqarah',
          arabicText: 'مَّثَلُ الَّذِينَ يُنفِقُونَ أَمْوَالَهُمْ فِي سَبِيلِ اللَّهِ كَمَثَلِ حَبَّةٍ أَنبَتَتْ سَبْعَ سَنَابِلَ',
          translationFa: 'مَثَل کسانی که اموال خود را در راه خدا انفاق می‌کنند، همانند دانه‌ای است که هفت خوشه برآورد...',
          translationEn: 'The example of those who spend their wealth in the way of Allah is like a seed of grain which grows seven spikes...',
        ),
        TopicVerseReference(
          surahNumber: 49,
          verseNumber: 10,
          surahNameFa: 'حجرات',
          surahNameEn: 'Al-Hujurat',
          arabicText: 'إِنَّمَا الْمُؤْمِنُونَ إِخْوَةٌ فَأَصْلِحُوا بَيْنَ أَخَوَيْكُمْ',
          translationFa: 'همانا مؤمنان با یکدیگر برادرند؛ پس میان دو برادر خود صلح و آشتی برقرار سازید.',
          translationEn: 'The believers are but brothers, so make settlement between your brothers.',
        ),
      ],
    ),

    // 6. Afterlife & Resurrection
    QuranTopic(
      id: 'afterlife_resurrection',
      titleFa: 'معاد، روز حساب و سرای باقی',
      titleEn: 'Afterlife & Resurrection',
      categoryFa: 'عقاید و معاد',
      categoryEn: 'Belief & Afterlife',
      descriptionFa: 'حتمیت روز قیامت، تجسم اعمال و پاداش جاودان پرهیزگاران در بهشت رضوان.',
      descriptionEn: 'The certainty of the Day of Judgment, embodiment of deeds, and eternal Paradise.',
      iconName: 'stars',
      verses: [
        TopicVerseReference(
          surahNumber: 99,
          verseNumber: 7,
          surahNameFa: 'زلزله',
          surahNameEn: 'Az-Zalzalah',
          arabicText: 'فَمَن يَعْمَلْ مِثْقَالَ ذَرَّةٍ خَيْرًا يَرَهُ',
          translationFa: 'پس هر کس به سنگینی ذره‌ای نیکی کند، [پاداش] آن را می‌بیند.',
          translationEn: 'So whoever does an atom\'s weight of good will see it.',
        ),
        TopicVerseReference(
          surahNumber: 55,
          verseNumber: 46,
          surahNameFa: 'الرحمن',
          surahNameEn: 'Ar-Rahman',
          arabicText: 'وَلِمَنْ خَافَ مَقَامَ رَبِّهِ جَنَّتَانِ',
          translationFa: 'و برای کسی که از مقام پروردگارش بهراسد، دو باغ بهشتی است.',
          translationEn: 'But for he who has feared the position of his Lord are two gardens.',
        ),
      ],
    ),
  ];
}
