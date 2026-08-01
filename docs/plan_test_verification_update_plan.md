# Implementation Plan — Adding Test & Verification Sub-Phases to Master Plan (`plan.md`)

This implementation plan outlines the updates required for [plan.md](file:///e:/projects/quran_mobile_app/plan.md) to ensure that every development phase (Phase 0 through Phase 5) contains a comprehensive, structured **Test & Verification** sub-phase.

## User Review Required

> [!NOTE]
> Each phase in `plan.md` will be updated with concrete, domain-specific testing strategies, automated validation suites, performance SLAs, and verification workflows tailored to that phase's tech stack (e.g., Python/NLP for Phase 0, EF Core/Postgres for Phase 1, ASP.NET Core xUnit/Testcontainers for Phase 2, OpenSearch/Vector benchmarks for Phase 3, RAG eval/grounding suites for Phase 4, and Flutter unit/golden tests for Phase 5).

## Proposed Changes

### Master Architecture Plan ([plan.md](file:///e:/projects/quran_mobile_app/plan.md))

#### [MODIFY] [plan.md](file:///e:/projects/quran_mobile_app/plan.md)

1. **Phase 0 — Research & Data Curation**:
   - Add `## Testing & Verification` subsection covering:
     - Dataset JSON Schema & Unicode encoding integrity tests.
     - Persian ZWNJ, character mapper, and diacritic stripping normalization unit tests.
     - Dense cross-lingual embedding semantic alignment benchmarks.
     - Data ingestion record count cross-validation (Postgres vs pgvector vs OpenSearch).

2. **Phase 1 — Database Design**:
   - Add `## Testing & Verification` subsection covering:
     - EF Core migration dry-run and schema validation.
     - Foreign key & relational constraint verification tests.
     - Seed data validation for bilingual default preferences (`fa-IR`/`en-US`).
     - Query execution plan (`EXPLAIN ANALYZE`) performance benchmarking for indexed columns.

3. **Phase 2 — Backend Architecture (ASP.NET Core)**:
   - Add `## Testing & Verification` subsection covering:
     - Unit test suite for Domain entities & MediatR pipeline behaviors (`CultureContextBehavior`, `ValidationBehavior`).
     - Integration testing using `WebApplicationFactory` & Testcontainers for PostgreSQL and Redis.
     - Request localization middleware tests (`Accept-Language` header resolving to Persian default `fa-IR`).
     - Architecture & layer isolation tests using NetArchTest to enforce Clean Architecture rules.

4. **Phase 3 — Search Engine**:
   - Add `## Testing & Verification` subsection covering:
     - OpenSearch BM25 lexical precision & recall evaluations against golden query sets in Persian & English.
     - Cross-lingual semantic vector similarity search validation using benchmark queries.
     - Reciprocal Rank Fusion (RRF) algorithm deterministic scoring and tie-breaking unit tests.
     - Search latency SLAs (< 100ms response time) verified via automated load/stress testing (k6/NBomber).

5. **Phase 4 — AI & RAG Engine Architecture**:
   - Add `## Testing & Verification` subsection covering:
     - Grounding & anti-hallucination evaluation suite measuring response adherence to retrieved Tafsir Nemoneh / Al-Mizan excerpts.
     - Citation integrity checker validating verse references `[سوره:آیه]` against database entities.
     - Out-of-bounds / guardrail regression test suite for unanswerable or non-Quranic prompts.
     - SignalR real-time streaming reliability and latency tests.

6. **Phase 5 — Flutter Mobile App Architecture**:
   - Add `## Testing & Verification` subsection covering:
     - Unit & Riverpod state notifier test suite for all presentation and domain logic.
     - Drift SQLite offline database migration and local CRUD integration tests.
     - RTL (Persian/Vazirmatn) vs LTR (English/Inter) layout visual golden tests.
     - End-to-End (E2E) UI performance verification ensuring smooth 60fps scrolling and fast initial load.

7. **Suggested Development Timeline**:
   - Update timeline table to explicitly detail verification gates for each phase milestone.

---

## Verification Plan

### Automated Tests
- Validate markdown syntax and link integrity across `plan.md`.
- Verify that every phase heading (`Phase 0` through `Phase 5`) explicitly includes a `Testing & Verification` section.

### Manual Verification
- Review the updated `plan.md` to ensure all 6 phases have comprehensive, domain-tailored testing strategies and that formatting remains clean and consistent.
