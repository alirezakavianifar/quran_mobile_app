class ReminderSettings {
  final bool dailyAyahEnabled;
  final String dailyAyahTime;
  final bool khatmahReminderEnabled;
  final String khatmahTime;
  final bool fridayKahfReminderEnabled;
  final String fridayKahfTime;
  final bool morningAdhkarEnabled;
  final String morningTime;
  final bool eveningAdhkarEnabled;
  final String eveningTime;

  const ReminderSettings({
    this.dailyAyahEnabled = true,
    this.dailyAyahTime = '08:00',
    this.khatmahReminderEnabled = true,
    this.khatmahTime = '20:00',
    this.fridayKahfReminderEnabled = true,
    this.fridayKahfTime = '10:00',
    this.morningAdhkarEnabled = false,
    this.morningTime = '06:30',
    this.eveningAdhkarEnabled = false,
    this.eveningTime = '18:30',
  });

  Map<String, dynamic> toMap() => {
        'dailyAyahEnabled': dailyAyahEnabled,
        'dailyAyahTime': dailyAyahTime,
        'khatmahReminderEnabled': khatmahReminderEnabled,
        'khatmahTime': khatmahTime,
        'fridayKahfReminderEnabled': fridayKahfReminderEnabled,
        'fridayKahfTime': fridayKahfTime,
        'morningAdhkarEnabled': morningAdhkarEnabled,
        'morningTime': morningTime,
        'eveningAdhkarEnabled': eveningAdhkarEnabled,
        'eveningTime': eveningTime,
      };

  factory ReminderSettings.fromMap(Map<String, dynamic> map) => ReminderSettings(
        dailyAyahEnabled: (map['dailyAyahEnabled'] as bool?) ?? true,
        dailyAyahTime: (map['dailyAyahTime'] as String?) ?? '08:00',
        khatmahReminderEnabled: (map['khatmahReminderEnabled'] as bool?) ?? true,
        khatmahTime: (map['khatmahTime'] as String?) ?? '20:00',
        fridayKahfReminderEnabled: (map['fridayKahfReminderEnabled'] as bool?) ?? true,
        fridayKahfTime: (map['fridayKahfTime'] as String?) ?? '10:00',
        morningAdhkarEnabled: (map['morningAdhkarEnabled'] as bool?) ?? false,
        morningTime: (map['morningTime'] as String?) ?? '06:30',
        eveningAdhkarEnabled: (map['eveningAdhkarEnabled'] as bool?) ?? false,
        eveningTime: (map['eveningTime'] as String?) ?? '18:30',
      );

  ReminderSettings copyWith({
    bool? dailyAyahEnabled,
    String? dailyAyahTime,
    bool? khatmahReminderEnabled,
    String? khatmahTime,
    bool? fridayKahfReminderEnabled,
    String? fridayKahfTime,
    bool? morningAdhkarEnabled,
    String? morningTime,
    bool? eveningAdhkarEnabled,
    String? eveningTime,
  }) {
    return ReminderSettings(
      dailyAyahEnabled: dailyAyahEnabled ?? this.dailyAyahEnabled,
      dailyAyahTime: dailyAyahTime ?? this.dailyAyahTime,
      khatmahReminderEnabled:
          khatmahReminderEnabled ?? this.khatmahReminderEnabled,
      khatmahTime: khatmahTime ?? this.khatmahTime,
      fridayKahfReminderEnabled:
          fridayKahfReminderEnabled ?? this.fridayKahfReminderEnabled,
      fridayKahfTime: fridayKahfTime ?? this.fridayKahfTime,
      morningAdhkarEnabled: morningAdhkarEnabled ?? this.morningAdhkarEnabled,
      morningTime: morningTime ?? this.morningTime,
      eveningAdhkarEnabled: eveningAdhkarEnabled ?? this.eveningAdhkarEnabled,
      eveningTime: eveningTime ?? this.eveningTime,
    );
  }
}
