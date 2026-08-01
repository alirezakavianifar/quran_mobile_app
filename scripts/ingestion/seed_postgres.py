"""
PostgreSQL Data Seeder Engine for Quran Knowledge Platform Phase 1.
Reads processed JSON datasets from data/processed/ and inserts records
into PostgreSQL database (quran_postgres).
"""

import os
import sys
import json
import logging
from typing import Dict, Any, List
import psycopg2
from psycopg2.extras import execute_values

# Configure logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
logger = logging.getLogger("seed_postgres")

# Base Paths & Connection Settings
BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
PROCESSED_DIR = os.path.join(BASE_DIR, "data", "processed")

POSTGRES_HOST = os.getenv("POSTGRES_HOST", "localhost")
POSTGRES_PORT = int(os.getenv("POSTGRES_PORT", "5432"))
POSTGRES_DB = os.getenv("POSTGRES_DB", "quran_db")
POSTGRES_USER = os.getenv("POSTGRES_USER", "quran_admin")
POSTGRES_PASSWORD = os.getenv("POSTGRES_PASSWORD", "quran_pass")


def get_db_connection():
    """Establishes connection to PostgreSQL database."""
    return psycopg2.connect(
        host=POSTGRES_HOST,
        port=POSTGRES_PORT,
        dbname=POSTGRES_DB,
        user=POSTGRES_USER,
        password=POSTGRES_PASSWORD
    )


def seed_surahs(cursor):
    """Seeds Surah table from surahs.json."""
    filepath = os.path.join(PROCESSED_DIR, "surahs.json")
    with open(filepath, "r", encoding="utf-8") as f:
        surahs = json.load(f)

    logger.info(f"Seeding {len(surahs)} Surahs...")
    query = """
        INSERT INTO "Surah" ("Id", "Number", "NameArabic", "NamePersian", "NameEnglish", "RevelationType", "VerseCount")
        VALUES %s
        ON CONFLICT ("Id") DO UPDATE SET
            "NameArabic" = EXCLUDED."NameArabic",
            "NamePersian" = EXCLUDED."NamePersian",
            "NameEnglish" = EXCLUDED."NameEnglish",
            "RevelationType" = EXCLUDED."RevelationType",
            "VerseCount" = EXCLUDED."VerseCount";
    """
    records = [
        (
            s["id"],
            s["number"],
            s["name_arabic"],
            s["name_persian"],
            s["name_english"],
            s["revelation_type"],
            s["verse_count"]
        )
        for s in surahs
    ]
    execute_values(cursor, query, records)
    logger.info("Surahs seeded successfully.")


def seed_verses(cursor):
    """Seeds Verse table from verses.json."""
    filepath = os.path.join(PROCESSED_DIR, "verses.json")
    with open(filepath, "r", encoding="utf-8") as f:
        verses = json.load(f)

    logger.info(f"Seeding {len(verses)} Verses...")
    query = """
        INSERT INTO "Verse" ("Id", "SurahId", "VerseNumber", "PageNumber", "JuzNumber", "TextUthmani", "TextSimple")
        VALUES %s
        ON CONFLICT ("Id") DO UPDATE SET
            "SurahId" = EXCLUDED."SurahId",
            "VerseNumber" = EXCLUDED."VerseNumber",
            "PageNumber" = EXCLUDED."PageNumber",
            "JuzNumber" = EXCLUDED."JuzNumber",
            "TextUthmani" = EXCLUDED."TextUthmani",
            "TextSimple" = EXCLUDED."TextSimple";
    """
    records = [
        (
            v["global_verse_id"],
            v["surah_id"],
            v["verse_number"],
            v.get("page_number", 1),
            v.get("juz_number", 1),
            v["text_uthmani"],
            v["text_simple"]
        )
        for v in verses
    ]
    execute_values(cursor, query, records)
    logger.info("Verses seeded successfully.")


