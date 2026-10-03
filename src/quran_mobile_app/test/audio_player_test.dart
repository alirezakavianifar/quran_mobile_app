import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile_app/src/features/audio/data/audio_repository.dart';
import 'package:quran_mobile_app/src/features/audio/presentation/audio_player_notifier.dart';

class FakeAudioPlayer implements AudioPlayer {
  double currentPlaybackRate = 1.0;

  @override
  Stream<Duration> get onDurationChanged => const Stream.empty();

  @override
  Stream<Duration> get onPositionChanged => const Stream.empty();

  @override
  Stream<PlayerState> get onPlayerStateChanged => const Stream.empty();

  @override
  Stream<void> get onPlayerComplete => const Stream.empty();

  @override
  Future<void> play(
    Source source, {
    double? volume,
    double? balance,
    AudioContext? ctx,
    Duration? position,
    PlayerMode? mode,
  }) async {}

  @override
  Future<void> stop() async {}

  @override
  Future<void> pause() async {}

  @override
  Future<void> resume() async {}

  @override
  Future<void> seek(Duration position) async {}

  @override
  Future<void> setPlaybackRate(double speed) async {
    currentPlaybackRate = speed;
  }

  @override
  Future<void> dispose() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeAudioRepository implements AudioRepository {
  final List<Reciter> mockReciters = [
    Reciter(
      id: 'parhizgar',
      nameArabic: 'شهريار پرهيزكار',
      namePersian: 'شهریار پرهیزگار',
      nameEnglish: 'Shahriar Parhizgar',
      style: 'Tartil',
      baseUrl: 'https://everyayah.com/data/Parhizgar_48kbps/',
      hasSeparateBismillahAudio: false,
    ),
    Reciter(
      id: 'alafasy',
      nameArabic: 'مشاري راشد العفاسي',
      namePersian: 'مشاری راشد العفاسی',
      nameEnglish: 'Mishary Rashid Alafasy',
      style: 'Murattal',
      baseUrl: 'https://everyayah.com/data/Alafasy_128kbps/',
      hasSeparateBismillahAudio: true,
    ),
    Reciter(
      id: 'husary',
      nameArabic: 'محمود خليل الحصري',
      namePersian: 'محمود خلیل الحصری',
      nameEnglish: 'Mahmoud Khalil Al-Husary',
      style: 'Murattal',
      baseUrl: 'https://everyayah.com/data/Husary_128kbps/',
      hasSeparateBismillahAudio: false,
    ),
  ];

  @override
  Future<List<Reciter>> fetchReciters() async {
    return mockReciters;
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

  group('AudioPlayerNotifier Unit Tests', () {
    late FakeAudioRepository repository;
    late FakeAudioPlayer player;
    late AudioPlayerNotifier notifier;

    setUp(() {
      repository = FakeAudioRepository();
      player = FakeAudioPlayer();
      notifier = AudioPlayerNotifier(repository, player: player);
    });

    tearDown(() {
      notifier.dispose();
    });

    test('Loads reciters on init and sets default reciter', () async {
      await notifier.loadReciters();
      expect(notifier.currentState.availableReciters.length, 3);
      expect(notifier.currentState.currentReciter?.id, 'parhizgar');
    });

    test('Toggles auto play next state', () {
      expect(notifier.currentState.autoPlayNext, true);
      notifier.toggleAutoPlayNext();
      expect(notifier.currentState.autoPlayNext, false);
    });

    test('Switches current reciter', () async {
      await notifier.loadReciters();
      final husary = notifier.currentState.availableReciters.firstWhere((r) => r.id == 'husary');
      await notifier.selectReciter(husary);
      expect(notifier.currentState.currentReciter?.id, 'husary');
    });

    test('Updates playback speed in state and player', () async {
      expect(notifier.currentState.playbackSpeed, 1.0);
      await notifier.setPlaybackSpeed(1.5);
      expect(notifier.currentState.playbackSpeed, 1.5);
      expect(player.currentPlaybackRate, 1.5);
    });

    test('stop clears surah and verse numbers', () async {
      await notifier.playVerse(2, 2, 286);
      expect(notifier.currentState.currentSurahId, 2);
      expect(notifier.currentState.currentVerseNumber, 2);

      await notifier.stop();
      expect(notifier.currentState.currentSurahId, null);
      expect(notifier.currentState.currentVerseNumber, null);
      expect(notifier.currentState.isPlaying, false);
      expect(notifier.currentState.currentVersePlayCount, 1);
    });

    test('Updates verse repeat count in state', () {
      expect(notifier.currentState.verseRepeatCount, 1);
      expect(notifier.currentState.currentVersePlayCount, 1);

      notifier.setVerseRepeatCount(3);
      expect(notifier.currentState.verseRepeatCount, 3);

      notifier.setVerseRepeatCount(-1);
      expect(notifier.currentState.verseRepeatCount, -1);
    });

    test('Configures verse range repeat and clears it', () async {
      expect(notifier.currentState.isRangeRepeatActive, false);

      await notifier.setVerseRange(
        surahId: 1,
        startVerse: 1,
        endVerse: 5,
        totalVerses: 7,
        loopCount: 3,
        startPlaying: false,
      );

      expect(notifier.currentState.isRangeRepeatActive, true);
      expect(notifier.currentState.rangeStartVerse, 1);
      expect(notifier.currentState.rangeEndVerse, 5);
      expect(notifier.currentState.rangeLoopCount, 3);
      expect(notifier.currentState.currentRangeCycle, 1);

      notifier.clearVerseRange();
      expect(notifier.currentState.isRangeRepeatActive, false);
      expect(notifier.currentState.rangeStartVerse, null);
      expect(notifier.currentState.rangeEndVerse, null);
    });

    test('Configures whole page repeat and clears it', () async {
      expect(notifier.currentState.isPageRepeatActive, false);

      await notifier.setPageRepeat(
        pageNumber: 23,
        loopCount: 5,
        startPlaying: false,
      );

      expect(notifier.currentState.isPageRepeatActive, true);
      expect(notifier.currentState.repeatPageNumber, 23);
      expect(notifier.currentState.pageLoopCount, 5);
      expect(notifier.currentState.currentPageCycle, 1);
      expect(notifier.currentState.pageVerses?.length, 8);

      notifier.clearPageRepeat();
      expect(notifier.currentState.isPageRepeatActive, false);
      expect(notifier.currentState.repeatPageNumber, null);
      expect(notifier.currentState.pageVerses, null);
    });

    test('playBismillah for reciter with separate Bismillah (Alafasy) plays verse 0', () async {
      await notifier.loadReciters();
      final alafasy = notifier.currentState.availableReciters.firstWhere((r) => r.id == 'alafasy');
      await notifier.selectReciter(alafasy);

      await notifier.playBismillah(40, 85);

      expect(notifier.currentState.currentSurahId, 40);
      expect(notifier.currentState.currentVerseNumber, 0);
      expect(notifier.currentState.isBismillahActive(40), true);
      expect(notifier.currentState.isPlaying, true);
    });

    test('playBismillah for reciter with integrated Bismillah (Parhizgar) plays verse 1', () async {
      await notifier.loadReciters();
      final parhizgar = notifier.currentState.availableReciters.firstWhere((r) => r.id == 'parhizgar');
      await notifier.selectReciter(parhizgar);

      await notifier.playBismillah(40, 85);

      expect(notifier.currentState.currentSurahId, 40);
      expect(notifier.currentState.currentVerseNumber, 1);
      expect(notifier.currentState.isBismillahActive(40), false);
      expect(notifier.currentState.isPlaying, true);
    });

    test('Starting Surah 40 with isSurahStart=true with Alafasy plays verse 0 (Bismillah)', () async {
      await notifier.loadReciters();
      final alafasy = notifier.currentState.availableReciters.firstWhere((r) => r.id == 'alafasy');
      await notifier.selectReciter(alafasy);

      await notifier.playVerse(40, 1, 85, isSurahStart: true);

      expect(notifier.currentState.currentSurahId, 40);
      expect(notifier.currentState.currentVerseNumber, 0);
      expect(notifier.currentState.isBismillahActive(40), true);
    });

    test('Surah 9 (At-Tawbah) never plays verse 0 even with isSurahStart=true', () async {
      await notifier.loadReciters();
      final alafasy = notifier.currentState.availableReciters.firstWhere((r) => r.id == 'alafasy');
      await notifier.selectReciter(alafasy);

      await notifier.playVerse(9, 1, 129, isSurahStart: true);

      expect(notifier.currentState.currentSurahId, 9);
      expect(notifier.currentState.currentVerseNumber, 1);
      expect(notifier.currentState.isBismillahActive(9), false);
    });

    test('Switching reciter from Alafasy to Parhizgar while Bismillah is active falls back safely to verse 1', () async {
      await notifier.loadReciters();
      final alafasy = notifier.currentState.availableReciters.firstWhere((r) => r.id == 'alafasy');
      final parhizgar = notifier.currentState.availableReciters.firstWhere((r) => r.id == 'parhizgar');
      await notifier.selectReciter(alafasy);

      await notifier.playBismillah(40, 85);
      expect(notifier.currentState.currentVerseNumber, 0);

      await notifier.selectReciter(parhizgar);
      expect(notifier.currentState.currentReciter?.id, 'parhizgar');
      expect(notifier.currentState.currentVerseNumber, 1);
    });
  });
}

