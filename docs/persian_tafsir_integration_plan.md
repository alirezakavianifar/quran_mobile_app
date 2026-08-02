# Implementation Plan - Persian Quran Interpretation (Tafsir Noor / Nemoneh) Integration

This document outlines the architecture, data sources, and implementation strategy for integrating Persian Quran interpretations (specifically **Tafsir Noor by Hojjat al-Islam Mohsen Qara'ati** and **Tafsir Nemoneh by Grand Ayatollah Makarem Shirazi**) into the Quran Mobile App.

---

## 1. Research & Data Source Analysis

### 1.1 Famous Persian Quran Interpretations Overview
1. **Tafsir Noor (تفسیر نور - دکتر محسن قرائتی)**:
   - **Characteristics**: Concise, highly practical, structured with bullet points (*پیام‌های آیه* - Lessons/Messages), ideal for quick reading per verse.
   - **Suitability**: Most requested for mobile apps due to its bullet-point structure and accessibility.
2. **Tafsir Nemoneh (تفسیر نمونه - آیت‌الله مکارم شیرازی)**:
   - **Characteristics**: Comprehensive, analytical, covers historical background (*شأن نزول*), vocabulary breakdown, and modern sociological/theological explanations.
   - **Suitability**: Great for deeper study.
3. **Tafsir Al-Mizan (تفسیر المیزان - علامه طباطبائی)**:
   - **Characteristics**: Deep philosophical and Quran-explains-Quran thematic commentary.

### 1.2 Data Availability & Ingestion Strategy
- **Local Asset / Data Seed**: The project repository already contains curated structured Tafsir data in `data/processed/tafsir.json` and `quran_platform.db` with `fa.noor` (Tafsir Noor) and `fa.nemoneh` (Tafsir Nemoneh) entries mapped by `global_verse_id` and `ayah_key`.
- **API Support**: The backend C# API (`QuranPlatform.API`) provides `GET /api/v1/tafsir/{key}/{editionId}`.
- **Offline First Mobile Storage**: The mobile app uses Drift SQLite (`app_database.dart`) with a pre-created `Tafsirs` table for fast offline lookup per verse.

---

## 2. Proposed Architectural Changes

### 2.1 Database & Repository Enhancements (`AppDatabase`)
- Add `getTafsirForVerse(int verseId, {String editionId = 'fa.noor'})` query method in `AppDatabase`.
- Add seeding logic `seedTafsirsForSurah(int surahNumber)` or lazy loading of Tafsir entries from `tafsir.json` asset into local Drift SQLite.

### 2.2 Riverpod Providers (`TafsirProvider`)
- Create `tafsirProvider` (Family FutureProvider using `(verseId, editionId)`) in `lib/src/features/tafsir/tafsir_provider.dart`.
- Support active edition state with `selectedTafsirEditionProvider`.

### 2.3 User Settings Integration
- Add `defaultTafsirEdition` setting in `settings_provider.dart` (options: `fa.noor` [Tafsir Noor - Qaraati], `fa.nemoneh` [Tafsir Nemoneh], `fa.almizan`, `en.ibnkathir`).

### 2.4 UI Integration in `VerseDetailView`
- Add a Tafsir button (`Icons.auto_stories` / `Icons.menu_book`) on each verse card header in `verse_detail_view.dart`.
- Build a custom Flutter modal bottom sheet (`TafsirBottomSheet`):
  - **Header**: Surah name, Ayah key `[سوره X : آیه Y]`, and Tafsir Edition dropdown selector.
  - **Body**: Smooth scrollable view displaying the commentary with Persian typography, support for "پیام‌ها" (messages/lessons), line spacing, and font resizing.
  - **Footer/Actions**: Option to copy tafsir text, bookmark, or close.

---

## 3. Implementation Steps

### Phase 1: Data & Database Preparation
- Verify and ensure `tafsir.json` includes entries for `fa.noor` (Tafsir Noor) and `fa.nemoneh`.
- Add Drift queries and data seeding helpers in `AppDatabase`.

### Phase 2: State Management & Provider Setup
- Implement `tafsir_provider.dart` with Riverpod for fetching, caching, and switching Tafsir editions per verse.
- Update `app_localizations.dart` for Persian / English Tafsir titles and labels.

### Phase 3: UI Implementation
- Build `TafsirBottomSheet` widget with rich styling (Glassmorphic cards, RTL Persian font, copy to clipboard button).
- Connect Tafsir action button in `VerseDetailView` cards to open the modal bottom sheet.

### Phase 4: Verification & Automated Tests
- Run `flutter test` to ensure database and UI components pass cleanly.
- Perform visual verification in Flutter Web / Mobile.

---

## 4. Verification Plan

### Automated Tests
- Test database Tafsir retrieval query in `AppDatabase`.
- Test `tafsirProvider` state emitting correct Tafsir content.

### Manual Verification
- Launch Flutter Web app (`http://127.0.0.1:8085`).
- Open a Surah (e.g. Surah Al-Fatihah or Al-Baqarah).
- Tap the Tafsir button on a verse card.
- Verify Persian commentary from **تفسیر نور (استاد قرائتی)** renders correctly in RTL with proper typography.
- Switch edition to **تفسیر نمونه** and verify content updates immediately.
