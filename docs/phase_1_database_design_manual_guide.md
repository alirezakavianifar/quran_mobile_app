# Phase 1 — Database Design: Manual Execution Guide

This document provides step-by-step instructions to manually implement **Phase 1 (Database Design)** of the Quran Knowledge Platform project.

---

## Overview of Phase 1

Phase 1 focuses on designing, setting up, migrating, seeding, and verifying the PostgreSQL relational and vector database schema for bilingual (Persian primary / English secondary) Quran text, translations, Tafsir commentaries, metadata taxonomy, and user settings.

---

## Step 1: Database Environment Setup (Docker Standard)

The project uses a containerized **PostgreSQL + pgvector** environment running via Docker.

### 1. Launch the Database Container

Run the following command in PowerShell or terminal:

```powershell
docker run -d `
  --name quran_postgres `
  -e POSTGRES_DB=quran_db `
  -e POSTGRES_USER=quran_admin `
  -e POSTGRES_PASSWORD=quran_pass `
  -p 5432:5432 `
  ankane/pgvector:latest
```

*(Alternatively as a single line command: `docker run -d --name quran_postgres -e POSTGRES_DB=quran_db -e POSTGRES_USER=quran_admin -e POSTGRES_PASSWORD=quran_pass -p 5432:5432 ankane/pgvector:latest`)*

### 2. Environment & Connection Parameters
- **Container Name**: `quran_postgres`
- **Host**: `localhost` (or `127.0.0.1`)
- **Port**: `5432`
- **Database**: `quran_db`
- **User**: `quran_admin`
- **Password**: `quran_pass`

### 3. Verify Container & Enable Extension

Verify the container is active and enable the `vector` extension:

```powershell
# Verify container status
docker ps

# Enable pgvector extension inside the database
docker exec -it quran_postgres psql -U quran_admin -d quran_db -c "CREATE EXTENSION IF NOT EXISTS vector;"
```

---

## Step 2: Database Schema Creation (DDL) & Indexing