def seed_translations(cursor):
    """Seeds Translation table from translations.json and editions.json."""
    editions_path = os.path.join(PROCESSED_DIR, "editions.json")
    translations_path = os.path.join(PROCESSED_DIR, "translations.json")

    author_map = {}
    if os.path.exists(editions_path):
        with open(editions_path, "r", encoding="utf-8") as f:
            editions = json.load(f)
            author_map = {e["id"]: e.get("author", "Unknown") for e in editions}

    with open(translations_path, "r", encoding="utf-8") as f:
        translations = json.load(f)

    logger.info(f"Seeding {len(translations)} Translations...")
    query = """
        INSERT INTO "Translation" ("VerseId", "LanguageCode", "AuthorName", "TranslationText")
        VALUES %s;
    """
    # Truncate existing translation table before full insert
    cursor.execute('TRUNCATE TABLE "Translation" RESTART IDENTITY CASCADE;')
    records = [
        (
            t["global_verse_id"],
            t["language"],
            author_map.get(t.get("edition_id"), "Makarem Shirazi" if t["language"] == "fa" else "Mustafa Khattab"),
            t["text"]
        )
        for t in translations
    ]
    execute_values(cursor, query, records)
    logger.info("Translations seeded successfully.")


def seed_tafsir(cursor):
    """Seeds TafsirEdition and TafsirContent from tafsir.json."""
    filepath = os.path.join(PROCESSED_DIR, "tafsir.json")
    with open(filepath, "r", encoding="utf-8") as f:
        tafsir_data = json.load(f)

    editions = tafsir_data.get("tafsir_editions", [])
    entries = tafsir_data.get("tafsir_entries", [])

    logger.info(f"Seeding {len(editions)} Tafsir Editions...")
    cursor.execute('TRUNCATE TABLE "TafsirEdition" RESTART IDENTITY CASCADE;')
    edition_query = """
        INSERT INTO "TafsirEdition" ("Id", "Name", "Author", "LanguageCode", "IsDefault")
        VALUES %s;
    """
    edition_id_map = {}
    edition_records = []
    for idx, e in enumerate(editions, start=1):
        edition_id_map[e["id"]] = idx
        edition_records.append((
            idx,
            e["name"],
            e["author"],
            e["language"],
            e.get("is_default", False)
        ))

    execute_values(cursor, edition_query, edition_records)

    logger.info(f"Seeding {len(entries)} Tafsir Content entries...")
    cursor.execute('TRUNCATE TABLE "TafsirContent" RESTART IDENTITY CASCADE;')
    content_query = """
        INSERT INTO "TafsirContent" ("TafsirEditionId", "VerseId", "VolumeNumber", "ContentText")
        VALUES %s;
    """
    content_records = [
        (
            edition_id_map.get(e["tafsir_edition_id"], 1),
            e["global_verse_id"],
            1,
            e["content"]
        )
        for e in entries
    ]
    execute_values(cursor, content_query, content_records)
    logger.info("Tafsir content seeded successfully.")


def seed_metadata(cursor):
    """Seeds Topic and Keyword tables from metadata_taxonomy.json."""
    filepath = os.path.join(PROCESSED_DIR, "metadata_taxonomy.json")
    with open(filepath, "r", encoding="utf-8") as f:
        meta_data = json.load(f)

    topics = meta_data.get("topics", [])
    logger.info(f"Seeding {len(topics)} Topics...")
    topic_query = """
        INSERT INTO "Topic" ("Id", "NamePersian", "NameEnglish", "Category")
        VALUES %s
        ON CONFLICT ("Id") DO UPDATE SET
            "NamePersian" = EXCLUDED."NamePersian",
            "NameEnglish" = EXCLUDED."NameEnglish",
            "Category" = EXCLUDED."Category";
    """
    topic_records = [
        (
            t["id"],
            t["name_fa"],
            t["name_en"],
            t["category"]
        )
        for t in topics
    ]
    execute_values(cursor, topic_query, topic_records)
    logger.info("Topics seeded successfully.")


def main():
    logger.info("Connecting to PostgreSQL...")
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            seed_surahs(cursor)
            seed_verses(cursor)
            seed_translations(cursor)
            seed_tafsir(cursor)
            seed_metadata(cursor)
            logger.info("Analyzing tables for optimizer statistics...")
            cursor.execute("ANALYZE;")
            conn.commit()
            logger.info("PostgreSQL Database seeding completed successfully!")
    except Exception as e:
        conn.rollback()
        logger.error(f"Error during seeding: {e}")
        raise e
    finally:
        conn.close()


if __name__ == "__main__":
    main()
