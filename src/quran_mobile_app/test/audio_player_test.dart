import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile_app/src/features/audio/data/audio_repository.dart';
import 'package:quran_mobile_app/src/features/audio/presentation/audio_player_notifier.dart';

class FakeAudioPlayer implements AudioPlayer {
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
    ),
    Reciter(
      id: 'alafasy',
      nameArabic: 'مشاري راشد العفاسي',
      namePersian: 'مشاری راشد العفاسی',
      nameEnglish: 'Mishary Rashid Alafasy',
      style: 'Murattal',
      baseUrl: 'https://everyayah.com/data/Alafasy_128kbps/',
    ),
    Reciter(
      id: 'husary',
      nameArabic: 'محمود خليل الحصري',
      namePersian: 'محمود خلیل الحصری',
      nameEnglish: 'Mahmoud Khalil Al-Husary',
      style: 'Murattal',
      baseUrl: 'https://everyayah.com/data/Husary_128kbps/',
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
  });
}
