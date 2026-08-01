# Implementation Plan - Phase 0: Research & Data Curation

Phase 0 sets up the foundational data layer for the Quran Knowledge Platform, focusing on bilingual (Persian primary default, English secondary) Quran text, translations, commentaries (Tafsir), audio recitations, structured metadata, and NLP text normalization utilities.

## Objectives
1. **Quran Texts & Translations Data Ingestion**:
   - Arabic Text: Uthmani Script (KFGQPC) & Simple Arabic.
   - Persian Translations: Makarem Shirazi (Default), Fouladvand, Ansarian, Ghomshei, Khorramshahi.
   - English Translations: Dr. Mustafa Khattab (The Clear Quran - Default), Sahih International, Yusuf Ali, Pickthall.
   - Unified Verse Schema: `GlobalVerseID` (1..6236) | `SurahID` (1..114) | `VerseNumber`.

2. **Tafsir Commentaries Data Ingestion**:
   - Persian Tafsir: Tafsir Nemoneh (Makarem Shirazi - Primary Default), Al-Mizan, Tafsir Noor.
   - English Tafsir: Tafsir Ibn Kathir (Primary Default), Tafsir Al-Jalalayn, Ma'ariful Qur'an.

3. **Multilingual NLP Engine & Text Normalizer**:
   - Persian Character Unification (`ی`/`ي`, `ک`/`ك`), ZWNJ (نیم‌فاصله `\u200c`), Diacritics/Tashkeel Stripping, Persian Digit Conversion (`۰-۹` vs `0-9`).
   - English Lowercasing and Normalization.
   - Arabic Tashkeel Handling.

4. **Audio Metadata & Recitations**:
   - Reciters: Mishary Rashid Alafasy, Abdul Basit, Minshawi, Parhizgar, Khalil Al-Husary.
   - Metadata: Reciter IDs, Bitrates, Durations, URL formatting, Localized reciter titles in Persian and English.

5. **Rich Structured Verse Metadata & Taxonomy**:
   - Topics (موضوعات), Keywords (کلیدواژه‌ها), Prophets (پیامبران), Stories (داستان‌ها), Commands (اوامر), Warnings (نواهی), Revelation Order, Makki/Madani, Juz, Hizb, Page mapping.

6. **Validation & Testing Suite**:
   - Python `pytest` suite ensuring 100% coverage of 114 Surahs and 6,236 Verses across translations, correct normalizer operations, and link integrity for Tafsir entries.

---

## Planned File Structure

```
e:/projects/quran_mobile_app/
├── README.md
├── AGENTS.md
├── plan.md
├── .gitignore
├── docs/
│   └── phase_0_research_and_data_curation_plan.md
├── scripts/
│   ├── build_datasets.py
│   ├── nlp/
│   │   ├── __init__.py
│   │   └── normalizer.py
│   └── ingestion/
│       ├── __init__.py
│       ├── quran_ingest.py
│       ├── tafsir_ingest.py
│       ├── audio_meta_ingest.py
│       └── metadata_ingest.py
├── tests/
│   ├── __init__.py
│   └── test_phase0_data.py
└── data/
    ├── raw/
    ├── metadata/
    └── processed/
```

---

## Verification & Acceptance Criteria
- Executing `python -m pytest tests/` completes cleanly with all tests passing.
- Executing `python scripts/build_datasets.py` outputs consolidated JSON and SQLite datasets containing 6,236 verses, all Persian & English translations, Tafsir commentaries, reciter metadata, and taxonomies.
