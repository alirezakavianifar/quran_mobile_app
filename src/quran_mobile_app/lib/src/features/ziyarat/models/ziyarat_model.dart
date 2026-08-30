class ZiyaratSection {
  final String arabicText;
  final String translationFa;
  final String translationEn;
  final int targetRepeat;
  final int currentRepeat;
  final bool isInteractive100x;

  const ZiyaratSection({
    required this.arabicText,
    required this.translationFa,
    required this.translationEn,
    this.targetRepeat = 1,
    this.currentRepeat = 0,
    this.isInteractive100x = false,
  });

  bool get isCompleted => currentRepeat >= targetRepeat;

  ZiyaratSection copyWith({
    String? arabicText,
    String? translationFa,
    String? translationEn,
    int? targetRepeat,
    int? currentRepeat,
    bool? isInteractive100x,
  }) {
    return ZiyaratSection(
      arabicText: arabicText ?? this.arabicText,
      translationFa: translationFa ?? this.translationFa,
      translationEn: translationEn ?? this.translationEn,
      targetRepeat: targetRepeat ?? this.targetRepeat,
      currentRepeat: currentRepeat ?? this.currentRepeat,
      isInteractive100x: isInteractive100x ?? this.isInteractive100x,
    );
  }

  Map<String, dynamic> toMap() => {
        'arabicText': arabicText,
        'translationFa': translationFa,
        'translationEn': translationEn,
        'targetRepeat': targetRepeat,
        'currentRepeat': currentRepeat,
        'isInteractive100x': isInteractive100x,
      };

  factory ZiyaratSection.fromMap(Map<String, dynamic> map) => ZiyaratSection(
        arabicText: map['arabicText'] as String,
        translationFa: map['translationFa'] as String,
        translationEn: map['translationEn'] as String,
        targetRepeat: (map['targetRepeat'] as int?) ?? 1,
        currentRepeat: (map['currentRepeat'] as int?) ?? 0,
        isInteractive100x: (map['isInteractive100x'] as bool?) ?? false,
      );
}

class ZiyaratItem {
  final String id;
  final String titleFa;
  final String titleEn;
  final String titleAr;
  final String subtitle;
  final String virtueFa;
  final String virtueEn;
  final List<ZiyaratSection> sections;

  const ZiyaratItem({
    required this.id,
    required this.titleFa,
    required this.titleEn,
    required this.titleAr,
    required this.subtitle,
    required this.virtueFa,
    required this.virtueEn,
    required this.sections,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'titleFa': titleFa,
        'titleEn': titleEn,
        'titleAr': titleAr,
        'subtitle': subtitle,
        'virtueFa': virtueFa,
        'virtueEn': virtueEn,
        'sections': sections.map((s) => s.toMap()).toList(),
      };

  factory ZiyaratItem.fromMap(Map<String, dynamic> map) => ZiyaratItem(
        id: map['id'] as String,
        titleFa: map['titleFa'] as String,
        titleEn: map['titleEn'] as String,
        titleAr: map['titleAr'] as String,
        subtitle: map['subtitle'] as String,
        virtueFa: map['virtueFa'] as String,
        virtueEn: map['virtueEn'] as String,
        sections: ((map['sections'] as List?) ?? [])
            .map((e) => ZiyaratSection.fromMap(e as Map<String, dynamic>))
            .toList(),
      );
}
