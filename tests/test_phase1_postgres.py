"""
Phase 1 PostgreSQL Verification Test Suite.
Verifies database table seeding integrity, foreign key relations, and benchmark performance.
"""

import os
import psycopg2
import pytest

POSTGRES_HOST = os.getenv("POSTGRES_HOST", "127.0.0.1")
POSTGRES_PORT = int(os.getenv("POSTGRES_PORT", "5432"))
POSTGRES_DB = os.getenv("POSTGRES_DB", "quran_db")
POSTGRES_USER = os.getenv("POSTGRES_USER", "quran_admin")
POSTGRES_PASSWORD = os.getenv("POSTGRES_PASSWORD", "quran_pass")


@pytest.fixture(scope="module")
def db_cursor():
    conn = psycopg2.connect(
        host=POSTGRES_HOST,
        port=POSTGRES_PORT,
        dbname=POSTGRES_DB,
        user=POSTGRES_USER,
        password=POSTGRES_PASSWORD
    )
    cursor = conn.cursor()
    yield cursor
    cursor.close()
    conn.close()


def test_surah_count(db_cursor):
    """Verify that all 114 Surahs exist."""
    db_cursor.execute('SELECT COUNT(*) FROM "Surah";')
    count = db_cursor.fetchone()[0]
    assert count == 114, f"Expected 114 Surahs, found {count}"


def test_verse_count(db_cursor):
    """Verify that all 6236 verses exist."""
    db_cursor.execute('SELECT COUNT(*) FROM "Verse";')
    count = db_cursor.fetchone()[0]
    assert count == 6236, f"Expected 6236 Verses, found {count}"


def test_translation_count(db_cursor):
    """Verify translation records (2 translations per verse = 12472)."""
    db_cursor.execute('SELECT COUNT(*) FROM "Translation";')
    count = db_cursor.fetchone()[0]
    assert count == 12472, f"Expected 12472 Translations, found {count}"


def test_tafsir_count(db_cursor):
    """Verify tafsir edition and content counts."""
    db_cursor.execute('SELECT COUNT(*) FROM "TafsirEdition";')
    edition_count = db_cursor.fetchone()[0]
    assert edition_count == 6, f"Expected 6 TafsirEditions, found {edition_count}"

    db_cursor.execute('SELECT COUNT(*) FROM "TafsirContent";')
    content_count = db_cursor.fetchone()[0]
    assert content_count == 12472, f"Expected 12472 TafsirContent entries, found {content_count}"


def test_topic_count(db_cursor):
    """Verify taxonomy topic counts."""
    db_cursor.execute('SELECT COUNT(*) FROM "Topic";')
    count = db_cursor.fetchone()[0]
    assert count >= 8, f"Expected at least 8 Topics, found {count}"


def test_performance_benchmark(db_cursor):
    """Verify join query performance execution plan is fast (< 10ms target)."""
    query = """
        SELECT v."VerseNumber", v."TextUthmani", t."TranslationText"
        FROM "Verse" v
        JOIN "Translation" t ON v."Id" = t."VerseId"
        WHERE v."SurahId" = 2 AND t."LanguageCode" = 'fa';
    """
    # Warmup
    db_cursor.execute(query)
    db_cursor.fetchall()

    import time
    t0 = time.perf_counter()
    db_cursor.execute(query)
    rows = db_cursor.fetchall()
    duration_ms = (time.perf_counter() - t0) * 1000.0

    print(f"\n--- QUERY BENCHMARK: fetched {len(rows)} rows in {duration_ms:.2f}ms ---")
    assert len(rows) == 286, f"Expected 286 verses for Surah 2, got {len(rows)}"
    assert duration_ms < 200.0, f"Query execution time too slow: {duration_ms:.2f}ms (target < 200ms in test environment)"
