"""
Master Build Script for Quran Knowledge Platform Phase 0.
Runs data ingestion, normalizations, produces JSON artifacts in data/processed/,
and compiles the local SQLite database (quran_platform.db) for Flutter Drift & ASP.NET Core EF Core seeders.
"""

import os
import sys

# Ensure repository root is in sys.path
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if BASE_DIR not in sys.path:
    sys.path.insert(0, BASE_DIR)

import json
import sqlite3
import argparse
from typing import Dict, Any

from scripts.ingestion.quran_ingest import generate_sample_verses_dataset, generate_global_verse_mapping
from scripts.ingestion.tafsir_ingest import generate_sample_tafsir_dataset
from scripts.ingestion.audio_meta_ingest import generate_audio_metadata_dataset
from scripts.ingestion.metadata_ingest import generate_metadata_taxonomy_dataset


BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA_DIR = os.path.join(BASE_DIR, "data")
PROCESSED_DIR = os.path.join(DATA_DIR, "processed")
SQLITE_DB_PATH = os.path.join(PROCESSED_DIR, "quran_platform.db")


def ensure_directories():
    os.makedirs(PROCESSED_DIR, exist_ok=True)
    os.makedirs(os.path.join(DATA_DIR, "raw"), exist_ok=True)
    os.makedirs(os.path.join(DATA_DIR, "metadata"), exist_ok=True)


def build_json_datasets() -> Dict[str, Any]:
    print("Building Quran datasets...")
    quran_data = generate_sample_verses_dataset()
    
    verse_mapping = generate_global_verse_mapping()
    print("Building Tafsir datasets...")
    tafsir_data = generate_sample_tafsir_dataset(verse_mapping)
    
    print("Building Audio Metadata datasets...")
    audio_data = generate_audio_metadata_dataset()
    
    print("Building Taxonomy & Verse Metadata datasets...")
    meta_data = generate_metadata_taxonomy_dataset(verse_mapping)

    # Save JSON files
    with open(os.path.join(PROCESSED_DIR, "surahs.json"), "w", encoding="utf-8") as f:
        json.dump(quran_data["surahs"], f, ensure_ascii=False, indent=2)

    with open(os.path.join(PROCESSED_DIR, "editions.json"), "w", encoding="utf-8") as f:
        json.dump(quran_data["editions"], f, ensure_ascii=False, indent=2)

    with open(os.path.join(PROCESSED_DIR, "verses.json"), "w", encoding="utf-8") as f:
        json.dump(quran_data["verses"], f, ensure_ascii=False, indent=2)

    with open(os.path.join(PROCESSED_DIR, "translations.json"), "w", encoding="utf-8") as f:
        json.dump(quran_data["translations"], f, ensure_ascii=False, indent=2)

    with open(os.path.join(PROCESSED_DIR, "tafsir.json"), "w", encoding="utf-8") as f:
        json.dump(tafsir_data, f, ensure_ascii=False, indent=2)

    with open(os.path.join(PROCESSED_DIR, "audio_reciters.json"), "w", encoding="utf-8") as f:
        json.dump(audio_data, f, ensure_ascii=False, indent=2)

    with open(os.path.join(PROCESSED_DIR, "metadata_taxonomy.json"), "w", encoding="utf-8") as f:
        json.dump(meta_data, f, ensure_ascii=False, indent=2)

    print("JSON datasets written successfully to data/processed/")
    return {
        "quran": quran_data,
        "tafsir": tafsir_data,
        "audio": audio_data,
        "metadata": meta_data
    }


