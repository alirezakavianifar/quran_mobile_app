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

  group('Persian Tafsir (Interpretation) Tests', () {
    test('getTafsirForVerse retrieves Tafsir Noor by default', () async {
      await db.seedInitialData();
      await db.seedVersesForSurah(1);

      final verses = await (db.select(db.verses)..where((tbl) => tbl.surahId.equals(1))).get();
      final firstVerseId = verses.first.id;

      final tafsirNoor = await db.getTafsirForVerse(firstVerseId, editionId: 'fa.noor');
      expect(tafsirNoor, isNotNull);
      expect(tafsirNoor!.editionName, equals('fa.noor'));
      expect(tafsirNoor.languageCode, equals('fa'));
      expect(tafsirNoor.contentText, contains('تفسیر نور'));
      expect(tafsirNoor.contentText, contains('قرائتی'));
    });

    test('getTafsirForVerse retrieves Tafsir Nemoneh and Tafsir Al-Mizan', () async {
      await db.seedInitialData();
      await db.seedVersesForSurah(1);

      final verses = await (db.select(db.verses)..where((tbl) => tbl.surahId.equals(1))).get();
      final firstVerseId = verses.first.id;

      final tafsirNemoneh = await db.getTafsirForVerse(firstVerseId, editionId: 'fa.nemoneh');
      expect(tafsirNemoneh, isNotNull);
      expect(tafsirNemoneh!.contentText, contains('تفسیر نمونه'));

      final tafsirAlmizan = await db.getTafsirForVerse(firstVerseId, editionId: 'fa.almizan');
      expect(tafsirAlmizan, isNotNull);
      expect(tafsirAlmizan!.contentText, contains('المیزان'));
    });
  });
}
