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
  Future<void> setPlaybackRate(double speed) async {}

  @override
  Future<void> setVolume(double volume) async {}

  @override
  Future<void> dispose() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeAudioRepository implements AudioRepository {
  @override
  Future<List<Reciter>> fetchReciters() async => const [];

  @override
  Future<String> getAyahAudioUrl(String reciterId, int surahId, int verseId) async => '';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Audio Sleep Timer Tests', () {
    test('startSleepTimer sets countdown and active flag', () {
      final repository = FakeAudioRepository();
      final player = FakeAudioPlayer();
      final notifier = AudioPlayerNotifier(repository, player: player);

      expect(notifier.state.isSleepTimerActive, isFalse);
      expect(notifier.state.sleepTimerRemaining, isNull);

      notifier.startSleepTimer(const Duration(minutes: 15));

      expect(notifier.state.isSleepTimerActive, isTrue);
      expect(notifier.state.sleepTimerRemaining, const Duration(minutes: 15));
      expect(notifier.state.isEndOfSurahSleepTimer, isFalse);

      notifier.cancelSleepTimer();

      expect(notifier.state.isSleepTimerActive, isFalse);
      expect(notifier.state.sleepTimerRemaining, isNull);
    });

    test('startEndOfSurahSleepTimer sets end-of-surah mode', () {
      final repository = FakeAudioRepository();
      final player = FakeAudioPlayer();
      final notifier = AudioPlayerNotifier(repository, player: player);

      notifier.startEndOfSurahSleepTimer();

      expect(notifier.state.isSleepTimerActive, isTrue);
      expect(notifier.state.isEndOfSurahSleepTimer, isTrue);
      expect(notifier.state.sleepTimerRemaining, isNull);

      notifier.cancelSleepTimer();

      expect(notifier.state.isSleepTimerActive, isFalse);
      expect(notifier.state.isEndOfSurahSleepTimer, isFalse);
    });
  });
}
