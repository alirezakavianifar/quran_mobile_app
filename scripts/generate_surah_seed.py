import json

with open('data/processed/surahs.json', 'r', encoding='utf-8') as f:
    items = json.load(f)

dart_code = '''import 'package:drift/drift.dart';
import 'app_database.dart';

final List<SurahsCompanion> initialSurahsList = [
'''

for s in items:
    name_ar = s['name_arabic'].replace('"', '\\"')
    name_fa = s['name_persian'].replace('"', '\\"')
    name_en = s['name_english'].replace("'", "\\'")
    dart_code += f'''  SurahsCompanion.insert(
    number: {s['number']},
    nameArabic: '{name_ar}',
    namePersian: '{name_fa}',
    nameEnglish: '{name_en}',
    revelationType: '{s['revelation_type']}',
    verseCount: {s['verse_count']},
  ),
'''

dart_code += '];\n'

with open('src/quran_mobile_app/lib/src/core/database/surah_seed_data.dart', 'w', encoding='utf-8') as f:
    f.write(dart_code)

print(f"Generated surah_seed_data.dart with {len(items)} surahs.")
