import 'package:drift/drift.dart';
import 'connection/connection.dart';

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
    if (count.isNotEmpty) return;

    await batch((b) {
      b.insertAll(surahs, [
        SurahsCompanion.insert(
          number: 1,
          nameArabic: 'الفاتحة',
          namePersian: 'حمد (سرآغاز)',
          nameEnglish: 'Al-Fatihah',
          revelationType: 'Makki',
          verseCount: 7,
        ),
        SurahsCompanion.insert(
          number: 2,
          nameArabic: 'البقرة',
          namePersian: 'بقره (گاو ماده)',
          nameEnglish: 'Al-Baqarah',
          revelationType: 'Madani',
          verseCount: 286,
        ),
        SurahsCompanion.insert(
          number: 3,
          nameArabic: 'آل عمران',
          namePersian: 'آل عمران (خاندان عمران)',
          nameEnglish: 'Ali \'Imran',
          revelationType: 'Madani',
          verseCount: 200,
        ),
        SurahsCompanion.insert(
          number: 112,
          nameArabic: 'الإخلاص',
          namePersian: 'توحید (اخلاص)',
          nameEnglish: 'Al-Ikhlas',
          revelationType: 'Makki',
          verseCount: 4,
        ),
      ]);

      b.insertAll(verses, [
        VersesCompanion.insert(
          surahId: 1,
          verseNumber: 1,
          textUthmani: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
          textSimple: 'بسم الله الرحمن الرحيم',
          pageNumber: 1,
          juzNumber: 1,
        ),
        VersesCompanion.insert(
          surahId: 1,
          verseNumber: 2,
          textUthmani: 'ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَٰلَمِينَ',
          textSimple: 'الحمد لله رب العالمين',
          pageNumber: 1,
          juzNumber: 1,
        ),
        VersesCompanion.insert(
          surahId: 2,
          verseNumber: 255,
          textUthmani: 'ٱللَّهُ لَآ إِلَٰهَ إِلَّا هُوَ ٱلْحَيُّ ٱلْقَيُّومُ...',
          textSimple: 'الله لا اله الا هو الحي القيوم',
          pageNumber: 42,
          juzNumber: 3,
        ),
      ]);

      b.insertAll(translations, [
        TranslationsCompanion.insert(
          verseId: 1,
          languageCode: 'fa',
          authorName: 'آیت‌الله مکارم شیرازی',
          translationText: 'به نام خداوند بخشنده بخشایشگر',
        ),
        TranslationsCompanion.insert(
          verseId: 1,
          languageCode: 'en',
          authorName: 'Dr. Mustafa Khattab',
          translationText: 'In the name of Allah—the Most Compassionate, Most Merciful.',
        ),
        TranslationsCompanion.insert(
          verseId: 2,
          languageCode: 'fa',
          authorName: 'آیت‌الله مکارم شیرازی',
          translationText: 'ستایش مخصوص خداوندی است که پروردگار جهانیان است.',
        ),
        TranslationsCompanion.insert(
          verseId: 2,
          languageCode: 'en',
          authorName: 'Dr. Mustafa Khattab',
          translationText: 'All praise is for Allah—Lord of all worlds.',
        ),
      ]);
    });
  }
}
