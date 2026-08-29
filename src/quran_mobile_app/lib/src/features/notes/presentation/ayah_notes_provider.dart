import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/ayah_notes_repository.dart';
import '../models/ayah_note_model.dart';

class AyahNotesNotifier extends StateNotifier<Map<String, AyahNote>> {
  final AyahNotesRepository _repository;

  AyahNotesNotifier(this._repository) : super({}) {
    _init();
  }

  Future<void> _init() async {
    final notes = await _repository.loadNotes();
    state = notes;
  }

  AyahNote? getNote(int surahId, int verseNumber) {
    return state['${surahId}_$verseNumber'];
  }

  Future<void> setHighlightColor(int surahId, int verseNumber, String? colorHex) async {
    final existing = getNote(surahId, verseNumber);
    final updated = existing != null
        ? existing.copyWith(
            colorHex: colorHex,
            clearColor: colorHex == null,
          )
        : AyahNote(
            surahId: surahId,
            verseNumber: verseNumber,
            colorHex: colorHex,
          );

    final newMap = Map<String, AyahNote>.from(state);
    if (updated.isEmpty) {
      newMap.remove(updated.key);
    } else {
      newMap[updated.key] = updated;
    }
    state = newMap;
    await _repository.saveNote(updated);
  }

  Future<void> saveAyahNote({
    required int surahId,
    required int verseNumber,
    String? noteText,
    String? colorHex,
  }) async {
    final existing = getNote(surahId, verseNumber);
    final updated = existing != null
        ? existing.copyWith(
            noteText: noteText,
            colorHex: colorHex ?? existing.colorHex,
            clearNote: noteText == null || noteText.trim().isEmpty,
          )
        : AyahNote(
            surahId: surahId,
            verseNumber: verseNumber,
            noteText: noteText,
            colorHex: colorHex,
          );

    final newMap = Map<String, AyahNote>.from(state);
    if (updated.isEmpty) {
      newMap.remove(updated.key);
    } else {
      newMap[updated.key] = updated;
    }
    state = newMap;
    await _repository.saveNote(updated);
  }

  Future<void> deleteNote(int surahId, int verseNumber) async {
    final key = '${surahId}_$verseNumber';
    final newMap = Map<String, AyahNote>.from(state)..remove(key);
    state = newMap;
    await _repository.deleteNote(surahId, verseNumber);
  }
}

final ayahNotesProvider =
    StateNotifierProvider<AyahNotesNotifier, Map<String, AyahNote>>((ref) {
  final repository = ref.watch(ayahNotesRepositoryProvider);
  return AyahNotesNotifier(repository);
});
