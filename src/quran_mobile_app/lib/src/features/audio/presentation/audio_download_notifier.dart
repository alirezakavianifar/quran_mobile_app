import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/audio_repository.dart';
import '../data/audio_storage_service.dart';

enum DownloadStatus { idle, downloading, completed, error, cancelled }

class SurahDownloadState {
  final String reciterId;
  final int surahId;
  final int totalVerses;
  final int downloadedVerses;
  final DownloadStatus status;
  final String? errorMessage;

  const SurahDownloadState({
    required this.reciterId,
    required this.surahId,
    required this.totalVerses,
    this.downloadedVerses = 0,
    this.status = DownloadStatus.idle,
    this.errorMessage,
  });

  double get progressRatio =>
      totalVerses > 0 ? (downloadedVerses / totalVerses).clamp(0.0, 1.0) : 0.0;

  bool get isDownloading => status == DownloadStatus.downloading;
  bool get isCompleted => status == DownloadStatus.completed;

  SurahDownloadState copyWith({
    String? reciterId,
    int? surahId,
    int? totalVerses,
    int? downloadedVerses,
    DownloadStatus? status,
    String? errorMessage,
  }) {
    return SurahDownloadState(
      reciterId: reciterId ?? this.reciterId,
      surahId: surahId ?? this.surahId,
      totalVerses: totalVerses ?? this.totalVerses,
      downloadedVerses: downloadedVerses ?? this.downloadedVerses,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

class AudioDownloadNotifier extends StateNotifier<Map<String, SurahDownloadState>> {
  final AudioRepository _repository;
  final AudioStorageService _storageService;
  final Dio _dio;
  final Map<String, CancelToken> _cancelTokens = {};

  AudioDownloadNotifier(this._repository, this._storageService, {Dio? dio})
      : _dio = dio ?? Dio(),
        super({});

  String _getKey(String reciterId, int surahId) => '${reciterId}_$surahId';

  SurahDownloadState getSurahState(String reciterId, int surahId, int totalVerses) {
    final key = _getKey(reciterId, surahId);
    return state[key] ??
        SurahDownloadState(
          reciterId: reciterId,
          surahId: surahId,
          totalVerses: totalVerses,
        );
  }

  Future<void> checkSurahStatus(String reciterId, int surahId, int totalVerses) async {
    final key = _getKey(reciterId, surahId);
    // Don't overwrite if currently actively downloading
    if (state[key]?.isDownloading == true) return;

    final isDownloaded = await _storageService.isSurahDownloaded(reciterId, surahId, totalVerses);
    final count = await _storageService.getSurahDownloadedVerseCount(reciterId, surahId, totalVerses);

    state = {
      ...state,
      key: SurahDownloadState(
        reciterId: reciterId,
        surahId: surahId,
        totalVerses: totalVerses,
        downloadedVerses: count,
        status: isDownloaded ? DownloadStatus.completed : DownloadStatus.idle,
      ),
    };
  }

  Future<void> downloadSurah(String reciterId, int surahId, int totalVerses) async {
    final key = _getKey(reciterId, surahId);
    if (state[key]?.isDownloading == true) return;

    final cancelToken = CancelToken();
    _cancelTokens[key] = cancelToken;

    int initialCount = await _storageService.getSurahDownloadedVerseCount(reciterId, surahId, totalVerses);

    state = {
      ...state,
      key: SurahDownloadState(
        reciterId: reciterId,
        surahId: surahId,
        totalVerses: totalVerses,
        downloadedVerses: initialCount,
        status: DownloadStatus.downloading,
      ),
    };

    try {
      for (int v = 1; v <= totalVerses; v++) {
        if (cancelToken.isCancelled) {
          state = {
            ...state,
            key: state[key]!.copyWith(status: DownloadStatus.cancelled),
          };
          return;
        }

        final existing = await _storageService.getLocalAyahAudioPath(reciterId, surahId, v);
        if (existing == null) {
          final audioUrl = await _repository.getAyahAudioUrl(reciterId, surahId, v);
          if (audioUrl.isEmpty) {
            throw Exception('Audio URL not available for Ayah $v');
          }

          final targetFile = await _storageService.getAyahFile(reciterId, surahId, v);
          await _dio.download(
            audioUrl,
            targetFile.path,
            cancelToken: cancelToken,
          );
        }

        final currentDownloaded = await _storageService.getSurahDownloadedVerseCount(reciterId, surahId, totalVerses);
        state = {
          ...state,
          key: state[key]!.copyWith(
            downloadedVerses: currentDownloaded,
            status: DownloadStatus.downloading,
          ),
        };
      }

      state = {
        ...state,
        key: state[key]!.copyWith(
          downloadedVerses: totalVerses,
          status: DownloadStatus.completed,
        ),
      };
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        state = {
          ...state,
          key: state[key]!.copyWith(status: DownloadStatus.cancelled),
        };
      } else {
        state = {
          ...state,
          key: state[key]!.copyWith(
            status: DownloadStatus.error,
            errorMessage: 'Download failed: ${e.message}',
          ),
        };
      }
    } catch (e) {
      state = {
        ...state,
        key: state[key]!.copyWith(
          status: DownloadStatus.error,
          errorMessage: 'Download failed: $e',
        ),
      };
    } finally {
      _cancelTokens.remove(key);
    }
  }

  void cancelDownload(String reciterId, int surahId) {
    final key = _getKey(reciterId, surahId);
    _cancelTokens[key]?.cancel('Cancelled by user');
    _cancelTokens.remove(key);
  }

  Future<void> deleteSurahDownload(String reciterId, int surahId, int totalVerses) async {
    cancelDownload(reciterId, surahId);
    await _storageService.deleteSurahAudio(reciterId, surahId);
    final key = _getKey(reciterId, surahId);
    state = {
      ...state,
      key: SurahDownloadState(
        reciterId: reciterId,
        surahId: surahId,
        totalVerses: totalVerses,
        downloadedVerses: 0,
        status: DownloadStatus.idle,
      ),
    };
  }
}

final audioDownloadProvider =
    StateNotifierProvider<AudioDownloadNotifier, Map<String, SurahDownloadState>>((ref) {
  final repository = ref.watch(audioRepositoryProvider);
  final storageService = ref.watch(audioStorageServiceProvider);
  return AudioDownloadNotifier(repository, storageService);
});
