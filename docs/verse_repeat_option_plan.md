# Verse Repeat Option (تکرار آیه) Implementation Plan

## Goal Description
Implement configurable Verse Repeat options (1x, 2x, 3x, 5x, 10x, and Infinite $\infty$) in the Quran audio player engine and settings, allowing continuous repetition of individual verses for Quran memorization (حفظ), Tajweed mastery, and study.

---

## 1. Requirements & Architecture
- **Repeat Multipliers**:
  - `1`: Play once (Default)
  - `2`: Repeat twice
  - `3`: Repeat 3 times
  - `5`: Repeat 5 times
  - `10`: Repeat 10 times
  - `-1`: Infinite repeat ($\infty$)
- **Audio Engine Lifecycle**:
  - `_onAudioCompleted` checks if `currentVersePlayCount < verseRepeatCount` or `verseRepeatCount == -1`.
  - Replays current verse if repeats remain.
  - Automatically advances to the next verse once repeat count is satisfied (if `autoPlayNext` is enabled).
- **In-Player UI**:
  - PopupMenuButton in `AudioPlayerBottomBar` with badge showing current repeat mode.
- **Settings Screen**:
  - Setting in `SettingsScreen` under Audio & Recitation section.

---

## 2. Implementation Steps
1. Update `UserSettings` with `defaultVerseRepeatCount: int`.
2. Update `AudioPlayerState` & `AudioPlayerNotifier` with repeat counter and loop logic.
3. Update `AudioPlayerBottomBar` with repeat selector menu.
4. Add localization strings to `AppLocalizations`.
5. Add setting dropdown in `SettingsScreen`.
6. Write unit tests in `test/audio_player_test.dart` and `test/settings_test.dart`.
