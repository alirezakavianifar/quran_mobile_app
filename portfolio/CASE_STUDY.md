# 📱 Case Study: Quran Knowledge Platform & Mobile App

## 1. Executive Summary
**Quran Knowledge Platform** is an enterprise-grade, intelligent dual-language exploration ecosystem engineered for modern mobile and web clients. Built from the ground up prioritizing **Persian (Farsi RTL)** alongside **English (LTR)**, the platform combines a responsive **Flutter 3.22+** client with a high-performance **ASP.NET Core 8** backend utilizing **Clean Architecture**, **MediatR CQRS**, **PostgreSQL 16 with pgvector**, **OpenSearch 2.x**, **Redis 7**, and a strictly grounded **Retrieval-Augmented Generation (RAG)** AI engine.

The platform solves the fragmented digital Quran experience by delivering sub-second hybrid lexical-vector search, authentic multi-source Tafsir commentary (Tafsir Nemoneh, Al-Mizan, Ibn Kathir), continuous verse-by-verse audio recitation with background streaming, and seamless offline-first SQLite synchronization.

---

## 2. Core Architecture & Tech Stack

```
                          Flutter Mobile App (Android / iOS / Web / Desktop)
                           Riverpod State Management • Drift (SQLite) Engine
                           [Persian RTL (Vazirmatn) / English LTR (Inter)]
                                                 │
                                                 ▼
                                     ASP.NET Core 8 Web API
                           MediatR CQRS • FluentValidation • SignalR Hub
                                                 │
                  ┌──────────────────────────────┼──────────────────────────────┐
                  │                              │                              │
                  ▼                              ▼                              ▼
          PostgreSQL 16 + pgvector          OpenSearch 2.x                   Redis 7
        Relational & Vector Embeddings     BM25 Full-Text Search        Distributed Cache Layer
                  │                              │                              │
                  └──────────────────────────────┼──────────────────────────────┘
                                                 │
                                                 ▼
                                      Grounded AI RAG Engine
                          Google Gemini / xAI Grok / Authentic Tafsir Grounding
```

### Client Layer (Mobile & Web)
- **Framework:** Flutter 3.22+ / Dart 3.4+ (Cross-platform targeting Android, iOS, Web WASM, and Desktop)
- **State Management & Architecture:** Feature-First Clean Architecture powered by Flutter Riverpod
- **Local Persistence & Caching:** Drift (SQLite) with Web WASM support for zero-latency offline reading and bookmarking
- **Typography & Localization:** Dynamic bi-directional layout switching (Persian RTL with *Vazirmatn*, English LTR with *Inter*, and customizable Quranic Arabic fonts: *Amiri*, *Scheherazade New*, *Lateef*)
- **Audio Engine:** `audioplayers` with background audio service, notification controls, and wake lock session persistence

### Backend & AI Gateway Layer
- **Runtime & Framework:** .NET 8 / ASP.NET Core Web API
- **Architecture Pattern:** Clean Architecture with CQRS (Command Query Responsibility Segregation) via MediatR
- **Validation & Pipeline Behaviors:** FluentValidation with custom Persian/English normalization and validation pipelines
- **Real-Time Streaming:** SignalR Hub (`/hubs/aichat`) for token-by-token LLM streaming and conversation telemetry
- **Security & Observability:** Request rate-limiting, standardized `/healthz` liveness/readiness probes, and CORS policies

### Data, Search & Infrastructure Layer
- **Relational & Vector Store:** PostgreSQL 16 with `pgvector` extension for storing 1536-dimensional semantic embeddings
- **Lexical Search Engine:** OpenSearch 2.x with custom Persian and Arabic text analyzers (zero-width non-joiner normalization, diacritic stripping, stemmers)
- **Caching & Message Broker:** Redis 7 for high-throughput query caching and distributed rate-limiting
- **Container Orchestration:** Docker Compose orchestration for unified one-click local and production deployment

---

## 3. Key Feature Modules

### 📖 1. Dynamic Quran Reader & Typography Customization
- **Page & Juz Boundary Indicators:** Real-time dynamic `AppBar` headers tracking active Surah, Juz, and Quran page numbers, accompanied by visual page-divider headers rendered inline as the user scrolls.
- **Customizable Typography Suite:** Independent font-size sliders for Arabic calligraphy (18–42pt) and localized translations (12–28pt), font family selector, and live verse preview card.
- **Eye-Care Themes:** One-touch theme switching between Light, Dark, System, and Sepia eye-care mode.

