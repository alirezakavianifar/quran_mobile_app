# Remove Parenthetical Persian Translations from Surah Names Plan

## Context
In the Quran Mobile App, `namePersian` for each surah currently contains the Persian translation of the surah name inside parentheses, e.g. `حمد (گشایش)` or `بقره (گاو ماده)`. The user requested to remove the parenthetical translations so only clean Surah names remain.

## Objectives
1. Update `surah_seed_data.dart` to strip all parenthetical translations from `namePersian` across all 114 Surahs.
2. Update `app_database.dart` so `seedInitialData()` refreshes existing SQLite/Drift surah entries with cleaned data.
3. Update `surah_list_view.dart`, `verse_detail_view.dart`, and `tafsir_bottom_sheet.dart` to format Surah names cleanly without parenthetical meanings.

## Phases
- Phase 1: Update `surah_seed_data.dart` and `app_database.dart`.
- Phase 2: Update UI list and detail views.
- Phase 3: Run unit and integration tests.
