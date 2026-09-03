import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/settings/settings_provider.dart';
import '../data/audio_repository.dart';
import '../data/audio_storage_service.dart';
import '../data/quran_page_data.dart';

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
  final int verseRepeatCount; // 1, 2, 3, 5, 10, -1 (infinite)
  final int currentVersePlayCount; // 1-indexed count of how many times current verse has played
  final int? rangeStartVerse;
  final int? rangeEndVerse;
  final int rangeLoopCount; // 1, 2, 3, 5, 10, -1 (infinite)
  final int currentRangeCycle; // 1-indexed count of how many times range has looped
  final int? repeatPageNumber; // 1 to 604
  final List<PageVerseRef>? pageVerses; // all verses on the repeat page
  final int currentPageVerseIndex; // 0-indexed position within pageVerses
  final int pageLoopCount; // 1, 2, 3, 5, 10, -1 (infinite)
  final int currentPageCycle; // 1-indexed count of how many times page has looped
  final Duration? sleepTimerRemaining;
  final bool isEndOfSurahSleepTimer;
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
    this.verseRepeatCount = 1,
    this.currentVersePlayCount = 1,
    this.rangeStartVerse,
    this.rangeEndVerse,
    this.rangeLoopCount = 1,
    this.currentRangeCycle = 1,
    this.repeatPageNumber,
    this.pageVerses,
    this.currentPageVerseIndex = 0,
    this.pageLoopCount = 1,
    this.currentPageCycle = 1,
    this.sleepTimerRemaining,
    this.isEndOfSurahSleepTimer = false,
    this.errorMessage,
  });

  bool isVerseActive(int surahId, int verseNumber) {
    return currentSurahId == surahId && currentVerseNumber == verseNumber;
  }

  bool get isRangeRepeatActive =>
      rangeStartVerse != null &&
      rangeEndVerse != null &&
      rangeStartVerse! <= rangeEndVerse!;

  bool get isPageRepeatActive =>
      repeatPageNumber != null &&
      pageVerses != null &&
      pageVerses!.isNotEmpty;

  bool get isSleepTimerActive =>
      sleepTimerRemaining != null || isEndOfSurahSleepTimer;

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
    int? verseRepeatCount,
    int? currentVersePlayCount,
    Object? rangeStartVerse = _sentinel,
    Object? rangeEndVerse = _sentinel,
    int? rangeLoopCount,
    int? currentRangeCycle,
    Object? repeatPageNumber = _sentinel,
    Object? pageVerses = _sentinel,
    int? currentPageVerseIndex,
    int? pageLoopCount,
    int? currentPageCycle,
    Object? sleepTimerRemaining = _sentinel,
    bool? isEndOfSurahSleepTimer,
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
      verseRepeatCount: verseRepeatCount ?? this.verseRepeatCount,
      currentVersePlayCount: currentVersePlayCount ?? this.currentVersePlayCount,
      rangeStartVerse: rangeStartVerse == _sentinel ? this.rangeStartVerse : rangeStartVerse as int?,
      rangeEndVerse: rangeEndVerse == _sentinel ? this.rangeEndVerse : rangeEndVerse as int?,
      rangeLoopCount: rangeLoopCount ?? this.rangeLoopCount,
      currentRangeCycle: currentRangeCycle ?? this.currentRangeCycle,
      repeatPageNumber: repeatPageNumber == _sentinel ? this.repeatPageNumber : repeatPageNumber as int?,
      pageVerses: pageVerses == _sentinel ? this.pageVerses : pageVerses as List<PageVerseRef>?,
      currentPageVerseIndex: currentPageVerseIndex ?? this.currentPageVerseIndex,
      pageLoopCount: pageLoopCount ?? this.pageLoopCount,
      currentPageCycle: currentPageCycle ?? this.currentPageCycle,
      sleepTimerRemaining: sleepTimerRemaining == _sentinel
          ? this.sleepTimerRemaining
          : sleepTimerRemaining as Duration?,
      isEndOfSurahSleepTimer: isEndOfSurahSleepTimer ?? this.isEndOfSurahSleepTimer,
      errorMessage: errorMessage,
    );
  }
}

