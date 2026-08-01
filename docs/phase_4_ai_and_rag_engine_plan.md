# Phase 4 Implementation Plan — AI & RAG Engine Architecture

## Overview
This document outlines the step-by-step implementation plan for **Phase 4 (AI & Grounded RAG Engine Architecture)** of the Quran Platform, as defined in `plan.md`.

The RAG engine powers bilingual (Persian primary default / English secondary) AI question-answering strictly grounded in authentic Quranic verses and Tafsir commentaries (Tafsir Nemoneh / Al-Mizan for Persian, Ibn Kathir for English).

---

## Technical Scope & Architecture

```
User Query (fa/en)
       │
       ▼
┌─────────────────────────────────────────────────────────────┐
│                      IRagEngine                             │
│ 1. Normalize Query & Determine Culture                      │
│ 2. Generate Query Embedding (IEmbeddingService)             │
│ 3. Perform Vector Similarity Search (IVectorSearchService)  │
│ 4. Hydrate Verses & Tafsir Context (IQuranRepo/ITafsirRepo) │
│ 5. Assemble Grounded System Prompt & Guardrails             │
│ 6. Stream Answer via ILLMProvider                           │
└─────────────────────────────────────────────────────────────┘
       │
       ├───────────────────────────────┐
       ▼                               ▼
AiChatHub (SignalR Streaming)    AiController (REST POST /ask)
```

---

## Key Components to Implement / Update

### 1. Application Layer (`QuranPlatform.Application`)
- **[NEW] `QuranPlatform.Application/Common/Interfaces/ILLMProvider.cs`**:
  Update/define `ILLMProvider` interface supporting both single-shot generation and token-by-token streaming (`IAsyncEnumerable<string>`).
- **[NEW] `QuranPlatform.Application/Common/Interfaces/IEmbeddingService.cs`**:
  Interface for query vector generation.
- **[NEW] `QuranPlatform.Application/Common/Interfaces/IRagEngine.cs` & DTOs**:
  Interfaces for `IRagEngine`, `GroundedAnswer`, `GroundedCitation`, and `SystemInstruction`.
- **[NEW] `QuranPlatform.Application/AI/RagPromptBuilder.cs`**:
  Constructs grounded system instructions for Persian (`fa-IR`) and English (`en-US`), enforcing strict citations (`[سوره البقرة ۲:۲۵۵]`) and guardrail responses when context is insufficient.
- **[NEW] `QuranPlatform.Application/AI/RagEngine.cs`**:
  Core RAG engine implementation linking vector search, database hydration, prompt assembly, and LLM streaming.

### 2. Infrastructure Layer (`QuranPlatform.Infrastructure`)
- **[MODIFY] `QuranPlatform.Infrastructure/AI/LLMProviderAdapter.cs`**:
  Implement `ILLMProvider` with support for streaming responses and mock/production providers.
- **[NEW] `QuranPlatform.Infrastructure/AI/EmbeddingServiceAdapter.cs`**:
  Implement `IEmbeddingService` for vector embeddings.

### 3. API Layer (`QuranPlatform.API`)
- **[MODIFY] `QuranPlatform.API/Controllers/AiController.cs`**:
  Update `Ask` endpoint to invoke `IRagEngine` and return structured `GroundedAnswer`.
- **[MODIFY] `QuranPlatform.API/Hubs/AiChatHub.cs`**:
  Update SignalR hub to stream tokens directly from `IRagEngine.StreamAnswerAsync`.
- **[MODIFY] `QuranPlatform.API/Program.cs`**:
  Register DI bindings for `IRagEngine`, `ILLMProvider`, `IEmbeddingService`.

### 4. Tests (`QuranPlatform.UnitTests`)
- **[NEW] `tests/QuranPlatform.UnitTests/AITests/RagEngineTests.cs`**:
  Unit tests verifying prompt formatting, citation parsing, fallback guardrails, and streaming behavior.

---

## Verification & Testing Plan

1. **Unit Verification**:
   - Test `RagPromptBuilder` for proper Persian and English system prompt generation and context formatting.
   - Test `RagEngine` with mock dependencies to ensure proper query embedding -> vector lookup -> context hydration -> LLM invocation pipeline flow.
   - Verify out-of-bounds guardrail fallback when retrieved candidate list is empty.
2. **Build & Test Command**:
   - Run `dotnet test` across the entire solution to ensure zero regression across architecture, search, and domain tests.

---

## Implementation Steps Execution Order

1. **Step 1**: Create/update core interfaces in `QuranPlatform.Application.Common.Interfaces`.
2. **Step 2**: Implement `RagPromptBuilder` and `RagEngine` in `QuranPlatform.Application.AI`.
3. **Step 3**: Update `LLMProviderAdapter` and create `EmbeddingServiceAdapter` in `QuranPlatform.Infrastructure.AI`.
4. **Step 4**: Update `AiController` and `AiChatHub` in `QuranPlatform.API`.
5. **Step 5**: Update DI registrations in `QuranPlatform.API/Program.cs`.
6. **Step 6**: Add unit tests in `QuranPlatform.UnitTests/AITests/RagEngineTests.cs` and run full verification (`dotnet test`).
