-- Phase 1: Database Schema Creation (DDL) & Indexing

-- Enable vector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- 1. Users & Localization Settings
CREATE TABLE IF NOT EXISTS "Users" (
    "Id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "Email" VARCHAR(255) UNIQUE NOT NULL,
    "CreatedAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS "UserSettings" (
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
CREATE TABLE IF NOT EXISTS "Surah" (
    "Id" INT PRIMARY KEY,
    "Number" INT UNIQUE NOT NULL,
    "NameArabic" VARCHAR(100) NOT NULL,
    "NamePersian" VARCHAR(100) NOT NULL,
    "NameEnglish" VARCHAR(100) NOT NULL,
    "RevelationType" VARCHAR(20) NOT NULL,
    "VerseCount" INT NOT NULL
);

CREATE TABLE IF NOT EXISTS "Verse" (
    "Id" INT PRIMARY KEY,
    "SurahId" INT REFERENCES "Surah"("Id") ON DELETE CASCADE,
    "VerseNumber" INT NOT NULL,
    "PageNumber" INT NOT NULL,
    "JuzNumber" INT NOT NULL,
    "TextUthmani" TEXT NOT NULL,
    "TextSimple" TEXT NOT NULL,
    CONSTRAINT "UQ_Surah_VerseNumber" UNIQUE ("SurahId", "VerseNumber")
);

CREATE TABLE IF NOT EXISTS "Translation" (
    "Id" SERIAL PRIMARY KEY,
    "VerseId" INT REFERENCES "Verse"("Id") ON DELETE CASCADE,
    "LanguageCode" VARCHAR(10) NOT NULL, -- 'fa' or 'en'
    "AuthorName" VARCHAR(100) NOT NULL,
    "TranslationText" TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS "Transliteration" (
    "Id" SERIAL PRIMARY KEY,
    "VerseId" INT REFERENCES "Verse"("Id") ON DELETE CASCADE,
    "LanguageCode" VARCHAR(10) NOT NULL,
    "TransliterationText" TEXT NOT NULL
);

-- 3. Tafsir Commentary
CREATE TABLE IF NOT EXISTS "TafsirEdition" (
    "Id" SERIAL PRIMARY KEY,
    "Name" VARCHAR(150) NOT NULL,
    "Author" VARCHAR(150) NOT NULL,
    "LanguageCode" VARCHAR(10) NOT NULL,
    "IsDefault" BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS "TafsirContent" (
    "Id" SERIAL PRIMARY KEY,
    "TafsirEditionId" INT REFERENCES "TafsirEdition"("Id") ON DELETE CASCADE,
    "VerseId" INT REFERENCES "Verse"("Id") ON DELETE CASCADE,
    "VolumeNumber" INT DEFAULT 1,
    "ContentText" TEXT NOT NULL,
    CONSTRAINT "UQ_Tafsir_Edition_Verse" UNIQUE ("TafsirEditionId", "VerseId")
);

-- 4. Taxonomy & Vector Embeddings
CREATE TABLE IF NOT EXISTS "Topic" (
    "Id" SERIAL PRIMARY KEY,
    "NamePersian" VARCHAR(200) NOT NULL,
    "NameEnglish" VARCHAR(200) NOT NULL,
    "Category" VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS "Keyword" (
    "Id" SERIAL PRIMARY KEY,
    "WordPersian" VARCHAR(100) NOT NULL,
    "WordEnglish" VARCHAR(100) NOT NULL,
    "RootArabic" VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS "Embedding" (
    "Id" SERIAL PRIMARY KEY,
    "VerseId" INT REFERENCES "Verse"("Id") ON DELETE CASCADE,
    "LanguageCode" VARCHAR(10) NOT NULL,
    "VectorData" vector(1536)
);

-- 5. AI Conversation Tables
CREATE TABLE IF NOT EXISTS "Conversation" (
    "Id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "UserId" UUID REFERENCES "Users"("Id") ON DELETE CASCADE,
    "Title" VARCHAR(255) NOT NULL,
    "LanguageCode" VARCHAR(10) DEFAULT 'fa',
    "CreatedAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS "ConversationMessage" (
    "Id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "ConversationId" UUID REFERENCES "Conversation"("Id") ON DELETE CASCADE,
    "SenderRole" VARCHAR(20) NOT NULL, -- 'user' or 'assistant'
    "ContentText" TEXT NOT NULL,
    "LanguageCode" VARCHAR(10) DEFAULT 'fa',
    "CreatedAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS "MessageCitation" (
    "Id" SERIAL PRIMARY KEY,
    "MessageId" UUID REFERENCES "ConversationMessage"("Id") ON DELETE CASCADE,
    "VerseId" INT REFERENCES "Verse"("Id") ON DELETE CASCADE
);

-- 6. User Interactions
CREATE TABLE IF NOT EXISTS "Bookmarks" (
    "Id" SERIAL PRIMARY KEY,
    "UserId" UUID REFERENCES "Users"("Id") ON DELETE CASCADE,
    "VerseId" INT REFERENCES "Verse"("Id") ON DELETE CASCADE,
    "CreatedAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS "Highlights" (
    "Id" SERIAL PRIMARY KEY,
    "UserId" UUID REFERENCES "Users"("Id") ON DELETE CASCADE,
    "VerseId" INT REFERENCES "Verse"("Id") ON DELETE CASCADE,
    "ColorHex" VARCHAR(7) DEFAULT '#FFD700',
    "CreatedAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS "Notes" (
    "Id" SERIAL PRIMARY KEY,
    "UserId" UUID REFERENCES "Users"("Id") ON DELETE CASCADE,
    "VerseId" INT REFERENCES "Verse"("Id") ON DELETE CASCADE,
    "NoteText" TEXT NOT NULL,
    "CreatedAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 7. Performance & Vector Indexing
CREATE INDEX IF NOT EXISTS "IX_Verse_SurahId_VerseNumber" ON "Verse" ("SurahId", "VerseNumber");
CREATE INDEX IF NOT EXISTS "IX_Translation_VerseId_Lang" ON "Translation" ("VerseId", "LanguageCode");
CREATE INDEX IF NOT EXISTS "IX_Translation_Lang_VerseId" ON "Translation" ("LanguageCode", "VerseId");
CREATE INDEX IF NOT EXISTS "IX_TafsirContent_VerseId" ON "TafsirContent" ("VerseId");
CREATE INDEX IF NOT EXISTS "IX_Embedding_VectorData" ON "Embedding" USING hnsw ("VectorData" vector_cosine_ops);
