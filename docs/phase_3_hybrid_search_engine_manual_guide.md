# Phase 3 — Hybrid Search Engine: Manual Execution Guide

This document provides a comprehensive, step-by-step guide to implement **Phase 3 (Multilingual Hybrid Search Engine)** of the Quran Knowledge Platform project.

---

## 📌 Phase 3 Overview

Phase 3 builds a high-performance **Multilingual Hybrid Search Engine** combining **BM25 Lexical Search (OpenSearch)** and **Dense Vector Semantic Search (`pgvector`)** merged using **Reciprocal Rank Fusion (RRF)**.

```
                          Client Request (fa-IR or en-US)
                                        │
                                        ▼
                           MultilingualSearchOrchestrator
                                        │
                      ┌─────────────────┴─────────────────┐
                      ▼                                   ▼
        OpenSearch BM25 Lexical Search           pgvector Cosine Semantic Search
       (Persian ZWNJ / English Stemmer)        (Cross-Lingual Vector Embeddings)
                      │                                   │
                      └─────────────────┬─────────────────┘
                                        ▼
                          ReciprocalRankFusion (RRF)
                          RRF(d) = 1/(60+r_bm25) + 1/(60+r_vec)
                                        │
                                        ▼
                           PostgreSQL Verse Hydration
                        (Makarem Shirazi / Khattab)
```

---

## 🛠️ Step 1: Core Search Contracts & Data Models

In `src/QuranPlatform.Domain/Search/`:
- **`SearchQuery.cs`**: Query string, `PreferredCulture`, Page, PageSize, Weights (`LexicalWeight`, `SemanticWeight`).
- **`SearchResult.cs`**: Ranked list of `SearchHitDto` with AyahKey, SurahName, VerseNumber, MatchScore, HighlightSnippets.
- **`ISearchOrchestrator.cs`**: Contract for orchestrating parallel lexical + vector search and RRF re-ranking.

---

## 🛠️ Step 2: Implement Reciprocal Rank Fusion (RRF) Engine

In `src/QuranPlatform.Application/Search/ReciprocalRankFusion.cs`:
Implement the deterministic RRF merging algorithm:

$$\text{RRF}(d) = \sum_{m \in M} \frac{1}{k + r_m(d)}$$

where $k = 60$, and $r_m(d)$ is the 1-based rank position of document $d$ in result set $m$.

---

## 🛠️ Step 3: Implement OpenSearch Lexical Search Indexer & Query Service

In `src/QuranPlatform.Infrastructure/Search/OpenSearchService.cs`:
- Configure Persian OpenSearch Analyzer:
  - `zwnj_filter` for Zero-Width Non-Joiner handling.
  - `persian_char_filter` (`ی`/`ي`, `ک`/`ك`).
  - Persian stemmer & Tashkeel diacritics stripper.
- Configure English OpenSearch Analyzer:
  - English lowercase & Porter stemmer.
- Execute BM25 phrase, keyword, and fuzzy searches.

---

## 🛠️ Step 4: Implement `pgvector` Dense Semantic Vector Search

In `src/QuranPlatform.Infrastructure/Search/PgvectorSearchService.cs`:
- Query `pgvector` using cosine distance (`<=>` operator) across 1536-dimensional cross-lingual embedding vectors.

---

## 🛠️ Step 5: Application CQRS Search Handler & API Endpoint

- `SearchVersesQuery`: MediatR query accepting search terms and culture context.
- `SearchController.cs`: REST endpoint `GET /api/v1/search?q=...`.

---

## 🛠️ Step 6: Testing & Relevancy Benchmarks

- RRF Rank Merging Unit Tests: Verify score calculation and tie-breaking.
- BM25 Lexical Precision Tests: Test ZWNJ and character variant normalization matching.
- Vector Cosine Similarity Tests: Test cross-lingual semantic query matching.
