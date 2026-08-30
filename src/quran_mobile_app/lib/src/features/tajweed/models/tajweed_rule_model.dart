enum TajweedRuleType {
  ghunnah, // 🔴 Red
  ikhfa, // 🟢 Green
  idgham, // 🟠 Orange
  qalqalah, // 🔵 Blue
  madd, // 🟣 Purple
  iqlab, // 🟡 Amber/Brown
}

class TajweedExample {
  final String arabicText;
  final String highlightSnippet;
  final int surahNumber;
  final int verseNumber;
  final String explanation;

  const TajweedExample({
    required this.arabicText,
    required this.highlightSnippet,
    required this.surahNumber,
    required this.verseNumber,
    required this.explanation,
  });

  Map<String, dynamic> toMap() => {
        'arabicText': arabicText,
        'highlightSnippet': highlightSnippet,
        'surahNumber': surahNumber,
        'verseNumber': verseNumber,
        'explanation': explanation,
      };

  factory TajweedExample.fromMap(Map<String, dynamic> map) => TajweedExample(
        arabicText: map['arabicText'] as String,
        highlightSnippet: map['highlightSnippet'] as String,
        surahNumber: map['surahNumber'] as int,
        verseNumber: map['verseNumber'] as int,
        explanation: map['explanation'] as String,
      );
}

class TajweedRule {
  final TajweedRuleType type;
  final String nameAr;
  final String nameFa;
  final String nameEn;
  final String colorHex;
  final String descriptionFa;
  final String descriptionEn;
  final List<String> letters;
  final List<TajweedExample> examples;

  const TajweedRule({
    required this.type,
    required this.nameAr,
    required this.nameFa,
    required this.nameEn,
    required this.colorHex,
    required this.descriptionFa,
    required this.descriptionEn,
    required this.letters,
    required this.examples,
  });

  Map<String, dynamic> toMap() => {
        'type': type.name,
        'nameAr': nameAr,
        'nameFa': nameFa,
        'nameEn': nameEn,
        'colorHex': colorHex,
        'descriptionFa': descriptionFa,
        'descriptionEn': descriptionEn,
        'letters': letters,
        'examples': examples.map((e) => e.toMap()).toList(),
      };

  factory TajweedRule.fromMap(Map<String, dynamic> map) => TajweedRule(
        type: TajweedRuleType.values.firstWhere(
          (e) => e.name == map['type'],
          orElse: () => TajweedRuleType.ghunnah,
        ),
        nameAr: map['nameAr'] as String,
        nameFa: map['nameFa'] as String,
        nameEn: map['nameEn'] as String,
        colorHex: map['colorHex'] as String,
        descriptionFa: map['descriptionFa'] as String,
        descriptionEn: map['descriptionEn'] as String,
        letters: List<String>.from((map['letters'] as List?) ?? []),
        examples: ((map['examples'] as List?) ?? [])
            .map((e) => TajweedExample.fromMap(e as Map<String, dynamic>))
            .toList(),
      );
}
