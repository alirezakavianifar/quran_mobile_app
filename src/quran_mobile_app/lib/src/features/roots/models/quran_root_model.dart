class RootDerivedForm {
  final String arabicWord;
  final String meaningFa;
  final String meaningEn;
  final String grammaticalType;

  const RootDerivedForm({
    required this.arabicWord,
    required this.meaningFa,
    required this.meaningEn,
    required this.grammaticalType,
  });

  Map<String, dynamic> toMap() => {
        'arabicWord': arabicWord,
        'meaningFa': meaningFa,
        'meaningEn': meaningEn,
        'grammaticalType': grammaticalType,
      };

  factory RootDerivedForm.fromMap(Map<String, dynamic> map) => RootDerivedForm(
        arabicWord: map['arabicWord'] as String,
        meaningFa: map['meaningFa'] as String,
        meaningEn: map['meaningEn'] as String,
        grammaticalType: map['grammaticalType'] as String,
      );
}

class RootVerseSample {
  final int surahNumber;
  final int verseNumber;
  final String surahNameFa;
  final String surahNameEn;
  final String arabicSnippet;
  final String translationFa;
  final String translationEn;

  const RootVerseSample({
    required this.surahNumber,
    required this.verseNumber,
    required this.surahNameFa,
    required this.surahNameEn,
    required this.arabicSnippet,
    required this.translationFa,
    required this.translationEn,
  });

  Map<String, dynamic> toMap() => {
        'surahNumber': surahNumber,
        'verseNumber': verseNumber,
        'surahNameFa': surahNameFa,
        'surahNameEn': surahNameEn,
        'arabicSnippet': arabicSnippet,
        'translationFa': translationFa,
        'translationEn': translationEn,
      };

  factory RootVerseSample.fromMap(Map<String, dynamic> map) => RootVerseSample(
        surahNumber: map['surahNumber'] as int,
        verseNumber: map['verseNumber'] as int,
        surahNameFa: map['surahNameFa'] as String,
        surahNameEn: map['surahNameEn'] as String,
        arabicSnippet: map['arabicSnippet'] as String,
        translationFa: map['translationFa'] as String,
        translationEn: map['translationEn'] as String,
      );
}

class QuranRootWord {
  final String id;
  final String lettersAr;
  final String transliteration;
  final int occurrencesCount;
  final String coreMeaningFa;
  final String coreMeaningEn;
  final List<RootDerivedForm> derivedForms;
  final List<RootVerseSample> sampleVerses;

  const QuranRootWord({
    required this.id,
    required this.lettersAr,
    required this.transliteration,
    required this.occurrencesCount,
    required this.coreMeaningFa,
    required this.coreMeaningEn,
    required this.derivedForms,
    required this.sampleVerses,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'lettersAr': lettersAr,
        'transliteration': transliteration,
        'occurrencesCount': occurrencesCount,
        'coreMeaningFa': coreMeaningFa,
        'coreMeaningEn': coreMeaningEn,
        'derivedForms': derivedForms.map((d) => d.toMap()).toList(),
        'sampleVerses': sampleVerses.map((s) => s.toMap()).toList(),
      };

  factory QuranRootWord.fromMap(Map<String, dynamic> map) => QuranRootWord(
        id: map['id'] as String,
        lettersAr: map['lettersAr'] as String,
        transliteration: map['transliteration'] as String,
        occurrencesCount: map['occurrencesCount'] as int,
        coreMeaningFa: map['coreMeaningFa'] as String,
        coreMeaningEn: map['coreMeaningEn'] as String,
        derivedForms: ((map['derivedForms'] as List?) ?? [])
            .map((e) => RootDerivedForm.fromMap(e as Map<String, dynamic>))
            .toList(),
        sampleVerses: ((map['sampleVerses'] as List?) ?? [])
            .map((e) => RootVerseSample.fromMap(e as Map<String, dynamic>))
            .toList(),
      );
}
