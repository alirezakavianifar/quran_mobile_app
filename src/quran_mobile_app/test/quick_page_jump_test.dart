import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile_app/src/core/localization/app_localizations.dart';
import 'package:quran_mobile_app/src/core/utils/persian_digit_converter.dart';
import 'package:quran_mobile_app/src/features/audio/data/quran_page_data.dart';
import 'package:quran_mobile_app/src/features/reader/quick_page_jump_dialog.dart';

int? testTryParsePageNumber(String query) {
  if (query.trim().isEmpty) return null;

  final clean = query
      .toLowerCase()
      .replaceAll('صفحه', '')
      .replaceAll('صفحة', '')
      .replaceAll('page', '')
      .replaceAll('p', '')
      .replaceAll('ص', '')
      .replaceAll('#', '')
      .replaceAll(':', '')
      .trim();

  final englishDigits = PersianDigitConverter.toEnglish(clean);
  final parsed = int.tryParse(englishDigits);
  if (parsed != null && parsed >= 1 && parsed <= QuranPageData.totalPages) {
    return parsed;
  }
  return null;
}

void main() {
  group('Quick Page Jump Query Parser Tests', () {
    test('parses pure English page numbers', () {
      expect(testTryParsePageNumber('456'), 456);
      expect(testTryParsePageNumber('1'), 1);
      expect(testTryParsePageNumber('604'), 604);
      expect(testTryParsePageNumber('23'), 23);
    });

    test('parses English page prefixes and letters', () {
      expect(testTryParsePageNumber('page 456'), 456);
      expect(testTryParsePageNumber('Page 456'), 456);
      expect(testTryParsePageNumber('p 456'), 456);
      expect(testTryParsePageNumber('p:456'), 456);
      expect(testTryParsePageNumber('#456'), 456);
    });

    test('parses pure Persian and Arabic digits', () {
      expect(testTryParsePageNumber('۴۵۶'), 456);
      expect(testTryParsePageNumber('۱'), 1);
      expect(testTryParsePageNumber('۶۰۴'), 604);
      expect(testTryParsePageNumber('۲۳'), 23);
    });

    test('parses Persian phrases and prefixes', () {
      expect(testTryParsePageNumber('صفحه ۴۵۶'), 456);
      expect(testTryParsePageNumber('صفحه 456'), 456);
      expect(testTryParsePageNumber('ص ۴۵۶'), 456);
      expect(testTryParsePageNumber('ص:۴۵۶'), 456);
      expect(testTryParsePageNumber('صفحة ۴۵۶'), 456);
    });

    test('rejects out of range or invalid queries', () {
      expect(testTryParsePageNumber('0'), isNull);
      expect(testTryParseNumberZero(), isNull);
      expect(testTryParsePageNumber('605'), isNull);
      expect(testTryParsePageNumber('1000'), isNull);
      expect(testTryParsePageNumber('سوره بقره'), isNull);
      expect(testTryParsePageNumber('yasin'), isNull);
      expect(testTryParsePageNumber(''), isNull);
    });
  });

  group('QuranPageData Page 456 Lookup Tests', () {
    test('resolves Page 456 to Surah Sad Verse 43', () {
      final verses = QuranPageData.getVersesForPage(456);
      expect(verses, isNotEmpty);
      expect(verses.first.surahId, 38);
      expect(verses.first.verseNumber, 43);
      expect(verses.last.surahId, 38);
      expect(verses.last.verseNumber, 61);
      expect(verses.length, 19);
    });

    test('produces correct Persian and English summaries for Page 456', () {
      final summaryFa = QuranPageData.getPageSummary(456, isPersian: true);
      final summaryEn = QuranPageData.getPageSummary(456, isPersian: false);

      expect(summaryFa, contains('سوره ص'));
      expect(summaryFa, contains('۴۳'));
      expect(summaryFa, contains('۶۱'));

      expect(summaryEn, contains('Sad'));
      expect(summaryEn, contains('43'));
      expect(summaryEn, contains('61'));
    });
  });

  group('QuickPageJumpDialog Widget Tests', () {
    testWidgets('renders dialog with initial page and preview card', (tester) async {
      int? selectedPage;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () {
                  QuickPageJumpDialog.show(
                    ctx,
                    initialPage: 456,
                    onPageSelected: (p) => selectedPage = p,
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.byType(QuickPageJumpDialog), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(tester.widget<TextField>(find.byType(TextField)).controller?.text, '456');
      expect(find.text('صفحه ۴۵۶'), findsOneWidget);
      expect(find.textContaining('سوره ص'), findsOneWidget);
    });

    testWidgets('preset chip updates page and submits correctly', (tester) async {
      int? submittedPage;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () {
                  QuickPageJumpDialog.show(
                    ctx,
                    initialPage: 1,
                    onPageSelected: (p) => submittedPage = p,
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Tap preset chip 'ص ۱۰۰'
      await tester.tap(find.text('ص ۱۰۰'));
      await tester.pumpAndSettle();

      expect(find.text('100'), findsOneWidget);

      // Tap the primary action button
      await tester.tap(find.textContaining('برو به صفحه ۱۰۰'));
      await tester.pumpAndSettle();

      expect(submittedPage, 100);
    });
  });
}

int? testTryParseNumberZero() => testTryParsePageNumber('۰');
