import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  db.seedInitialData();
  return db;
});

final surahListProvider = FutureProvider<List<Surah>>((ref) async {
  final db = ref.watch(databaseProvider);
  final surahs = await db.select(db.surahs).get();
  return surahs;
});

class VerseWithTranslation {
  final Verse verse;
  final Translation? translation;

  VerseWithTranslation({required this.verse, this.translation});
}

final surahVersesProvider =
    FutureProvider.family<List<VerseWithTranslation>, int>((ref, surahId) async {
  final db = ref.watch(databaseProvider);
  final verses = await (db.select(db.verses)
        ..where((tbl) => tbl.surahId.equals(surahId)))
      .get();

  final translations = await db.select(db.translations).get();

  return verses.map((v) {
    final t = translations.cast<Translation?>().firstWhere(
          (trans) => trans?.verseId == v.id,
          orElse: () => null,
        );
    return VerseWithTranslation(verse: v, translation: t);
  }).toList();
});
