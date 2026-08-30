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

### 5. Advanced Flutter Mobile Companion Features (Phases 8 & 9)
- **Digital Tasbih & Multi-Stage Dhikr Counter (`features/tasbih/`)**:
  * Multi-stage sequential prayer progression (e.g. **Tasbihat of Lady Fatima (س)**: $34 \times \text{Allahu Akbar} \to 33 \times \text{Alhamdulillah} \to 33 \times \text{Subhanallah}$).
  * Rich presets (Salawat, Istighfar, dynamic Persian weekday prayers) and custom prayer creator with haptic feedback pulses and persistent lifetime counts.
  * Interactive circular glowing progress dial with real-time sweep animation.
- **40 Rabbana & Quranic Duas Hub (`features/duas/`)**:
  * 40+ curated divine supplications starting with *Rabbana* and *Rabbi* across 6 thematic categories (*Forgiveness, Family, Faith, Relief, Knowledge, Patience*).
  * Thematic filter chips, instant search across Arabic/Translations/Surahs, 1-tap audio recitation, and clipboard copying.
- **Obligatory & Recommended Sajdah Verses System (`features/sajdah/`)**:
  * Fiqh taxonomy classifying the **4 Wajib Sajdah verses** (32:15, 41:38, 53:62, 96:19) and **11 Mustahab Sajdah verses**.
  * Decorated Sajdah badge (`۩ سجده واجب` / `۩ سجده مستحب`) in reader cards with 1-tap popup displaying the prescribed Sajdah dua (*لا إِلَهَ إِلا اللَّهُ حَقّاً حَقّاً...*), translation, and fiqh rules.
- **Recitation Sleep Timer & Gentle Fade-Out Engine (`features/audio/`)**:
  * Sleep timer presets (15m, 30m, 45m, 60m, end-of-surah, or custom minutes).
  * Gentle 15-second volume fade-out before pausing, and live countdown badge (`💤 ۱۴:۵۹`) on the reader player bar.
- **Ayah Story & Image Card Generator (`features/card_generator/`)**:
  * Export beautiful, high-resolution PNG images of Quranic verses at $3.0\times$ pixel ratio.
  * Formats: **1:1 Square (Post)** and **9:16 Vertical (Story / Status)**.
  * 4 Visual Themes: 🌿 *Emerald & Gold*, 🌌 *Deep Midnight*, 📜 *Ancient Parchment*, 💎 *Modern Glassmorphism*.
  * Font sizing, translation visibility toggles, and direct file export.
- **Offline Audio Batch Downloader**: Download entire Surahs locally (`audio_cache/{reciter}/{surah}/{verse}.mp3`) with live progress and zero-latency offline playback.
- **Khatmah / Daily Reading Plan & Progress Tracker**: Plan custom reading goals (30-day Ramadan, 60-day, 90-day, 1-year) with daily quotas, consecutive reading streak tracking (🔥 Day Streak), home banner, and direct page jump.
- **Verse-Range Repeat (Hifz Mode)**: Loop custom verse ranges (e.g., Ayah 1 to 5) with multipliers (1x, 2x, 3x, 5x, 10x, ∞) and nested single-verse repeats.
- **Personal Ayah Notes & 5-Color Highlights**: Color-code verses across 5 palettes (Green, Gold, Blue, Purple, Orange), attach personal reflections, and search/filter via the Notes Hub.
- **Qibla Compass & Prayer Times Engine**: High-precision astronomical solar calculations (University of Tehran, MWL, Umm al-Qura, ISNA) for 8 daily prayer events, live countdowns, and spherical trigonometric Qibla direction dial with distance to Kaaba.
- **Keep Screen On (WakeLock)**: Prevent device sleep during study and recitation with customizable settings toggle.

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

## 🧠 Phase 10 — Interactive Hifz, Study Analytics & Quranic Quiz Suite

Phase 10 introduces advanced memorization testing tools, reading habit consistency trackers, and gamified Quranic knowledge challenges.

### 1. Interactive Hifz Hide-and-Reveal Practice Mode (`lib/src/features/hifz/`)
- **3 Practice Testing Styles**:
  - `fullMask`: All words are blurred/masked behind interactive tokens (` ۞ `). Tapping any word smoothly reveals it to test recall during memorization.
  - `firstLetterOnly`: Displays only the initial letter of each Arabic word (e.g. `ب...`) as an active recall memory prompt.
  - `translationPrompt`: Masks the entire Arabic text completely, prompting the reciter to recall and recite the Ayah solely from the translation.
- **Reader Integration**: Dedicated Hifz Mode toggle in `VerseDetailView` with "Mask All" and "Reveal All" quick action buttons.

