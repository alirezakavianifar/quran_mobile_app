import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile_app/src/core/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('Drift AppDatabase Integration Tests', () {
    test('seedInitialData inserts default Surahs, Verses, and Translations', () async {
      await db.seedInitialData();
      await db.seedVersesForSurah(1);

      final surahsList = await db.select(db.surahs).get();
      expect(surahsList.length, equals(114));
      expect(surahsList.first.nameArabic, equals('الفاتحة'));

      final versesList = await db.select(db.verses).get();
      expect(versesList.isNotEmpty, isTrue);
      expect(versesList.first.textUthmani, contains('بِسْمِ'));

      final translationsList = await db.select(db.translations).get();
      expect(translationsList.isNotEmpty, isTrue);
      expect(translationsList.first.languageCode, equals('fa'));
    });

    test('Bookmarks CRUD operations', () async {
      await db.into(db.bookmarks).insert(
            BookmarksCompanion.insert(
              surahId: 2,
              verseNumber: 255,
              note: const Value('Ayat al-Kursi'),
            ),
          );

      final bookmarksList = await db.select(db.bookmarks).get();
      expect(bookmarksList.length, equals(1));
      expect(bookmarksList.first.surahId, equals(2));
      expect(bookmarksList.first.verseNumber, equals(255));
      expect(bookmarksList.first.note, equals('Ayat al-Kursi'));

      await (db.delete(db.bookmarks)..where((tbl) => tbl.id.equals(bookmarksList.first.id))).go();
      final afterDelete = await db.select(db.bookmarks).get();
      expect(afterDelete.isEmpty, isTrue);
    });

    test('seedVersesForSurah loads correct verses for Surah 2 (Al-Baqarah)', () async {
      await db.seedInitialData();
      await db.seedVersesForSurah(2);

      final baqarahVerses = await (db.select(db.verses)
            ..where((tbl) => tbl.surahId.equals(2))
            ..orderBy([(t) => OrderingTerm.asc(t.verseNumber)]))
          .get();

      expect(baqarahVerses.length, equals(286));
      expect(baqarahVerses.first.textUthmani, equals('الٓمٓ'));
      expect(baqarahVerses[1].textUthmani, contains('ذَٰلِكَ ٱلْكِتَٰبُ'));
    });
  });
}
