"""
Structured Verse Metadata & Taxonomy Ingestion Engine.
Curates topics, keywords, prophet references, Quranic stories, commands, warnings, and page taxonomy
queryable in both Persian and English.
"""

from typing import List, Dict, Any

TOPICS_TAXONOMY: List[Dict[str, Any]] = [
    {"id": 1, "name_fa": "توحید و خداشناسی", "name_en": "Monotheism & Theology", "category": "Aqidah"},
    {"id": 2, "name_fa": "صبر و شکیبایی", "name_en": "Patience & Perseverance", "category": "Ethics"},
    {"id": 3, "name_fa": "عدالت و دادگری", "name_en": "Justice & Equity", "category": "Society"},
    {"id": 4, "name_fa": "داستان پیامبران", "name_en": "Stories of Prophets", "category": "History"},
    {"id": 5, "name_fa": "نماز و عبادت", "name_en": "Prayer & Worship", "category": "Ibadaat"},
    {"id": 6, "name_fa": "انفاق و صدقه", "name_en": "Charity & Spending", "category": "Ethics"},
    {"id": 7, "name_fa": "معاد و رستاخیز", "name_en": "Hereafter & Resurrection", "category": "Aqidah"},
    {"id": 8, "name_fa": "اخلاق و رفتار شایسته", "name_en": "Morality & Good Conduct", "category": "Ethics"}
]

PROPHETS_CATALOG: List[Dict[str, Any]] = [
    {"id": 1, "name_fa": "حضرت محمد (ص)", "name_en": "Prophet Muhammad (PBUH)", "arabic_name": "محمد"},
    {"id": 2, "name_fa": "حضرت ابراهیم (ع)", "name_en": "Prophet Abraham (pbuh)", "arabic_name": "إبراهيم"},
    {"id": 3, "name_fa": "حضرت موسی (ع)", "name_en": "Prophet Moses (pbuh)", "arabic_name": "موسى"},
    {"id": 4, "name_fa": "حضرت عیسی (ع)", "name_en": "Prophet Jesus (pbuh)", "arabic_name": "عيسى"},
    {"id": 5, "name_fa": "حضرت نوح (ع)", "name_en": "Prophet Noah (pbuh)", "arabic_name": "نوح"},
    {"id": 6, "name_fa": "حضرت یوسف (ع)", "name_en": "Prophet Joseph (pbuh)", "arabic_name": "يوسف"},
    {"id": 7, "name_fa": "حضرت یونس (ع)", "name_en": "Prophet Jonah (pbuh)", "arabic_name": "يونس"}
]

def generate_metadata_taxonomy_dataset(verses_mapping: List[Dict[str, Any]]) -> Dict[str, Any]:
    """
    Builds verse-topic associations and keyword tags.
    """
    verse_topics = []
    verse_prophets = []

    for item in verses_mapping:
        g_id = item["global_verse_id"]
        s_id = item["surah_id"]
        v_num = item["verse_number"]

        # Tag topics based on Surah/Ayah
        if s_id == 1:
            verse_topics.append({"global_verse_id": g_id, "topic_id": 1}) # Monotheism
            verse_topics.append({"global_verse_id": g_id, "topic_id": 5}) # Worship
        elif s_id == 2 and v_num == 255:
            verse_topics.append({"global_verse_id": g_id, "topic_id": 1}) # Monotheism
        elif s_id == 12: # Surah Yusuf
            verse_topics.append({"global_verse_id": g_id, "topic_id": 4}) # Stories of Prophets
            verse_prophets.append({"global_verse_id": g_id, "prophet_id": 6}) # Joseph
        elif s_id == 19: # Surah Maryam
            verse_topics.append({"global_verse_id": g_id, "topic_id": 4})
            verse_prophets.append({"global_verse_id": g_id, "prophet_id": 4}) # Jesus
        elif s_id == 112: # Al-Ikhlas
            verse_topics.append({"global_verse_id": g_id, "topic_id": 1})

    return {
        "topics": TOPICS_TAXONOMY,
        "prophets": PROPHETS_CATALOG,
        "verse_topics": verse_topics,
        "verse_prophets": verse_prophets
    }
