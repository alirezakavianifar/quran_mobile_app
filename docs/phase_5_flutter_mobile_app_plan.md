# Phase 5 Implementation Plan — Flutter Mobile App Architecture

## Overview
This document outlines the step-by-step implementation plan for **Phase 5 (Flutter Mobile App Architecture)** of the Quran Platform, as defined in `plan.md`.

The mobile app is built with **Flutter (3.44+ / Dart 3.12+)** using **Feature-First Clean Architecture** and **Riverpod** state management. It features **native Right-To-Left (RTL) Persian UI as default** (`fa-IR` with Vazirmatn typography) and dynamic English LTR support (`en-US` with Inter typography), along with an **Offline-First Drift (SQLite)** database for instant offline Quran reading and translation access.

---

## Technical Architecture & Directory Layout

The Flutter application is organized under `src/quran_mobile_app` following Feature-First Clean Architecture:

```
src/quran_mobile_app/
├── pubspec.yaml                        # Flutter package dependencies (riverpod, drift, dio, etc.)
├── assets/
│   ├── fonts/                          # Vazirmatn, Inter, Scheherazade New / Uthmani fonts
│   ├── i18n/                           # Localized string definitions (fa.json, en.json)
│   └── db/                             # Bundled offline database seed (quran_platform.db)
└── lib/
    ├── main.dart                       # App entry point initializing providers & localization
    └── src/
        ├── core/                       # Shared infrastructure & core services
        │   ├── database/               # Drift SQLite database schema, tables & migrations
        │   ├── network/                # Dio HTTP Client with automatic Accept-Language header
        │   ├── localization/           # Localized strings controller & Persian/English language state
        │   ├── theme/                  # Persian (Vazirmatn RTL) & English (Inter LTR) themes
        │   └── utils/                  # Persian digit converter (123 -> ۱۲۳) & helpers
        └── features/                   # Self-contained feature modules
            ├── reader/                 # Quran reader (Surahs, Verses, Translations, Tafsir)
            ├── search/                 # Local & API hybrid search UI
            ├── bookmarks/              # Local verse bookmarking & notes (Drift)
            ├── ai_chat/                # AI Assistant grounded RAG chat interface
            └── audio/                  # Audio reciter selection & playback controls
```

---

## Key Modules & Implementation Details

### 1. Core Infrastructure (`lib/src/core/`)
- **Localization & Directionality**:
  - `LocaleStateNotifier` (Riverpod) managing active locale (`fa_IR` default, `en_US` secondary).
  - Dynamic `TextDirection` switching (`TextDirection.rtl` for Persian, `TextDirection.ltr` for English).
  - `AppLocalizations`: Type-safe string translations for both Persian and English.
- **Typography & Theme**:
  - Persian theme using `Vazirmatn` font, styled for primary RTL presentation.
  - English theme using `Inter` font for clear LTR readability.
  - Arabic Uthmanic / Scheherazade font styling for Quranic text.
- **Utilities**:
  - `PersianDigitConverter`: Converts numbers to Persian digits (`۲:۲۵۵`) when active locale is Persian.
- **Network Client**:
  - `DioHttpClient`: Configured with base URL, timeout, and automatic `Accept-Language` request header injection (`fa-IR` or `en-US`).
- **Drift SQLite Database**:
  - `AppDatabase`: Drift table definitions for `Surahs`, `Verses`, `Translations`, `Tafsirs`, `Bookmarks`, and `Notes`.

### 2. Feature Modules (`lib/src/features/`)
- **Reader Feature**:
  - `SurahListView`: Browsing all 114 Surahs with metadata (Makki/Madani, Verse count, Persian/English names).
  - `VerseDetailView`: Viewing verses with Arabic Uthmani text, Makarem Shirazi / Khattab translations, and Tafsir Nemoneh commentary.
- **Search Feature**:
  - `SearchScreen`: Local search in Drift SQLite database with fallback/integration to ASP.NET Core Hybrid Search API (`/api/v1/search`).
- **AI Chat Feature**:
  - `AiChatScreen`: Interactive UI to ask Quranic questions, showing grounded AI answers with citations (`[سوره البقرة ۲:۲۵۵]`).
- **Bookmarks Feature**:
  - `BookmarksScreen`: Manage saved verses and personal notes stored locally in Drift SQLite.

### 3. Automated Testing Suite (`test/`)
- **Unit Tests**: Test `PersianDigitConverter`, Riverpod state providers, repository mapping, and localized text formatting.
- **Database Tests**: Integration tests for Drift SQLite table operations (CRUD on bookmarks, querying verses & translations).
- **Widget & Visual Tests**: Verify RTL/LTR layout rendering, locale switching, and Surah list item presentation.

---

## Step-by-Step Execution Order

1. **Step 1 — Project Scaffold & Dependencies**:
   - Initialize Flutter application in `src/quran_mobile_app`.
   - Configure `pubspec.yaml` with dependencies (`flutter_riverpod`, `drift`, `drift_flutter`, `sqlite3_flutter_libs`, `dio`, `google_fonts`, `flutter_localizations`).
2. **Step 2 — Core Theme, Localization & Utilities**:
   - Implement `PersianDigitConverter`.
   - Create `AppLocalizations` & `LocaleNotifier` for `fa_IR` default & `en_US` secondary locale.
   - Define Persian (`Vazirmatn`) RTL & English (`Inter`) LTR themes in `AppTheme`.
3. **Step 3 — Drift SQLite Offline Database**:
   - Define Drift database tables (`Surahs`, `Verses`, `Translations`, `Bookmarks`).
   - Create `AppDatabase` class and seed handler for offline reading.
4. **Step 4 — Core Network API Client**:
   - Implement `DioHttpClient` with `Accept-Language` header interceptor.
5. **Step 5 — Feature Modules Implementation**:
   - Build **Reader** feature (Surah list provider & widget, Verse detail provider & widget).
   - Build **Search** feature (Hybrid API & local search state).
   - Build **AI Chat** feature (RAG chat state & message view).
   - Build **Bookmarks** feature (Riverpod state & persistence).
6. **Step 6 — Verification & Testing**:
   - Execute Flutter unit tests (`flutter test`) covering converters, Riverpod providers, Drift database queries, and RTL layout widgets.
   - Build & verify app compilation cleanly.
