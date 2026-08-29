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
                    Flutter Mobile App / Web Target
                     Android / iOS / Desktop / Web
                    [Persian (Default RTL) / English]
                                    │
                                    ▼
                          ASP.NET Core Gateway
                   Request Localization (fa-IR / en-US)
                                    │
        ┌───────────────────────────┴───────────────────────────┐
        │                 Backend Micro-Services                │
        │  Search | Quran | Tafsir | RAG AI | Admin & Health    │
        └───────────────────────────┬───────────────────────────┘
                                    │
        ┌───────────────────────────┼───────────────────────────┐
        │                     Data Layer                        │
        │  PostgreSQL | pgvector | OpenSearch | Redis Cache     │
        └───────────────────────────────────────────────────────┘
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
│   ├── phase_1_database_design_manual_guide.md
│   ├── phase_2_backend_architecture_manual_guide.md
│   ├── phase_3_hybrid_search_engine_manual_guide.md
│   ├── phase_4_ai_and_rag_engine_plan.md
│   ├── phase_5_flutter_mobile_app_plan.md
│   └── phase_6_testing_admin_portal_and_launch_readiness_plan.md
├── scripts/                            # Data ingestion, ETL, & NLP pipelines
│   ├── start-dev.ps1                   # One-click dev environment launcher
│   ├── start-tunnel.ps1                # Launch Ngrok public tunnel for API
│   ├── build-apk.ps1                   # Build release Flutter APK
│   ├── build_datasets.py               # Master dataset build & SQLite generator script
│   ├── nlp/
│   │   └── normalizer.py               # Persian/English/Arabic NLP text normalizers
│   └── ingestion/                      # Data ingestion & PostgreSQL seeders
├── tests/                              # Automated test suites
│   ├── test_phase0_data.py             # Python Phase 0 data quality tests
│   ├── test_phase1_postgres.py         # Python Phase 1 database integrity tests
│   ├── QuranPlatform.UnitTests/        # .NET CQRS, Domain & Admin unit tests
│   └── QuranPlatform.IntegrationTests/ # .NET WebApplicationFactory API & Health integration tests
├── src/                                # Source code
│   ├── QuranPlatform.API/              # ASP.NET Core Web API presentation layer
│   ├── QuranPlatform.Application/      # MediatR CQRS commands, queries & admin features
│   ├── QuranPlatform.Domain/           # Enterprise domain entities, value objects & interfaces
│   ├── QuranPlatform.Infrastructure/   # PostgreSQL, OpenSearch, LLM adapters & Redis
│   └── quran_mobile_app/               # Flutter mobile & web application (Riverpod & Drift)
└── data/                               # Generated datasets
    └── processed/
        ├── surahs.json                 # Master Surah catalog
        ├── verses.json                 # Verses dataset
        ├── translations.json           # Localized translations dataset
        ├── tafsir.json                 # Localized Tafsirs dataset
        └── quran_platform.db           # Bundled SQLite Database for Flutter & Seeders
```

---

## 🛠 Setup & Data Curation Guide

### Prerequisites
* .NET SDK 8.0+
* Flutter SDK (3.22+ / 3.44+)
* Python 3.10+
* Docker Desktop (for PostgreSQL & OpenSearch)

---

## 🛠 Phase 0 — Data Curation & Setup Guide

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/alirezakavianifar/quran_mobile_app.git
   cd quran_mobile_app
   ```

2. **Run Dataset Ingestion & Build Pipeline**:
   ```bash
   python scripts/build_datasets.py
   ```

3. **Run Phase 0 Tests**:
   ```bash
   python -m unittest discover tests
   ```

---

## 🗄 Phase 1 — Database Setup (PostgreSQL + pgvector)

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

2. **Apply Database Schema**:
   ```powershell
   Get-Content sql\schema_phase1.sql | docker exec -i quran_postgres psql -U quran_admin -d quran_db
   ```

3. **Seed Database**:
   ```bash
   python -m scripts.ingestion.seed_postgres
   ```

4. **Run Database Integrity Tests**:
   ```bash
   pytest tests/test_phase1_postgres.py -v
   ```

---

## 🛠 Phase 2 — Backend Architecture (ASP.NET Core)

Phase 2 establishes an enterprise Clean Architecture solution in **ASP.NET Core** featuring CQRS via MediatR and native Request Localization defaulting to **Persian (`fa-IR`)** with English (`en-US`) support.

### Quick Commands to Build & Run Backend:
```powershell
# Build ASP.NET Core Solution
dotnet build QuaranPlatform.slnx

# Run Unit & Integration Tests
dotnet test QuaranPlatform.slnx

# Launch Backend Web API Server
dotnet run --project src/QuranPlatform.API/QuranPlatform.API.csproj
```

---

## 🤖 Phase 4 — AI & Grounded RAG Engine Architecture

Phase 4 implements a vendor-agnostic Retrieval-Augmented Generation (RAG) engine that generates answers strictly grounded in authentic Quran verses and Persian Tafsir (**Tafsir Nemoneh** & **Al-Mizan**) or English Tafsir (**Ibn Kathir**).

