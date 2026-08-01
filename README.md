# Quran Knowledge Platform & Mobile App (قرآن مجید)

> **The World's Most Intelligent Quran Exploration Platform**
> Built with ASP.NET Core, Flutter, PostgreSQL, OpenSearch, pgvector, and LLM-powered RAG.

---

## 🌐 Vision & Dual-Language Architecture

The Quran Knowledge Platform is a multi-client AI platform designed **bilingually from the ground up**, prioritizing **Persian (Farsi)** as the default primary language and **English** as a fully supported secondary language:

* **Default Locale**: Persian (`fa` / `fa-IR`) with native **Right-To-Left (RTL)** layout and typography (**Vazirmatn**).
* **Secondary Locale**: English (`en` / `en-US`) with **Left-To-Right (LTR)** layout and typography (**Inter**).
* **Persian Default Content**:
  * Default Translation: **Ayatollah Makarem Shirazi**
  * Default Tafsir Commentary: **Tafsir Nemoneh (تفسیر نمونه)**
  * Additional Persian Translations: Mohammad Mahdi Fouladvand, Hossein Ansarian, Elahi Ghomshei, Baha'oddin Khorramshahi.
  * Additional Persian Tafsirs: Al-Mizan (علامه طباطبایی), Tafsir Noor (دکتر محسن قرائتی).
* **English Content**:
  * Default Translation: **Dr. Mustafa Khattab (The Clear Quran)**
  * Default Tafsir Commentary: **Tafsir Ibn Kathir**
  * Additional English Translations: Sahih International, Abdullah Yusuf Ali, Marmaduke Pickthall.
  * Additional English Tafsirs: Tafsir Al-Jalalayn, Ma'ariful Qur'an.

---

## 🏗 System Architecture Overview

```
                    Flutter Mobile App
              Android / iOS / Desktop / Web
             [Persian (Default RTL) / English]
                            │
                            ▼
                   ASP.NET Core Gateway
             Request Localization (fa-IR / en-US)
                            │
        ┌───────────────────┴───────────────────┐
        │          Backend Micro-Services        │
        │  Search | Quran | Tafsir | RAG AI     │
        └───────────────────┬───────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │              Data Layer               │
        │  PostgreSQL | pgvector | OpenSearch   │
        └───────────────────────────────────────┘
```

---

## 🚀 Repository Structure

```
quran_mobile_app/
├── README.md                           # Master Project Documentation
├── AGENTS.md                           # Agent instructions & repository rules
├── plan.md                             # Multi-phase master architectural plan
├── docs/                               # Phase implementation design plans
│   ├── phase_0_research_and_data_curation_plan.md
│   └── phase_1_database_design_manual_guide.md
├── scripts/                            # Data ingestion, ETL, & NLP pipelines
│   ├── build_datasets.py               # Master dataset build & SQLite generator script
│   ├── nlp/
│   │   ├── __init__.py
│   │   └── normalizer.py               # Persian/English/Arabic NLP text normalizers
│   └── ingestion/
│       ├── __init__.py
│       ├── quran_ingest.py             # 114 Surahs & 6236 Verses text engine
│       ├── tafsir_ingest.py            # Persian (Nemoneh) & English (Ibn Kathir) Tafsir
│       ├── audio_meta_ingest.py        # Audio reciters metadata catalog
│       └── metadata_ingest.py          # Topics, Prophets, Stories & Taxonomy metadata
├── tests/                              # Automated test suite
│   ├── __init__.py
│   └── test_phase0_data.py             # Unit & integration tests for Phase 0
└── data/                               # Generated datasets
    └── processed/
        ├── surahs.json                 # Master Surah catalog
        ├── verses.json                 # Verses dataset
        ├── translations.json           # Localized translations dataset
        ├── tafsir.json                 # Localized Tafsirs dataset
        ├── audio_reciters.json         # Reciter profiles & streaming metadata
        ├── metadata_taxonomy.json      # Structured Quranic taxonomy
        └── quran_platform.db           # Bundled SQLite Database for Flutter & Seeders
```

---

## 🛠 Phase 0 — Data Curation & Setup Guide

### Prerequisites
* Python 3.10+
* Git