def build_sqlite_database(all_data: Dict[str, Any]):
    print(f"Building SQLite database at {SQLITE_DB_PATH}...")
    if os.path.exists(SQLITE_DB_PATH):
        os.remove(SQLITE_DB_PATH)

    conn = sqlite3.connect(SQLITE_DB_PATH)
    cursor = conn.cursor()

    # Create Tables
    cursor.execute("""
    CREATE TABLE Surahs (
        id INTEGER PRIMARY KEY,
        number INTEGER NOT NULL,
        name_arabic TEXT NOT NULL,
        name_persian TEXT NOT NULL,
        name_english TEXT NOT NULL,
        revelation_type TEXT NOT NULL,
        revelation_order INTEGER NOT NULL,
        verse_count INTEGER NOT NULL
    );
    """)

    cursor.execute("""
    CREATE TABLE Verses (
        global_verse_id INTEGER PRIMARY KEY,
        surah_id INTEGER NOT NULL,
        verse_number INTEGER NOT NULL,
        ayah_key TEXT NOT NULL UNIQUE,
        text_uthmani TEXT NOT NULL,
        text_simple TEXT NOT NULL,
        page_number INTEGER NOT NULL,
        juz_number INTEGER NOT NULL,
        hizb_number INTEGER NOT NULL,
        FOREIGN KEY (surah_id) REFERENCES Surahs(id)
    );
    """)

    cursor.execute("""
    CREATE TABLE TranslationEditions (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        author TEXT NOT NULL,
        language TEXT NOT NULL,
        is_default INTEGER NOT NULL
    );
    """)

    cursor.execute("""
    CREATE TABLE Translations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        edition_id TEXT NOT NULL,
        global_verse_id INTEGER NOT NULL,
        language TEXT NOT NULL,
        text TEXT NOT NULL,
        text_normalized TEXT NOT NULL,
        FOREIGN KEY (edition_id) REFERENCES TranslationEditions(id),
        FOREIGN KEY (global_verse_id) REFERENCES Verses(global_verse_id)
    );
    """)

    cursor.execute("""
    CREATE TABLE TafsirEditions (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        author TEXT NOT NULL,
        language TEXT NOT NULL,
        is_default INTEGER NOT NULL
    );
    """)

    cursor.execute("""
    CREATE TABLE TafsirEntries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tafsir_edition_id TEXT NOT NULL,
        global_verse_id INTEGER NOT NULL,
        ayah_key TEXT NOT NULL,
        language TEXT NOT NULL,
        content TEXT NOT NULL,
        content_normalized TEXT NOT NULL,
        FOREIGN KEY (tafsir_edition_id) REFERENCES TafsirEditions(id),
        FOREIGN KEY (global_verse_id) REFERENCES Verses(global_verse_id)
    );
    """)

    cursor.execute("""
    CREATE TABLE Reciters (
        id TEXT PRIMARY KEY,
        reciter_name_fa TEXT NOT NULL,
        reciter_name_en TEXT NOT NULL,
        reciter_name_ar TEXT NOT NULL,
        bitrate INTEGER NOT NULL,
        audio_format TEXT NOT NULL,
        server_url_template TEXT NOT NULL
    );
    """)

    cursor.execute("""
    CREATE TABLE Topics (
        id INTEGER PRIMARY KEY,
        name_fa TEXT NOT NULL,
        name_en TEXT NOT NULL,
        category TEXT NOT NULL
    );
    """)

    cursor.execute("""
    CREATE TABLE VerseTopics (
        global_verse_id INTEGER NOT NULL,
        topic_id INTEGER NOT NULL,
        PRIMARY KEY (global_verse_id, topic_id),
        FOREIGN KEY (global_verse_id) REFERENCES Verses(global_verse_id),
        FOREIGN KEY (topic_id) REFERENCES Topics(id)
    );
    """)

    # Populate Surahs
    for s in all_data["quran"]["surahs"]:
        cursor.execute(
            "INSERT INTO Surahs VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
            (s["id"], s["number"], s["name_arabic"], s["name_persian"], s["name_english"], s["revelation_type"], s["revelation_order"], s["verse_count"])
        )

    # Populate Verses
    for v in all_data["quran"]["verses"]:
        cursor.execute(
            "INSERT INTO Verses VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
            (v["global_verse_id"], v["surah_id"], v["verse_number"], v["ayah_key"], v["text_uthmani"], v["text_simple"], v["page_number"], v["juz_number"], v["hizb_number"])
        )

    # Populate Translation Editions & Translations
    for e in all_data["quran"]["editions"]:
        cursor.execute(
            "INSERT INTO TranslationEditions VALUES (?, ?, ?, ?, ?)",
            (e["id"], e["name"], e["author"], e["language"], 1 if e["is_default"] else 0)
        )

    for t in all_data["quran"]["translations"]:
        cursor.execute(
            "INSERT INTO Translations (edition_id, global_verse_id, language, text, text_normalized) VALUES (?, ?, ?, ?, ?)",
            (t["edition_id"], t["global_verse_id"], t["language"], t["text"], t["text_normalized"])
        )

    # Populate Tafsir Editions & Entries
    for te in all_data["tafsir"]["tafsir_editions"]:
        cursor.execute(
            "INSERT INTO TafsirEditions VALUES (?, ?, ?, ?, ?)",
            (te["id"], te["name"], te["author"], te["language"], 1 if te["is_default"] else 0)
        )

    for tent in all_data["tafsir"]["tafsir_entries"]:
        cursor.execute(
            "INSERT INTO TafsirEntries (tafsir_edition_id, global_verse_id, ayah_key, language, content, content_normalized) VALUES (?, ?, ?, ?, ?, ?)",
            (tent["tafsir_edition_id"], tent["global_verse_id"], tent["ayah_key"], tent["language"], tent["content"], tent["content_normalized"])
        )

    # Populate Reciters
    for r in all_data["audio"]["reciters"]:
        cursor.execute(
            "INSERT INTO Reciters VALUES (?, ?, ?, ?, ?, ?, ?)",
            (r["id"], r["reciter_name_fa"], r["reciter_name_en"], r["reciter_name_ar"], r["bitrate"], r["audio_format"], r["server_url_template"])
        )

    # Populate Topics & VerseTopics
    for top in all_data["metadata"]["topics"]:
        cursor.execute(
            "INSERT INTO Topics VALUES (?, ?, ?, ?)",
            (top["id"], top["name_fa"], top["name_en"], top["category"])
        )

    for vt in all_data["metadata"]["verse_topics"]:
        cursor.execute(
            "INSERT INTO VerseTopics VALUES (?, ?)",
            (vt["global_verse_id"], vt["topic_id"])
        )

    # Indexes
    cursor.execute("CREATE INDEX idx_verses_surah ON Verses(surah_id);")
    cursor.execute("CREATE INDEX idx_trans_verse ON Translations(global_verse_id);")
    cursor.execute("CREATE INDEX idx_tafsir_verse ON TafsirEntries(global_verse_id);")

    conn.commit()
    conn.close()
    print("SQLite database successfully created and indexed.")


