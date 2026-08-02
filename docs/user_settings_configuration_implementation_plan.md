# User Settings & Configurations Implementation Plan

This implementation plan outlines the architecture, data models, state management, UI components, and feature integrations required to provide comprehensive end-user settings and configurations in the Quran Mobile App.

---

## 1. Objectives & Overview

The goal is to provide end-users with full control over their app experience through a centralized, reactive, and persistent Settings System.

### Key Settings Categories:
1. **Quran Reader & Typography**: Arabic script font, Arabic font size, translation font size, active translations/Tafsir, transliteration, Tajweed, and view mode (list vs Mushaf page).
2. **Audio & Recitation**: Default Reciter selection (e.g., Shahriar Parhizgar, Mishary Alafasy), playback speed, auto-scroll/highlight on playback, repeat mode.
3. **AI & Search**: AI response language, hybrid search toggle, context inclusion preference.
4. **Theme & Localization**: Theme mode (Light, Dark, System, Sepia reading mode), app interface language (`fa` / `en`).
5. **Sync & Cache Management**: Auto-sync over Wi-Fi, manual sync trigger, clear audio cache / data management.

---

## 2. User Review Required

> [!IMPORTANT]
> - **Persistence Mechanism**: We plan to use `shared_preferences` (or Drift local storage key-value table) for persisting user preferences across app restarts.
> - **Sepia / Reading Mode**: A new Sepia reading mode (warm background for night reading) will be added alongside Light & Dark themes in `AppTheme`.
> - **Navigation Integration**: A Settings icon will be added to the top AppBar or as a dedicated 5th tab in `MainNavigationScreen`.

---

## 3. Proposed Architecture & Changes

```
src/quran_mobile_app/lib/src/
├── core/
│   ├── theme/
│   │   └── app_theme.dart                # Add Sepia mode & dynamic font styling
│   └── settings/                         # NEW: Settings core module
│       ├── models/
│       │   └── user_settings.dart        # Immutable Settings state model
│       ├── settings_repository.dart      # SharedPreferences persistence layer
│       └── settings_provider.dart        # Riverpod notifier for global state
└── features/
    ├── settings/                         # NEW: Settings UI module
    │   ├── settings_screen.dart          # Main settings hub screen
    │   └── widgets/
    │       ├── reader_settings_card.dart  # Font sizes, script picker, preview
    │       ├── audio_settings_card.dart   # Reciter selector, speed slider
    │       ├── ai_search_settings_card.dart
    │       └── storage_sync_card.dart    # Cache cleaner, sync status
    ├── reader/
    │   └── verse_detail_view.dart        # Bind font sizes & script to settings state
    └── audio/
        └── audio_player_service.dart     # Bind default reciter & speed to settings state
```

---

## 4. Implementation Phases

### Component 1: Core Settings Data Model & Repository
#### [NEW] [user_settings.dart](file:///e:/projects/quran_mobile_app/src/quran_mobile_app/lib/src/core/settings/models/user_settings.dart)
Define `UserSettings` class with default values and JSON/SharedPreferences conversion.
- `arabicFontFamily`: Default `'Uthmani'`
- `arabicFontSize`: Default `24.0`
- `translationFontSize`: Default `16.0`
- `showTranslation`: Default `true`
- `showTransliteration`: Default `false`
- `defaultReciterId`: Default `'parhizgar'`
- `playbackSpeed`: Default `1.0`
- `autoScrollAudio`: Default `true`
- `themeMode`: Default `'system'` (`system`, `light`, `dark`, `sepia`)
- `appLanguage`: Default `'fa'`

#### [NEW] [settings_repository.dart](file:///e:/projects/quran_mobile_app/src/quran_mobile_app/lib/src/core/settings/settings_repository.dart)
- Handles loading and saving `UserSettings` to `SharedPreferences`.

#### [NEW] [settings_provider.dart](file:///e:/projects/quran_mobile_app/src/quran_mobile_app/lib/src/core/settings/settings_provider.dart)
- `StateNotifier<UserSettings>` / `Notifier<UserSettings>` providing reactive mutation methods (`updateArabicFontSize`, `updateTheme`, `updateReciter`, `resetDefaults`).

---

### Component 2: Settings UI Components & Navigation
#### [NEW] [settings_screen.dart](file:///e:/projects/quran_mobile_app/src/quran_mobile_app/lib/src/features/settings/settings_screen.dart)
- Build responsive, scrollable Settings screen with categorized cards & live previews (e.g. sample Quran verse font resizing preview).

#### [MODIFY] [main.dart](file:///e:/projects/quran_mobile_app/src/quran_mobile_app/lib/main.dart)
- Add Settings navigation tab to `MainNavigationScreen`.
- Connect `themeMode` and `locale` to `settingsProvider`.

---

### Component 3: Feature Integrations
#### [MODIFY] [verse_detail_view.dart](file:///e:/projects/quran_mobile_app/src/quran_mobile_app/lib/src/features/reader/verse_detail_view.dart)
- Consume `settingsProvider` to dynamically render Arabic font size, translation font size, font family, and show/hide options.

#### [MODIFY] [app_theme.dart](file:///e:/projects/quran_mobile_app/src/quran_mobile_app/lib/src/core/theme/app_theme.dart)
- Support Sepia reading theme parameters.

---

## 5. Verification Plan

### Automated Tests
- `flutter test test/core/settings/settings_repository_test.dart`: Test saving, loading, and fallback defaults.
- `flutter test test/features/settings/settings_screen_test.dart`: Test UI interaction and state updates when changing sliders and toggles.

### Manual Verification
- Launch app in web/emulator (`flutter run`).
- Change font size slider and confirm live update on Reader screen.
- Switch theme to Dark / Sepia / Light and confirm instant application.
- Change reciter selection and verify audio playback uses selected reciter stream.
- Restart application to verify all settings persist across sessions.
