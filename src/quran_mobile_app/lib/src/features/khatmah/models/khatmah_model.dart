import 'dart:convert';

class KhatmahPlan {
  final String id;
  final String title;
  final int targetDays;
  final DateTime startDate;
  final DateTime targetDate;
  final int completedPages;
  final int totalPages;
  final int lastReadPage;
  final DateTime? lastReadDate;
  final int pagesReadToday;
  final int streakDays;
  final bool isCompleted;

  KhatmahPlan({
    required this.id,
    required this.title,
    required this.targetDays,
    required this.startDate,
    required this.targetDate,
    this.completedPages = 0,
    this.totalPages = 604,
    this.lastReadPage = 1,
    this.lastReadDate,
    this.pagesReadToday = 0,
    this.streakDays = 0,
    this.isCompleted = false,
  });

  double get progressRatio =>
      totalPages > 0 ? (completedPages / totalPages).clamp(0.0, 1.0) : 0.0;

  int get remainingPages => (totalPages - completedPages).clamp(0, totalPages);

  int get daysRemaining {
    final now = DateTime.now();
    final diff = targetDate.difference(now).inDays;
    return diff > 0 ? diff : 0;
  }

  int get dailyTargetPages {
    if (isCompleted || remainingPages <= 0) return 0;
    final days = daysRemaining;
    if (days <= 0) return remainingPages;
    return (remainingPages / days).ceil();
  }

  bool get isAheadOrOnTrack {
    final daysPassed = DateTime.now().difference(startDate).inDays;
    final expectedPages = (totalPages / targetDays) * (daysPassed + 1);
    return completedPages >= expectedPages;
  }

  KhatmahPlan copyWith({
    String? id,
    String? title,
    int? targetDays,
    DateTime? startDate,
    DateTime? targetDate,
    int? completedPages,
    int? totalPages,
    int? lastReadPage,
    DateTime? lastReadDate,
    int? pagesReadToday,
    int? streakDays,
    bool? isCompleted,
  }) {
    return KhatmahPlan(
      id: id ?? this.id,
      title: title ?? this.title,
      targetDays: targetDays ?? this.targetDays,
      startDate: startDate ?? this.startDate,
      targetDate: targetDate ?? this.targetDate,
      completedPages: completedPages ?? this.completedPages,
      totalPages: totalPages ?? this.totalPages,
      lastReadPage: lastReadPage ?? this.lastReadPage,
      lastReadDate: lastReadDate ?? this.lastReadDate,
      pagesReadToday: pagesReadToday ?? this.pagesReadToday,
      streakDays: streakDays ?? this.streakDays,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'targetDays': targetDays,
      'startDate': startDate.toIso8601String(),
      'targetDate': targetDate.toIso8601String(),
      'completedPages': completedPages,
      'totalPages': totalPages,
      'lastReadPage': lastReadPage,
      'lastReadDate': lastReadDate?.toIso8601String(),
      'pagesReadToday': pagesReadToday,
      'streakDays': streakDays,
      'isCompleted': isCompleted,
    };
  }

  factory KhatmahPlan.fromMap(Map<String, dynamic> map) {
    return KhatmahPlan(
      id: map['id'] as String,
      title: map['title'] as String? ?? 'ختم قرآن',
      targetDays: (map['targetDays'] as num?)?.toInt() ?? 30,
      startDate: DateTime.tryParse(map['startDate'] as String? ?? '') ?? DateTime.now(),
      targetDate: DateTime.tryParse(map['targetDate'] as String? ?? '') ??
          DateTime.now().add(const Duration(days: 30)),
      completedPages: (map['completedPages'] as num?)?.toInt() ?? 0,
      totalPages: (map['totalPages'] as num?)?.toInt() ?? 604,
      lastReadPage: (map['lastReadPage'] as num?)?.toInt() ?? 1,
      lastReadDate: map['lastReadDate'] != null
          ? DateTime.tryParse(map['lastReadDate'] as String)
          : null,
      pagesReadToday: (map['pagesReadToday'] as num?)?.toInt() ?? 0,
      streakDays: (map['streakDays'] as num?)?.toInt() ?? 0,
      isCompleted: map['isCompleted'] as bool? ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory KhatmahPlan.fromJson(String source) =>
      KhatmahPlan.fromMap(json.decode(source) as Map<String, dynamic>);
}
