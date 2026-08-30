class IslamicWasiyyah {
  final String fullName;
  final String nationalIdOrDate;
  final String spiritualTestimony;
  final int prayersToMakeUp;
  final int fastsToMakeUp;
  final String khumsZakatStatus;
  final String financialDebtsAndCredits;
  final String thirdOfEstateInstructions;
  final String ethicalAdviceToHeirs;
  final String executorName;
  final DateTime lastUpdated;

  const IslamicWasiyyah({
    this.fullName = '',
    this.nationalIdOrDate = '',
    this.spiritualTestimony = 'اشهد ان لا اله الا الله وحده لا شریک له، و اشهد ان محمداً عبده و رسوله (ص)، و ان علیاً و اولاده المعصومین ائمتی و سادتی، و ان الجنة حق و النار حق و البعث حق.',
    this.prayersToMakeUp = 0,
    this.fastsToMakeUp = 0,
    this.khumsZakatStatus = 'حساب سال خمس انجام شده است و هرگونه بدهی شرعی از اصل مال پرداخت گردد.',
    this.financialDebtsAndCredits = '',
    this.thirdOfEstateInstructions = 'ثلث مال اینجانب صرف امور خیر، رد مظالم و صدقات جاریه شود.',
    this.ethicalAdviceToHeirs = 'فرزندان و بازماندگان خود را به تقوای الهی، اقامه نماز اول وقت، صله رحم و پرهیز از دنیاپرستی سفارش می‌نمایم.',
    this.executorName = '',
    required this.lastUpdated,
  });

  IslamicWasiyyah copyWith({
    String? fullName,
    String? nationalIdOrDate,
    String? spiritualTestimony,
    int? prayersToMakeUp,
    int? fastsToMakeUp,
    String? khumsZakatStatus,
    String? financialDebtsAndCredits,
    String? thirdOfEstateInstructions,
    String? ethicalAdviceToHeirs,
    String? executorName,
    DateTime? lastUpdated,
  }) {
    return IslamicWasiyyah(
      fullName: fullName ?? this.fullName,
      nationalIdOrDate: nationalIdOrDate ?? this.nationalIdOrDate,
      spiritualTestimony: spiritualTestimony ?? this.spiritualTestimony,
      prayersToMakeUp: prayersToMakeUp ?? this.prayersToMakeUp,
      fastsToMakeUp: fastsToMakeUp ?? this.fastsToMakeUp,
      khumsZakatStatus: khumsZakatStatus ?? this.khumsZakatStatus,
      financialDebtsAndCredits: financialDebtsAndCredits ?? this.financialDebtsAndCredits,
      thirdOfEstateInstructions: thirdOfEstateInstructions ?? this.thirdOfEstateInstructions,
      ethicalAdviceToHeirs: ethicalAdviceToHeirs ?? this.ethicalAdviceToHeirs,
      executorName: executorName ?? this.executorName,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toMap() => {
        'fullName': fullName,
        'nationalIdOrDate': nationalIdOrDate,
        'spiritualTestimony': spiritualTestimony,
        'prayersToMakeUp': prayersToMakeUp,
        'fastsToMakeUp': fastsToMakeUp,
        'khumsZakatStatus': khumsZakatStatus,
        'financialDebtsAndCredits': financialDebtsAndCredits,
        'thirdOfEstateInstructions': thirdOfEstateInstructions,
        'ethicalAdviceToHeirs': ethicalAdviceToHeirs,
        'executorName': executorName,
        'lastUpdated': lastUpdated.toIso8601String(),
      };

  factory IslamicWasiyyah.fromMap(Map<String, dynamic> map) => IslamicWasiyyah(
        fullName: (map['fullName'] as String?) ?? '',
        nationalIdOrDate: (map['nationalIdOrDate'] as String?) ?? '',
        spiritualTestimony: (map['spiritualTestimony'] as String?) ?? '',
        prayersToMakeUp: (map['prayersToMakeUp'] as int?) ?? 0,
        fastsToMakeUp: (map['fastsToMakeUp'] as int?) ?? 0,
        khumsZakatStatus: (map['khumsZakatStatus'] as String?) ?? '',
        financialDebtsAndCredits: (map['financialDebtsAndCredits'] as String?) ?? '',
        thirdOfEstateInstructions: (map['thirdOfEstateInstructions'] as String?) ?? '',
        ethicalAdviceToHeirs: (map['ethicalAdviceToHeirs'] as String?) ?? '',
        executorName: (map['executorName'] as String?) ?? '',
        lastUpdated: map['lastUpdated'] != null
            ? DateTime.tryParse(map['lastUpdated'] as String) ?? DateTime.now()
            : DateTime.now(),
      );
}
