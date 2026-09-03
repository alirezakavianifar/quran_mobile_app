import '../../../core/database/surah_seed_data.dart';
import '../../../core/database/verse_seed_data.dart';
import '../../../core/utils/persian_digit_converter.dart';

class PageVerseRef {
  final int surahId;
  final int verseNumber;
  final int pageNumber;
  final int juzNumber;
  final int totalVersesInSurah;

  const PageVerseRef({
    required this.surahId,
    required this.verseNumber,
    required this.pageNumber,
    required this.juzNumber,
    required this.totalVersesInSurah,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PageVerseRef &&
          runtimeType == other.runtimeType &&
          surahId == other.surahId &&
          verseNumber == other.verseNumber &&
          pageNumber == other.pageNumber;

  @override
  int get hashCode => Object.hash(surahId, verseNumber, pageNumber);

  @override
  String toString() => 'PageVerseRef(surah: $surahId, verse: $verseNumber, page: $pageNumber)';
}

class SurahMeta {
  final int number;
  final String nameArabic;
  final String namePersian;
  final String nameEnglish;
  final int verseCount;

  const SurahMeta({
    required this.number,
    required this.nameArabic,
    required this.namePersian,
    required this.nameEnglish,
    required this.verseCount,
  });
}

class QuranPageData {
  static const int totalPages = 604;

  static Map<int, List<PageVerseRef>>? _pageCache;
  static Map<int, SurahMeta>? _surahMetaCache;

  static void _ensureInitialized() {
    if (_pageCache != null && _surahMetaCache != null) return;

    final metaMap = <int, SurahMeta>{};
    for (final s in initialSurahsList) {
      metaMap[s.number.value] = SurahMeta(
        number: s.number.value,
        nameArabic: s.nameArabic.value,
        namePersian: s.namePersian.value,
        nameEnglish: s.nameEnglish.value,
        verseCount: s.verseCount.value,
      );
    }
    _surahMetaCache = metaMap;

    final pageMap = <int, List<PageVerseRef>>{};
    for (final entry in allQuranVersesMap.entries) {
      final surahId = entry.key;
      final totalVerses = metaMap[surahId]?.verseCount ?? entry.value.length;

      for (final v in entry.value) {
        final ref = PageVerseRef(
          surahId: v.surahId,
          verseNumber: v.verseNumber,
          pageNumber: v.pageNumber,
          juzNumber: v.juzNumber,
          totalVersesInSurah: totalVerses,
        );
        pageMap.putIfAbsent(v.pageNumber, () => []).add(ref);
      }
    }
    _pageCache = pageMap;
  }

  /// Returns the ordered list of all verses on a given Quran page (1 to 604).
  static List<PageVerseRef> getVersesForPage(int pageNumber) {
    _ensureInitialized();
    final clamped = pageNumber.clamp(1, totalPages);
    return _pageCache![clamped] ?? const [];
  }

  /// Returns metadata for a Surah.
  static SurahMeta? getSurahMeta(int surahNumber) {
    _ensureInitialized();
    return _surahMetaCache![surahNumber];
  }

  /// Finds the page number for a given Surah and Verse.
  static int getPageForVerse(int surahId, int verseNumber) {
    final list = allQuranVersesMap[surahId];
    if (list != null) {
      for (final v in list) {
        if (v.verseNumber == verseNumber) {
          return v.pageNumber;
        }
      }
    }
    return 1;
  }

  /// Formats a human-readable summary of the page contents (e.g. Surah name, Ayah range, verse count).
  static String getPageSummary(int pageNumber, {required bool isPersian}) {
    final verses = getVersesForPage(pageNumber);
    if (verses.isEmpty) return '';

    _ensureInitialized();

    // Group verses by Surah
    final surahIds = <int>[];
    for (final v in verses) {
      if (!surahIds.contains(v.surahId)) {
        surahIds.add(v.surahId);
      }
    }

    final totalVersesCount = verses.length;
    final totalVersesStr = isPersian
        ? PersianDigitConverter.toPersian('$totalVersesCount')
        : '$totalVersesCount';

    if (surahIds.length == 1) {
      final sId = surahIds.first;
      final meta = _surahMetaCache![sId];
      final surahName = isPersian
          ? (meta?.namePersian ?? 'سوره $sId')
          : (meta?.nameEnglish ?? 'Surah $sId');
      final firstVerse = verses.first.verseNumber;
      final lastVerse = verses.last.verseNumber;

      final startStr = isPersian
          ? PersianDigitConverter.toPersian('$firstVerse')
          : '$firstVerse';
      final endStr = isPersian
          ? PersianDigitConverter.toPersian('$lastVerse')
          : '$lastVerse';

      if (firstVerse == lastVerse) {
        return isPersian
            ? 'سوره $surahName • آیه $startStr ($totalVersesStr آیه)'
            : 'Surah $surahName • Ayah $startStr ($totalVersesStr verse)';
      }

      return isPersian
          ? 'سوره $surahName • آیات $startStr تا $endStr ($totalVersesStr آیه)'
          : 'Surah $surahName • Ayahs $startStr - $endStr ($totalVersesStr verses)';
    } else {
      // Spans multiple surahs
      final surahNames = surahIds.map((sId) {
        final meta = _surahMetaCache![sId];
        return isPersian
            ? (meta?.namePersian ?? '$sId')
            : (meta?.nameEnglish ?? '$sId');
      }).join(isPersian ? '، ' : ', ');

      return isPersian
          ? 'سوره‌های $surahNames ($totalVersesStr آیه)'
          : 'Surahs $surahNames ($totalVersesStr verses)';
    }
  }
}