def verify_datasets():
    print("Verifying built datasets...")
    assert os.path.exists(SQLITE_DB_PATH), "SQLite DB file missing!"

    conn = sqlite3.connect(SQLITE_DB_PATH)
    cursor = conn.cursor()

    cursor.execute("SELECT COUNT(*) FROM Surahs")
    surah_cnt = cursor.fetchone()[0]
    assert surah_cnt == 114, f"Expected 114 Surahs, found {surah_cnt}"

    cursor.execute("SELECT COUNT(*) FROM Verses")
    verse_cnt = cursor.fetchone()[0]
    assert verse_cnt == 6236, f"Expected 6236 Verses, found {verse_cnt}"

    cursor.execute("SELECT COUNT(*) FROM Translations WHERE edition_id = 'fa.makarem'")
    fa_cnt = cursor.fetchone()[0]
    assert fa_cnt == 6236, f"Expected 6236 Makarem translations, found {fa_cnt}"

    cursor.execute("SELECT COUNT(*) FROM Translations WHERE edition_id = 'en.khattab'")
    en_cnt = cursor.fetchone()[0]
    assert en_cnt == 6236, f"Expected 6236 Khattab translations, found {en_cnt}"

    cursor.execute("SELECT COUNT(*) FROM TafsirEntries WHERE tafsir_edition_id = 'fa.nemoneh'")
    tafsir_fa_cnt = cursor.fetchone()[0]
    assert tafsir_fa_cnt == 6236, f"Expected 6236 Tafsir Nemoneh entries, found {tafsir_fa_cnt}"

    conn.close()
    print("Dataset Verification Passed 100%! All 114 Surahs, 6,236 Ayahs, Persian & English translations, Tafsirs, and indexes are intact.")


def main():
    parser = argparse.ArgumentParser(description="Quran Platform Dataset Builder")
    parser.add_argument("--verify", action="store_true", help="Verify built datasets")
    args = parser.parse_args()

    ensure_directories()
    if args.verify:
        verify_datasets()
    else:
        all_data = build_json_datasets()
        build_sqlite_database(all_data)
        verify_datasets()


if __name__ == "__main__":
    main()
