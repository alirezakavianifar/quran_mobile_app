import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile_app/src/features/audio/data/audio_repository.dart';
import 'package:quran_mobile_app/src/features/audio/data/quran_page_data.dart';
import 'package:quran_mobile_app/src/features/audio/presentation/audio_player_notifier.dart';

class TestAudioPlayer implements AudioPlayer {
  @override
  Stream<Duration> get onDurationChanged => const Stream.empty();

  @override
  Stream<Duration> get onPositionChanged => const Stream.empty();

  @override
  Stream<PlayerState> get onPlayerStateChanged => const Stream.empty();

  @override
  Stream<void> get onPlayerComplete => const Stream.empty();

  @override
  Future<void> stop() async {}

  @override
  Future<void> pause() async {}

  @override
  Future<void> resume() async {}

  @override
  Future<void> seek(Duration position) async {}

  @override
  Future<void> setPlaybackRate(double speed) async {}

  @override
  Future<void> dispose() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class TestAudioRepository implements AudioRepository {
  @override
  Future<List<Reciter>> fetchReciters() async {
    return [
      Reciter(
        id: 'parhizgar',
        nameArabic: 'شهريار پرهيزكار',
        namePersian: 'شهریار پرهیزگار',
        nameEnglish: 'Shahriar Parhizgar',
        style: 'Tartil',
        baseUrl: 'https://everyayah.com/data/Parhizgar_48kbps/',
      ),
    ];
  }

  @override
  Future<String> getAyahAudioUrl(String reciterId, int surahId, int verseId) async {
    final s = surahId.toString().padLeft(3, '0');
    final v = verseId.toString().padLeft(3, '0');
    return 'https://everyayah.com/data/$reciterId/$s$v.mp3';
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QuranPageData Unit Tests', () {
    test('Total Quran pages is 604', () {
      expect(QuranPageData.totalPages, 604);
    });

    test('Page 23 maps precisely to Surah 2 (Al-Baqarah) Verses 146 to 153 (8 verses)', () {
      final verses = QuranPageData.getVersesForPage(23);
      expect(verses.length, 8);
      expect(verses.first.surahId, 2);
      expect(verses.first.verseNumber, 146);
      expect(verses.last.surahId, 2);
      expect(verses.last.verseNumber, 153);
      expect(verses.every((v) => v.pageNumber == 23), isTrue);
    });

    test('Page 1 maps to Surah 1 (Al-Fatihah) Verses 1 to 7', () {
      final verses = QuranPageData.getVersesForPage(1);
      expect(verses.length, 7);
      expect(verses.first.surahId, 1);
      expect(verses.first.verseNumber, 1);
      expect(verses.last.surahId, 1);
      expect(verses.last.verseNumber, 7);
    });

    test('Page 604 correctly maps across multiple Surahs (112, 113, 114)', () {
      final verses = QuranPageData.getVersesForPage(604);
      expect(verses.isNotEmpty, isTrue);

      final surahsOnPage = verses.map((v) => v.surahId).toSet();
      expect(surahsOnPage, containsAll([112, 113, 114]));
      expect(verses.first.surahId, 112);
      expect(verses.last.surahId, 114);
    });

    test('getPageSummary formats accurately for single-surah and multi-surah pages', () {
      final summaryFa = QuranPageData.getPageSummary(23, isPersian: true);
      expect(summaryFa, contains('بقره'));
      expect(summaryFa, contains('۱۴۶'));
      expect(summaryFa, contains('۱۵۳'));
      expect(summaryFa, contains('۸ آیه'));

      final summaryEn = QuranPageData.getPageSummary(23, isPersian: false);
      expect(summaryEn, contains('Al-Baqarah'));
      expect(summaryEn, contains('146'));
      expect(summaryEn, contains('153'));
      expect(summaryEn, contains('8 verses'));

      final summaryMultiFa = QuranPageData.getPageSummary(604, isPersian: true);
      expect(summaryMultiFa, contains('سوره‌های'));
    });

    test('getPageForVerse resolves page number from Surah and Verse', () {
      expect(QuranPageData.getPageForVerse(1, 1), 1);
      expect(QuranPageData.getPageForVerse(2, 146), 23);
      expect(QuranPageData.getPageForVerse(2, 153), 23);
      expect(QuranPageData.getPageForVerse(2, 154), 24);
    });
  });

  group('AudioPlayerNotifier Page Repeat Tests', () {
    late TestAudioRepository repository;
    late TestAudioPlayer player;
    late AudioPlayerNotifier notifier;

    setUp(() {
      repository = TestAudioRepository();
      player = TestAudioPlayer();
      notifier = AudioPlayerNotifier(repository, player: player);
    });

    tearDown(() {
      notifier.dispose();
    });

    test('setPageRepeat configures whole page repeat state and clears verse range', () async {
      expect(notifier.currentState.isPageRepeatActive, false);

      await notifier.setPageRepeat(
        pageNumber: 23,
        loopCount: 5,
        startPlaying: false,
      );

      expect(notifier.currentState.isPageRepeatActive, true);
      expect(notifier.currentState.repeatPageNumber, 23);
      expect(notifier.currentState.pageVerses?.length, 8);
      expect(notifier.currentState.currentPageVerseIndex, 0);
      expect(notifier.currentState.pageLoopCount, 5);
      expect(notifier.currentState.currentPageCycle, 1);
      expect(notifier.currentState.isRangeRepeatActive, false);
      expect(notifier.currentState.rangeStartVerse, null);
      expect(notifier.currentState.rangeEndVerse, null);
    });

    test('clearPageRepeat resets page repeat state', () async {
      await notifier.setPageRepeat(
        pageNumber: 23,
        loopCount: 3,
        startPlaying: false,
      );
      expect(notifier.currentState.isPageRepeatActive, true);

      notifier.clearPageRepeat();
      expect(notifier.currentState.isPageRepeatActive, false);
      expect(notifier.currentState.repeatPageNumber, null);
      expect(notifier.currentState.pageVerses, null);
      expect(notifier.currentState.currentPageVerseIndex, 0);
    });

    test('setVerseRange clears any active page repeat', () async {
      await notifier.setPageRepeat(
        pageNumber: 23,
        loopCount: 2,
        startPlaying: false,
      );
      expect(notifier.currentState.isPageRepeatActive, true);

      await notifier.setVerseRange(
        surahId: 2,
        startVerse: 1,
        endVerse: 5,
        totalVerses: 286,
        loopCount: 2,
        startPlaying: false,
      );

      expect(notifier.currentState.isRangeRepeatActive, true);
      expect(notifier.currentState.isPageRepeatActive, false);
      expect(notifier.currentState.repeatPageNumber, null);
    });

    test('playVerse synchronizes currentPageVerseIndex when page repeat is active', () async {
      await notifier.setPageRepeat(
        pageNumber: 23,
        loopCount: 3,
        startPlaying: false,
      );
      expect(notifier.currentState.currentPageVerseIndex, 0);

      // Play verse 148 of Surah 2 (which is index 2 on page 23)
      await notifier.playVerse(2, 148, 286);
      expect(notifier.currentState.currentPageVerseIndex, 2);
      expect(notifier.currentState.currentSurahId, 2);
      expect(notifier.currentState.currentVerseNumber, 148);
    });
  });
}
