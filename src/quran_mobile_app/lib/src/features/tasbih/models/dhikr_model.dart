enum DhikrPresetType {
  fatimaZahra,
  salawat,
  istighfar,
  subhanallah,
  alhamdulillah,
  allahuAkbar,
  laIlahaIllallah,
  hasbunallah,
  weekdayDhikr,
  custom,
}

class DhikrStage {
  final String titleFa;
  final String titleEn;
  final String arabicText;
  final int targetCount;

  const DhikrStage({
    required this.titleFa,
    required this.titleEn,
    required this.arabicText,
    required this.targetCount,
  });

  Map<String, dynamic> toMap() => {
        'titleFa': titleFa,
        'titleEn': titleEn,
        'arabicText': arabicText,
        'targetCount': targetCount,
      };

  factory DhikrStage.fromMap(Map<String, dynamic> map) => DhikrStage(
        titleFa: map['titleFa'] as String,
        titleEn: map['titleEn'] as String,
        arabicText: map['arabicText'] as String,
        targetCount: map['targetCount'] as int,
      );
}

class DhikrItem {
  final String id;
  final DhikrPresetType presetType;
  final String titleFa;
  final String titleEn;
  final List<DhikrStage> stages;
  final int currentStageIndex;
  final int currentCount;
  final int lifetimeCount;
  final bool isVibrationEnabled;
  final bool isSoundEnabled;

  const DhikrItem({
    required this.id,
    required this.presetType,
    required this.titleFa,
    required this.titleEn,
    required this.stages,
    this.currentStageIndex = 0,
    this.currentCount = 0,
    this.lifetimeCount = 0,
    this.isVibrationEnabled = true,
    this.isSoundEnabled = true,
  });

  DhikrStage get currentStage =>
      stages.isNotEmpty ? stages[currentStageIndex.clamp(0, stages.length - 1)] : defaultStage;

  int get currentStageTarget => currentStage.targetCount;

  bool get isCurrentStageComplete =>
      currentStageTarget > 0 && currentCount >= currentStageTarget;

  double get progressRatio =>
      currentStageTarget > 0 ? (currentCount / currentStageTarget).clamp(0.0, 1.0) : 0.0;

  static const DhikrStage defaultStage = DhikrStage(
    titleFa: 'ذکر',
    titleEn: 'Dhikr',
    arabicText: 'سُبْحَانَ اللَّهِ',
    targetCount: 33,
  );

