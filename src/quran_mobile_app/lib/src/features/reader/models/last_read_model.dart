class LastReadEntry {
  final int surahId;
  final int verseNumber;
  final int pageNumber;
  final int juzNumber;
  final String surahNameArabic;
  final String surahNamePersian;
  final String surahNameEnglish;
  final String? verseTextPreview;
  final DateTime timestamp;

  const LastReadEntry({
    required this.surahId,
    required this.verseNumber,
    required this.pageNumber,
    required this.juzNumber,
    required this.surahNameArabic,
    required this.surahNamePersian,
    required this.surahNameEnglish,
    this.verseTextPreview,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'surahId': surahId,
      'verseNumber': verseNumber,
      'pageNumber': pageNumber,
      'juzNumber': juzNumber,
      'surahNameArabic': surahNameArabic,
      'surahNamePersian': surahNamePersian,
      'surahNameEnglish': surahNameEnglish,
      'verseTextPreview': verseTextPreview,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory LastReadEntry.fromMap(Map<String, dynamic> map) {
    return LastReadEntry(
      surahId: (map['surahId'] as num?)?.toInt() ?? 1,
      verseNumber: (map['verseNumber'] as num?)?.toInt() ?? 1,
      pageNumber: (map['pageNumber'] as num?)?.toInt() ?? 1,
      juzNumber: (map['juzNumber'] as num?)?.toInt() ?? 1,
      surahNameArabic: (map['surahNameArabic'] as String?) ?? '',
      surahNamePersian: (map['surahNamePersian'] as String?) ?? '',
      surahNameEnglish: (map['surahNameEnglish'] as String?) ?? '',
      verseTextPreview: map['verseTextPreview'] as String?,
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  LastReadEntry copyWith({
    int? surahId,
    int? verseNumber,
    int? pageNumber,
    int? juzNumber,
    String? surahNameArabic,
    String? surahNamePersian,
    String? surahNameEnglish,
    String? verseTextPreview,
    DateTime? timestamp,
  }) {
    return LastReadEntry(
      surahId: surahId ?? this.surahId,
      verseNumber: verseNumber ?? this.verseNumber,
      pageNumber: pageNumber ?? this.pageNumber,
      juzNumber: juzNumber ?? this.juzNumber,
      surahNameArabic: surahNameArabic ?? this.surahNameArabic,
      surahNamePersian: surahNamePersian ?? this.surahNamePersian,
      surahNameEnglish: surahNameEnglish ?? this.surahNameEnglish,
      verseTextPreview: verseTextPreview ?? this.verseTextPreview,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
