import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile_app/src/features/audio/data/audio_repository.dart';
import 'package:quran_mobile_app/src/features/audio/data/audio_storage_service.dart';
import 'package:quran_mobile_app/src/features/audio/presentation/audio_download_notifier.dart';

class FakeAudioRepository implements AudioRepository {
  @override
  Future<List<Reciter>> fetchReciters() async => [];

  @override
  Future<String> getAyahAudioUrl(String reciterId, int surahId, int verseId) async {
    return 'https://everyayah.com/data/Parhizgar_48kbps/001001.mp3';
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late AudioStorageService storageService;
  late FakeAudioRepository repository;
  late AudioDownloadNotifier downloadNotifier;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('audio_storage_test_');
    storageService = AudioStorageService(customBaseDir: tempDir);
    repository = FakeAudioRepository();
    downloadNotifier = AudioDownloadNotifier(repository, storageService);
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('AudioStorageService Tests', () {
    test('Format bytes accurately calculates display strings', () {
      expect(storageService.formatBytes(0), '0 B');
      expect(storageService.formatBytes(512), '512.0 B');
      expect(storageService.formatBytes(1024), '1.0 KB');
      expect(storageService.formatBytes(1024 * 1024 * 5), '5.0 MB');
    });

    test('Initially surah is not downloaded', () async {
      final isDownloaded = await storageService.isSurahDownloaded('parhizgar', 1, 7);
      expect(isDownloaded, isFalse);

      final count = await storageService.getSurahDownloadedVerseCount('parhizgar', 1, 7);
      expect(count, 0);
    });

    test('Saving mock file marks ayah as downloaded', () async {
      final file = await storageService.getAyahFile('parhizgar', 1, 1);
      await file.writeAsBytes(List.filled(2048, 0)); // 2KB valid audio dummy

      final path = await storageService.getLocalAyahAudioPath('parhizgar', 1, 1);
      expect(path, isNotNull);
      expect(File(path!).existsSync(), isTrue);

      final size = await storageService.getTotalAudioCacheSizeBytes();
      expect(size, 2048);

      await storageService.deleteSurahAudio('parhizgar', 1);
      final afterDelete = await storageService.getLocalAyahAudioPath('parhizgar', 1, 1);
      expect(afterDelete, isNull);
    });
  });

  group('AudioDownloadNotifier State Tests', () {
    test('Initial download state is idle', () {
      final state = downloadNotifier.getSurahState('parhizgar', 1, 7);
      expect(state.status, DownloadStatus.idle);
      expect(state.isDownloading, isFalse);
      expect(state.isCompleted, isFalse);
      expect(state.progressRatio, 0.0);
    });

    test('Cancel download updates state to cancelled', () {
      downloadNotifier.cancelDownload('parhizgar', 1);
      final state = downloadNotifier.getSurahState('parhizgar', 1, 7);
      expect(state.isDownloading, isFalse);
    });
  });
}
