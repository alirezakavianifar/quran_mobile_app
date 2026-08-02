# Quran Page Indicator Implementation Plan

## Problem Statement
When reading Quran verses, users need to know which page of the Quran they are currently reading. Currently, the database stores `pageNumber` and `juzNumber` for each verse, but this information is not visible in the `VerseDetailView` UI.

## Proposed Changes

### 1. Localization Updates
- Update `src/quran_mobile_app/lib/src/core/localization/app_localizations.dart`:
  - Add `page` ('صفحه' / 'Page') and `juz` ('جزء' / 'Juz') translations in Persian and English.

### 2. UI Enhancements in Verse Detail Reader (`VerseDetailView`)
- Update `src/quran_mobile_app/lib/src/features/reader/verse_detail_view.dart`:
  - **Dynamic AppBar Header**: Show the current active page and juz in the `AppBar` subtitle / title area (e.g. `صفحه ۱ • جزء ۱` / `Page 1 • Juz 1`).
  - **Scroll Awareness**: Add a `ScrollController` listener to detect the top visible verse and dynamically update the visible page number in the header as the user scrolls.
  - **Verse Card Page Badge**: Display a page badge on each verse card header alongside the Ayah number (e.g. `[۱:۱] • صفحه ۱`).
  - **Page Transition Dividers**: When `pageNumber` changes between consecutive verses in a Surah, render a prominent visual Quran page boundary divider (e.g. `─── صفحه ۲ ───`).

### 3. Automated Tests
- Add/update unit and widget tests in `src/quran_mobile_app/test/` to verify page number rendering and localization.

## Verification Plan
### Automated Tests
- Execute `flutter test` inside `src/quran_mobile_app` directory to verify all tests pass without errors.
