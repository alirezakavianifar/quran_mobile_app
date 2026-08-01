# Implementation Plan - Fix Incomplete and Unrelated Surahs Content

## Problem Statement
In the Quran Flutter Mobile App, users reported two main issues (as visible in screenshots):
1. **Unrelated Surah Content**: Opening Surah 2 (Al-Baqarah) displays verses from Surah 6 (Al-An'am) under `[2:1]`, `[2:2]`, etc.
2. **Incomplete Surahs**: Some surahs do not show all their verses.

## Root Cause Analysis
1. **Surah ID vs Surah Number Mismatch in Reader View**:
   - `VerseDetailView` calls `ref.watch(surahVersesProvider(surah.id))` passing `surah.id` (the SQLite auto-increment primary key).
   - `surahVersesProvider` uses this value to look up `allQuranVersesMap[surahId]` and to query `verses.surahId`.
   - If `surah.id` diverges from `surah.number` (e.g., `surah.id` = 6 while `surah.number` = 2), `seedVersesForSurah(6)` seeds and fetches verses for Surah 6 (Al-An'am), while `VerseDetailView` formats the ayah badge as `[2:1]` using `surah.number` (2).
2. **Lack of Explicit Primary Key in Surah Seeding**:
   - In `surah_seed_data.dart`, `SurahsCompanion.insert(...)` did not explicitly set `id: Value(number)`. SQLite assigned auto-increment primary keys dynamically, leading to potential `id != number` drift.
3. **Flawed Surah Seed Guard for Incomplete Verses**:
   - `seedVersesForSurah` in `app_database.dart` checks `if (existing.isNotEmpty) return;`. If a surah had only 1 or 2 verses inserted from a previous partial run, it skipped completing the remaining verses.
4. **Translation Fetching Overhead**:
   - `surahVersesProvider` pulled the entire `translations` table into memory on every surah render rather than filtering by verse IDs of the active surah.

## Proposed Changes

### 1. `src/quran_mobile_app/lib/src/features/reader/verse_detail_view.dart`
- Change `surahVersesProvider(surah.id)` to `surahVersesProvider(surah.number)`.

### 2. `src/quran_mobile_app/lib/src/features/reader/reader_provider.dart`
- Rename parameter in `surahVersesProvider` from `surahId` to `surahNumber` for clarity.
- Query `db.verses` where `surahId == surahNumber`.
- Filter `db.translations` by the verse IDs of the loaded surah rather than selecting all rows.

### 3. `src/quran_mobile_app/lib/src/core/database/surah_seed_data.dart`
- Update all 114 `SurahsCompanion.insert(...)` calls to include `id: Value(number)`.

### 4. `src/quran_mobile_app/lib/src/core/database/app_database.dart`
- In `seedVersesForSurah(int surahNumber)`, update the check to `if (existing.length >= seedItems.length) return;`. If existing is smaller, clear the partial verses/translations for that surah and re-seed all verses completely.

## Verification Plan
1. **Unit & Database Verification**: Run Flutter/Dart tests and Python verification script to confirm all 114 surahs and 6,236 verses match their surah numbers accurately.
2. **Widget / App UI Verification**: Test reading Surah 1 (Al-Fatihah, 7 verses) and Surah 2 (Al-Baqarah, 286 verses) to ensure 100% complete content and correct verses.
