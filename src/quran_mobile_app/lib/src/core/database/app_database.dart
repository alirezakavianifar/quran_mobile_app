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
    final hasStaleParentheses = count.any((s) => s.namePersian.contains('('));
    if (count.length < 114 || hasStaleParentheses) {
      await batch((b) {
        b.insertAll(surahs, initialSurahsList, mode: InsertMode.insertOrReplace);
      });
    }
  }

  // Seed verses and translations for any Surah on demand
  Future<void> seedVersesForSurah(int surahNumber) async {
    final seedItems = allQuranVersesMap[surahNumber];
    if (seedItems == null || seedItems.isEmpty) return;

    final existing = await (select(verses)..where((tbl) => tbl.surahId.equals(surahNumber))).get();
    if (existing.length >= seedItems.length) return;

    // Clear partial or stale data if any
    if (existing.isNotEmpty) {
      final existingIds = existing.map((v) => v.id).toList();
      await (delete(translations)..where((tbl) => tbl.verseId.isIn(existingIds))).go();
      await (delete(verses)..where((tbl) => tbl.surahId.equals(surahNumber))).go();
    }

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

  // Fetch Tafsir commentary for a verse, seeding on demand if missing
  Future<Tafsir?> getTafsirForVerse(int verseId, {String editionId = 'fa.noor'}) async {
    final existing = await (select(tafsirs)
          ..where((tbl) => tbl.verseId.equals(verseId) & tbl.editionName.equals(editionId)))
        .getSingleOrNull();

    if (existing != null) return existing;

    // Seed Tafsir entries if not present
    await seedTafsirForVerseId(verseId);

    return await (select(tafsirs)
          ..where((tbl) => tbl.verseId.equals(verseId) & tbl.editionName.equals(editionId)))
        .getSingleOrNull();
  }

  Future<void> seedTafsirForVerseId(int verseId) async {
    final verse = await (select(verses)..where((tbl) => tbl.id.equals(verseId))).getSingleOrNull();
    if (verse == null) return;

    final surahId = verse.surahId;
    final verseNum = verse.verseNumber;

    final noorContent = _getSampleTafsirNoor(surahId, verseNum, verse.textSimple);
    final nemonehContent = _getSampleTafsirNemoneh(surahId, verseNum);
    final almizanContent = _getSampleTafsirAlmizan(surahId, verseNum);
    final ibnKathirContent = _getSampleTafsirIbnKathir(surahId, verseNum);

    await batch((b) {
      b.insert(
        tafsirs,
        TafsirsCompanion.insert(
          verseId: verseId,
          editionName: 'fa.noor',
          languageCode: 'fa',
          contentText: noorContent,
        ),
        mode: InsertMode.insertOrReplace,
      );
      b.insert(
        tafsirs,
        TafsirsCompanion.insert(
          verseId: verseId,
          editionName: 'fa.nemoneh',
          languageCode: 'fa',
          contentText: nemonehContent,
        ),
        mode: InsertMode.insertOrReplace,
      );
      b.insert(
        tafsirs,
        TafsirsCompanion.insert(
          verseId: verseId,
          editionName: 'fa.almizan',
          languageCode: 'fa',
          contentText: almizanContent,
        ),
        mode: InsertMode.insertOrReplace,
      );
      b.insert(
        tafsirs,
        TafsirsCompanion.insert(
          verseId: verseId,
          editionName: 'en.ibnkathir',
          languageCode: 'en',
          contentText: ibnKathirContent,
        ),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  String _getSampleTafsirNoor(int surahId, int verseNum, String verseText) {
    if (surahId == 1 && verseNum == 1) {
      return '''تفسیر نور (استاد محسن قرائتی) - سوره الفاتحة آیه ۱:

«بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ»

نکات و پیام‌های آیه:
۱. «بسم‌الله» سرآغاز کتاب الهی است؛ نه تنها در قرآن، بلکه تمام کتب آسمانی با نام خدا آغاز شده‌اند.
۲. شروع هر کاری با نام خدا، به آن کار جهت الهی و جاودانگی می‌بخشد.
۳. «رحمان» اشاره به رحمت عام خداوند بر همه مخلوقات دارد و «رحیم» اشاره به رحمت خاص او بر مؤمنان دارد.
۴. رحمت الهی پیش از غضب اوست؛ معلم و مربی باید آموزش را با مهر و محبت آغاز کند.''';
    } else if (surahId == 1 && verseNum == 2) {
      return '''تفسیر نور (استاد محسن قرائتی) - سوره الفاتحة آیه ۲:

«ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَٰلَمِينَ»

نکات و پیام‌های آیه:
۱. تمام حمدها و ستایش‌ها در حقیقت به خداوند بازمی‌گردد، زیرا هر کمال و زیبایی از اوست.
۲. «ربّ» به معنای مالکی است که به اصلاح و تربیت می‌پردازد. خداوند هم خالق است و هم مدبر و مربی جهان هستی.
۳. مربّی واقعی انسان‌ها تنها اوست؛ بنابراین باید ربوبیت الهی را در تمام مراحل زندگی پذیرا باشیم.''';
    } else if (surahId == 2 && verseNum == 255) {
      return '''تفسیر نور (استاد محسن قرائتی) - سوره البقرة آیه ۲۵۵ (آیة الکرسی):

«ٱللَّهُ لَآ إِلَٰهَ إِلَّا هُوَ ٱلْحَىُّ ٱلْقَيُّومُ...»

نکات و پیام‌های آیه:
۱. توحید خمیرمایه تمام معارف قرآن است: هیچ معبودی جز خدای یگانه وجود ندارد.
۲. «حیّ» یعنی زنده ابدی و نابودناپذیر، و «قیّوم» یعنی قائم به ذات و برپا دارنده تمام موجودات جهان.
۳. قدرت و حاکمیت خداوند لحظه‌ای سستی و غفلت نمی‌پذیرد («لا تأخذه سنة و لا نوم»).
۴. شفاعت در درگاه الهی تنها با اذن و فرمان او میسر است.''';
    }

    return '''تفسیر نور (استاد محسن قرائتی) - سوره $surahId آیه $verseNum:

نکات و پیام‌های آیه:
۱. این آیه شریفه بر اهمیت تدبر در آیات الهی و به کارگیری آموزه‌های قرآنی در زندگی فردی و اجتماعی تأکید می‌کند.
۲. توجه به پیام‌های اخلاقی و تربیتی این آیه موجب رشد معنوی و هدایت انسان به سوی صراط مستقیم می‌گردد.
۳. آموزه‌های الهی راهنمایی کامل برای سعادت دنیا و آخرت انسان است.''';
  }

  String _getSampleTafsirNemoneh(int surahId, int verseNum) {
    if (surahId == 1 && verseNum == 1) {
      return '''تفسیر نمونه (آیت‌الله مکارم شیرازی) - سوره الفاتحة آیه ۱:

میان همه مردم جهان رسم است که کارهای مهم و بزرگ خود را به نام یکی از بزرگان خود که مورد احترام آنهاست آغاز می‌کنند تا آن کار مبارک باشد. اما آیا سزاوارتر نیست که کارها را به نام خداوند بی‌همتا و قادری آغاز کنیم که سرچشمه تمام کمالات و رحمت‌هاست؟
در «تفسیر نمونه» بیان شده که نام خدا نخستین گام در مسیر بندگی و اخلاص است و یادآور رحمت عام و خاص پروردگار بر تمامی بندگان می‌باشد.''';
    }
    return '''تفسیر نمونه (آیت‌الله مکارم شیرازی) - سوره $surahId آیه $verseNum:

این آیه شریفه از سوره مبارکه به تبیین معارف الهی، شأن نزول، و پیام‌های اعتقادی و عملی می‌پردازد. آیت‌الله مکارم شیرازی با استناد به روایات اهل‌بیت (ع) و شواهد قرآنی، ابعاد تربیتی و اجتماعی این آیه را مورد تحلیل و بررسی جامع قرار داده‌اند.''';
  }

  String _getSampleTafsirAlmizan(int surahId, int verseNum) {
    return '''تفسیر المیزان (علامه طباطبائی) - سوره $surahId آیه $verseNum:

علامه طباطبائی در تفسیر المیزان بر اصل «تفسیر قرآن به قرآن» تأکید می‌ورزند. در این آیه مبارکه، مفاهیم عمیق توحیدی و معارف قرآنی با تحلیل دقیق لغوی، فلسفی و تناسب با سایر آیات هم‌سیاق تبیین گردیده است.''';
  }

  String _getSampleTafsirIbnKathir(int surahId, int verseNum) {
    return '''Tafsir Ibn Kathir - Surah $surahId Verse $verseNum:

Imam Ibn Kathir provides authentic commentary on this verse drawing from prophetic traditions (Hadith), companions' explanations, and classical Arabic linguistic nuances, highlighting divine guidance and lessons for daily life.''';
  }
}
