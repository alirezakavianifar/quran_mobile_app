# Phase 1 Step 4 — PostgreSQL Data Ingestion & Seeding Plan

This plan details the implementation of **Data Ingestion & Seeding** for the PostgreSQL database (`quran_postgres`) using the processed JSON datasets generated in Phase 0.

## User Review Required

> [!NOTE]
> All schema tables and indexes in `quran_db` were successfully initialized in Steps 1-3. This phase populates the database with Quranic text, translations, Tafsir commentaries, taxonomy metadata, and reciter information.

## Open Questions

None. The schema definitions and JSON dataset structures are fully mapped.

## Proposed Changes

### PostgreSQL Ingestion & Seeding Engine

#### [NEW] [seed_postgres.py](file:///e:/projects/quran_mobile_app/scripts/ingestion/seed_postgres.py)
- Python seeder module connecting to PostgreSQL via `psycopg2`.
- Reads processed JSON files from `data/processed/`:
  - `surahs.json` -> populates `"Surah"` table.
  - `verses.json` -> populates `"Verse"` table.
  - `translations.json` -> populates `"Translation"` table (`LanguageCode`: 'fa', 'en').
  - `tafsir.json` -> populates `"TafsirEdition"` and `"TafsirContent"` tables.
  - `metadata_taxonomy.json` -> populates `"Topic"` and `"Keyword"` tables.
- Employs batch insertion (`psycopg2.extras.execute_values`) for fast, transactional execution.

#### [NEW] [test_phase1_postgres.py](file:///e:/projects/quran_mobile_app/tests/test_phase1_postgres.py)
- Pytest suite verifying PostgreSQL data integrity and performance:
  - Verifies exact record counts for `"Surah"`, `"Verse"`, `"Translation"`, `"TafsirContent"`, `"Topic"`, `"Keyword"`.
  - Executes benchmark `EXPLAIN ANALYZE` join query to ensure query execution time is < 10ms.

#### [MODIFY] [phase_1_database_design_manual_guide.md](file:///e:/projects/quran_mobile_app/docs/phase_1_database_design_manual_guide.md)
- Update Step 4 instructions to document running `python -m scripts.ingestion.seed_postgres`.

#### [MODIFY] [README.md](file:///e:/projects/quran_mobile_app/README.md)
- Update setup instructions in `README.md` with PostgreSQL seeder execution command.

---

## Verification Plan

### Automated Tests
- Run `pytest tests/test_phase1_postgres.py -v` to verify database integrity and performance benchmarks.

### Manual Verification
- Run `docker exec -i quran_postgres psql -U quran_admin -d quran_db -c "SELECT COUNT(*) FROM \"Verse\";"` in terminal.
