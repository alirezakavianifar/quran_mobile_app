# Quran Whole-Page Repeat (Hifz & Memorization Mode) Implementation Plan

## Goal Description
Implement whole-page repetition (`تکرار صفحه کامل قرآن جهت حفظ و تثبیت`) alongside the existing verse-range repeat feature. Users will be able to select any page of the Quran (e.g. Page 23, containing Surah Al-Baqarah Ayahs 146 to 153) and loop through all verses on that page with configurable cycle counts (1x, 2x, 3x, 5x, 10x, and Infinite $\infty$) for Quran memorization (حفظ).

---

## 1. Requirements & Architecture

### 1.1 Quran Page Data Mapping (`QuranPageData`)
- The Quran has 604 standard Medina pages.
- While many pages reside within a single Surah (e.g. Page 23 has Surah 2:146-153), 51 pages span multiple Surahs (e.g. Page 106 spans Surah 4 and Surah 5; Page 604 contains Surahs 112, 113, and 114).
- A specialized helper `QuranPageData` will provide:
  - `List<PageVerseRef> getVersesForPage(int pageNumber)`: returns the exact ordered list of verses on that page with cached O(1) performance.
  - `QuranPageSummary getPageSummary(int pageNumber, {bool isPersian = true})`: returns a formatted human-readable summary (e.g. `سوره بقره • آیات ۱۴۶ تا ۱۵۳ (۸ آیه)`).
  - `int getPageForVerse(int surahId, int verseNumber)`.

### 1.2 Audio Player State & Lifecycle (`AudioPlayerNotifier`)
- Extend `AudioPlayerState` with:
  - `repeatPageNumber: int?` (1 to 604)
  - `pageVerses: List<PageVerseRef>?`
  - `currentPageVerseIndex: int` (0-indexed position within the page)
  - `pageLoopCount: int` (1, 2, 3, 5, 10, -1 for infinite)
  - `currentPageCycle: int` (1-indexed cycle counter)
  - `bool get isPageRepeatActive => repeatPageNumber != null && pageVerses != null && pageVerses!.isNotEmpty;`
- Lifecycle methods on `AudioPlayerNotifier`:
  - `Future<void> setPageRepeat({ required int pageNumber, int loopCount = 1, bool startPlaying = true })`
  - `void clearPageRepeat()`
- In `_onAudioCompleted`:
  - If `isPageRepeatActive` is true:
    - If there are remaining verses on the page (`currentPageVerseIndex + 1 < pageVerses.length`):
      - Advance index and call `playVerse(next.surahId, next.verseNumber, nextTotal)`.
    - If the end of the page is reached:
      - If `pageLoopCount == -1` or `currentPageCycle < pageLoopCount`:
        - Increment `currentPageCycle`, reset `currentPageVerseIndex = 0`, and loop back to the first verse of the page.
      - Else:
        - All cycles completed -> call `stop()`.

### 1.3 User Interface (UI) Integration
1. **Enhanced `VerseRangeDialog`**:
   - Provide a Segmented Toggle / TabBar:
     - **"تکرار بازه‌ای آیات" (Verse Range)**: select start/end Ayah.
     - **"تکرار کل صفحه" (Entire Page)**: select Page Number (1 to 604), default to current visible page (e.g. Page 23).
   - On the Page tab:
     - Page selector with preview card showing the Surah and verse range on that page.
     - Quick chips: `[صفحه فعلی]` (Current Page), `[صفحه بعد]` (Next Page), `[صفحه قبل]` (Previous Page).
     - Cycle multiplier: 1x, 2x, 3x, 5x, 10x, $\infty$.
     - "آغاز تکرار صفحه" (Start Page Loop) / "توقف تکرار صفحه" (Stop Page Loop).
2. **Page Divider Quick Action in `VerseDetailView`**:
   - On the Quran page divider (`─── صفحه ۲۳ • جزء ۲ ───`), add a dedicated "تکرار صفحه" (`Icons.repeat_rounded`) action button.
   - Tapping it opens the dialog pre-filled with that specific page.
3. **`AudioPlayerBottomBar` Integration**:
   - When Page Repeat is active:
     - Top banner shows: `صفحه فعال: صفحه ۲۳ • دور ۱ از ۵` (or `∞`) with a close button.
     - Bottom repeat button highlights as active: `تکرار صفحه ۲۳`.

### 1.4 Localization
- Persian and English translations in `AppLocalizations` for all page repeat labels and descriptions.

---

## 2. Implementation Steps
1. Create `src/quran_mobile_app/lib/src/features/audio/data/quran_page_data.dart` with page-to-verse mapping and summary utilities.
2. Update `AudioPlayerState` and `AudioPlayerNotifier` in `src/quran_mobile_app/lib/src/features/audio/presentation/audio_player_notifier.dart` with page repeat state, methods, and completion looping mechanics.
3. Enhance `VerseRangeDialog` in `src/quran_mobile_app/lib/src/features/audio/presentation/verse_range_dialog.dart` to support both Verse Range and Entire Page modes.
4. Update `AudioPlayerBottomBar` in `src/quran_mobile_app/lib/src/features/audio/presentation/audio_player_bottom_bar.dart` to render the active page repeat badge and controls.
5. Update `VerseDetailView` in `src/quran_mobile_app/lib/src/features/reader/verse_detail_view.dart` to add a quick-repeat button on page headers.
6. Add translation keys to `src/quran_mobile_app/lib/src/core/localization/app_localizations.dart`.
7. Write unit and widget tests in `src/quran_mobile_app/test/page_repeat_test.dart` and update `test/audio_player_test.dart`.
8. Run `flutter test` to ensure 100% passing tests.