### 2. 52-Week Reading Activity Heatmap & Analytics Engine (`lib/src/features/analytics/`)
- **Activity Tracking Engine (`ReadingActivityRepository`)**: Automatically logs daily reading activity, verses read, Khatmah pages completed, and recitation listening minutes.
- **Interactive Analytics Dashboard (`AnalyticsScreen`)**:
  - **GitHub-style 52-Week Year-Round Heatmap**: Horizontally scrollable 52-column matrix with 5 color intensity levels ($0 \to 4$) and interactive date tooltips.
  - **Daily Consistency Streak Counter (🔥)**: Tracks consecutive daily reading habits.
  - **Weekly Activity Breakdown**: Day-by-day bar charts comparing reading volume across the week.
  - **Milestone Badges**: *First Steps (1st Ayah)*, *Week of Light (7-Day Streak)*, *Quran Companion (100 Verses)*.

### 3. Interactive Quranic Knowledge & Vocabulary Quiz (`lib/src/features/quiz/`)
- **Multiple Question Categories**:
  - `missingWord`: "Fill in the missing Quranic word in the verse" (*کلمه جاافتاده در آیه چیست؟*).
  - `nextVerse`: "What is the next Ayah?" (*آیه بعدی کدام است؟*).
  - `surahIdentification`: "Which Surah does this Ayah belong to?" (*این آیه متعلق به کدام سوره است؟*).
- **Gamified 10-Question Rounds**: Dynamic score streaks, haptic tactile feedback, instant green/red answer animations, and detailed explanation cards with Ayah citations.

---

## 📑 Phase 11 — Advanced Quran Divisions, Smart Bookmark Collections & Daily Reminders Hub

Phase 11 introduces comprehensive multi-index navigation across the Holy Quran, structured bookmark collections with tagging, and daily habit reminders.

