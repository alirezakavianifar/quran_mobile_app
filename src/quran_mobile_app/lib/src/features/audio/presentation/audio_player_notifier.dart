import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/settings/settings_provider.dart';
import '../data/audio_repository.dart';

class AudioPlayerState {
  final Reciter? currentReciter;
  final int? currentSurahId;
  final int? currentVerseNumber;
  final int? totalVersesInSurah;
  final bool isPlaying;
  final bool isLoading;
  final Duration position;
  final Duration duration;
  final List<Reciter> availableReciters;
  final bool autoPlayNext;
  final double playbackSpeed;
  final String? errorMessage;

  AudioPlayerState({
    this.currentReciter,
    this.currentSurahId,
    this.currentVerseNumber,
    this.totalVersesInSurah,
    this.isPlaying = false,
    this.isLoading = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.availableReciters = const [],
    this.autoPlayNext = true,
    this.playbackSpeed = 1.0,
    this.errorMessage,
  });

  bool isVerseActive(int surahId, int verseNumber) {
    return currentSurahId == surahId && currentVerseNumber == verseNumber;
  }

static const Object _sentinel = Object();

  AudioPlayerState copyWith({
    Reciter? currentReciter,
    Object? currentSurahId = _sentinel,
    Object? currentVerseNumber = _sentinel,
    Object? totalVersesInSurah = _sentinel,
    bool? isPlaying,
    bool? isLoading,
    Duration? position,
    Duration? duration,
    List<Reciter>? availableReciters,
    bool? autoPlayNext,
    double? playbackSpeed,
    String? errorMessage,
  }) {
    return AudioPlayerState(
      currentReciter: currentReciter ?? this.currentReciter,
      currentSurahId: currentSurahId == _sentinel ? this.currentSurahId : currentSurahId as int?,
      currentVerseNumber: currentVerseNumber == _sentinel ? this.currentVerseNumber : currentVerseNumber as int?,
      totalVersesInSurah: totalVersesInSurah == _sentinel ? this.totalVersesInSurah : totalVersesInSurah as int?,
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      availableReciters: availableReciters ?? this.availableReciters,
      autoPlayNext: autoPlayNext ?? this.autoPlayNext,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      errorMessage: errorMessage,
    );
  }
}

class AudioPlayerNotifier extends StateNotifier<AudioPlayerState> {
  final AudioRepository _repository;
  final AudioPlayer _player;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _completeSubscription;

  AudioPlayerNotifier(this._repository, {AudioPlayer? player, double initialSpeed = 1.0})
      : _player = player ?? AudioPlayer(),
        super(AudioPlayerState(playbackSpeed: initialSpeed)) {
    _initPlayerListeners();
    loadReciters();
  }

  AudioPlayerState get currentState => state;

  void _initPlayerListeners() {
    _durationSubscription = _player.onDurationChanged.listen((duration) {
      state = state.copyWith(duration: duration);
    });

    _positionSubscription = _player.onPositionChanged.listen((position) {
      state = state.copyWith(position: position);
    });

    _playerStateSubscription = _player.onPlayerStateChanged.listen((playerState) {
      final playing = playerState == PlayerState.playing;
      state = state.copyWith(
        isPlaying: playing,
        isLoading: false,
      );
    });

    _completeSubscription = _player.onPlayerComplete.listen((_) {
      _onAudioCompleted();
    });
  }

  Future<void> loadReciters() async {
    final reciters = await _repository.fetchReciters();
    final defaultReciter = reciters.isNotEmpty ? reciters.first : null;
    state = state.copyWith(
      availableReciters: reciters,
      currentReciter: state.currentReciter ?? defaultReciter,
    );
  }

  Future<void> setPlaybackSpeed(double speed) async {
    state = state.copyWith(playbackSpeed: speed);
    try {
      await _player.setPlaybackRate(speed);
    } catch (_) {}
  }

  Future<void> playVerse(int surahId, int verseNumber, int totalVerses) async {
    if (state.currentReciter == null) {
      await loadReciters();
    }

    final reciter = state.currentReciter;
    if (reciter == null) {
      state = state.copyWith(errorMessage: 'No reciters available.');
      return;
    }

    // If tapping the currently playing verse, toggle pause/play
    if (state.isVerseActive(surahId, verseNumber)) {
      if (state.isPlaying) {
        await pause();
      } else {
        await resume();
      }
      return;
    }

    state = state.copyWith(
      isLoading: true,
      currentSurahId: surahId,
      currentVerseNumber: verseNumber,
      totalVersesInSurah: totalVerses,
      position: Duration.zero,
      duration: Duration.zero,
    );

    try {
      final audioUrl = await _repository.getAyahAudioUrl(reciter.id, surahId, verseNumber);
      if (audioUrl.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Audio URL not found.',
        );
        return;
      }

      await _player.stop();
      await _player.play(UrlSource(audioUrl));
      try {
        await _player.setPlaybackRate(state.playbackSpeed);
      } catch (_) {}
      state = state.copyWith(isLoading: false, isPlaying: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isPlaying: false,
        errorMessage: 'Failed to play audio: $e',
      );
    }
  }

  Future<void> pause() async {
    await _player.pause();
    state = state.copyWith(isPlaying: false);
  }

  Future<void> resume() async {
    await _player.resume();
    state = state.copyWith(isPlaying: true);
  }

  Future<void> stop() async {
    await _player.stop();
    state = state.copyWith(
      isPlaying: false,
      isLoading: false,
      currentSurahId: null,
      currentVerseNumber: null,
      position: Duration.zero,
      duration: Duration.zero,
    );
  }

  Future<void> seek(Duration newPosition) async {
    await _player.seek(newPosition);
    state = state.copyWith(position: newPosition);
  }

  Future<void> selectReciter(Reciter reciter) async {
    state = state.copyWith(currentReciter: reciter);

    // If currently playing/active, switch stream to new reciter immediately
    if (state.currentSurahId != null && state.currentVerseNumber != null) {
      final sId = state.currentSurahId!;
      final vNum = state.currentVerseNumber!;
      final totalV = state.totalVersesInSurah ?? vNum;
      
      // Stop active player state completely before switching
      await _player.stop();
      state = state.copyWith(currentSurahId: null, currentVerseNumber: null);
      await playVerse(sId, vNum, totalV);
    }
  }

  void toggleAutoPlayNext() {
    state = state.copyWith(autoPlayNext: !state.autoPlayNext);
  }

  Future<void> _onAudioCompleted() async {
    if (state.autoPlayNext &&
        state.currentSurahId != null &&
        state.currentVerseNumber != null &&
        state.totalVersesInSurah != null &&
        state.currentVerseNumber! < state.totalVersesInSurah!) {
      final nextVerse = state.currentVerseNumber! + 1;
      final surahId = state.currentSurahId!;
      final totalVerses = state.totalVersesInSurah!;

      // Reset verse state to trigger play on next verse
      state = state.copyWith(currentSurahId: null, currentVerseNumber: null);
      await playVerse(surahId, nextVerse, totalVerses);
    } else {
      await stop();
    }
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _completeSubscription?.cancel();
    _player.dispose();
    super.dispose();
  }
}

final audioPlayerProvider =
    StateNotifierProvider<AudioPlayerNotifier, AudioPlayerState>((ref) {
  final repository = ref.watch(audioRepositoryProvider);
  final initialSpeed = ref.watch(settingsProvider.select((s) => s.playbackSpeed));
  return AudioPlayerNotifier(repository, initialSpeed: initialSpeed);
});

