# Last Read Verse Tracking & Resume Study Implementation Plan

## Problem Description
Users currently have no automatic tracking of their last studied or listened Quran verse. When returning to the app or opening a Surah, the reader always starts from verse 1 (top of the Surah), and the Home Screen lacks a direct "Continue Reading / Resume Study" widget to jump back to where they left off.

## Proposed Solution
Build an automatic "Last Read / Study History" tracking and resume system:
1. **`LastReadModel` & Storage**: Persist the latest reading/listening session (`surahId`, `verseNumber`, `pageNumber`, `juzNumber`, `surahNameArabic`, `surahNamePersian`, `surahNameEnglish`, `timestamp`).
2. **`LastReadNotifier` Provider**: Expose reactive state for the most recent reading position with save/get/clear operations.
3. **Auto-Tracking in `VerseDetailView`**:
   - As the user scrolls through verses, study tafsir, or listens to audio recitation, update the last-read position.
4. **Direct Verse Jumping in `VerseDetailView`**:
   - Accept an optional `initialVerseNumber` parameter.
   - Automatically smooth-scroll or jump to the designated verse upon opening.
5. **"Continue Reading" Home Banner**:
   - Add a sleek "Continue Reading" (آخرین مطالعه) card at the top of `SurahListView`.
   - Displays last studied Surah, Ayah number, page number, and a 1-tap "Resume" action.
6. **Bilingual Localization**:
   - Add English and Persian translations for all new UI strings.

---

## Proposed Changes

### Data & State Layer

#### [NEW] [last_read_model.dart](file:///e:/projects/quran_mobile_app/src/quran_mobile_app/lib/src/features/reader/models/last_read_model.dart)
- Model `LastReadEntry` containing `surahId`, `verseNumber`, `pageNumber`, `juzNumber`, `surahNameArabic`, `surahNamePersian`, `surahNameEnglish`, `timestamp`.
- Serializers `toMap()` and `fromMap()`.

#### [NEW] [last_read_provider.dart](file:///e:/projects/quran_mobile_app/src/quran_mobile_app/lib/src/features/reader/last_read_provider.dart)
- `LastReadRepository` backed by `SharedPreferences`.
- `LastReadNotifier` extending `StateNotifier<LastReadEntry?>`.
- Methods: `saveLastRead(...)`, `loadLastRead()`, `clearLastRead()`.

---

### Presentation Layer

#### [MODIFY] [verse_detail_view.dart](file:///e:/projects/quran_mobile_app/src/quran_mobile_app/lib/src/features/reader/verse_detail_view.dart)
- Add optional `final int? initialVerseNumber;` to `VerseDetailView`.
- In `initState` / `postFrameCallback`:
  - If `initialVerseNumber != null`, call `_scrollToVerse(widget.initialVerseNumber!, animate: false)`.
- In `_onScroll` and audio listener:
  - Record the latest visible or active verse to `lastReadProvider`.
- When tapping on a verse (selecting tafsir/actions), record to `lastReadProvider`.

#### [MODIFY] [surah_list_view.dart](file:///e:/projects/quran_mobile_app/src/quran_mobile_app/lib/src/features/reader/surah_list_view.dart)
- Add `_buildLastReadBanner(BuildContext context, LastReadEntry lastRead, List<Surah> surahs)` widget.
- Position the banner above the Surah catalog.
- Tapping the banner finds the matching Surah and navigates to `VerseDetailView(surah: surah, initialVerseNumber: lastRead.verseNumber)`.

---

### Localization

#### [MODIFY] [app_localizations.dart](file:///e:/projects/quran_mobile_app/src/quran_mobile_app/lib/src/core/localization/app_localizations.dart)
- Add keys:
  - `lastRead`: 'آخرین مطالعه' / 'Last Read'
  - `continueReading`: 'ادامه مطالعه' / 'Continue Reading'
  - `resumedAtVerse`: 'ادامه از آیه' / 'Resumed at Verse'
  - `lastReadTime`: 'زمان آخرین مطالعه' / 'Last Read Time'

---

### Testing

#### [NEW] [last_read_test.dart](file:///e:/projects/quran_mobile_app/src/quran_mobile_app/test/last_read_test.dart)
- Unit tests for:
  - `LastReadEntry` serialization/deserialization.
  - `LastReadNotifier` saving and loading state from `SharedPreferences`.
  - State clearing and edge cases.

---

## Verification Plan

### Automated Tests
- `flutter test test/last_read_test.dart`
- Full test suite: `flutter test`

### Manual Verification
- Open a Surah (e.g. Al-Baqarah), scroll to Ayah 50 or listen to audio up to Ayah 10.
- Return to the Home Screen (`SurahListView`) and confirm the "Continue Reading" banner displays the last read position.
- Tap "Continue Reading" and verify the app immediately jumps directly to that verse in `VerseDetailView`.
- Toggle between Persian and English to ensure RTL/LTR and translated strings are rendered accurately.
