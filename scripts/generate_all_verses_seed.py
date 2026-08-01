import json

with open('data/processed/verses.json', 'r', encoding='utf-8') as f:
    verses_data = json.load(f)

with open('data/processed/translations.json', 'r', encoding='utf-8') as f:
    trans_data = json.load(f)

# Create translation maps by global_verse_id
fa_trans = {t['global_verse_id']: t['text'] for t in trans_data if t.get('language') == 'fa' or t.get('edition_id') == 'fa.makarem'}
en_trans = {t['global_verse_id']: t['text'] for t in trans_data if t.get('language') == 'en' or t.get('edition_id') == 'en.khattab'}

# Group verses by surah_id
surah_verses_map = {}
for v in verses_data:
    sid = v['surah_id']
    if sid not in surah_verses_map:
        surah_verses_map[sid] = []
    surah_verses_map[sid].append(v)

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
        gid = v['global_verse_id']
        txt_u = v['text_uthmani'].replace("'", "\\'")
        txt_s = v['text_simple'].replace("'", "\\'")
        fa = fa_trans.get(gid, f"ترجمه آیه {v['surah_id']}:{v['verse_number']}").replace("'", "\\'")
        en = en_trans.get(gid, f"Translation for verse {v['surah_id']}:{v['verse_number']}").replace("'", "\\'")
        dart_code += f"    SeedVerseItem(surahId: {v['surah_id']}, verseNumber: {v['verse_number']}, textUthmani: '{txt_u}', textSimple: '{txt_s}', pageNumber: {v['page_number']}, juzNumber: {v['juz_number']}, translationFa: '{fa}', translationEn: '{en}'),\n"
    dart_code += "  ],\n"

dart_code += "};\n"

with open('src/quran_mobile_app/lib/src/core/database/verse_seed_data.dart', 'w', encoding='utf-8') as f:
    f.write(dart_code)

print(f"Generated verse_seed_data.dart for {len(surah_verses_map)} surahs.")
