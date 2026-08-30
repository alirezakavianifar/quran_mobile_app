class JuzInfo {
  final int juzNumber;
  final String nameAr;
  final String nameFa;
  final String nameEn;
  final int startSurahNumber;
  final int startVerseNumber;
  final int startPageNumber;
  final int endPageNumber;
  final String startAyahSnippet;
  final int versesCount;

  const JuzInfo({
    required this.juzNumber,
    required this.nameAr,
    required this.nameFa,
    required this.nameEn,
    required this.startSurahNumber,
    required this.startVerseNumber,
    required this.startPageNumber,
    required this.endPageNumber,
    required this.startAyahSnippet,
    required this.versesCount,
  });

  Map<String, dynamic> toMap() => {
        'juzNumber': juzNumber,
        'nameAr': nameAr,
        'nameFa': nameFa,
        'nameEn': nameEn,
        'startSurahNumber': startSurahNumber,
        'startVerseNumber': startVerseNumber,
        'startPageNumber': startPageNumber,
        'endPageNumber': endPageNumber,
        'startAyahSnippet': startAyahSnippet,
        'versesCount': versesCount,
      };

  factory JuzInfo.fromMap(Map<String, dynamic> map) => JuzInfo(
        juzNumber: map['juzNumber'] as int,
        nameAr: map['nameAr'] as String,
        nameFa: map['nameFa'] as String,
        nameEn: map['nameEn'] as String,
        startSurahNumber: map['startSurahNumber'] as int,
        startVerseNumber: map['startVerseNumber'] as int,
        startPageNumber: map['startPageNumber'] as int,
        endPageNumber: map['endPageNumber'] as int,
        startAyahSnippet: map['startAyahSnippet'] as String,
        versesCount: map['versesCount'] as int,
      );
}

class HizbInfo {
  final int hizbNumber; // 1 to 60
  final int quarterNumber; // 1 to 4
  final int surahNumber;
  final int verseNumber;
  final int pageNumber;
  final String snippet;

  const HizbInfo({
    required this.hizbNumber,
    required this.quarterNumber,
    required this.surahNumber,
    required this.verseNumber,
    required this.pageNumber,
    required this.snippet,
  });

  Map<String, dynamic> toMap() => {
        'hizbNumber': hizbNumber,
        'quarterNumber': quarterNumber,
        'surahNumber': surahNumber,
        'verseNumber': verseNumber,
        'pageNumber': pageNumber,
        'snippet': snippet,
      };

  factory HizbInfo.fromMap(Map<String, dynamic> map) => HizbInfo(
        hizbNumber: map['hizbNumber'] as int,
        quarterNumber: map['quarterNumber'] as int,
        surahNumber: map['surahNumber'] as int,
        verseNumber: map['verseNumber'] as int,
        pageNumber: map['pageNumber'] as int,
        snippet: map['snippet'] as String,
      );
}

class RevelationOrderItem {
  final int revelationOrder; // 1 to 114
  final int surahNumber;
  final String nameAr;
  final String nameFa;
  final String nameEn;
  final bool isMakki;
  final int verseCount;

  const RevelationOrderItem({
    required this.revelationOrder,
    required this.surahNumber,
    required this.nameAr,
    required this.nameFa,
    required this.nameEn,
    required this.isMakki,
    required this.verseCount,
  });

  Map<String, dynamic> toMap() => {
        'revelationOrder': revelationOrder,
        'surahNumber': surahNumber,
        'nameAr': nameAr,
        'nameFa': nameFa,
        'nameEn': nameEn,
        'isMakki': isMakki,
        'verseCount': verseCount,
      };

  factory RevelationOrderItem.fromMap(Map<String, dynamic> map) =>
      RevelationOrderItem(
        revelationOrder: map['revelationOrder'] as int,
        surahNumber: map['surahNumber'] as int,
        nameAr: map['nameAr'] as String,
        nameFa: map['nameFa'] as String,
        nameEn: map['nameEn'] as String,
        isMakki: map['isMakki'] as bool,
        verseCount: map['verseCount'] as int,
      );
}