### 1. Advanced Quran Divisions & Chronological Revelation Index (`lib/src/features/divisions/`)
- **Multi-Tab Index Navigator (`QuranIndexScreen`)**:
  - **30 Juz Index Tab**: Complete catalog of all 30 Juz with starting Arabic Ayah snippets, names, page spans (`صفحه ۱ تا ۲۱`), verse counts, and 1-tap reading navigation.
  - **Chronological Revelation Order Tab (ترتیب نزول)**: 114 Surahs ordered by historical revelation (e.g. Surah 96 Al-Alaq #1 ... Surah 110 An-Nasr #114) with search and Makki/Madani filter toggle (`همه`, `مکی`, `مدنی`).

### 2. Smart Bookmark Collections & Tagging Taxonomy (`lib/src/features/bookmarks/`)
- **Multi-Folder Organization (`SmartBookmarksScreen` & `EnhancedBookmarksRepository`)**:
  - Create and manage custom folders (*General*, *Tadabbur & Reflections*, *Memorization Goals*, *Friday Recitations*).
  - Multi-tag tagging taxonomy (`#صبر`, `#امید`, `#خانواده`, `#دعا`, `#Patience`, `#Mercy`) with fast choice chip filtering.
  - Full JSON backup export & restore utility (`exportToJson()` and `importFromJson()`).

### 3. Daily Quranic Devotional Reminders Hub (`lib/src/features/reminders/`)
- **Daily Ayah Curator (`DailyAyahCurator`)**: Rotating daily inspirational Ayah widget with Uthmani script, translations, theme labels, and direct Surah navigation.
- **Devotional Reminders Suite (`RemindersScreen`)**:
  - **Daily Ayah Reminder (آیه روز)**: Scheduled morning verse reminder with time picker.
  - **Khatmah Reading Target Reminder**: Daily reading goal reminder with time picker.
  - **Friday Surah Al-Kahf Reminder**: Weekly Sunnah recitation reminder for Fridays.

---

## 🎨 Phase 12 — Phonetic Tajweed Guide, Thematic Topics Index & Asmaul Husna Hub

Phase 12 delivers foundational Quranic pronunciation learning, semantic theme-based exploration, and the complete 99 Beautiful Names of Allah.

### 1. Phonetic Tajweed Rules & Color Coding Guide (`lib/src/features/tajweed/`)
- **6 Core Tajweed Rule Families**:
  - 🔴 **Ghunnah (غنه)** (#E53935): Nasalization rules in Noon & Meem Mushaddad with 2-vowel duration.
  - 🔵 **Qalqalah (قلقله)** (#1E88E5): Bouncing/echoing consonants (ق، ط، ب، ج، د - قُطب جَد) in state of Sukoon.
  - 🟢 **Ikhfa (اخفاء)** (#43A047): Concealment of Noon Sakinah/Tanween before 15 consonants with 2-beat nasalization.
  - 🟠 **Idgham (ادغام)** (#FB8C00): Merging letters into Yarmaloon (یرملون) with/without Ghunnah.
  - 🟣 **Madd (مد)** (#8E24AA): Prolongation rules (Madd Muttasil, Munfasil, Lazim) from 4 to 6 counts.
  - 🟡 **Iqlab (اقلاب)** (#8D6E63): Transforming Noon Sakinah into a hidden Meem before Ba (ب).
- **Interactive Guide Screen (`TajweedGuideScreen`)**:
  - Color-coded rule legend, letter badges, authentic Quranic examples in Amiri Quran typography, and 1-tap navigation directly into Surah reader.

### 2. Conceptual Quranic Topics & Thematic Index (`lib/src/features/topics/`)
- **Thematic Exploration (`QuranTopicsScreen`)**:
  - ⚖️ *Justice, Ethics & Human Rights (عدالت، قسط و امانت‌داری)*
  - 🌿 *Nature, Creation & Cosmos (طبیعت، کیهان و شگفتی‌های آفرینش)*
  - 📜 *Stories of the Prophets (داستان‌ها و عبرت‌های پیامبران الهی)*
  - 🕊 *Charity, Benevolence & Brotherhood (انفاق، احسان و برادری ایمانی)*
  - 🛡 *Patience & Steadfastness (صبر، شکیبایی و استقامت)*
  - 🌙 *Afterlife & Resurrection (معاد، روز حساب و سرای باقی)*
- **Interactive Features**: Instant search across topics, category carousel filters, and expandable verse preview cards with 1-tap reading navigation.

### 3. Asmaul Husna (99 Beautiful Names of Allah) Hub (`lib/src/features/asmaul_husna/`)
- **Divine Names Hub (`AsmaulHusnaScreen`)**:
  - Complete authentic 99 Names catalog with Uthmani calligraphy, transliteration, deep Persian & English spiritual meanings, and Quranic citations.
  - Interactive search by Arabic name, transliteration, or meaning keywords.
  - Detail modal with spiritual reflection and **1-tap "Count in Digital Tasbih (ذکر در تسبیح‌شمار)"** action.

---

## 🌙 Phase 13 — Islamic Hijri Calendar, Quranic Root Words & Daily Adhkar Hub

Phase 13 delivers Islamic calendar date conversion, real-time lunar moon phase calculations, root word morphology semantics, and daily prophetic Adhkar.

### 1. Islamic Hijri Calendar & Holy Events (`lib/src/features/calendar/`)
- **Multi-Calendar Converter (`IslamicCalendarScreen`)**:
  - Gregorian $\leftrightarrow$ Lunar Hijri $\leftrightarrow$ Solar Shamsi date conversion.
  - Complete catalog of Islamic holy occasions across all 12 Hijri months (Ramadan, Laylat al-Qadr, Eid al-Fitr, Eid al-Adha, Eid al-Ghadir, Ashura, Arbaeen, Mab'ath, Mid-Sha'ban).
  - **Real-Time Moon Phase Tracker**: Illumination percentage, phase badges (🌑🌒🌓🌔🌕🌖🌗🌘), and recommended Quranic Surahs/A'mal for holy dates.

### 2. Quranic Vocab & Arabic Root Word Explorer (`lib/src/features/roots/`)
- **Morphological Root Word Library (`QuranRootsScreen`)**:
  - Root letters (`الجذر` - e.g. `ر-ح-م`, `ع-ل-م`, `ص-ب-ر`, `خ-ل-ق`, `ن-ص-ر`, `ک-ت-ب`, `ه-د-ی`).
  - Total occurrences count across the entire Quran.
  - Core linguistic meaning in Persian and English.
  - Morphological derived forms (nouns, verbs, participles).
  - Sample verses with 1-tap navigation directly into the Quran reader.

### 3. Daily Morning, Evening & Post-Salah Adhkar Suite (`lib/src/features/adhkar/`)
- **Authentic Adhkar Collections (`DailyAdhkarScreen`)**:
  - 🌅 *Morning Adhkar (اذکار و تعقیبات صبحگاه)*
  - 🌇 *Evening Adhkar (اذکار و تعقیبات شامگاه)*
  - 🛏 *Bedtime Adhkar & Sleep Sunnahs (اذکار و آداب خواب)*
  - 🕌 *Post-Salah Adhkar (تعقیبات مشترکه نمازها)*
- **Interactive Step Counter**: Tap-to-count with haptic feedback, step progress, virtues/sources, reset action, and completion indicators.

---

## 🕊 Phase 14 — Sacred Ziyarat Sanctuary, Quranic Parables & Islamic Wasiyyah Builder

Phase 14 introduces comprehensive sacred supplications with 100x counters, allegorical Quranic parables, and a spiritual will composer.

### 1. Sacred Ziyarat & Landmark Supplications (`lib/src/features/ziyarat/`)
- **Sacred Ziyarats & Duas Sanctuary (`ZiyaratHubScreen` & `ZiyaratDetailScreen`)**:
  - 🕊 **Ziyarat Ashura (زیارت عاشورا)** with interactive 100x Peace & Curse counters (۱۰۰ سلام و ۱۰۰ لعن) featuring haptic feedback and completion badges.
  - 🌟 **Ziyarat Warith (زیارت وارث)**: Connecting the legacy of the major Prophets with Imam Hussain (AS).
  - 💫 **Dua Kumayl (دعای کمیل)**: Soulful supplication for Friday nights and Mid-Sha'ban.
  - 🛡 **Dua Tawassul (دعای توسل)**: Seeking intercession of the Prophet (PBUH) and Ahlulbayt.
  - 🌿 **Ziyarat Ale Yasin (زیارت آل یاسین)**: Special Ziyarat for Imam al-Mahdi (AJ).
  - 🤲 **Dua Ahd (دعای عهد)**: Morning renewal of allegiance with the Living Imam.

### 2. Quranic Parables & Metaphors (امثال قرآن) Hub (`lib/src/features/parables/`)
- **Divine Parables Explorer (`QuranParablesScreen`)**:
  - 💡 *The Light of Allah (آیه نور - النور: ۳۵)*: Niche, lamp, pearly star, and the blessed olive tree.
  - 🕸 *The Spider's Web (مَثَل عنکبوت - العنکبوت: ۴۱)*: The utter frailty of polytheism and false idols.
  - 🌧 *The Rain on the Hard Rock (باران بر تخته سنگ - البقرة: ۲۶۴)*: The ruin of insincere and ostentatious charity.
  - 🌳 *The Good Word as a Pure Tree (کلمه طیبه شجره طیبه - ابراهیم: ۲۴)*: Deep-rooted faith producing endless fruits.
  - 📚 *The Donkey Carrying Books (حمل تورات و غفلت - الجمعة: ۵)*: The futility of knowledge without practice.
  - 🏜 *The Desert Mirage (سراب در کویر - النور: ۳۹)*: The illusion of disbelievers' deeds on the Day of Judgment.
- **Detailed Metaphorical Breakdown**: Allegory subject, moral lessons, and symbolic keys with 1-tap navigation to the Quran reader.

### 3. Islamic Will & Spiritual Testament (وصیت‌نامه شرعی) Builder (`lib/src/features/wasiyyah/`)
- **Structured Prophetic Wasiyyah Composer (`WasiyyahScreen` & `WasiyyahRepository`)**:
  - 📜 *Spiritual Testimony & Creed (اقرار به توحید، نبوت و ولایت)*
  - 🕌 *Obligatory Religious Dues (قضای نماز، روزه و خمس/زکات)*
  - 💰 *Financial & Trust Bequests (دیون، مطالبات و امانات)*
  - ⚖️ *One-Third Estate Bequests (ثلث مال در امور خیریه)*
  - 🕊 *Personal Advice to Heirs (سفارش‌های اخلاقی و معنوی به فرزندان و بازماندگان)*
- **Export & Utility**: Local SharedPreferences persistence, auto-filled Islamic templates, and formatted text export to clipboard.

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
| **Phase 8 — Companion & Islamic Productivity Suite** | Offline Audio Downloader, Khatmah Planner, Verse-Range Loop, Notes & Qibla. | ✅ Completed |
| **Phase 9 — Devotional & Visual Suite** | Digital Tasbih, 40 Rabbana Duas, Sajdah Verses, Sleep Timer, Ayah Story Cards. | ✅ Completed |
| **Phase 10 — Hifz, Analytics & Quiz Suite** | Hifz Mask Mode, 52-Week Heatmap & Streaks, Quranic Ayah Knowledge Quiz. | ✅ Completed |
| **Phase 11 — Divisions, Smart Bookmarks & Reminders** | 30 Juz & Revelation Index, Tagged Folders & Backup, Daily Ayah Reminders. | ✅ Completed |
| **Phase 12 — Tajweed, Topics & Asmaul Husna** | Color Tajweed Guide, Thematic Topics Index, 99 Names of Allah Hub. | ✅ Completed |
| **Phase 13 — Hijri Calendar, Roots & Daily Adhkar** | Hijri & Moon Tracker, Quranic Roots Explorer, Daily Adhkar Suite. | ✅ Completed |
| **Phase 14 — Ziyarat, Parables & Islamic Wasiyyah** | Ashura 100x & Duas, Quranic Parables, Islamic Will Composer. | ✅ Completed |

---

## 📄 Remote Repository

Changes are pushed to: [github.com/alirezakavianifar/quran_mobile_app.git](https://github.com/alirezakavianifar/quran_mobile_app.git)






