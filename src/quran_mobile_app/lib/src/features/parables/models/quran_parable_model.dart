class QuranParable {
  final String id;
  final String titleFa;
  final String titleEn;
  final int surahNumber;
  final int verseNumber;
  final String surahNameFa;
  final String surahNameEn;
  final String arabicVerse;
  final String translationFa;
  final String translationEn;
  final String allegorySubjectFa;
  final String allegorySubjectEn;
  final String moralLessonFa;
  final String moralLessonEn;
  final String symbolicMeaningFa;
  final String symbolicMeaningEn;

  const QuranParable({
    required this.id,
    required this.titleFa,
    required this.titleEn,
    required this.surahNumber,
    required this.verseNumber,
    required this.surahNameFa,
    required this.surahNameEn,
    required this.arabicVerse,
    required this.translationFa,
    required this.translationEn,
    required this.allegorySubjectFa,
    required this.allegorySubjectEn,
    required this.moralLessonFa,
    required this.moralLessonEn,
    required this.symbolicMeaningFa,
    required this.symbolicMeaningEn,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'titleFa': titleFa,
        'titleEn': titleEn,
        'surahNumber': surahNumber,
        'verseNumber': verseNumber,
        'surahNameFa': surahNameFa,
        'surahNameEn': surahNameEn,
        'arabicVerse': arabicVerse,
        'translationFa': translationFa,
        'translationEn': translationEn,
        'allegorySubjectFa': allegorySubjectFa,
        'allegorySubjectEn': allegorySubjectEn,
        'moralLessonFa': moralLessonFa,
        'moralLessonEn': moralLessonEn,
        'symbolicMeaningFa': symbolicMeaningFa,
        'symbolicMeaningEn': symbolicMeaningEn,
      };

  factory QuranParable.fromMap(Map<String, dynamic> map) => QuranParable(
        id: map['id'] as String,
        titleFa: map['titleFa'] as String,
        titleEn: map['titleEn'] as String,
        surahNumber: map['surahNumber'] as int,
        verseNumber: map['verseNumber'] as int,
        surahNameFa: map['surahNameFa'] as String,
        surahNameEn: map['surahNameEn'] as String,
        arabicVerse: map['arabicVerse'] as String,
        translationFa: map['translationFa'] as String,
        translationEn: map['translationEn'] as String,
        allegorySubjectFa: map['allegorySubjectFa'] as String,
        allegorySubjectEn: map['allegorySubjectEn'] as String,
        moralLessonFa: map['moralLessonFa'] as String,
        moralLessonEn: map['moralLessonEn'] as String,
        symbolicMeaningFa: map['symbolicMeaningFa'] as String,
        symbolicMeaningEn: map['symbolicMeaningEn'] as String,
      );
}
