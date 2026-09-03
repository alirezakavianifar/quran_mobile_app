# Implementation Plan — Quick Quran Page Jump (پرش سریع به صفحه)

## Overview
This feature enables users to quickly jump directly to any of the 604 standard Medina pages of the Holy Quran from anywhere in the app (e.g. typing "456", "page 456", "صفحه ۴۵۶", or using a dedicated quick-jump modal).

---

## Key Requirements & User Experience

1. **Smart Search Bar Page Detection (`SurahListView`)**:
   - Detects when the search query contains a page number ($1 \le \text{page} \le 604$ in English or Persian digits, e.g. `456`, `۴۵۶`, `page 456`, `صفحه ۴۵۶`, `ص ۴۵۶`, `p 456`).
   - Renders a prominent, high-priority **"Go to Page" (رفتن به صفحه)** hero card directly above or at the top of the search list.
   - Displays live metadata for that page: Surah name(s), Ayah range, verse count, and Juz number.
   - Pressing "Enter" or tapping the card navigates directly to the target page and Ayah in `VerseDetailView`.

2. **Dedicated Quick Page Jump Dialog (`QuickPageJumpDialog`)**:
   - Accessible via:
     - A dedicated AppBar action button (`Icons.find_in_page_rounded`) in `SurahListView`.
     - A dedicated AppBar action button or tapping the Page/Juz header badge in `VerseDetailView`.
   - Clean, modern UI with:
     - Large number input field with validation (1 to 604) supporting Persian & English digits.
     - Live dynamic preview card showing Surah name, Ayah range, and Juz using `QuranPageData.getPageSummary(pageNumber)`.
     - Quick navigation chips: `[صفحه ۱]`, `[صفحه ۱۰۰]`, `[صفحه ۲۰۰]`, `[صفحه ۳۰۰]`, `[صفحه ۴۰۰]`, `[صفحه ۵۰۰]`, `[صفحه ۶۰۴]`, `[صفحه تصادفی 🎲]`.
     - Fine-tuning stepper buttons (`-10`, `-1`, `+1`, `+10`).
     - Primary button: **"Go to Page" (برو به صفحه)**.

3. **In-Reader Smooth Scrolling & Cross-Surah Navigation**:
   - If already inside `VerseDetailView` and the target page belongs to the current Surah, smoothly scroll directly to that page's first verse using `_scrollToVerse()`.
   - If the target page belongs to a different Surah, seamlessly transition using `Navigator.pushReplacement()`.

4. **Localization**:
   - Bilingual strings in Persian and English (`quickPageJump`, `goToPage`, `enterPageNumber`, `pageNotFound`, `randomPage`, etc.).

---

## Proposed File Changes

- **[NEW] `src/quran_mobile_app/lib/src/features/reader/quick_page_jump_dialog.dart`**:
  - Reusable modal dialog for jumping to any Quran page (1–604) with real-time preview and presets.
- **[MODIFY] `src/quran_mobile_app/lib/src/features/reader/surah_list_view.dart`**:
  - Add search bar page query parsing and "Go to Page" hero card.
  - Add AppBar action button for Quick Page Jump.
- **[MODIFY] `src/quran_mobile_app/lib/src/features/reader/verse_detail_view.dart`**:
  - Add AppBar action button for Quick Page Jump.
  - Make the Page & Juz header badge clickable to open the dialog.
  - Support instant intra-surah scrolling or inter-surah replacement when jumping.
- **[MODIFY] `src/quran_mobile_app/lib/src/core/localization/app_localizations.dart`**:
  - Add Persian and English localization keys for quick page jump.
- **[NEW] `src/quran_mobile_app/test/quick_page_jump_test.dart`**:
  - Comprehensive unit and widget tests for page parsing, resolution, and navigation.

---

## Verification Plan
- Automated unit tests for page number parsing in Persian and English.
- Automated tests verifying navigation to Page 456 (Surah 38 Sad, Verse 43).
- Full application test suite run (`flutter test`).
- Up-to-date `README.md` documentation.
