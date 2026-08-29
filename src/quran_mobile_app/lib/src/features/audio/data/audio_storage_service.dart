import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class AudioStorageService {
  Directory? _cacheBaseDir;

  AudioStorageService({Directory? customBaseDir}) : _cacheBaseDir = customBaseDir;

  Future<Directory> _getBaseDirectory() async {
    if (_cacheBaseDir != null) {
      return _cacheBaseDir!;
    }
    final appDocs = await getApplicationDocumentsDirectory();
    final cacheDir = Directory(p.join(appDocs.path, 'audio_cache'));
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    _cacheBaseDir = cacheDir;
    return cacheDir;
  }

  Future<File> getAyahFile(String reciterId, int surahId, int verseId) async {
    final base = await _getBaseDirectory();
    final s = surahId.toString().padLeft(3, '0');
    final v = verseId.toString().padLeft(3, '0');
    final dir = Directory(p.join(base.path, reciterId, s));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return File(p.join(dir.path, '$s$v.mp3'));
  }

  Future<String?> getLocalAyahAudioPath(String reciterId, int surahId, int verseId) async {
    try {
      final file = await getAyahFile(reciterId, surahId, verseId);
      if (await file.exists()) {
        final len = await file.length();
        if (len > 1024) {
          // Valid audio file (larger than 1KB)
          return file.path;
        }
      }
    } catch (_) {}
    return null;
  }

  Future<bool> isSurahDownloaded(String reciterId, int surahId, int totalVerses) async {
    if (totalVerses <= 0) return false;
    for (int v = 1; v <= totalVerses; v++) {
      final path = await getLocalAyahAudioPath(reciterId, surahId, v);
      if (path == null) {
        return false;
      }
    }
    return true;
  }

  Future<int> getSurahDownloadedVerseCount(String reciterId, int surahId, int totalVerses) async {
    int count = 0;
    for (int v = 1; v <= totalVerses; v++) {
      final path = await getLocalAyahAudioPath(reciterId, surahId, v);
      if (path != null) {
        count++;
      }
    }
    return count;
  }

  Future<int> getTotalAudioCacheSizeBytes() async {
    try {
      final base = await _getBaseDirectory();
      if (!await base.exists()) return 0;
      int totalBytes = 0;
      await for (final entity in base.list(recursive: true, followLinks: false)) {
        if (entity is File) {
          totalBytes += await entity.length();
        }
      }
      return totalBytes;
    } catch (_) {
      return 0;
    }
  }

  String formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    var i = 0;
    double count = bytes.toDouble();
    while (count >= 1024 && i < suffixes.length - 1) {
      count /= 1024;
      i++;
    }
    return '${count.toStringAsFixed(1)} ${suffixes[i]}';
  }

  Future<void> deleteSurahAudio(String reciterId, int surahId) async {
    try {
      final base = await _getBaseDirectory();
      final s = surahId.toString().padLeft(3, '0');
      final dir = Directory(p.join(base.path, reciterId, s));
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    } catch (_) {}
  }

  Future<void> clearAllAudioCache() async {
    try {
      final base = await _getBaseDirectory();
      if (await base.exists()) {
        await for (final entity in base.list()) {
          if (entity is Directory) {
            await entity.delete(recursive: true);
          } else if (entity is File) {
            await entity.delete();
          }
        }
      }
    } catch (_) {}
  }
}

final audioStorageServiceProvider = Provider<AudioStorageService>((ref) {
  return AudioStorageService();
});