### Step-by-Step Instructions

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/alirezakavianifar/quran_mobile_app.git
   cd quran_mobile_app
   ```

2. **Run Dataset Ingestion & Build Pipeline**:
   The ETL pipeline processes all 114 Surahs, 6,236 Ayahs, Persian and English translations, Tafsir commentaries, reciter metadata, and generates both JSON files and a complete SQLite database (`quran_platform.db`).

   ```bash
   # Run dataset builder
   python scripts/build_datasets.py
   ```

   **Expected Output**:
   ```text
   Building Quran datasets...
   Building Tafsir datasets...
   Building Audio Metadata datasets...
   Building Taxonomy & Verse Metadata datasets...
   JSON datasets written successfully to data/processed/
   Building SQLite database at data/processed/quran_platform.db...
   SQLite database successfully created and indexed.
   Verifying built datasets...
   Dataset Verification Passed 100%! All 114 Surahs, 6,236 Ayahs, Persian & English translations, Tafsirs, and indexes are intact.
   ```

3. **Run Unit & Integration Test Suite**:
   Verify Persian character unification, ZWNJ normalization, diacritics stripping, digit conversions, and SQLite database integrity:

   ```bash
   python -m unittest discover tests
   ```

   **Expected Output**:
   ```text
   ..........
   ----------------------------------------------------------------------
   Ran 10 tests in 0.023s

   OK
   ```

---

## 📖 Key Features & NLP Capabilities

### 1. Persian Text Normalization (`scripts/nlp/normalizer.py`)
* **Character Unification**: Automatically standardizes Arabic Yeh (`ي`) to Persian Yeh (`ی`), Arabic Kaf (`ك`) to Persian Kaf (`ک`), and Alef variants.
* **ZWNJ (نیم‌فاصله) Handling**: Normalizes Half-Spaces (`\u200c`) cleanly for compound words (`می‌خواهم`, `درخت‌ها`).
* **Diacritics Removal**: Strips Tashkeel/Harakat for accurate keyword and semantic indexing.
* **Digit Normalization**: Seamlessly converts between Persian numerals (`۰-۹`) and English numerals (`0-9`).

### 2. Multi-Tiered Data Storage
* **JSON Datasets (`data/processed/*.json`)**: Formatted for direct seeding into ASP.NET Core PostgreSQL/EF Core.
* **SQLite Database (`data/processed/quran_platform.db`)**: Pre-compiled database optimized for offline mobile experience with Flutter (Drift SQLite).

---

---

## 🗄 Phase 1 — Database Setup & Seeding Guide (PostgreSQL + pgvector)

### Prerequisites
* Docker Desktop installed and running
* Python 3.10+ with `psycopg2-binary` and `pytest` (`pip install psycopg2-binary pytest`)

### Step-by-Step Execution

1. **Launch PostgreSQL + pgvector Docker Container**:
   ```powershell
   docker run -d `
     --name quran_postgres `
     -e POSTGRES_DB=quran_db `
     -e POSTGRES_USER=quran_admin `
     -e POSTGRES_PASSWORD=quran_pass `
     -p 5432:5432 `
     ankane/pgvector:latest
   ```

2. **Apply Database Schema & Indexing (Step 1 - 3)**:
   Apply the complete relational DDL and vector similarity indexes (`sql/schema_phase1.sql`):
   ```powershell
   Get-Content sql\schema_phase1.sql | docker exec -i quran_postgres psql -U quran_admin -d quran_db
   ```

3. **Run Data Ingestion & Seeding (Step 4)**:
   Seed all 114 Surahs, 6,236 Verses, 12,472 Translations, 6 Tafsir Editions, 12,472 Tafsir Content entries, and Taxonomy metadata into PostgreSQL:
   ```bash
   python -m scripts.ingestion.seed_postgres
   ```

   **Expected Output**:
   ```text
   INFO - Connecting to PostgreSQL...
   INFO - Seeding 114 Surahs...
   INFO - Seeding 6236 Verses...
   INFO - Seeding 12472 Translations...
   INFO - Seeding 6 Tafsir Editions...
   INFO - Seeding 12472 Tafsir Content entries...
   INFO - Seeding 8 Topics...
   INFO - Analyzing tables for optimizer statistics...
   INFO - PostgreSQL Database seeding completed successfully!
   ```

4. **Run Phase 1 Automated Test Suite**:
   Verify record counts, foreign key relationships, and query performance benchmarks:
   ```bash
   python -m pytest tests/test_phase1_postgres.py -v
   ```

   **Expected Output**:
   ```text
   tests/test_phase1_postgres.py::test_surah_count PASSED                   [ 16%]
   tests/test_phase1_postgres.py::test_verse_count PASSED                   [ 33%]
   tests/test_phase1_postgres.py::test_translation_count PASSED             [ 50%]
   tests/test_phase1_postgres.py::test_tafsir_count PASSED                  [ 66%]
   tests/test_phase1_postgres.py::test_topic_count PASSED                   [ 83%]
   tests/test_phase1_postgres.py::test_performance_benchmark PASSED         [100%]
   ```

217: ---
218: 
219: ## 🛠 Phase 2 — Backend Architecture (ASP.NET Core)
220: 
221: Phase 2 establishes an enterprise Clean Architecture solution in **ASP.NET Core** featuring CQRS via MediatR and native Request Localization defaulting to **Persian (`fa-IR`)** with English (`en-US`) support.
222: 
223: For detailed step-by-step instructions on creating projects, dependencies, EF Core persistence, request culture pipeline behaviors, and unit/architecture testing, see the manual guide:
224: 👉 **[phase_2_backend_architecture_manual_guide.md](docs/phase_2_backend_architecture_manual_guide.md)**
225: 
226: ### Quick Commands to Build & Test Phase 2:
227: ```powershell
228: # 1. Build ASP.NET Core Solution
229: dotnet build
230: 
231: # 2. Run Architecture & Unit Tests
232: dotnet test tests/QuranPlatform.UnitTests/QuranPlatform.UnitTests.csproj
233: 
234: # 3. Launch Backend Web API Server
---

## 🛠 Phase 2 — Backend Architecture (ASP.NET Core)

Phase 2 establishes an enterprise Clean Architecture solution in **ASP.NET Core** featuring CQRS via MediatR and native Request Localization defaulting to **Persian (`fa-IR`)** with English (`en-US`) support.

For detailed step-by-step instructions on creating projects, dependencies, EF Core persistence, request culture pipeline behaviors, and unit/architecture testing, see the manual guide:
👉 **[phase_2_backend_architecture_manual_guide.md](docs/phase_2_backend_architecture_manual_guide.md)**

### Quick Commands to Build & Test Phase 2:
```powershell
# 1. Build ASP.NET Core Solution
dotnet build

# 2. Run Architecture & Unit Tests
dotnet test tests/QuranPlatform.UnitTests/QuranPlatform.UnitTests.csproj

# 3. Launch Backend Web API Server
dotnet run --project src/QuranPlatform.API/QuranPlatform.API.csproj
```

---

## 🤖 Phase 4 — AI & Grounded RAG Engine Architecture

Phase 4 implements a vendor-agnostic Retrieval-Augmented Generation (RAG) engine that generates answers strictly grounded in authentic Quran verses and Persian Tafsir (**Tafsir Nemoneh** & **Al-Mizan**) or English Tafsir (**Ibn Kathir**).

- **Vendor-Agnostic Abstractions**: `IRagEngine`, `ILLMProvider`, `IEmbeddingService`, and `IVectorSearchService`.
- **Supported Providers**: Google Gemini API, xAI Grok API, and built-in Mock token streaming for development/testing without external API keys.
- **Real-Time Token Streaming**: Real-time token streaming over SignalR (`/hubs/aichat`) and REST API (`POST /api/v1/ai/ask`).
- **Guardrails**: Automated detection and fallback (`در منابع موجود اطلاعات کافی برای پاسخ دقیق یافت نشد.`) when retrieved context is insufficient.

### Configuration (`appsettings.Development.json`):
```json
"AI": {
  "Provider": "Gemini", // Options: "Gemini", "Grok", "Mock"
  "Gemini": {
    "ApiKey": "YOUR_GEMINI_API_KEY",
    "Model": "gemini-1.5-flash"
  },
  "Grok": {
    "ApiKey": "YOUR_GROK_API_KEY",
    "Model": "grok-beta",
    "BaseUrl": "https://api.x.ai/v1"
  }
}
```

---

## 📱 Phase 5 — Flutter Mobile App Architecture

Phase 5 implements a native cross-platform mobile app in **Flutter** (`src/quran_mobile_app`) using **Feature-First Clean Architecture** and **Riverpod** state management.

- **Persian RTL Primary Layout**: Default `fa_IR` locale with native Right-To-Left directionality, **Vazirmatn** typography, and Persian digit converter (`۱۲۳`).
- **English LTR Secondary Layout**: Dynamic language switching to `en_US` with Left-To-Right directionality and **Inter** typography without app reboot.
- **Offline-First Drift (SQLite) Database**: Complete offline Surahs, Verses, Translations (Makarem Shirazi / Khattab), and local Bookmarks CRUD operations.
- **Dio HTTP Networking**: Configured with automatic `Accept-Language` request header injection (`fa-IR` or `en-US`).
- **Feature Modules**:
  - `reader`: Surah browsing & verse details with Uthmanic Arabic text and translations.
  - `search`: Local SQLite search with hybrid backend API integration.
  - `ai_chat`: Interactive grounded RAG AI study assistant with citation chips (`[سوره البقرة ۲:۲۵۵]`).
  - `bookmarks`: Saved verses and personal notes.

### Quick Commands to Build & Test Phase 5 (Flutter App):
```powershell
# 1. Navigate to Flutter app directory
cd src/quran_mobile_app

# 2. Get packages & dependencies
flutter pub get

# 3. Run full automated test suite (Unit, Drift DB, & RTL/LTR Widget tests)
flutter test

# 4. Launch Flutter App
flutter run
```

---

## ⚡ Development & Tunnel Helper Scripts (`scripts/`)

The repository includes convenient PowerShell launcher and builder scripts located in the `scripts/` directory:

### 1. Development Launcher (`scripts/start-dev.ps1`)
Automatically checks and frees port `5153`, launches the `.NET` backend (`QuranPlatform.API`) in a new terminal window, waits until backend health check passes, detects available Flutter devices, and interactively launches the mobile app on your chosen target (Windows desktop, Chrome, Android emulator, or iOS simulator).

```powershell
.\scripts\start-dev.ps1
```

### 2. Ngrok Tunnel Launcher (`scripts/start-tunnel.ps1`)
Starts an Ngrok HTTP tunnel forwarding port `5153` to the public internet so remote devices or mobile emulators can connect directly to your local backend API. Automatically launches the `.NET` backend if it is not already running.

```powershell
.\scripts\start-tunnel.ps1
```

### 3. Release APK Builder (`scripts/build-apk.ps1`)
Automates building a release Android APK for the Flutter app (`src/quran_mobile_app`). Automatically detects active Ngrok tunnel or custom backend URL (passed via `-TargetUrl`), passes it to Flutter via `--dart-define=API_BASE_URL=...`, builds the release APK, and places the final `app-release.apk` at the workspace root directory.

```powershell
# Build APK using active Ngrok tunnel or default emulator loopback (10.0.2.2:5153):
.\scripts\build-apk.ps1

# Build APK targeting a specific remote backend URL:
.\scripts\build-apk.ps1 -TargetUrl "http://45.94.215.188"
```


---

## 🔮 Roadmap & Milestone Status

| Phase | Description | Status |
| :--- | :--- | :--- |
| **Phase 0 — Data Preparation** | Curated Persian & English datasets, NLP normalizers, SQLite generator. | ✅ Completed |
| **Phase 1 — Database & Entity Architecture** | PostgreSQL schema with pgvector, DDL migrations, seeding engine & tests. | ✅ Completed |
| **Phase 2 — Backend Architecture** | ASP.NET Core Clean Architecture API with `fa-IR` default localization. | ✅ Completed |
| **Phase 3 — Search Engine** | Persian & English hybrid lexical (OpenSearch BM25) + vector search (RRF). | ✅ Completed |
| **Phase 4 — AI & Grounded RAG Engine** | Persian-default prompt builder, Tafsir Nemoneh grounding, SignalR stream. | ✅ Completed |
| **Phase 5 — Flutter Mobile App** | Feature-First RTL Persian UI with dynamic English switching & Drift SQLite. | ✅ Completed |

---

## 📄 Remote Repository

Changes are pushed to: [github.com/alirezakavianifar/quran_mobile_app.git](https://github.com/alirezakavianifar/quran_mobile_app.git)

