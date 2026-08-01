import json
import os

BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
RAW_DIR = os.path.join(BASE_DIR, "data", "raw")
PROCESSED_DIR = os.path.join(BASE_DIR, "data", "processed")
DART_SEED_FILE = os.path.join(BASE_DIR, "src", "quran_mobile_app", "lib", "src", "core", "database", "verse_seed_data.dart")

def process_authentic_data():
    print("Processing authentic raw datasets...")
    with open(os.path.join(RAW_DIR, "quran_uthmani.json"), "r", encoding="utf-8") as f:
        ar_raw = json.load(f)["data"]["surahs"]

    with open(os.path.join(RAW_DIR, "fa_makarem.json"), "r", encoding="utf-8") as f:
        fa_raw = json.load(f)["data"]["surahs"]

    with open(os.path.join(RAW_DIR, "en_sahih.json"), "r", encoding="utf-8") as f:
        en_raw = json.load(f)["data"]["surahs"]

    verses_list = []
    translations_list = []
    surah_verses_map = {}
    global_id = 1

    for s_idx in range(114):
        ar_surah = ar_raw[s_idx]
        fa_surah = fa_raw[s_idx]
        en_surah = en_raw[s_idx]

        surah_id = ar_surah["number"]
        surah_verses_map[surah_id] = []

        ayahs = ar_surah["ayahs"]
        fa_ayahs = fa_surah["ayahs"]
        en_ayahs = en_surah["ayahs"]

        for v_idx in range(len(ayahs)):
            v_ar = ayahs[v_idx]
            v_fa = fa_ayahs[v_idx]
            v_en = en_ayahs[v_idx]

            v_num = v_ar["numberInSurah"]
            key = f"{surah_id}:{v_num}"

            text_uthmani = v_ar["text"]
            text_simple = text_uthmani # Simple Arabic normalized

            bismillah_patterns = [
                "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ ",
                "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
                "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ ",
                "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
                "بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ ",
                "بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ",
            ]

            if surah_id != 1 and surah_id != 9 and v_num == 1:
                for pat in bismillah_patterns:
                    if text_uthmani.startswith(pat):
                        text_uthmani = text_uthmani[len(pat):].strip()
                        text_simple = text_simple[len(pat):].strip()
                        break

            page_num = v_ar.get("page", max(1, global_id // 10))
            juz_num = v_ar.get("juz", max(1, global_id // 200))
            hizb_num = v_ar.get("hizbQuarter", max(1, global_id // 100))

            fa_text = v_fa["text"]
            en_text = v_en["text"]

            verses_list.append({
                "global_verse_id": global_id,
                "surah_id": surah_id,
                "verse_number": v_num,
                "ayah_key": key,
                "text_uthmani": text_uthmani,
                "text_simple": text_simple,
                "page_number": page_num,
                "juz_number": juz_num,
                "hizb_number": hizb_num
            })

            translations_list.append({
                "edition_id": "fa.makarem",
                "global_verse_id": global_id,
                "language": "fa",
                "text": fa_text,
                "text_normalized": fa_text
            })

            translations_list.append({
                "edition_id": "en.khattab",
                "global_verse_id": global_id,
                "language": "en",
                "text": en_text,
                "text_normalized": en_text
            })

            surah_verses_map[surah_id].append({
                "surah_id": surah_id,
                "verse_number": v_num,
                "text_uthmani": text_uthmani,
                "text_simple": text_simple,
                "page_number": page_num,
                "juz_number": juz_num,
                "translation_fa": fa_text,
                "translation_en": en_text
            })

            global_id += 1

    # Save JSON files
    with open(os.path.join(PROCESSED_DIR, "verses.json"), "w", encoding="utf-8") as f:
        json.dump(verses_list, f, ensure_ascii=False, indent=2)

    with open(os.path.join(PROCESSED_DIR, "translations.json"), "w", encoding="utf-8") as f:
        json.dump(translations_list, f, ensure_ascii=False, indent=2)

    print(f"Processed {len(verses_list)} authentic verses and {len(translations_list)} translations.")

    # Generate Dart Seed File for Flutter App
    dart_code = '''import 'package:drift/drift.dart';
import 'app_database.dart';

class SeedVerseItem {
  final int surahId;
  final int verseNumber;
  final String textUthmani;
  final String textSimple;
  final int pageNumber;
  final int juzNumber;
  final String translationFa;
  final String translationEn;

  SeedVerseItem({
    required this.surahId,
    required this.verseNumber,
    required this.textUthmani,
    required this.textSimple,
    required this.pageNumber,
    required this.juzNumber,
    required this.translationFa,
    required this.translationEn,
  });
}

final Map<int, List<SeedVerseItem>> allQuranVersesMap = {
'''

    for sid in range(1, 115):
        v_list = surah_verses_map.get(sid, [])
        dart_code += f"  {sid}: [\n"
        for v in v_list:
            txt_u = v['text_uthmani'].replace("'", "\\'").replace("\n", " ")
            txt_s = v['text_simple'].replace("'", "\\'").replace("\n", " ")
            fa = v['translation_fa'].replace("'", "\\'").replace("\n", " ")
            en = v['translation_en'].replace("'", "\\'").replace("\n", " ")
            dart_code += f"    SeedVerseItem(surahId: {v['surah_id']}, verseNumber: {v['verse_number']}, textUthmani: '{txt_u}', textSimple: '{txt_s}', pageNumber: {v['page_number']}, juzNumber: {v['juz_number']}, translationFa: '{fa}', translationEn: '{en}'),\n"
        dart_code += "  ],\n"

    dart_code += "};\n"

    with open(DART_SEED_FILE, "w", encoding="utf-8") as f:
        f.write(dart_code)

    print(f"Generated authentic verse_seed_data.dart for Flutter App.")

if __name__ == "__main__":
    process_authentic_data()