### 🎧 2. Verse-by-Verse Recitation & Background Streaming
- **Continuous Surah Playback:** Verse-by-verse streaming engine that automatically advances across verses with synchronized text highlighting.
- **Multi-Reciter Profiles:** Support for leading international reciters (Mishary Rashid Alafasy, Mahmoud Khalil Al-Husary, Abdul Basit, Shahriar Parhizgar).
- **Background Media Service:** Full background playback session preservation with lockscreen notifications, Android `FOREGROUND_SERVICE_MEDIA_PLAYBACK`, and iOS `UIBackgroundModes -> audio`.
- **Granular Playback Controls:** Adjustable recitation speed (0.75x–2.0x) with real-time UI timeline slider.

### 🤖 3. Authentic Grounded AI Knowledge Assistant (RAG)
- **Zero-Hallucination Grounding:** Dual-language RAG architecture querying PostgreSQL `pgvector` and OpenSearch to ground LLM responses strictly in authentic Quran verses and respected Tafsirs (**Tafsir Nemoneh**, **Al-Mizan**, and **Ibn Kathir**).
- **Interactive Verse Citations:** AI responses return structured metadata and interactive verse reference cards enabling users to jump directly to the referenced Ayah.
- **Provider Agnostic Engine:** Pluggable LLM integration supporting Google Gemini API, xAI Grok API, and offline Mock providers configurable at runtime.

### 🔍 4. Hybrid Lexical & Semantic Vector Search
- **Reciprocal Rank Fusion (RRF):** Combines OpenSearch BM25 lexical keyword matching with `pgvector` cosine similarity embeddings, ensuring comprehensive recall for both exact phrase queries and conceptual topic searches.
- **Multilingual NLP Pipelines:** Native Persian and Arabic character normalizers handling Alef variations, Yeh/Kaf Persian-Arabic unification, and diacritic handling.

### ☁️ 5. Offline-First Storage & Multi-Device Cloud Synchronization
- **Local SQLite Engine:** Complete offline reading, bookmarking, and reading history powered by Drift.
- **Cloud Sync API:** Two-way synchronization between client SQLite databases and the PostgreSQL backend with timestamp-based conflict resolution (latest write wins).

### 📊 6. Administrative Telemetry & Control Suite
- **Web Admin Dashboard (`/admin`):** Integrated management console hosted natively by ASP.NET Core Static Files with bilingual Persian RTL / English LTR support.
- **Real-Time Telemetry:** Live monitoring of Surah/Verse counts, vector embedding totals, search query analytics, and AI conversation moderation logs.
- **Runtime LLM Switcher:** Administrative controls to switch active AI model providers on the fly without server restarts.

---

## 4. Engineering Challenges & Solutions

| Challenge | Engineering Solution |
| :--- | :--- |
| **Bilingual LTR / RTL Symmetry** | Implemented responsive layout directions in Flutter with custom `Directionality` wrappers and dual font stacks (*Vazirmatn* for Persian, *Inter* for English), paired with ASP.NET Core `RequestLocalization` middleware. |
| **Sub-Second Hybrid Search Latency** | Orchestrated parallel execution of OpenSearch BM25 queries and PostgreSQL `pgvector` cosine similarity searches, fusing ranked results using Reciprocal Rank Fusion (RRF) algorithms cached via Redis. |
| **Offline-First Data Sync & Conflict Resolution** | Architected a Drift SQLite local schema mirroring PostgreSQL user entities, utilizing UTC timestamp comparisons and idempotent batch sync endpoints (`POST /api/v1/sync`). |
| **Mobile OS Background Audio Throttling** | Configured foreground media playback services with `WAKE_LOCK` permissions, lockscreen notification actions, and audio session category policies across Android and iOS. |
| **LLM Hallucination in Religious Texts** | Implemented strict prompt injection guardrails that inject verbatim verse text and Tafsir commentary into the system context, forcing the LLM to cite verse numbers `[Surah:Ayah]` or decline answering if out of scope. |

---

## 5. Deliverables & Repository

- **Source Code Repository:** [github.com/alirezakavianifar/quran_mobile_app](https://github.com/alirezakavianifar/quran_mobile_app)
- **Architecture Structure:** Clean Architecture `.NET 8` solution (`API`, `Application`, `Domain`, `Infrastructure`) and Feature-First `Flutter` client (`src/features/*`, `src/core/*`).
- **Master Release Artifact:** Ready-to-install Android Release APK (`app-release.apk`).
- **Comprehensive Documentation:** Full architectural guides and multi-phase implementation plans under [`docs/`](../docs/).
