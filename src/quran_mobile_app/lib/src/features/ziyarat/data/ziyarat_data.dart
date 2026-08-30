import '../models/ziyarat_model.dart';

class ZiyaratData {
  static const List<ZiyaratItem> allZiyarat = [
    // 1. Ziyarat Ashura
    ZiyaratItem(
      id: 'ashura',
      titleFa: 'زیارت عاشورا',
      titleEn: 'Ziyarat Ashura',
      titleAr: 'زِيَارَةُ عَاشُورَاء',
      subtitle: 'زیارت حضرت اباعبدالله الحسین (ع) با ۱۰۰ لعن و ۱۰۰ سلام',
      virtueFa: 'تأکید فراوان ائمه اطهار (ع) بر مداومت بر آن، برآورده شدن حاجات و دفع بلاها.',
      virtueEn: 'Profound spiritual benefits, protection from adversities, and fulfillment of legitimate prayers.',
      sections: [
        ZiyaratSection(
          arabicText: 'السَّلامُ عَلَيْكَ يَا أَبَا عَبْدِ اللَّهِ، السَّلامُ عَلَيْكَ يَا ابْنَ رَسُولِ اللَّهِ...',
          translationFa: 'سلام بر تو ای اباعبدالله، سلام بر تو ای فرزند رسول خدا...',
          translationEn: 'Peace be upon you, O Aba Abdillah! Peace be upon you, O son of the Messenger of Allah...',
        ),
        ZiyaratSection(
          arabicText: 'اللَّهُمَّ الْعَنْ أَوَّلَ ظَالِمٍ ظَلَمَ حَقَّ مُحَمَّدٍ وَآلِ مُحَمَّدٍ وَآخِرَ تَابِعٍ لَهُ عَلَى ذَلِكَ...',
          translationFa: 'خدایا لعنت فرست بر نخستین ستمکاری که در حق محمد و آل محمد ستم کرد و آخرین کسی که در این راه از او پیروی نمود...',
          translationEn: 'O Allah, curse the first oppressor who usurped the right of Muhammad and the family of Muhammad...',
          targetRepeat: 100,
          isInteractive100x: true,
        ),
        ZiyaratSection(
          arabicText: 'السَّلامُ عَلَيْكَ يَا أَبَا عَبْدِ اللَّهِ وَعَلَى الأَرْوَاحِ الَّتِي حَلَّتْ بِفِنَائِكَ...',
          translationFa: 'سلام بر تو ای اباعبدالله و بر روان‌های پاکی که در بارگاهت فرود آمدند...',
          translationEn: 'Peace be upon you, O Aba Abdillah, and upon the souls that gathered around your threshold...',
          targetRepeat: 100,
          isInteractive100x: true,
        ),
        ZiyaratSection(
          arabicText: 'اللَّهُمَّ لَكَ الحَمْدُ حَمْدَ الشَّاكِرِينَ لَكَ عَلَى مُصَابِهِمْ، الحَمْدُ لِلَّهِ عَلَى عَظِيمِ رَزِيَّتِي...',
          translationFa: 'خدایا ستایش تو را، ستایش سپاسگزاران بر مصیبت‌زدگی آنان، ستایش خدا را بر بزرگی اندوهم...',
          translationEn: 'O Allah, to You belongs praise, the praise of the thankful to You for their tragedy...',
        ),
      ],
    ),

    // 2. Ziyarat Warith
    ZiyaratItem(
      id: 'warith',
      titleFa: 'زیارت وارث',
      titleEn: 'Ziyarat Warith',
      titleAr: 'زِيَارَةُ وَارِث',
      subtitle: 'زیارت امام حسین (ع) به عنوان وارث انبیای الهی',
      virtueFa: 'پیوند رسالت انبیای عظام (آدم، نوح، ابراهیم، موسی، عیسی و محمد ص) با نهضت عاشورا.',
      virtueEn: 'Connects the legacy of the major Prophets with the mission of Imam Hussain (AS).',
      sections: [
        ZiyaratSection(
          arabicText: 'السَّلامُ عَلَيْكَ يَا وَارِثَ آدَمَ صَفْوَةِ اللَّهِ، السَّلامُ عَلَيْكَ يَا وَارِثَ نُوحٍ نَبِيِّ اللَّهِ...',
          translationFa: 'سلام بر تو ای وارث آدم برگزیده خدا، سلام بر تو ای وارث نوح پیامبر خدا...',
          translationEn: 'Peace be upon you, O heir of Adam, the chosen of Allah! Peace be upon you, O heir of Noah, the Prophet of Allah...',
        ),
        ZiyaratSection(
          arabicText: 'أَشْهَدُ أَنَّكَ قَدْ أَقَمْتَ الصَّلاةَ وَآتَيْتَ الزَّكَاةَ وَأَمَرْتَ بِالمَعْرُوفِ وَنَهَيْتَ عَنِ المُنكَرِ...',
          translationFa: 'گواهی می‌دهم که تو نماز را به پا داشتی و زکات پرداختی و امر به معروف و نهی از منکر نمودی...',
          translationEn: 'I bear witness that you established prayer, gave zakat, enjoined good, and forbade evil...',
        ),
      ],
    ),

    // 3. Dua Kumayl
    ZiyaratItem(
      id: 'kumayl',
      titleFa: 'دعای کمیل',
      titleEn: 'Dua Kumayl',
      titleAr: 'دُعَاءُ كُمَيْل',
      subtitle: 'دعای پرفیض حضرت امیرالمؤمنین (ع) در شب‌های جمعه و نیمه شعبان',
      virtueFa: 'آمرزش تمام گناهان، ایمنی از شر دشمنان و وسعت رزق.',
      virtueEn: 'Forgiveness of sins, spiritual purification, and protection against evil.',
      sections: [
        ZiyaratSection(
          arabicText: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ بِرَحْمَتِكَ الَّتِي وَسِعَتْ كُلَّ شَيْءٍ، وَبِقُوَّتِكَ الَّتِي قَهَرْتَ بِهَا كُلَّ شَيْءٍ...',
          translationFa: 'خدایا از تو می‌خواهم به رحمتت که همه چیز را فرا گرفته، و به نیرویت که با آن بر همه چیز چیره گشتی...',
          translationEn: 'O Allah, I ask You by Your mercy which embraces all things, and by Your power by which You conquered all things...',
        ),
        ZiyaratSection(
          arabicText: 'اللَّهُمَّ اغْفِرْ لِيَ الذُّنُوبَ الَّتِي تَهْتِكُ العِصَمَ، اللَّهُمَّ اغْفِرْ لِيَ الذُّنُوبَ الَّتِي تُنْزِلُ النِّقَمَ...',
          translationFa: 'خدایا ببخش برای من گناهانی را که پرده‌های پاکی را می‌درند؛ خدایا ببخش گناهانی را که بلاها را فرود می‌آورند...',
          translationEn: 'O Allah, forgive my sins that tear apart protections; O Allah, forgive my sins that draw down afflictions...',
        ),
      ],
    ),

    // 4. Dua Tawassul
    ZiyaratItem(
      id: 'tawassul',
      titleFa: 'دعای توسل',
      titleEn: 'Dua Tawassul',
      titleAr: 'دُعَاءُ التَّوَسُّل',
      subtitle: 'توسل به پیامبر اکرم (ص) و ائمه معصومین (ع) برای برآورده شدن حاجات',
      virtueFa: 'وسیله قرار دادن اولیای الهی برای گشایش امور و استجابت دعا.',
      virtueEn: 'Seeking the intercession of the Prophet (PBUH) and Ahlulbayt for fulfillment of needs.',
      sections: [
        ZiyaratSection(
          arabicText: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ وَأَتَوَجَّهُ إِلَيْكَ بِنَبِيِّكَ نَبِيِّ الرَّحْمَةِ مُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَآلِهِ...',
          translationFa: 'خدایا من از تو می‌خواهم و به سوی تو روی می‌آورم به وسیله پیامبرت، پیامبر رحمت محمد (ص)...',
          translationEn: 'O Allah, I ask You and turn towards You through Your Prophet, the Prophet of Mercy, Muhammad (PBUH)...',
        ),
        ZiyaratSection(
          arabicText: 'يَا حُجَّةَ اللَّهِ عَلَى خَلْقِهِ، يَا سَيِّدَنَا وَمَوْلانَا، إِنَّا تَوَجَّهْنَا وَاسْتَشْفَعْنَا وَتَوَسَّلْنَا بِكَ إِلَى اللَّهِ...',
          translationFa: 'ای حجت خدا بر بندگانش، ای سرور و مولای ما! ما به تو روی آوردیم و تو را شفیع قرار دادیم به سوی خدا...',
          translationEn: 'O proof of Allah over His creation, O our master! We turn and seek intercession through you to Allah...',
        ),
      ],
    ),

    // 5. Ziyarat Ale Yasin
    ZiyaratItem(
      id: 'ale_yasin',
      titleFa: 'زیارت آل یاسین',
      titleEn: 'Ziyarat Ale Yasin',
      titleAr: 'زِيَارَةُ آلِ يَاسِين',
      subtitle: 'زیارت مخصوص حضرت صاحب الزمان امام مهدی (عج)',
      virtueFa: 'پیوند عمیق با امام زمان (عج) و سلام بر حالات مختلف حضرت.',
      virtueEn: 'Profound spiritual connection with the Living Imam Mahdi (AJ).',
      sections: [
        ZiyaratSection(
          arabicText: 'سَلامٌ عَلَى آلِ يَاسِينَ، السَّلامُ عَلَيْكَ يَا دَاعِيَ اللَّهِ وَرَبَّانِيَّ آيَاتِهِ...',
          translationFa: 'سلام بر خاندان یاسین، سلام بر تو ای دعوت‌کننده به سوی خدا و دانای آیات الهی...',
          translationEn: 'Peace be upon the family of Ya-Sin! Peace be upon you, O summoner to Allah and interpreter of His signs...',
        ),
      ],
    ),

    // 6. Dua Ahd
    ZiyaratItem(
      id: 'ahd',
      titleFa: 'دعای عهد',
      titleEn: 'Dua Ahd',
      titleAr: 'دُعَاءُ العَهْد',
      subtitle: 'تجدید بیعت صبحگاهی با حضرت ولی عصر (عج)',
      virtueFa: 'پاداش یاری حضرت مهدی (عج) برای کسی که ۴۰ صبح آن را بخواند.',
      virtueEn: 'Renewing allegiance every morning with the Promised Savior.',
      sections: [
        ZiyaratSection(
          arabicText: 'اللَّهُمَّ رَبَّ النُّورِ العَظِيمِ، وَرَبَّ الكُرْسِيِّ الرَّفِيعِ، وَرَبَّ البَحْرِ المَسْجُورِ...',
          translationFa: 'خدایا ای پروردگار نور بزرگ، و پروردگار کرسی بلندپایه، و پروردگار دریای افروخته...',
          translationEn: 'O Allah, Lord of the Great Light, Lord of the Elevated Throne, and Lord of the Surging Sea...',
        ),
        ZiyaratSection(
          arabicText: 'اللَّهُمَّ إِنِّي أُجَدِّدُ لَهُ فِي صَبِيحَةِ يَوْمِي هَذَا وَمَا عِشْتُ مِنْ أَيَّامِي عَهْدًا وَعَقْدًا وَبَيْعَةً لَهُ فِي عُنُقِي...',
          translationFa: 'خدایا من در بامداد این روز و تمام روزهایی که زندگی می‌کنم، پیمان و عهد و بیعت با او را بر گردن خویش تجدید می‌نمایم...',
          translationEn: 'O Allah, I renew to him on the morning of this day of mine and all days of my life, a covenant and pledge of allegiance...',
        ),
      ],
    ),
  ];
}
