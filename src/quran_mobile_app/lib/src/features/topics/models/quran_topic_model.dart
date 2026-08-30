class TopicVerseReference {
  final int surahNumber;
  final int verseNumber;
  final String surahNameFa;
  final String surahNameEn;
  final String arabicText;
  final String translationFa;
  final String translationEn;

  const TopicVerseReference({
    required this.surahNumber,
    required this.verseNumber,
    required this.surahNameFa,
    required this.surahNameEn,
    required this.arabicText,
    required this.translationFa,
    required this.translationEn,
  });

  Map<String, dynamic> toMap() => {
        'surahNumber': surahNumber,
        'verseNumber': verseNumber,
        'surahNameFa': surahNameFa,
        'surahNameEn': surahNameEn,
        'arabicText': arabicText,
        'translationFa': translationFa,
        'translationEn': translationEn,
      };

  factory TopicVerseReference.fromMap(Map<String, dynamic> map) =>
      TopicVerseReference(
        surahNumber: map['surahNumber'] as int,
        verseNumber: map['verseNumber'] as int,
        surahNameFa: map['surahNameFa'] as String,
        surahNameEn: map['surahNameEn'] as String,
        arabicText: map['arabicText'] as String,
        translationFa: map['translationFa'] as String,
        translationEn: map['translationEn'] as String,
      );
}

class QuranTopic {
  final String id;
  final String titleFa;
  final String titleEn;
  final String categoryFa;
  final String categoryEn;
  final String descriptionFa;
  final String descriptionEn;
  final String iconName;
  final List<TopicVerseReference> verses;

  const QuranTopic({
    required this.id,
    required this.titleFa,
    required this.titleEn,
    required this.categoryFa,
    required this.categoryEn,
    required this.descriptionFa,
    required this.descriptionEn,
    required this.iconName,
    required this.verses,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'titleFa': titleFa,
        'titleEn': titleEn,
        'categoryFa': categoryFa,
        'categoryEn': categoryEn,
        'descriptionFa': descriptionFa,
        'descriptionEn': descriptionEn,
        'iconName': iconName,
        'verses': verses.map((v) => v.toMap()).toList(),
      };

  factory QuranTopic.fromMap(Map<String, dynamic> map) => QuranTopic(
        id: map['id'] as String,
        titleFa: map['titleFa'] as String,
        titleEn: map['titleEn'] as String,
        categoryFa: map['categoryFa'] as String,
        categoryEn: map['categoryEn'] as String,
        descriptionFa: map['descriptionFa'] as String,
        descriptionEn: map['descriptionEn'] as String,
        iconName: (map['iconName'] as String?) ?? 'menu_book',
        verses: ((map['verses'] as List?) ?? [])
            .map((e) => TopicVerseReference.fromMap(e as Map<String, dynamic>))
            .toList(),
      );
}
