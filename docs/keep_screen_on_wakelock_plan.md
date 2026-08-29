# Keep Screen On (WakeLock) Implementation Plan

## Goal Description
Implement a configurable "Keep Screen On" (همیشه روشن ماندن صفحه هنگام قرائت) feature using `wakelock_plus` to prevent mobile devices from sleeping or locking during Quran reading and recitation sessions.

---

## 1. Requirements & Architecture
- **Package**: `wakelock_plus: ^1.2.8`
- **Default State**: Enabled (`keepScreenOn: true`)
- **Settings Toggle**: `SwitchListTile` in `SettingsScreen` with localized text.
- **Lifecycle Handling**:
  - Automatically activates wakelock when opening `VerseDetailView` or playing audio.
  - Releases wakelock when navigating back or when audio stops.

---

## 2. Implementation Steps
1. Add `wakelock_plus` to `pubspec.yaml`.
2. Update `UserSettings` and `SettingsNotifier` with `keepScreenOn`.
3. Add localization keys in `AppLocalizations`.
4. Integrate `WakelockPlus` in `VerseDetailView`.
5. Add UI toggle in `SettingsScreen`.
6. Write unit tests in `test/settings_test.dart` and `test/wakelock_settings_test.dart`.
