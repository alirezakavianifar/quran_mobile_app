import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/hifz_mode_model.dart';

class HifzNotifier extends StateNotifier<HifzState> {
  HifzNotifier() : super(const HifzState());

  void toggleHifzMode() {
    state = state.copyWith(
      isEnabled: !state.isEnabled,
      revealedWords: {},
      revealedVerses: {},
    );
  }

  void setMaskMode(HifzMaskMode mode) {
    state = state.copyWith(
      maskMode: mode,
      revealedWords: {},
      revealedVerses: {},
    );
  }

  void toggleWordReveal(int surahNumber, int verseNumber, int wordIndex) {
    final key = '${surahNumber}_${verseNumber}_$wordIndex';
    final updated = Set<String>.from(state.revealedWords);
    if (updated.contains(key)) {
      updated.remove(key);
    } else {
      updated.add(key);
    }
    state = state.copyWith(revealedWords: updated);
  }

  void toggleVerseReveal(int surahNumber, int verseNumber) {
    final key = '${surahNumber}_$verseNumber';
    final updated = Set<String>.from(state.revealedVerses);
    if (updated.contains(key)) {
      updated.remove(key);
    } else {
      updated.add(key);
    }
    state = state.copyWith(revealedVerses: updated);
  }

  void revealAllInSurah(int surahNumber, int totalVerses) {
    final updated = Set<String>.from(state.revealedVerses);
    for (int i = 1; i <= totalVerses; i++) {
      updated.add('${surahNumber}_$i');
    }
    state = state.copyWith(revealedVerses: updated);
  }

  void maskAllInSurah() {
    state = state.copyWith(
      revealedWords: {},
      revealedVerses: {},
    );
  }
}

final hifzProvider = StateNotifierProvider<HifzNotifier, HifzState>((ref) {
  return HifzNotifier();
});
