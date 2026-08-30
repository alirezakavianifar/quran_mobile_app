enum AdhkarCategory {
  morning, // 🌅 Morning
  evening, // 🌇 Evening
  sleep, // 🛏 Bedtime
  postSalah, // 🕌 Post-Salah
}

class AdhkarItem {
  final String id;
  final AdhkarCategory category;
  final String titleFa;
  final String titleEn;
  final String arabicText;
  final String translationFa;
  final String translationEn;
  final String sourceOrBenefitFa;
  final String sourceOrBenefitEn;
  final int targetCount;
  final int currentCount;

  const AdhkarItem({
    required this.id,
    required this.category,
    required this.titleFa,
    required this.titleEn,
    required this.arabicText,
    required this.translationFa,
    required this.translationEn,
    required this.sourceOrBenefitFa,
    required this.sourceOrBenefitEn,
    required this.targetCount,
    this.currentCount = 0,
  });

  bool get isCompleted => currentCount >= targetCount;

  AdhkarItem copyWith({
    String? id,
    AdhkarCategory? category,
    String? titleFa,
    String? titleEn,
    String? arabicText,
    String? translationFa,
    String? translationEn,
    String? sourceOrBenefitFa,
    String? sourceOrBenefitEn,
    int? targetCount,
    int? currentCount,
  }) {
    return AdhkarItem(
      id: id ?? this.id,
      category: category ?? this.category,
      titleFa: titleFa ?? this.titleFa,
      titleEn: titleEn ?? this.titleEn,
      arabicText: arabicText ?? this.arabicText,
      translationFa: translationFa ?? this.translationFa,
      translationEn: translationEn ?? this.translationEn,
      sourceOrBenefitFa: sourceOrBenefitFa ?? this.sourceOrBenefitFa,
      sourceOrBenefitEn: sourceOrBenefitEn ?? this.sourceOrBenefitEn,
      targetCount: targetCount ?? this.targetCount,
      currentCount: currentCount ?? this.currentCount,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'category': category.name,
        'titleFa': titleFa,
        'titleEn': titleEn,
        'arabicText': arabicText,
        'translationFa': translationFa,
        'translationEn': translationEn,
        'sourceOrBenefitFa': sourceOrBenefitFa,
        'sourceOrBenefitEn': sourceOrBenefitEn,
        'targetCount': targetCount,
        'currentCount': currentCount,
      };

  factory AdhkarItem.fromMap(Map<String, dynamic> map) => AdhkarItem(
        id: map['id'] as String,
        category: AdhkarCategory.values.firstWhere(
          (c) => c.name == map['category'],
          orElse: () => AdhkarCategory.morning,
        ),
        titleFa: map['titleFa'] as String,
        titleEn: map['titleEn'] as String,
        arabicText: map['arabicText'] as String,
        translationFa: map['translationFa'] as String,
        translationEn: map['translationEn'] as String,
        sourceOrBenefitFa: map['sourceOrBenefitFa'] as String,
        sourceOrBenefitEn: map['sourceOrBenefitEn'] as String,
        targetCount: map['targetCount'] as int,
        currentCount: (map['currentCount'] as int?) ?? 0,
      );
}
