import 'dart:convert';

class UserSettings {
  final String arabicFontFamily; // 'Amiri', 'Scheherazade New', 'Lateef'
  final double arabicFontSize;
  final double translationFontSize;
  final bool showTranslation;
  final bool showTransliteration;
  final String defaultReciterId; // 'parhizgar', 'alafasy', 'basit'
  final double playbackSpeed;
  final bool autoScrollAudio;
  final String themeMode; // 'system', 'light', 'dark', 'sepia'
  final String appLanguage; // 'fa', 'en'
  final bool hybridSearchEnabled;
  final bool autoSyncWifiOnly;
  final String defaultVerseTapAction; // 'showTafsir', 'playAudio', 'showMenu'
  final String defaultTafsirEdition; // 'fa.noor', 'fa.nemoneh', 'fa.almizan', 'en.ibnkathir'

  const UserSettings({
    this.arabicFontFamily = 'Amiri',
    this.arabicFontSize = 24.0,
    this.translationFontSize = 16.0,
    this.showTranslation = true,
    this.showTransliteration = false,
    this.defaultReciterId = 'parhizgar',
    this.playbackSpeed = 1.0,
    this.autoScrollAudio = true,
    this.themeMode = 'system',
    this.appLanguage = 'fa',
    this.hybridSearchEnabled = true,
    this.autoSyncWifiOnly = true,
    this.defaultVerseTapAction = 'showTafsir',
    this.defaultTafsirEdition = 'fa.noor',
  });

  UserSettings copyWith({
    String? arabicFontFamily,
    double? arabicFontSize,
    double? translationFontSize,
    bool? showTranslation,
    bool? showTransliteration,
    String? defaultReciterId,
    double? playbackSpeed,
    bool? autoScrollAudio,
    String? themeMode,
    String? appLanguage,
    bool? hybridSearchEnabled,
    bool? autoSyncWifiOnly,
    String? defaultVerseTapAction,
    String? defaultTafsirEdition,
  }) {
    return UserSettings(
      arabicFontFamily: arabicFontFamily ?? this.arabicFontFamily,
      arabicFontSize: arabicFontSize ?? this.arabicFontSize,
      translationFontSize: translationFontSize ?? this.translationFontSize,
      showTranslation: showTranslation ?? this.showTranslation,
      showTransliteration: showTransliteration ?? this.showTransliteration,
      defaultReciterId: defaultReciterId ?? this.defaultReciterId,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      autoScrollAudio: autoScrollAudio ?? this.autoScrollAudio,
      themeMode: themeMode ?? this.themeMode,
      appLanguage: appLanguage ?? this.appLanguage,
      hybridSearchEnabled: hybridSearchEnabled ?? this.hybridSearchEnabled,
      autoSyncWifiOnly: autoSyncWifiOnly ?? this.autoSyncWifiOnly,
      defaultVerseTapAction: defaultVerseTapAction ?? this.defaultVerseTapAction,
      defaultTafsirEdition: defaultTafsirEdition ?? this.defaultTafsirEdition,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'arabicFontFamily': arabicFontFamily,
      'arabicFontSize': arabicFontSize,
      'translationFontSize': translationFontSize,
      'showTranslation': showTranslation,
      'showTransliteration': showTransliteration,
      'defaultReciterId': defaultReciterId,
      'playbackSpeed': playbackSpeed,
      'autoScrollAudio': autoScrollAudio,
      'themeMode': themeMode,
      'appLanguage': appLanguage,
      'hybridSearchEnabled': hybridSearchEnabled,
      'autoSyncWifiOnly': autoSyncWifiOnly,
      'defaultVerseTapAction': defaultVerseTapAction,
      'defaultTafsirEdition': defaultTafsirEdition,
    };
  }

  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      arabicFontFamily: map['arabicFontFamily'] as String? ?? 'Amiri',
      arabicFontSize: (map['arabicFontSize'] as num?)?.toDouble() ?? 24.0,
      translationFontSize: (map['translationFontSize'] as num?)?.toDouble() ?? 16.0,
      showTranslation: map['showTranslation'] as bool? ?? true,
      showTransliteration: map['showTransliteration'] as bool? ?? false,
      defaultReciterId: map['defaultReciterId'] as String? ?? 'parhizgar',
      playbackSpeed: (map['playbackSpeed'] as num?)?.toDouble() ?? 1.0,
      autoScrollAudio: map['autoScrollAudio'] as bool? ?? true,
      themeMode: map['themeMode'] as String? ?? 'system',
      appLanguage: map['appLanguage'] as String? ?? 'fa',
      hybridSearchEnabled: map['hybridSearchEnabled'] as bool? ?? true,
      autoSyncWifiOnly: map['autoSyncWifiOnly'] as bool? ?? true,
      defaultVerseTapAction: map['defaultVerseTapAction'] as String? ?? 'showTafsir',
      defaultTafsirEdition: map['defaultTafsirEdition'] as String? ?? 'fa.noor',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserSettings.fromJson(String source) =>
      UserSettings.fromMap(json.decode(source) as Map<String, dynamic>);
}
