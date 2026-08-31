import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/last_read_model.dart';

class LastReadRepository {
  static const String _storageKey = 'quran_last_read_position_v1';

  Future<LastReadEntry?> getLastRead() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_storageKey);
      if (jsonStr == null || jsonStr.isEmpty) return null;
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return LastReadEntry.fromMap(map);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveLastRead(LastReadEntry entry) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, jsonEncode(entry.toMap()));
    } catch (_) {}
  }

  Future<void> clearLastRead() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
    } catch (_) {}
  }
}

class LastReadNotifier extends StateNotifier<LastReadEntry?> {
  final LastReadRepository _repository;

  LastReadNotifier(this._repository) : super(null) {
    loadLastRead();
  }

  Future<void> loadLastRead() async {
    final entry = await _repository.getLastRead();
    state = entry;
  }

  Future<void> recordLastRead({
    required int surahId,
    required int verseNumber,
    required int pageNumber,
    required int juzNumber,
    required String surahNameArabic,
    required String surahNamePersian,
    required String surahNameEnglish,
    String? verseTextPreview,
  }) async {
    // Avoid redundant writes if same surah and verse
    if (state?.surahId == surahId && state?.verseNumber == verseNumber) {
      return;
    }

    final entry = LastReadEntry(
      surahId: surahId,
      verseNumber: verseNumber,
      pageNumber: pageNumber,
      juzNumber: juzNumber,
      surahNameArabic: surahNameArabic,
      surahNamePersian: surahNamePersian,
      surahNameEnglish: surahNameEnglish,
      verseTextPreview: verseTextPreview,
      timestamp: DateTime.now(),
    );

    state = entry;
    await _repository.saveLastRead(entry);
  }

  Future<void> clearLastRead() async {
    state = null;
    await _repository.clearLastRead();
  }
}

final lastReadRepositoryProvider = Provider<LastReadRepository>((ref) {
  return LastReadRepository();
});

final lastReadProvider =
    StateNotifierProvider<LastReadNotifier, LastReadEntry?>((ref) {
  final repo = ref.watch(lastReadRepositoryProvider);
  return LastReadNotifier(repo);
});
