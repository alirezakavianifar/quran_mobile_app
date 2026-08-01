import 'package:drift/drift.dart';
import 'connection/connection.dart';

import 'surah_seed_data.dart';
import 'verse_seed_data.dart';

part 'app_database.g.dart';

class Surahs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get number => integer()();
  TextColumn get nameArabic => text()();
  TextColumn get namePersian => text()();
  TextColumn get nameEnglish => text()();
  TextColumn get revelationType => text()();
  IntColumn get verseCount => integer()();
}

class Verses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get surahId => integer()();
  IntColumn get verseNumber => integer()();
  TextColumn get textUthmani => text()();
  TextColumn get textSimple => text()();
  IntColumn get pageNumber => integer()();
  IntColumn get juzNumber => integer()();
}

class Translations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get verseId => integer()();
  TextColumn get languageCode => text()(); // 'fa' or 'en'
  TextColumn get authorName => text()();
  TextColumn get translationText => text()();
}

class Tafsirs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get verseId => integer()();
  TextColumn get editionName => text()(); // e.g. 'Tafsir Nemoneh'
  TextColumn get languageCode => text()();
  TextColumn get contentText => text()();
}

class Bookmarks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get surahId => integer()();
  IntColumn get verseNumber => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get note => text().nullable()();
}

@DriftDatabase(tables: [Surahs, Verses, Translations, Tafsirs, Bookmarks])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e])
      : super(e ?? createDatabaseConnection());

  @override
  int get schemaVersion => 1;

  // Seed sample Quran Surahs for offline reading
  Future<void> seedInitialData() async {
    final count = await select(surahs).get();
    if (count.length < 114) {
      await batch((b) {
        b.insertAll(surahs, initialSurahsList, mode: InsertMode.insertOrReplace);
      });
    }
  }

  // Seed verses and translations for any Surah on demand
  Future<void> seedVersesForSurah(int surahId) async {
    final existing = await (select(verses)..where((tbl) => tbl.surahId.equals(surahId))).get();
    if (existing.isNotEmpty) return;

    final seedItems = allQuranVersesMap[surahId];
    if (seedItems == null || seedItems.isEmpty) return;

    for (final item in seedItems) {
      final verseId = await into(verses).insert(
        VersesCompanion.insert(
          surahId: item.surahId,
          verseNumber: item.verseNumber,
          textUthmani: item.textUthmani,
          textSimple: item.textSimple,
          pageNumber: item.pageNumber,
          juzNumber: item.juzNumber,
        ),
      );

      await into(translations).insert(
        TranslationsCompanion.insert(
          verseId: verseId,
          languageCode: 'fa',
          authorName: 'آیت‌الله مکارم شیرازی',
          translationText: item.translationFa,
        ),
      );

      await into(translations).insert(
        TranslationsCompanion.insert(
          verseId: verseId,
          languageCode: 'en',
          authorName: 'Dr. Mustafa Khattab',
          translationText: item.translationEn,
        ),
      );
    }
  }
}
