# Personal Ayah Notes & Multi-Color Highlights + Qibla Compass & Prayer Times Calculation Plan

## Goal Description
Implement:
1. **Personal Ayah Notes & Multi-Color Highlights (یادداشت‌نویسی و هایلایت چندرنگ آیات)** with 5 color themes (Green, Gold, Blue, Purple, Orange), inline card decoration, and a Notes Hub.
2. **Qibla Compass & Prayer Times Engine (قبله‌نما و محاسبه دقیق اوقات شرعی)** with astronomical calculations (University of Tehran, MWL, Umm al-Qura, ISNA), live next-prayer countdown, and trigonometric Qibla compass bearing to Kaaba.

---

## Implementation Outline
1. **Ayah Notes & Highlights**:
   - `AyahNote` model with 5 preset color hexes.
   - `AyahNotesRepository` and `ayahNotesProvider`.
   - `NotesHubScreen` for browsing notes/highlights.
   - Decorate `VerseDetailView` cards with background color tint and note badge.
2. **Qibla Compass & Prayer Times**:
   - `PrayerCalculator` with solar algorithms and Qibla spherical trigonometry.
   - `PrayerTimesProvider` managing city presets and live countdown.
   - `PrayerTimesScreen` with visual compass dial and 7-prayer schedule.
3. **Integration & Localization**:
   - AppLocalizations with Persian/English strings.
   - AppBar action buttons in `SurahListView`.
4. **Testing**:
   - Unit tests in `test/prayer_and_qibla_test.dart` and `test/ayah_notes_test.dart`.
