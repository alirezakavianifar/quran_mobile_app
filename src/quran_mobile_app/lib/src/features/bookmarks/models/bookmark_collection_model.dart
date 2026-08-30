class BookmarkFolder {
  final String id;
  final String titleFa;
  final String titleEn;
  final String colorHex;
  final String iconName;

  const BookmarkFolder({
    required this.id,
    required this.titleFa,
    required this.titleEn,
    this.colorHex = '#2E7D32',
    this.iconName = 'bookmark',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'titleFa': titleFa,
        'titleEn': titleEn,
        'colorHex': colorHex,
        'iconName': iconName,
      };

  factory BookmarkFolder.fromMap(Map<String, dynamic> map) => BookmarkFolder(
        id: map['id'] as String,
        titleFa: map['titleFa'] as String,
        titleEn: map['titleEn'] as String,
        colorHex: (map['colorHex'] as String?) ?? '#2E7D32',
        iconName: (map['iconName'] as String?) ?? 'bookmark',
      );

  static const List<BookmarkFolder> defaultPresets = [
    BookmarkFolder(
      id: 'default',
      titleFa: 'نشان‌های عمومی',
      titleEn: 'General Bookmarks',
      colorHex: '#2E7D32',
      iconName: 'bookmark',
    ),
    BookmarkFolder(
      id: 'tadabbur',
      titleFa: 'آیات تدبر و تأمل',
      titleEn: 'Tadabbur & Reflections',
      colorHex: '#1565C0',
      iconName: 'lightbulb',
    ),
    BookmarkFolder(
      id: 'hifz',
      titleFa: 'برنامه حفظ و تثبیت',
      titleEn: 'Memorization Goals',
      colorHex: '#E65100',
      iconName: 'psychology',
    ),
    BookmarkFolder(
      id: 'friday',
      titleFa: 'تلاوت‌های روز جمعه',
      titleEn: 'Friday Recitations',
      colorHex: '#6A1B9A',
      iconName: 'auto_awesome',
    ),
  ];
}

class TaggedBookmark {
  final int surahNumber;
  final int verseNumber;
  final String folderId;
  final List<String> tags;
  final String? note;
  final DateTime createdAt;

  const TaggedBookmark({
    required this.surahNumber,
    required this.verseNumber,
    this.folderId = 'default',
    this.tags = const [],
    this.note,
    required this.createdAt,
  });

  String get key => '${surahNumber}_$verseNumber';

  Map<String, dynamic> toMap() => {
        'surahNumber': surahNumber,
        'verseNumber': verseNumber,
        'folderId': folderId,
        'tags': tags,
        'note': note,
        'createdAt': createdAt.toIso8601String(),
      };

  factory TaggedBookmark.fromMap(Map<String, dynamic> map) => TaggedBookmark(
        surahNumber: map['surahNumber'] as int,
        verseNumber: map['verseNumber'] as int,
        folderId: (map['folderId'] as String?) ?? 'default',
        tags: List<String>.from((map['tags'] as List?) ?? []),
        note: map['note'] as String?,
        createdAt: map['createdAt'] != null
            ? DateTime.tryParse(map['createdAt'] as String) ?? DateTime.now()
            : DateTime.now(),
      );

  TaggedBookmark copyWith({
    int? surahNumber,
    int? verseNumber,
    String? folderId,
    List<String>? tags,
    String? note,
    DateTime? createdAt,
  }) {
    return TaggedBookmark(
      surahNumber: surahNumber ?? this.surahNumber,
      verseNumber: verseNumber ?? this.verseNumber,
      folderId: folderId ?? this.folderId,
      tags: tags ?? this.tags,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
