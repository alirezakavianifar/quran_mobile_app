import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../core/database/app_database.dart';
import '../../core/localization/app_localizations.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final surahListProvider = FutureProvider<List<Surah>>((ref) async {
  final db = ref.watch(databaseProvider);
  await db.seedInitialData();
  final surahs = await (db.select(db.surahs)
        ..orderBy([(t) => OrderingTerm.asc(t.number)]))
      .get();
  return surahs;
});

class VerseWithTranslation {
  final Verse verse;
  final Translation? translation;

  VerseWithTranslation({required this.verse, this.translation});
}

final surahVersesProvider =
    FutureProvider.family<List<VerseWithTranslation>, int>((ref, surahNumber) async {
  final db = ref.watch(databaseProvider);
  final locale = ref.watch(localeProvider);
  final langCode = locale.languageCode;

  await db.seedInitialData();
  await db.seedVersesForSurah(surahNumber);

  final verses = await (db.select(db.verses)
        ..where((tbl) => tbl.surahId.equals(surahNumber))
        ..orderBy([(t) => OrderingTerm.asc(t.verseNumber)]))
      .get();

  final verseIds = verses.map((v) => v.id).toList();
  final translations = verseIds.isEmpty
      ? <Translation>[]
      : await (db.select(db.translations)
            ..where((tbl) => tbl.verseId.isIn(verseIds)))
          .get();

  return verses.map((v) {
    final t = translations.cast<Translation?>().firstWhere(
          (trans) => trans?.verseId == v.id && trans?.languageCode == langCode,
          orElse: () => translations.cast<Translation?>().firstWhere(
            (trans) => trans?.verseId == v.id,
            orElse: () => null,
          ),
        );
    return VerseWithTranslation(verse: v, translation: t);
  }).toList();
});
