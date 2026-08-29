# Verse Selection Action and Pre-Selected Interpretation Implementation Plan

## Goal Description
Provide a configurable mechanism where selecting a verse in the Quran Reader automatically triggers the user's preferred action (Listen to recitation or View Tafsir interpretation) based on pre-selected configuration, with persistent default Tafsir edition and seamless in-app audio controls.

---

## 1. Requirements & Architecture

### 1.1 Configurable Verse Tap Actions
Users can choose what happens when tapping on an ayah card in the Quran reader:
1. **Show Tafsir (`showTafsir`)**: Automatically opens the Tafsir modal/bottom sheet with the pre-selected Tafsir commentary edition.
2. **Play Audio Recitation (`playAudio`)**: Automatically triggers recitation for the selected verse using the pre-selected reciter and playback speed.
3. **Show Quick Actions Menu (`showMenu`)**: Opens an interactive action bottom sheet with direct shortcuts to:
   - Play Recitation
   - View Tafsir
   - Add/Remove Bookmark
   - Copy Ayah Text
   - Share Ayah

### 1.2 Persistent Default Tafsir Edition
- Persist `defaultTafsirEdition` in `UserSettings`:
  - `fa.noor` (تفسیر نور - حجت‌الاسلام قرائتی)
  - `fa.nemoneh` (تفسیر نمونه - آیت‌الله مکارم شیرازی)
  - `fa.almizan` (تفسیر المیزان - علامه طباطبایی)
  - `en.ibnkathir` (Tafsir Ibn Kathir - English)
- Opening Tafsir defaults to this pre-selected edition.
- Tafsir Bottom Sheet allows switching editions on the fly.

### 1.3 Audio Listening from Tafsir Modal
- Add a direct audio play/pause toggle in the Tafsir bottom sheet header, allowing users to listen to the verse recitation while reading its commentary.

---

## 2. Implementation Steps

### Phase 1: UserSettings & State Management
- Update `UserSettings` model with `defaultVerseTapAction` and `defaultTafsirEdition`.
- Update `SettingsNotifier` and `SettingsRepository` with serialization and update methods.
- Update `AppLocalizations` with English and Persian strings for the new settings.

### Phase 2: Settings Screen UI
- Add "Default Verse Tap Action" selector (`showTafsir` / `playAudio` / `showMenu`).
- Add "Default Tafsir Edition" dropdown in Settings screen.

### Phase 3: Quran Reader & Verse Selection
- Wrap verse card in `verse_detail_view.dart` with selection handler (`InkWell`).
- Execute action based on `settings.defaultVerseTapAction`.
- Maintain individual icon buttons on the card top bar (Play, Tafsir, Bookmark) for direct access.

### Phase 4: Tafsir View Enhancements
- Default edition initialized from `settings.defaultTafsirEdition`.
- Add audio play/pause button in Tafsir Bottom Sheet header.

### Phase 5: Automated Testing & Verification
- Unit tests for `UserSettings` serialization and updates.
- Unit & widget tests for verse selection action handling and Tafsir defaults.
- Run `flutter test`.
