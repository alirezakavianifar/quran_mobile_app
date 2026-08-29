# Verse-Range Repeat (Hifz & Memorization Mode) Implementation Plan

## Goal Description
Implement Verse-Range Repeat (تکرار بازه‌ای آیات جهت حفظ و تثبیت قرآن) in the audio player engine to allow looping custom passages of verses (e.g., Ayah 1 to 5) with cycle multipliers (1x, 2x, 3x, 5x, 10x, ∞).

---

## 1. Architecture & Design
- **State Management (`AudioPlayerState`)**:
  - `rangeStartVerse: int?`
  - `rangeEndVerse: int?`
  - `rangeLoopCount: int` (1, 2, 3, 5, 10, -1)
  - `currentRangeCycle: int`
  - `isRangeRepeatActive: bool`
- **Playback Control (`AudioPlayerNotifier`)**:
  - Methods `setVerseRange(...)` and `clearVerseRange()`.
  - Automatic looping upon reaching `rangeEndVerse` until cycles are completed.
- **UI Components**:
  - `VerseRangeDialog` for configuring start/end verses and loop multipliers.
  - Active range badge on `AudioPlayerBottomBar`.
- **Localization**:
  - Persian & English translations for range repeat options.

---

## 2. Implementation Steps
1. Extend `AudioPlayerState` and `AudioPlayerNotifier` with verse range state and loop mechanics.
2. Add `VerseRangeDialog` component.
3. Update `AudioPlayerBottomBar` with range loop button and active status badge.
4. Update `AppLocalizations` with new strings.
5. Add unit tests to `test/audio_player_test.dart` and verify via `flutter test`.
