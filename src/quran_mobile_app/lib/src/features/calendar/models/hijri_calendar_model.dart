class HijriDate {
  final int year;
  final int month;
  final int day;
  final String monthNameAr;
  final String monthNameFa;
  final String monthNameEn;

  const HijriDate({
    required this.year,
    required this.month,
    required this.day,
    required this.monthNameAr,
    required this.monthNameFa,
    required this.monthNameEn,
  });

  Map<String, dynamic> toMap() => {
        'year': year,
        'month': month,
        'day': day,
        'monthNameAr': monthNameAr,
        'monthNameFa': monthNameFa,
        'monthNameEn': monthNameEn,
      };

  factory HijriDate.fromMap(Map<String, dynamic> map) => HijriDate(
        year: map['year'] as int,
        month: map['month'] as int,
        day: map['day'] as int,
        monthNameAr: map['monthNameAr'] as String,
        monthNameFa: map['monthNameFa'] as String,
        monthNameEn: map['monthNameEn'] as String,
      );
}

class IslamicOccasion {
  final String titleFa;
  final String titleEn;
  final int hijriMonth;
  final int hijriDay;
  final bool isMajorHoliday;
  final String descriptionFa;
  final String descriptionEn;
  final int? recommendedSurah;

  const IslamicOccasion({
    required this.titleFa,
    required this.titleEn,
    required this.hijriMonth,
    required this.hijriDay,
    required this.isMajorHoliday,
    required this.descriptionFa,
    required this.descriptionEn,
    this.recommendedSurah,
  });

  Map<String, dynamic> toMap() => {
        'titleFa': titleFa,
        'titleEn': titleEn,
        'hijriMonth': hijriMonth,
        'hijriDay': hijriDay,
        'isMajorHoliday': isMajorHoliday,
        'descriptionFa': descriptionFa,
        'descriptionEn': descriptionEn,
        if (recommendedSurah != null) 'recommendedSurah': recommendedSurah,
      };

  factory IslamicOccasion.fromMap(Map<String, dynamic> map) => IslamicOccasion(
        titleFa: map['titleFa'] as String,
        titleEn: map['titleEn'] as String,
        hijriMonth: map['hijriMonth'] as int,
        hijriDay: map['hijriDay'] as int,
        isMajorHoliday: map['isMajorHoliday'] as bool,
        descriptionFa: map['descriptionFa'] as String,
        descriptionEn: map['descriptionEn'] as String,
        recommendedSurah: map['recommendedSurah'] as int?,
      );
}

class MoonPhase {
  final String phaseNameFa;
  final String phaseNameEn;
  final double illuminationPercent;
  final String icon;

  const MoonPhase({
    required this.phaseNameFa,
    required this.phaseNameEn,
    required this.illuminationPercent,
    required this.icon,
  });

  Map<String, dynamic> toMap() => {
        'phaseNameFa': phaseNameFa,
        'phaseNameEn': phaseNameEn,
        'illuminationPercent': illuminationPercent,
        'icon': icon,
      };

  factory MoonPhase.fromMap(Map<String, dynamic> map) => MoonPhase(
        phaseNameFa: map['phaseNameFa'] as String,
        phaseNameEn: map['phaseNameEn'] as String,
        illuminationPercent: (map['illuminationPercent'] as num).toDouble(),
        icon: map['icon'] as String,
      );
}
