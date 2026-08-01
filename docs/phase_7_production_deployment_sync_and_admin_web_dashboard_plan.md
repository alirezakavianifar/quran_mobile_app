# Phase 7 Implementation Plan — Production Deployment, Containerization, Admin Web Dashboard & Real-Time Sync Services

## Overview
This document outlines the implementation plan for **Phase 7 (Production Deployment, Containerization, Admin Web Dashboard UI, Cross-Device Sync & Audio Recitation Services)** of the Quran Knowledge Platform, building upon Phase 6 as established in `plan.md`.

Phase 7 completes the production infrastructure by providing containerized Docker orchestration, a bilingual Web Admin Dashboard UI (Persian RTL default / English LTR), cloud data synchronization services for user bookmarks/history/notes, audio recitation streaming metadata APIs, and comprehensive verification.

---

## Key Deliverables & Architectural Scope

```
Quran Platform — Phase 7 Components
├── Production Containerization & Deployment
│   ├── Dockerfile                              # Multi-stage ASP.NET Core 9 build file
│   ├── docker-compose.yml                      # Orchestrates API, PostgreSQL+pgvector, Redis, OpenSearch
│   └── .env.example                            # Production environment template
│
├── Web Admin Dashboard UI
│   ├── wwwroot/admin/index.html                # Localized (FA/EN) Admin Portal Single Page Application
│   ├── wwwroot/admin/app.js                    # Dynamic Dashboard logic (Stats, Analytics, AI Logs)
│   └── wwwroot/admin/style.css                 # RTL/LTR Responsive styling with dark mode & glassmorphism
│
├── User Cloud Synchronization Service
│   ├── SyncUserDataCommand.cs                  # CQRS Command for sync payload processing
│   ├── GetUserDataQuery.cs                     # CQRS Query for retrieving remote sync state
│   └── SyncController.cs                       # REST API endpoint /api/v1/sync
│
├── Audio Recitation & Streaming Service
│   ├── GetRecitersQuery.cs                     # CQRS Query for available Quran reciters
│   ├── GetAyahAudioQuery.cs                    # CQRS Query for verse audio stream URLs & timestamps
│   └── AudioController.cs                      # REST API endpoint /api/v1/audio
│
├── Automated Testing & Verification
│   ├── SyncServiceTests.cs                     # Unit tests for synchronization logic & conflict resolution
│   ├── AudioServiceTests.cs                    # Unit tests for reciter audio URL generation
│   └── SyncAndAudioIntegrationTests.cs         # End-to-end integration tests
│
└── Documentation & Operations
    └── README.md                               # Updated setup guide with Docker Compose instructions
```

---

## Proposed Changes

### 1. Presentation & API Layer (`src/QuranPlatform.API`)
- **[NEW]** `src/QuranPlatform.API/Dockerfile` — Multi-stage production container build definition.
- **[NEW]** `src/QuranPlatform.API/Controllers/SyncController.cs` — Handles `/api/v1/sync` POST/GET operations.
- **[NEW]** `src/QuranPlatform.API/Controllers/AudioController.cs` — Handles `/api/v1/audio/reciters` and `/api/v1/audio/ayah` endpoints.
- **[NEW]** `src/QuranPlatform.API/wwwroot/admin/index.html` — Web Admin Dashboard HTML layout with RTL Persian / LTR support.
- **[NEW]** `src/QuranPlatform.API/wwwroot/admin/app.js` — JavaScript controller fetching `/api/v1/admin/stats`, `/search-analytics`, and `/ai-logs`.
- **[NEW]** `src/QuranPlatform.API/wwwroot/admin/style.css` — Modern Vazirmatn/Inter UI styling for Admin dashboard.
- **[MODIFY]** `src/QuranPlatform.API/Program.cs` — Enable `UseStaticFiles()` and register Sync and Audio services.