  DhikrItem copyWith({
    String? id,
    DhikrPresetType? presetType,
    String? titleFa,
    String? titleEn,
    List<DhikrStage>? stages,
    int? currentStageIndex,
    int? currentCount,
    int? lifetimeCount,
    bool? isVibrationEnabled,
    bool? isSoundEnabled,
  }) {
    return DhikrItem(
      id: id ?? this.id,
      presetType: presetType ?? this.presetType,
      titleFa: titleFa ?? this.titleFa,
      titleEn: titleEn ?? this.titleEn,
      stages: stages ?? this.stages,
      currentStageIndex: currentStageIndex ?? this.currentStageIndex,
      currentCount: currentCount ?? this.currentCount,
      lifetimeCount: lifetimeCount ?? this.lifetimeCount,
      isVibrationEnabled: isVibrationEnabled ?? this.isVibrationEnabled,
      isSoundEnabled: isSoundEnabled ?? this.isSoundEnabled,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'presetType': presetType.name,
        'titleFa': titleFa,
        'titleEn': titleEn,
        'stages': stages.map((s) => s.toMap()).toList(),
        'currentStageIndex': currentStageIndex,
        'currentCount': currentCount,
        'lifetimeCount': lifetimeCount,
        'isVibrationEnabled': isVibrationEnabled,
        'isSoundEnabled': isSoundEnabled,
      };

  factory DhikrItem.fromMap(Map<String, dynamic> map) => DhikrItem(
        id: map['id'] as String,
        presetType: DhikrPresetType.values.firstWhere(
          (e) => e.name == map['presetType'],
          orElse: () => DhikrPresetType.salawat,
        ),
        titleFa: map['titleFa'] as String,
        titleEn: map['titleEn'] as String,
        stages: (map['stages'] as List<dynamic>)
            .map((e) => DhikrStage.fromMap(e as Map<String, dynamic>))
            .toList(),
        currentStageIndex: map['currentStageIndex'] as int? ?? 0,
        currentCount: map['currentCount'] as int? ?? 0,
        lifetimeCount: map['lifetimeCount'] as int? ?? 0,
        isVibrationEnabled: map['isVibrationEnabled'] as bool? ?? true,
        isSoundEnabled: map['isSoundEnabled'] as bool? ?? true,
      );

  // Standard Presets
  static DhikrItem getFatimaZahra() => const DhikrItem(
        id: 'fatima_zahra',
        presetType: DhikrPresetType.fatimaZahra,
        titleFa: 'تسبیحات حضرت زهرا (س)',
        titleEn: 'Tasbihat of Lady Fatima (sa)',
        stages: [
          DhikrStage(
            titleFa: 'مرحله ۱ از ۳: تکبیر',
            titleEn: 'Stage 1 of 3: Takbir',
            arabicText: 'اللَّهُ أَكْبَرُ',
            targetCount: 34,
          ),
          DhikrStage(
            titleFa: 'مرحله ۲ از ۳: تحمید',
            titleEn: 'Stage 2 of 3: Tahmid',
            arabicText: 'الْحَمْدُ لِلَّهِ',
            targetCount: 33,
          ),
          DhikrStage(
            titleFa: 'مرحله ۳ از ۳: تسبیح',
            titleEn: 'Stage 3 of 3: Tasbih',
            arabicText: 'سُبْحَانَ اللَّهِ',
            targetCount: 33,
          ),
        ],
      );

  static DhikrItem getSalawat() => const DhikrItem(
        id: 'salawat',
        presetType: DhikrPresetType.salawat,
        titleFa: 'صلوات بر پیامبر و آل پیامبر',
        titleEn: 'Salawat on Prophet & His Progeny',
        stages: [
          DhikrStage(
            titleFa: 'صلوات',
            titleEn: 'Salawat',
            arabicText: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَ آلِ مُحَمَّدٍ',
            targetCount: 100,
          ),
        ],
      );

  static DhikrItem getIstighfar() => const DhikrItem(
        id: 'istighfar',
        presetType: DhikrPresetType.istighfar,
        titleFa: 'استغفار و طلب آمرزش',
        titleEn: 'Istighfar & Seeking Forgiveness',
        stages: [
          DhikrStage(
            titleFa: 'استغفار',
            titleEn: 'Istighfar',
            arabicText: 'أَسْتَغْفِرُ اللَّهَ رَبِّي وَ أَتُوبُ إِلَيْهِ',
            targetCount: 70,
          ),
        ],
      );

  static DhikrItem getSubhanallah() => const DhikrItem(
        id: 'subhanallah',
        presetType: DhikrPresetType.subhanallah,
        titleFa: 'تسبیح خداوند',
        titleEn: 'Subhanallah',
        stages: [
          DhikrStage(
            titleFa: 'تسبیح',
            titleEn: 'Tasbih',
            arabicText: 'سُبْحَانَ اللَّهِ وَ بِحَمْدِهِ سُبْحَانَ اللَّهِ الْعَظِيمِ',
            targetCount: 100,
          ),
        ],
      );

  static DhikrItem getLaIlahaIllallah() => const DhikrItem(
        id: 'la_ilaha_illallah',
        presetType: DhikrPresetType.laIlahaIllallah,
        titleFa: 'تهلیل و توحید',
        titleEn: 'La Ilaha Illallah',
        stages: [
          DhikrStage(
            titleFa: 'تهلیل',
            titleEn: 'Tahlil',
            arabicText: 'لَا إِلَهَ إِلَّا اللَّهُ',
            targetCount: 100,
          ),
        ],
      );

  static DhikrItem getHasbunallah() => const DhikrItem(
        id: 'hasbunallah',
        presetType: DhikrPresetType.hasbunallah,
        titleFa: 'حسبنا الله (توکل)',
        titleEn: 'Hasbunallah (Tawakkul)',
        stages: [
          DhikrStage(
            titleFa: 'توکل',
            titleEn: 'Tawakkul',
            arabicText: 'حَسْبُنَا اللَّهُ وَ نِعْمَ الْوَكِيلُ نِعْمَ الْمَوْلَى وَ نِعْمَ النَّصِيرُ',
            targetCount: 100,
          ),
        ],
      );

  static DhikrItem getWeekdayDhikr([DateTime? date]) {
    final dt = date ?? DateTime.now();
    // In Dart DateTime: Monday = 1, Tuesday = 2, Wednesday = 3, Thursday = 4, Friday = 5, Saturday = 6, Sunday = 7
    switch (dt.weekday) {
      case DateTime.saturday:
        return const DhikrItem(
          id: 'weekday_saturday',
          presetType: DhikrPresetType.weekdayDhikr,
          titleFa: 'ذکر روز شنبه (۱۰۰ مرتبه)',
          titleEn: 'Saturday Dhikr (100 times)',
          stages: [
            DhikrStage(
              titleFa: 'ذکر شنبه',
              titleEn: 'Saturday Dhikr',
              arabicText: 'يَا رَبَّ الْعَالَمِينَ',
              targetCount: 100,
            ),
          ],
        );
      case DateTime.sunday:
        return const DhikrItem(
          id: 'weekday_sunday',
          presetType: DhikrPresetType.weekdayDhikr,
          titleFa: 'ذکر روز یکشنبه (۱۰۰ مرتبه)',
          titleEn: 'Sunday Dhikr (100 times)',
          stages: [
            DhikrStage(
              titleFa: 'ذکر یکشنبه',
              titleEn: 'Sunday Dhikr',
              arabicText: 'يَا ذَا الْجَلَالِ وَ الْإِكْرَامِ',
              targetCount: 100,
            ),
          ],
        );
      case DateTime.monday:
        return const DhikrItem(
          id: 'weekday_monday',
          presetType: DhikrPresetType.weekdayDhikr,
          titleFa: 'ذکر روز دوشنبه (۱۰۰ مرتبه)',
          titleEn: 'Monday Dhikr (100 times)',
          stages: [
            DhikrStage(
              titleFa: 'ذکر دوشنبه',
              titleEn: 'Monday Dhikr',
              arabicText: 'يَا قَاضِيَ الْحَاجَاتِ',
              targetCount: 100,
            ),
          ],
        );
      case DateTime.tuesday:
        return const DhikrItem(
          id: 'weekday_tuesday',
          presetType: DhikrPresetType.weekdayDhikr,
          titleFa: 'ذکر روز سه‌شنبه (۱۰۰ مرتبه)',
          titleEn: 'Tuesday Dhikr (100 times)',
          stages: [
            DhikrStage(
              titleFa: 'ذکر سه‌شنبه',
              titleEn: 'Tuesday Dhikr',
              arabicText: 'يَا أَرْحَمَ الرَّاحِمِينَ',
              targetCount: 100,
            ),
          ],
        );
      case DateTime.wednesday:
        return const DhikrItem(
          id: 'weekday_wednesday',
          presetType: DhikrPresetType.weekdayDhikr,
          titleFa: 'ذکر روز چهارشنبه (۱۰۰ مرتبه)',
          titleEn: 'Wednesday Dhikr (100 times)',
          stages: [
            DhikrStage(
              titleFa: 'ذکر چهارشنبه',
              titleEn: 'Wednesday Dhikr',
              arabicText: 'يَا حَيُّ يَا قَيُّومُ',
              targetCount: 100,
            ),
          ],
        );
      case DateTime.thursday:
        return const DhikrItem(
          id: 'weekday_thursday',
          presetType: DhikrPresetType.weekdayDhikr,
          titleFa: 'ذکر روز پنج‌شنبه (۱۰۰ مرتبه)',
          titleEn: 'Thursday Dhikr (100 times)',
          stages: [
            DhikrStage(
              titleFa: 'ذکر پنج‌شنبه',
              titleEn: 'Thursday Dhikr',
              arabicText: 'لَا إِلَهَ إِلَّا اللَّهُ الْمَلِكُ الْحَقُّ الْمُبِينُ',
              targetCount: 100,
            ),
          ],
        );
      case DateTime.friday:
      default:
        return const DhikrItem(
          id: 'weekday_friday',
          presetType: DhikrPresetType.weekdayDhikr,
          titleFa: 'ذکر روز جمعه (۱۰۰ مرتبه)',
          titleEn: 'Friday Dhikr (100 times)',
          stages: [
            DhikrStage(
              titleFa: 'ذکر جمعه',
              titleEn: 'Friday Dhikr',
              arabicText: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَ آلِ مُحَمَّدٍ وَ عَجِّلْ فَرَجَهُمْ',
              targetCount: 100,
            ),
          ],
        );
    }
  }

  static List<DhikrItem> getAllPresets() => [
        getFatimaZahra(),
        getSalawat(),
        getWeekdayDhikr(),
        getIstighfar(),
        getSubhanallah(),
        getLaIlahaIllallah(),
        getHasbunallah(),
      ];
}
