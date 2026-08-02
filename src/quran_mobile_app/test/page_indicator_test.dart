import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile_app/src/core/database/app_database.dart';
import 'package:quran_mobile_app/src/features/reader/reader_provider.dart';
import 'package:quran_mobile_app/src/features/reader/verse_detail_view.dart';
import 'package:quran_mobile_app/src/core/localization/app_localizations.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('Quran Page Indicator Tests', () {
    test('Database verses contain valid pageNumber and juzNumber', () async {
      await db.seedInitialData();
      await db.seedVersesForSurah(1);
      await db.seedVersesForSurah(2);

      final surah1Verses = await (db.select(db.verses)
            ..where((tbl) => tbl.surahId.equals(1)))
          .get();
      expect(surah1Verses.every((v) => v.pageNumber == 1), isTrue);
      expect(surah1Verses.every((v) => v.juzNumber == 1), isTrue);

      final surah2Verses = await (db.select(db.verses)
            ..where((tbl) => tbl.surahId.equals(2)))
          .get();
      expect(surah2Verses.first.pageNumber, equals(2));
      expect(surah2Verses.first.juzNumber, equals(1));
    });

    testWidgets('VerseDetailView renders page indicator in AppBar and verse cards',
        (WidgetTester tester) async {
      await db.seedInitialData();
      await db.seedVersesForSurah(1);

      final surahList = await db.select(db.surahs).get();
      final surah1 = surahList.firstWhere((s) => s.number == 1);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              DefaultMaterialLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
            ],
            home: VerseDetailView(surah: surah1),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check AppBar page indicator text in Persian (default)
      expect(find.textContaining('صفحه ۱'), findsWidgets);
      expect(find.textContaining('جزء ۱'), findsWidgets);
    });
  });
}