class AudioPlayerNotifier extends StateNotifier<AudioPlayerState> {
  final AudioRepository _repository;
  final AudioStorageService? _storageService;
  final AudioPlayer _player;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _completeSubscription;

  AudioPlayerNotifier(
    this._repository, {
    AudioStorageService? storageService,
    AudioPlayer? player,
    double initialSpeed = 1.0,
    int initialRepeatCount = 1,
  })  : _storageService = storageService,
        _player = player ?? AudioPlayer(),
        super(AudioPlayerState(
          playbackSpeed: initialSpeed,
          verseRepeatCount: initialRepeatCount,
        )) {
    _initAudioContext();
    _initPlayerListeners();
    loadReciters();
  }

  AudioPlayerState get currentState => state;

  void _initAudioContext() {
    try {
      AudioPlayer.global.setAudioContext(
        AudioContext(
          android: const AudioContextAndroid(
            stayAwake: true,
            contentType: AndroidContentType.music,
            usageType: AndroidUsageType.media,
            audioFocus: AndroidAudioFocus.gain,
          ),
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playback,
            options: const {
              AVAudioSessionOptions.defaultToSpeaker,
            },
          ),
        ),
      );
    } catch (_) {}
  }

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

  void setVerseRepeatCount(int count) {
    state = state.copyWith(verseRepeatCount: count);
  }

  Future<void> setVerseRange({
    required int surahId,
    required int startVerse,
    required int endVerse,
    required int totalVerses,
    int loopCount = 1,
    bool startPlaying = true,
  }) async {
    state = state.copyWith(
      rangeStartVerse: startVerse,
      rangeEndVerse: endVerse,
      rangeLoopCount: loopCount,
      currentRangeCycle: 1,
      currentVersePlayCount: 1,
      repeatPageNumber: null,
      pageVerses: null,
      currentPageVerseIndex: 0,
      pageLoopCount: 1,
      currentPageCycle: 1,
    );

    if (startPlaying) {
      await playVerse(surahId, startVerse, totalVerses);
    }
  }

  void clearVerseRange() {
    state = state.copyWith(
      rangeStartVerse: null,
      rangeEndVerse: null,
      rangeLoopCount: 1,
      currentRangeCycle: 1,
    );
  }

  Future<void> setPageRepeat({
    required int pageNumber,
    int loopCount = 1,
    bool startPlaying = true,
  }) async {
    final verses = QuranPageData.getVersesForPage(pageNumber);
    if (verses.isEmpty) return;

    state = state.copyWith(
      repeatPageNumber: pageNumber,
      pageVerses: verses,
      currentPageVerseIndex: 0,
      pageLoopCount: loopCount,
      currentPageCycle: 1,
      currentVersePlayCount: 1,
      rangeStartVerse: null,
      rangeEndVerse: null,
      rangeLoopCount: 1,
      currentRangeCycle: 1,
    );

    if (startPlaying) {
      final first = verses.first;
      await playVerse(first.surahId, first.verseNumber, first.totalVersesInSurah);
    }
  }

  void clearPageRepeat() {
    state = state.copyWith(
      repeatPageNumber: null,
      pageVerses: null,
      currentPageVerseIndex: 0,
      pageLoopCount: 1,
      currentPageCycle: 1,
    );
  }

  Future<void> playVerse(int surahId, int verseNumber, int totalVerses, {bool isReplay = false}) async {
    if (state.currentReciter == null) {
      await loadReciters();
    }

    final reciter = state.currentReciter;
    if (reciter == null) {
      state = state.copyWith(errorMessage: 'No reciters available.');
      return;
    }

    // If tapping the currently playing verse without it being a replay, toggle pause/play
    if (!isReplay && state.isVerseActive(surahId, verseNumber)) {
      if (state.isPlaying) {
        await pause();
      } else {
        await resume();
      }
      return;
    }

    int? updatedPageIndex;
    if (state.isPageRepeatActive && state.pageVerses != null) {
      final idx = state.pageVerses!.indexWhere(
        (v) => v.surahId == surahId && v.verseNumber == verseNumber,
      );
      if (idx != -1) {
        updatedPageIndex = idx;
      }
    }

    state = state.copyWith(
      isLoading: true,
      currentSurahId: surahId,
      currentVerseNumber: verseNumber,
      totalVersesInSurah: totalVerses,
      currentVersePlayCount: isReplay ? state.currentVersePlayCount : 1,
      currentPageVerseIndex: updatedPageIndex ?? state.currentPageVerseIndex,
      position: Duration.zero,
      duration: Duration.zero,
    );

    try {
      Source source;
      final localPath = await _storageService?.getLocalAyahAudioPath(reciter.id, surahId, verseNumber);
      if (localPath != null) {
        source = DeviceFileSource(localPath);
      } else {
        final audioUrl = await _repository.getAyahAudioUrl(reciter.id, surahId, verseNumber);
        if (audioUrl.isEmpty) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: 'Audio URL not found.',
          );
          return;
        }
        source = UrlSource(audioUrl);
      }

      await _player.stop();
      await _player.play(source);
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
      currentVersePlayCount: 1,
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
    if (state.currentSurahId == null || state.currentVerseNumber == null) {
      await stop();
      return;
    }

    final surahId = state.currentSurahId!;
    final verseNum = state.currentVerseNumber!;
    final totalVerses = state.totalVersesInSurah ?? verseNum;

    // 1. Check per-verse repeat logic
    if (state.verseRepeatCount == -1) {
      // Infinite Loop on current verse
      await _replayVerse(surahId, verseNum, totalVerses);
      return;
    } else if (state.currentVersePlayCount < state.verseRepeatCount) {
      // Repeat current verse again
      state = state.copyWith(currentVersePlayCount: state.currentVersePlayCount + 1);
      await _replayVerse(surahId, verseNum, totalVerses);
      return;
    }

    // Finished repeats for this verse
    state = state.copyWith(currentVersePlayCount: 1);

    // 2. Check Page Repeat logic
    if (state.isPageRepeatActive) {
      final pageVerses = state.pageVerses!;
      final currentIndex = state.currentPageVerseIndex;

      if (currentIndex + 1 < pageVerses.length) {
        final nextIndex = currentIndex + 1;
        final nextItem = pageVerses[nextIndex];
        state = state.copyWith(
          currentPageVerseIndex: nextIndex,
          currentSurahId: null,
          currentVerseNumber: null,
        );
        await playVerse(nextItem.surahId, nextItem.verseNumber, nextItem.totalVersesInSurah);
      } else {
        // Reached end of page
        if (state.pageLoopCount == -1) {
          // Infinite page loop
          final firstItem = pageVerses.first;
          state = state.copyWith(
            currentPageCycle: state.currentPageCycle + 1,
            currentPageVerseIndex: 0,
            currentSurahId: null,
            currentVerseNumber: null,
          );
          await playVerse(firstItem.surahId, firstItem.verseNumber, firstItem.totalVersesInSurah);
        } else if (state.currentPageCycle < state.pageLoopCount) {
          final firstItem = pageVerses.first;
          state = state.copyWith(
            currentPageCycle: state.currentPageCycle + 1,
            currentPageVerseIndex: 0,
            currentSurahId: null,
            currentVerseNumber: null,
          );
          await playVerse(firstItem.surahId, firstItem.verseNumber, firstItem.totalVersesInSurah);
        } else {
          // Finished all page cycles
          await stop();
        }
      }
      return;
    }

    // 3. Check Range Repeat logic
    if (state.isRangeRepeatActive) {
      final rangeStart = state.rangeStartVerse!;
      final rangeEnd = state.rangeEndVerse!;

      if (verseNum < rangeEnd) {
        final nextVerse = verseNum + 1;
        state = state.copyWith(currentSurahId: null, currentVerseNumber: null);
        await playVerse(surahId, nextVerse, totalVerses);
      } else {
        // Reached end of range
        if (state.rangeLoopCount == -1) {
          // Infinite range loop
          state = state.copyWith(
            currentRangeCycle: state.currentRangeCycle + 1,
            currentSurahId: null,
            currentVerseNumber: null,
          );
          await playVerse(surahId, rangeStart, totalVerses);
        } else if (state.currentRangeCycle < state.rangeLoopCount) {
          state = state.copyWith(
            currentRangeCycle: state.currentRangeCycle + 1,
            currentSurahId: null,
            currentVerseNumber: null,
          );
          await playVerse(surahId, rangeStart, totalVerses);
        } else {
          // Finished all range cycles
          await stop();
        }
      }
      return;
    }

    // 3. Standard autoPlayNext logic
    if (state.isEndOfSurahSleepTimer && verseNum >= totalVerses) {
      await stop();
      cancelSleepTimer();
      return;
    }

    if (state.autoPlayNext && verseNum < totalVerses) {
      final nextVerse = verseNum + 1;
      state = state.copyWith(currentSurahId: null, currentVerseNumber: null);
      await playVerse(surahId, nextVerse, totalVerses);
    } else {
      await stop();
    }
  }

  Timer? _sleepTimer;

  void startSleepTimer(Duration duration) {
    cancelSleepTimer();
    state = state.copyWith(
      sleepTimerRemaining: duration,
      isEndOfSurahSleepTimer: false,
    );

    _sleepTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final current = state.sleepTimerRemaining;
      if (current == null || current.inSeconds <= 1) {
        try {
          await _player.setVolume(1.0);
        } catch (_) {}
        await pause();
        cancelSleepTimer();
      } else {
        final remainingSec = current.inSeconds - 1;
        if (remainingSec <= 15) {
          try {
            final volume = (remainingSec / 15.0).clamp(0.0, 1.0);
            await _player.setVolume(volume);
          } catch (_) {}
        }
        state = state.copyWith(sleepTimerRemaining: Duration(seconds: remainingSec));
      }
    });
  }

  void startEndOfSurahSleepTimer() {
    cancelSleepTimer();
    state = state.copyWith(
      isEndOfSurahSleepTimer: true,
      sleepTimerRemaining: null,
    );
  }

  void cancelSleepTimer() {
    _sleepTimer?.cancel();
    _sleepTimer = null;
    try {
      _player.setVolume(1.0);
    } catch (_) {}
    state = state.copyWith(
      sleepTimerRemaining: null,
      isEndOfSurahSleepTimer: false,
    );
  }

  Future<void> _replayVerse(int surahId, int verseNumber, int totalVerses) async {
    final reciter = state.currentReciter;
    if (reciter == null) {
      await stop();
      return;
    }

    state = state.copyWith(
      isLoading: true,
      position: Duration.zero,
    );

    try {
      Source source;
      final localPath = await _storageService?.getLocalAyahAudioPath(reciter.id, surahId, verseNumber);
      if (localPath != null) {
        source = DeviceFileSource(localPath);
      } else {
        final audioUrl = await _repository.getAyahAudioUrl(reciter.id, surahId, verseNumber);
        if (audioUrl.isEmpty) {
          await stop();
          return;
        }
        source = UrlSource(audioUrl);
      }

      await _player.stop();
      await _player.play(source);
      try {
        await _player.setPlaybackRate(state.playbackSpeed);
      } catch (_) {}
      state = state.copyWith(isLoading: false, isPlaying: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isPlaying: false,
        errorMessage: 'Failed to replay audio: $e',
      );
    }
  }

  @override
  void dispose() {
    _sleepTimer?.cancel();
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
  final storageService = ref.watch(audioStorageServiceProvider);
  final userSettings = ref.watch(settingsProvider);
  return AudioPlayerNotifier(
    repository,
    storageService: storageService,
    initialSpeed: userSettings.playbackSpeed,
    initialRepeatCount: userSettings.defaultVerseRepeatCount,
  );
});


