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

      final surahsList = await db.select(db.surahs).get();
      expect(surahsList.length, equals(4));
      expect(surahsList.first.nameArabic, equals('الفاتحة'));
      expect(surahsList.first.namePersian, equals('حمد (سرآغاز)'));

      final versesList = await db.select(db.verses).get();
      expect(versesList.isNotEmpty, isTrue);
      expect(versesList.first.textUthmani, contains('ٱللَّهِ'));

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
  });
}
