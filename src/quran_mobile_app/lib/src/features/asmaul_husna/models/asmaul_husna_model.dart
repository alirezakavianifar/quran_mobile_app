class DivineName {
  final int number;
  final String nameAr;
  final String transliteration;
  final String meaningFa;
  final String meaningEn;
  final String quranCitation;
  final String spiritualBenefitFa;
  final String spiritualBenefitEn;

  const DivineName({
    required this.number,
    required this.nameAr,
    required this.transliteration,
    required this.meaningFa,
    required this.meaningEn,
    required this.quranCitation,
    required this.spiritualBenefitFa,
    required this.spiritualBenefitEn,
  });

  Map<String, dynamic> toMap() => {
        'number': number,
        'nameAr': nameAr,
        'transliteration': transliteration,
        'meaningFa': meaningFa,
        'meaningEn': meaningEn,
        'quranCitation': quranCitation,
        'spiritualBenefitFa': spiritualBenefitFa,
        'spiritualBenefitEn': spiritualBenefitEn,
      };

  factory DivineName.fromMap(Map<String, dynamic> map) => DivineName(
        number: map['number'] as int,
        nameAr: map['nameAr'] as String,
        transliteration: map['transliteration'] as String,
        meaningFa: map['meaningFa'] as String,
        meaningEn: map['meaningEn'] as String,
        quranCitation: map['quranCitation'] as String,
        spiritualBenefitFa: map['spiritualBenefitFa'] as String,
        spiritualBenefitEn: map['spiritualBenefitEn'] as String,
      );
}
