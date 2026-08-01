"""
Unit and Integration Tests for Phase 0 - Data Curation & NLP Engine.
"""

import os
import sys
import sqlite3
import unittest

# Add project root to sys.path
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if BASE_DIR not in sys.path:
    sys.path.insert(0, BASE_DIR)

from scripts.nlp.normalizer import PersianNormalizer, EnglishNormalizer, ArabicNormalizer
from scripts.ingestion.quran_ingest import SURAHS_CATALOG, generate_global_verse_mapping
from scripts.ingestion.audio_meta_ingest import RECITERS_CATALOG
from scripts.ingestion.tafsir_ingest import TAFSIR_EDITIONS


class TestPersianNormalizer(unittest.TestCase):

    def test_character_unification(self):
        # Arabic Yeh and Kaf -> Persian Yeh and Kaf
        raw = "علي كاتب است."
        normalized = PersianNormalizer.normalize(raw)
        self.assertIn("علی", normalized)
        self.assertIn("کاتب", normalized)
        self.assertNotIn("ي", normalized)
        self.assertNotIn("ك", normalized)

    def test_zwnj_normalization(self):
        # Multiple ZWNJs and spaces around ZWNJ
        raw = "می‌‌‌خواهم  ‌  برویم"
        normalized = PersianNormalizer.normalize(raw)
        self.assertEqual(normalized, "می‌خواهم برویم")

    def test_diacritics_removal(self):
        raw = "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ"
        stripped = PersianNormalizer.strip_diacritics(raw)
        self.assertNotIn("ِ", stripped)
        self.assertNotIn("َّ", stripped)

    def test_digit_conversions(self):
        persian_digits = "۰۱۲۳۴۵۶۷۸۹"
        english_converted = PersianNormalizer.convert_digits_to_en(persian_digits)
        self.assertEqual(english_converted, "0123456789")

        english_digits = "0123456789"
        persian_converted = PersianNormalizer.convert_digits_to_fa(english_digits)
        self.assertEqual(persian_converted, "۰۱۲۳۴۵۶۷۸۹")


class TestEnglishAndArabicNormalizer(unittest.TestCase):

    def test_english_normalizer(self):
        raw = "  “The Clear Quran” — Verse 1.  "
        normalized = EnglishNormalizer.normalize(raw)
        self.assertEqual(normalized, '"the clear quran" - verse 1.')

    def test_arabic_normalizer(self):
        raw = "ٱلْحَمْدُ لِلَّهِ"
        clean = ArabicNormalizer.strip_tashkeel(raw)
        self.assertEqual(clean, "الحمد لله")


class TestDataIntegrity(unittest.TestCase):

    def test_surah_catalog_count(self):
        self.assertEqual(len(SURAHS_CATALOG), 114)
        total_verses = sum(s["verse_count"] for s in SURAHS_CATALOG)
        self.assertEqual(total_verses, 6236)

    def test_global_verse_mapping(self):
        mapping = generate_global_verse_mapping()
        self.assertEqual(len(mapping), 6236)
        self.assertEqual(mapping[0]["global_verse_id"], 1)
        self.assertEqual(mapping[0]["ayah_key"], "1:1")
        self.assertEqual(mapping[-1]["global_verse_id"], 6236)
        self.assertEqual(mapping[-1]["ayah_key"], "114:6")

    def test_audio_reciters_catalog(self):
        self.assertGreaterEqual(len(RECITERS_CATALOG), 5)
        ids = [r["id"] for r in RECITERS_CATALOG]
        self.assertIn("ar.alafasy", ids)
        self.assertIn("ar.parhizgar", ids)

    def test_sqlite_database_integrity(self):
        db_path = os.path.join(BASE_DIR, "data", "processed", "quran_platform.db")
        self.assertTrue(os.path.exists(db_path), "SQLite DB file must exist")

        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()

        cursor.execute("SELECT COUNT(*) FROM Surahs")
        self.assertEqual(cursor.fetchone()[0], 114)

        cursor.execute("SELECT COUNT(*) FROM Verses")
        self.assertEqual(cursor.fetchone()[0], 6236)

        cursor.execute("SELECT COUNT(*) FROM Translations WHERE edition_id = 'fa.makarem'")
        self.assertEqual(cursor.fetchone()[0], 6236)

        cursor.execute("SELECT COUNT(*) FROM Translations WHERE edition_id = 'en.khattab'")
        self.assertEqual(cursor.fetchone()[0], 6236)

        cursor.execute("SELECT COUNT(*) FROM TafsirEntries WHERE tafsir_edition_id = 'fa.nemoneh'")
        self.assertEqual(cursor.fetchone()[0], 6236)

        conn.close()


if __name__ == "__main__":
    unittest.main()