The schema DDL is located in [`sql/schema_phase1.sql`](file:///e:/projects/quran_mobile_app/sql/schema_phase1.sql).

### Method 1: Single Command Execution (Recommended)

Run the following command in PowerShell to apply the complete schema and indexes to the container:

```powershell
Get-Content sql\schema_phase1.sql | docker exec -i quran_postgres psql -U quran_admin -d quran_db
```

### Method 2: Interactive Terminal (`psql`)

Alternatively, open an interactive PostgreSQL shell in the container:

```powershell
docker exec -it quran_postgres psql -U quran_admin -d quran_db
```

```sql
-- 1. Users & Localization Settings
CREATE TABLE "Users" (
    "Id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "Email" VARCHAR(255) UNIQUE NOT NULL,
    "CreatedAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "UserSettings" (
    "UserId" UUID PRIMARY KEY REFERENCES "Users"("Id") ON DELETE CASCADE,
    "PreferredLanguage" VARCHAR(10) DEFAULT 'fa',
    "SecondaryLanguage" VARCHAR(10) DEFAULT 'en',
    "DefaultTranslationId" INT,
    "DefaultTafsirId" INT,
    "TextDirection" VARCHAR(5) DEFAULT 'rtl',
    "FontFamily" VARCHAR(100) DEFAULT 'Vazirmatn',
    "QuranFontSize" INT DEFAULT 22,
    "TranslationFontSize" INT DEFAULT 16
);

-- 2. Quran Text & Translations
CREATE TABLE "Surah" (
    "Id" INT PRIMARY KEY,
    "Number" INT UNIQUE NOT NULL,
    "NameArabic" VARCHAR(100) NOT NULL,
    "NamePersian" VARCHAR(100) NOT NULL,
    "NameEnglish" VARCHAR(100) NOT NULL,
    "RevelationType" VARCHAR(20) NOT NULL,
    "VerseCount" INT NOT NULL
);

CREATE TABLE "Verse" (
    "Id" INT PRIMARY KEY,
    "SurahId" INT REFERENCES "Surah"("Id") ON DELETE CASCADE,
    "VerseNumber" INT NOT NULL,
    "PageNumber" INT NOT NULL,
    "JuzNumber" INT NOT NULL,
    "TextUthmani" TEXT NOT NULL,
    "TextSimple" TEXT NOT NULL,
    CONSTRAINT "UQ_Surah_VerseNumber" UNIQUE ("SurahId", "VerseNumber")
);

CREATE TABLE "Translation" (
    "Id" SERIAL PRIMARY KEY,
    "VerseId" INT REFERENCES "Verse"("Id") ON DELETE CASCADE,
    "LanguageCode" VARCHAR(10) NOT NULL, -- 'fa' or 'en'
    "AuthorName" VARCHAR(100) NOT NULL,
    "TranslationText" TEXT NOT NULL
);

CREATE TABLE "Transliteration" (
    "Id" SERIAL PRIMARY KEY,
    "VerseId" INT REFERENCES "Verse"("Id") ON DELETE CASCADE,
    "LanguageCode" VARCHAR(10) NOT NULL,
    "TransliterationText" TEXT NOT NULL
);

-- 3. Tafsir Commentary
CREATE TABLE "TafsirEdition" (
    "Id" SERIAL PRIMARY KEY,
    "Name" VARCHAR(150) NOT NULL,
    "Author" VARCHAR(150) NOT NULL,
    "LanguageCode" VARCHAR(10) NOT NULL,
    "IsDefault" BOOLEAN DEFAULT FALSE
);

CREATE TABLE "TafsirContent" (
    "Id" SERIAL PRIMARY KEY,
    "TafsirEditionId" INT REFERENCES "TafsirEdition"("Id") ON DELETE CASCADE,
    "VerseId" INT REFERENCES "Verse"("Id") ON DELETE CASCADE,
    "VolumeNumber" INT DEFAULT 1,
    "ContentText" TEXT NOT NULL,
    CONSTRAINT "UQ_Tafsir_Edition_Verse" UNIQUE ("TafsirEditionId", "VerseId")
);

-- 4. Taxonomy & Vector Embeddings
CREATE TABLE "Topic" (
    "Id" SERIAL PRIMARY KEY,
    "NamePersian" VARCHAR(200) NOT NULL,
    "NameEnglish" VARCHAR(200) NOT NULL,
    "Category" VARCHAR(100) NOT NULL
);

CREATE TABLE "Keyword" (
    "Id" SERIAL PRIMARY KEY,
    "WordPersian" VARCHAR(100) NOT NULL,
    "WordEnglish" VARCHAR(100) NOT NULL,
    "RootArabic" VARCHAR(50)
);

CREATE TABLE "Embedding" (
    "Id" SERIAL PRIMARY KEY,
    "VerseId" INT REFERENCES "Verse"("Id") ON DELETE CASCADE,
    "LanguageCode" VARCHAR(10) NOT NULL,
    "VectorData" vector(1536) -- Adjust vector dimensions based on model selection
);

-- 5. AI Conversation Tables
CREATE TABLE "Conversation" (
    "Id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "UserId" UUID REFERENCES "Users"("Id") ON DELETE CASCADE,
    "Title" VARCHAR(255) NOT NULL,
    "LanguageCode" VARCHAR(10) DEFAULT 'fa',
    "CreatedAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "ConversationMessage" (
    "Id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "ConversationId" UUID REFERENCES "Conversation"("Id") ON DELETE CASCADE,
    "SenderRole" VARCHAR(20) NOT NULL, -- 'user' or 'assistant'
    "ContentText" TEXT NOT NULL,
    "LanguageCode" VARCHAR(10) DEFAULT 'fa',
    "CreatedAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "MessageCitation" (
    "Id" SERIAL PRIMARY KEY,
    "MessageId" UUID REFERENCES "ConversationMessage"("Id") ON DELETE CASCADE,
    "VerseId" INT REFERENCES "Verse"("Id") ON DELETE CASCADE
);

-- 6. User Interactions
CREATE TABLE "Bookmarks" (
    "Id" SERIAL PRIMARY KEY,
    "UserId" UUID REFERENCES "Users"("Id") ON DELETE CASCADE,
    "VerseId" INT REFERENCES "Verse"("Id") ON DELETE CASCADE,
    "CreatedAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "Highlights" (
    "Id" SERIAL PRIMARY KEY,
    "UserId" UUID REFERENCES "Users"("Id") ON DELETE CASCADE,
    "VerseId" INT REFERENCES "Verse"("Id") ON DELETE CASCADE,
    "ColorHex" VARCHAR(7) DEFAULT '#FFD700',
    "CreatedAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "Notes" (
    "Id" SERIAL PRIMARY KEY,
    "UserId" UUID REFERENCES "Users"("Id") ON DELETE CASCADE,
    "VerseId" INT REFERENCES "Verse"("Id") ON DELETE CASCADE,
    "NoteText" TEXT NOT NULL,
    "CreatedAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
```

---

## Step 3: Performance & Vector Indexing

Run the following index creations for high-performance lookup and vector similarity search:

```sql
-- Relational indexes
CREATE INDEX "IX_Verse_SurahId_VerseNumber" ON "Verse" ("SurahId", "VerseNumber");
CREATE INDEX "IX_Translation_VerseId_Lang" ON "Translation" ("VerseId", "LanguageCode");
CREATE INDEX "IX_TafsirContent_VerseId" ON "TafsirContent" ("VerseId");

-- Vector Cosine Similarity HNSW Index
CREATE INDEX "IX_Embedding_VectorData" ON "Embedding" USING hnsw ("VectorData" vector_cosine_ops);
```

---

## Step 4: Data Ingestion & Seeding

Import the processed datasets generated during **Phase 0** (located under `data/processed/`):
- `data/processed/quran_uthmani.json` -> Insert into `Surah` and `Verse`.
- `data/processed/translations_fa_makarem.json` -> Insert into `Translation` (`LanguageCode = 'fa'`).
- `data/processed/translations_en_khattab.json` -> Insert into `Translation` (`LanguageCode = 'en'`).
- `data/processed/tafsir_fa_nemoneh.json` -> Insert into `TafsirContent` (`LanguageCode = 'fa'`).
- `data/processed/metadata_taxonomy.json` -> Insert into `Topic` and `Keyword`.

---

## Step 5: Verification & Benchmarks

Run the following test queries directly against the `quran_postgres` Docker container to verify database integrity and performance:

1. **Verify Entity Counts**:
   ```powershell
   docker exec -it quran_postgres psql -U quran_admin -d quran_db -c 'SELECT COUNT(*) FROM "Surah";'       # Expected: 114
   docker exec -it quran_postgres psql -U quran_admin -d quran_db -c 'SELECT COUNT(*) FROM "Verse";'       # Expected: 6236
   docker exec -it quran_postgres psql -U quran_admin -d quran_db -c 'SELECT COUNT(*) FROM "Translation";' # Expected: 12472 (6236 FA + 6236 EN)
   ```

2. **Run Performance Execution Plan Benchmark**:
   ```powershell
   docker exec -it quran_postgres psql -U quran_admin -d quran_db -c 'EXPLAIN ANALYZE SELECT v."VerseNumber", v."TextUthmani", t."TranslationText" FROM "Verse" v JOIN "Translation" t ON v."Id" = t."VerseId" WHERE v."SurahId" = 2 AND t."LanguageCode" = '\''fa'\'';'
   ```
   *Target Execution Time: < 10ms.*