- **Endpoints**: `POST /api/v1/ai/ask` and SignalR Hub `/hubs/aichat`.
- **Supported Providers**: Google Gemini API, xAI Grok API, and built-in Mock provider for offline testing.

---

## 📱 Phase 5 — Flutter Mobile & Web App

Built with **Flutter** (`src/quran_mobile_app`) using **Feature-First Clean Architecture**, **Riverpod**, and **Drift SQLite**.

- **Persian RTL Layout (Default)**: `fa_IR` with Vazirmatn font and Persian digit conversion.
- **English LTR Layout**: Dynamic switching to `en_US` with Inter font.
- **Quran Page & Juz Indicators**:
  - Dynamic `AppBar` header display showing the active Quran Page and Juz (e.g., `صفحه ۱ • جزء ۱` / `Page 1 • Juz 1`) automatically updated as the user scrolls.
  - Visual page boundary transition headers (e.g., `─── صفحه ۲ • جزء ۱ ───`) rendered inside the reader view when page numbers change between consecutive verses.
  - Individual Ayah page number badges (e.g., `[۱:۱] • صفحه ۱`) on every verse card header.
- **Surah Recitation & Audio Playback**:
  - Full verse-by-verse audio streaming with support for top reciters (Mishary Rashid Alafasy, Mahmoud Khalil Al-Husary, etc.).
  - Background audio playback session & CPU wake lock enabled (`WAKE_LOCK`, `FOREGROUND_SERVICE_MEDIA_PLAYBACK`, iOS `UIBackgroundModes -> audio`).
  - Automatic continuous verse playback progression across the active Surah.
  - Interactive active verse highlighting and reciter selection sheet.
  - Persistent bottom audio player bar with progress timeline slider and play/pause controls.
- **User Settings & Customizations**:
  - **Quran Typography**: Arabic script font selection (*Amiri*, *Scheherazade New*, *Lateef*), font size sliders for Arabic (18–42pt) and Translation (12–28pt), live verse text preview card, show/hide translation toggle, show/hide transliteration toggle.
  - **Audio & Recitation**: Default reciter selection (*Shahriar Parhizgar*, *Mishary Alafasy*, *Abdul Basit*), audio playback speed slider (0.75x–2.0x), auto-scroll Ayah toggle.
  - **Appearance & Themes**: Theme mode selector (*Light*, *Dark*, *System*, *Sepia eye-care mode*), interface language switcher (*Persian RTL* vs *English LTR*).
  - **AI & Storage Utilities**: Hybrid search switch, Wi-Fi sync switch, audio cache cleaner, and reset settings dialog.
- **Offline Reading**: Bundled Drift SQLite database with offline translations and bookmark management.
- **Web Support**: Configured with web WASM SQLite support and CORS headers.

### Quick Commands to Build & Test Flutter App:
```powershell
cd src/quran_mobile_app
flutter pub get
flutter test
flutter run -d chrome  # or windows / android
```

---

## 📊 Phase 6 — Admin Portal, Quality Assurance & Launch Readiness

Phase 6 provides administrative telemetry, system health probes, CI/CD pipeline automation, and master verification test suites.

### 1. Admin Telemetry & Moderation API (`AdminController`)
- **GET `/api/v1/admin/stats`**: System metrics (Surahs count, Verses count, Translations count, Tafsirs count, Users count, Subsystem statuses).
- **GET `/api/v1/admin/search-analytics`**: Search query performance, query counts, and top search trends across Persian and English queries.
- **GET `/api/v1/admin/ai-logs`**: Recent AI assistant interactions, citation verification, and content moderation logs.

### 2. System Health Monitoring Probe (`/healthz`)
- **GET `/healthz`**: Standardized health check endpoint verifying database connectivity, cache status, and API liveness.

### 3. CI/CD Pipeline (`.github/workflows/ci-cd.yml`)
- Automated GitHub Actions workflow performing:
  - ASP.NET Core solution build & test (`dotnet test`)
  - Python dataset ingestion & NLP verification (`pytest`)
  - Flutter mobile & web app test suite (`flutter test`)

---

## 🚀 Phase 7 — Production Deployment, Containerization, Admin Web Dashboard & Sync

Phase 7 completes the multi-year platform architecture with production-grade Docker orchestration, a bilingual Web Admin Dashboard UI, cloud user data synchronization, and audio recitation streaming APIs.

### 1. Docker Compose Production Deployment
Launch the complete containerized stack (ASP.NET Core API Gateway, PostgreSQL 16 with `pgvector`, Redis 7, and OpenSearch 2.x) with a single command:

```powershell
docker-compose up -d
```

### 2. Web Admin Dashboard UI (`/admin`)
The Web Admin Dashboard is hosted natively by ASP.NET Core Static Files:
- **Access URLs**:
  * **Local Admin Web Portal**: `http://localhost:5153/admin/` (or `https://localhost:5154/admin/`)
  * **Ngrok Tunnel Admin Portal**: `https://<your-ngrok-subdomain>.ngrok-free.app/admin/`
  * **Swagger Open API Explorer**: `http://localhost:5153/swagger`
