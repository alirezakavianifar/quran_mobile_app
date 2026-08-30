enum DuaCategory {
  forgiveness,
  family,
  faith,
  protection,
  knowledge,
  patience,
}

class QuranicDua {
  final int id;
  final DuaCategory category;
  final String arabicText;
  final String translationFa;
  final String translationEn;
  final int surahNumber;
  final int verseNumber;
  final String surahNameFa;
  final String surahNameEn;
  final String themeDescriptionFa;
  final String themeDescriptionEn;

  const QuranicDua({
    required this.id,
    required this.category,
    required this.arabicText,
    required this.translationFa,
    required this.translationEn,
    required this.surahNumber,
    required this.verseNumber,
    required this.surahNameFa,
    required this.surahNameEn,
    required this.themeDescriptionFa,
    required this.themeDescriptionEn,
  });

  String get ayahKey => '$surahNumber:$verseNumber';

  Map<String, dynamic> toMap() => {
        'id': id,
        'category': category.name,
        'arabicText': arabicText,
        'translationFa': translationFa,
        'translationEn': translationEn,
        'surahNumber': surahNumber,
        'verseNumber': verseNumber,
        'surahNameFa': surahNameFa,
        'surahNameEn': surahNameEn,
        'themeDescriptionFa': themeDescriptionFa,
        'themeDescriptionEn': themeDescriptionEn,
      };

  factory QuranicDua.fromMap(Map<String, dynamic> map) => QuranicDua(
        id: map['id'] as int,
        category: DuaCategory.values.firstWhere(
          (e) => e.name == map['category'],
          orElse: () => DuaCategory.forgiveness,
        ),
        arabicText: map['arabicText'] as String,
        translationFa: map['translationFa'] as String,
        translationEn: map['translationEn'] as String,
        surahNumber: map['surahNumber'] as int,
        verseNumber: map['verseNumber'] as int,
        surahNameFa: map['surahNameFa'] as String,
        surahNameEn: map['surahNameEn'] as String,
        themeDescriptionFa: map['themeDescriptionFa'] as String,
        themeDescriptionEn: map['themeDescriptionEn'] as String,
      );
}
