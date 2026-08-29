import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ayah_note_model.dart';

class AyahNotesRepository {
  static const String _storageKey = 'quran_ayah_notes_and_highlights_v1';

  Future<Map<String, AyahNote>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_storageKey);
    if (jsonStr == null || jsonStr.isEmpty) return {};

    try {
      final Map<String, dynamic> decoded = json.decode(jsonStr) as Map<String, dynamic>;
      final result = <String, AyahNote>{};
      decoded.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          result[key] = AyahNote.fromMap(value);
        }
      });
      return result;
    } catch (_) {
      return {};
    }
  }

  Future<void> saveNote(AyahNote note) async {
    final prefs = await SharedPreferences.getInstance();
    final all = await loadNotes();
    if (note.isEmpty) {
      all.remove(note.key);
    } else {
      all[note.key] = note;
    }

    final rawMap = all.map((key, value) => MapEntry(key, value.toMap()));
    await prefs.setString(_storageKey, json.encode(rawMap));
  }

  Future<void> deleteNote(int surahId, int verseNumber) async {
    final key = '${surahId}_$verseNumber';
    final prefs = await SharedPreferences.getInstance();
    final all = await loadNotes();
    all.remove(key);

    final rawMap = all.map((k, v) => MapEntry(k, v.toMap()));
    await prefs.setString(_storageKey, json.encode(rawMap));
  }
}

final ayahNotesRepositoryProvider = Provider<AyahNotesRepository>((ref) {
  return AyahNotesRepository();
});