### 2. Application Layer (`src/QuranPlatform.Application`)
- **[NEW]** `src/QuranPlatform.Application/Sync/Commands/SyncUserDataCommand.cs` & `SyncUserDataCommandHandler.cs`
- **[NEW]** `src/QuranPlatform.Application/Sync/Queries/GetUserDataQuery.cs` & `GetUserDataQueryHandler.cs`
- **[NEW]** `src/QuranPlatform.Application/Sync/DTOs/SyncPayloadDto.cs`
- **[NEW]** `src/QuranPlatform.Application/Audio/Queries/GetRecitersQuery.cs` & `GetRecitersQueryHandler.cs`
- **[NEW]** `src/QuranPlatform.Application/Audio/Queries/GetAyahAudioQuery.cs` & `GetAyahAudioQueryHandler.cs`
- **[NEW]** `src/QuranPlatform.Application/Audio/DTOs/ReciterDto.cs` & `AyahAudioDto.cs`

### 3. Orchestration & Environment (`root`)
- **[NEW]** `docker-compose.yml` — Container stack containing API, PostgreSQL 16 (pgvector), Redis 7, and OpenSearch 2.x.
- **[NEW]** `.env.example` — Environment configuration keys for Docker Compose.

### 4. Unit & Integration Testing (`tests/`)
- **[NEW]** `tests/QuranPlatform.UnitTests/Sync/SyncServiceTests.cs`
- **[NEW]** `tests/QuranPlatform.UnitTests/Audio/AudioServiceTests.cs`
- **[MODIFY]** `tests/QuranPlatform.IntegrationTests/ApiIntegrationTests.cs` — Add tests for `/api/v1/sync` and `/api/v1/audio` endpoints.

### 5. Flutter App Sync & Audio Integration (`src/quran_mobile_app`)
- **[NEW]** `src/quran_mobile_app/lib/src/features/sync/data/sync_repository.dart` — Sync service client for sync backend integration.
- **[NEW]** `src/quran_mobile_app/lib/src/features/audio/data/audio_repository.dart` — Reciter audio player repository.

### 6. Documentation (`README.md`)
- **[MODIFY]** `README.md` — Include Docker Compose single-command launch guide, Admin Web Dashboard usage, Sync API specs, and Audio player documentation.

---

## Step-by-Step Implementation Workflow

1. **Step 1 — Application Layer (Sync & Audio CQRS Handlers & DTOs)**:
   - Implement `SyncUserDataCommand`, `GetUserDataQuery`, `GetRecitersQuery`, `GetAyahAudioQuery` and their respective DTOs.
2. **Step 2 — API Controllers & Static File Hosting**:
   - Implement `SyncController.cs` and `AudioController.cs`.
   - Update `Program.cs` to configure Static Files middleware.
3. **Step 3 — Web Admin Dashboard UI Implementation**:
   - Build `index.html`, `app.js`, and `style.css` under `src/QuranPlatform.API/wwwroot/admin/`.
   - Implement dynamic tabs for System Stats, Search Analytics, AI Logs, and Content Moderation.
4. **Step 4 — Flutter Mobile/Web Repositories for Sync & Audio**:
   - Implement `sync_repository.dart` and `audio_repository.dart` in Flutter app with provider bindings.
5. **Step 5 — Containerization & Docker Orchestration**:
   - Create `src/QuranPlatform.API/Dockerfile` and root `docker-compose.yml`.
6. **Step 6 — Automated Unit & Integration Tests**:
   - Write and execute unit and integration test suites for Sync, Audio, and Admin Web endpoints.
7. **Step 7 — Documentation & Launch Verification**:
   - Update `README.md` and run full solution validation (`dotnet test`, `flutter test`, `pytest`).

---

## Verification Plan

### Automated Tests
- `.NET Solution`: `dotnet test` (Pass all Unit and Integration tests, including Sync, Audio, and Admin endpoints).
- `Python Suite`: `pytest` (Verify data curation and NLP scripts).
- `Flutter Suite`: `flutter test` in `src/quran_mobile_app` (Verify mobile and web app unit tests).

### Manual Verification
- Test Docker image build via `docker build` / `docker-compose config`.
- Verify Web Admin Dashboard at `http://localhost:5000/admin` (or ASP.NET API static route).
- Validate `/api/v1/sync` and `/api/v1/audio/reciters` REST endpoints.
