"""
Tafsir Data Ingestion Engine.
Curates Persian and English commentaries linked to target verses.
"""

from typing import List, Dict, Any
from scripts.nlp.normalizer import PersianNormalizer, EnglishNormalizer

TAFSIR_EDITIONS: List[Dict[str, Any]] = [
    {
        "id": "fa.nemoneh",
        "name": "تفسیر نمونه (آیت‌الله مکارم شیرازی)",
        "author": "Ayatollah Makarem Shirazi",
        "language": "fa",
        "is_default": True
    },
    {
        "id": "fa.almizan",
        "name": "تفسیر المیزان (علامه طباطبایی)",
        "author": "Allameh Tabataba'i",
        "language": "fa",
        "is_default": False
    },
    {
        "id": "fa.noor",
        "name": "تفسیر نور (دکتر محسن قرائتی)",
        "author": "Dr. Mohsen Qara'ati",
        "language": "fa",
        "is_default": False
    },
    {
        "id": "en.ibnkathir",
        "name": "Tafsir Ibn Kathir (Abridged English Edition)",
        "author": "Ibn Kathir",
        "language": "en",
        "is_default": True
    },
    {
        "id": "en.jalalayn",
        "name": "Tafsir Al-Jalalayn",
        "author": "Jalal ad-Din al-Mahalli & Jalal ad-Din as-Suyuti",
        "language": "en",
        "is_default": False
    },
    {
        "id": "en.maarif",
        "name": "Ma'ariful Qur'an",
        "author": "Mufti Muhammad Shafi",
        "language": "en",
        "is_default": False
    }
]

def generate_sample_tafsir_dataset(verses_mapping: List[Dict[str, Any]]) -> Dict[str, Any]:
    """
    Generates Tafsir entries for verses mapping.
    """
    entries = []

    for item in verses_mapping:
        g_id = item["global_verse_id"]
        key = item["ayah_key"]
        s_id = item["surah_id"]
        v_num = item["verse_number"]

        # Tafsir Nemoneh (Persian Default)
        fa_text = f"تفسیر نمونه برای آیه {key}: این آیه به بیان مفاهیم و دستورات الهی می‌پردازد و راهنمای مؤمنان است."
        if s_id == 1 and v_num == 1:
            fa_text = "تفسیر نمونه (سوره الفاتحة ۱:۱): بسم الله الرحمن الرحیم - سرآغاز کتاب الهی با نام خداوند بخشنده و مهربان که رحمت عام و خاصش همه موجودات را فرا گرفته است."
        elif s_id == 2 and v_num == 255:
            fa_text = "تفسیر نمونه (سوره البقرة ۲:۲۵۵ - آیت الکرسی): این آیه شریف شامل والاترین معارف توحیدی درباره ذات و صفات پروردگار، حیات مطلق و قیومیت الهی است."

        entries.append({
            "tafsir_edition_id": "fa.nemoneh",
            "global_verse_id": g_id,
            "ayah_key": key,
            "language": "fa",
            "content": fa_text,
            "content_normalized": PersianNormalizer.normalize(fa_text)
        })

        # Tafsir Ibn Kathir (English Default)
        en_text = f"Tafsir Ibn Kathir for verse {key}: This verse provides guidance and explains divine decrees for the believers."
        if s_id == 1 and v_num == 1:
            en_text = "Tafsir Ibn Kathir (Surah Al-Fatihah 1:1): Bismillah is the opening verse of the Quran, starting with the Blessed Name of Allah, the Most Gracious, Most Merciful."
        elif s_id == 2 and v_num == 255:
            en_text = "Tafsir Ibn Kathir (Surah Al-Baqarah 2:255 - Ayah al-Kursi): Ayah al-Kursi is the greatest verse in the Quran, emphasizing Allah's oneness, absolute living self-existence, and supreme sovereignty over the heavens and earth."

        entries.append({
            "tafsir_edition_id": "en.ibnkathir",
            "global_verse_id": g_id,
            "ayah_key": key,
            "language": "en",
            "content": en_text,
            "content_normalized": EnglishNormalizer.normalize(en_text)
        })

    return {
        "tafsir_editions": TAFSIR_EDITIONS,
        "tafsir_entries": entries
    }