- **Features**:
  * Persian RTL (Default) / English LTR toggle with Vazirmatn & Inter typography.
  * Real-time System Statistics dashboard (Database metrics, vector counts, OpenSearch document totals).
  * Search Analytics monitor (Top query trends in Persian and English).
  * AI LLM Engine Manager (View & dynamically switch active provider between **Google Gemini**, **xAI Grok**, and **Mock** at runtime).
  * AI Assistant Conversation Logs and Guardrail Safety inspector.
  * Translation & Tafsir source moderation interface.

### 3. User Cloud Data Synchronization API (`SyncController`)
- **POST `/api/v1/sync`**: Synchronizes local Drift SQLite bookmarks, highlights, notes, and reading history with the PostgreSQL backend using timestamp-based conflict resolution (latest wins).
- **GET `/api/v1/sync/{userId}`**: Retrieves remote user data state for cross-device synchronization.

### 4. Audio Recitation Streaming API (`AudioController`)
- **GET `/api/v1/audio/reciters`**: Returns available reciter profiles (Mishary Rashid Alafasy, Mahmoud Khalil Al-Husary, Abdul Basit, Shahriar Parhizgar).
- **GET `/api/v1/audio/ayah/{reciterId}/{surahId}/{verseId}`**: Returns verse audio stream URLs and word-by-word timing metadata.

---

## ⚡ Development & Launch Helper Scripts (`scripts/`)

```powershell
# 1. Dev Launcher (Backend + App):
.\scripts\start-dev.ps1

# 2. Admin Panel Launcher (Backend + Browser Admin Dashboard):
.\scripts\start-admin.ps1

# 3. Master 1-Click Ngrok Tunnel & Release Android APK Builder:
.\scripts\build-apk.ps1

# 4. Production Server 1-Click Deployment:
.\scripts\deploy-to-server.ps1 -ServerIP "45.94.215.188" -ServerUser "root"

# 5. Rubika Bot Build Distribution CLI:
python .\scripts\upload-to-rubika.py --file "app-release.rar"

# 6. Multi-Platform App Icon Generator:
python .\scripts\generate_app_icons.py icon.png
```

---

## 🤖 GitHub Actions CI/CD & Automated Pipelines (`.github/workflows/`)

| Workflow | File | Trigger | Description |
| :--- | :--- | :--- | :--- |
| **Android APK Build** | [build-apk.yml](file:///.github/workflows/build-apk.yml) | `workflow_dispatch` | Builds release APK with ABI selection (`arm64-v8a`, `universal`, `all`), creates `.zip` archive, uploads artifacts, and optionally sends to Rubika Bot. |
| **Unified Mobile Build** | [build-mobile.yml](file:///.github/workflows/build-mobile.yml) | `push` / `workflow_dispatch` | Automated multi-target pipeline building Android APKs (Ubuntu) and iOS IPAs/Simulator packages (macOS runner). |
| **Server Deployment** | [deploy-server.yml](file:///.github/workflows/deploy-server.yml) | `push` / `workflow_dispatch` | Automated zero-downtime server deployment via SSH: packages source archive, extracts to `/opt/quran-platform`, executes `docker compose up -d --build`, and verifies `/healthz`. |
| **CI Quality Gate** | [ci-cd.yml](file:///.github/workflows/ci-cd.yml) | `push` / `pull_request` | Validates .NET backend tests, Python ETL & NLP tests, and Flutter mobile test suite. |

### Repository Secrets Required for Actions:
* `SERVER_SSH_KEY` / `DEPLOY_SSH_KEY`: Private SSH key for production server deployment.
* `RUBIKA_BOT_TOKEN`: Token for automated release distribution via Rubika Bot.


---

## 🧪 Comprehensive Master Testing Commands

To run all test suites across the entire repository:

```powershell
# 1. .NET Unit & Integration Test Suites
dotnet test QuaranPlatform.slnx

# 2. Python Data Quality & PostgreSQL Test Suites
pytest tests/test_phase0_data.py tests/test_phase1_postgres.py

# 3. Flutter Mobile & Web Test Suite
cd src/quran_mobile_app; flutter test
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
| **Phase 5 — Flutter Mobile & Web App** | Feature-First RTL Persian UI with dynamic English switching & Drift SQLite. | ✅ Completed |
| **Phase 6 — Admin Portal & Quality Assurance** | Admin API telemetry, `/healthz` probes, CI/CD workflow & master testing suite. | ✅ Completed |
| **Phase 7 — Production Deployment & Sync** | Docker orchestration, Web Admin Dashboard UI (`/admin`), Sync & Audio APIs. | ✅ Completed |

---

## 📄 Remote Repository

Changes are pushed to: [github.com/alirezakavianifar/quran_mobile_app.git](https://github.com/alirezakavianifar/quran_mobile_app.git)

