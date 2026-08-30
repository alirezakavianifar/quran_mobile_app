enum HifzMaskMode {
  fullMask, // All words masked behind clickable pills
  firstLetterOnly, // First letter shown as a hint
  translationPrompt, // Arabic masked, translation shown as prompt
}

class HifzState {
  final bool isEnabled;
  final HifzMaskMode maskMode;
  final Set<String> revealedWords;
  final Set<String> revealedVerses;

  const HifzState({
    this.isEnabled = false,
    this.maskMode = HifzMaskMode.fullMask,
    this.revealedWords = const {},
    this.revealedVerses = const {},
  });

  bool isWordRevealed(int surahNumber, int verseNumber, int wordIndex) {
    if (!isEnabled) return true;
    if (revealedVerses.contains('${surahNumber}_$verseNumber')) return true;
    return revealedWords.contains('${surahNumber}_${verseNumber}_$wordIndex');
  }

  bool isVerseRevealed(int surahNumber, int verseNumber) {
    if (!isEnabled) return true;
    return revealedVerses.contains('${surahNumber}_$verseNumber');
  }

  HifzState copyWith({
    bool? isEnabled,
    HifzMaskMode? maskMode,
    Set<String>? revealedWords,
    Set<String>? revealedVerses,
  }) {
    return HifzState(
      isEnabled: isEnabled ?? this.isEnabled,
      maskMode: maskMode ?? this.maskMode,
      revealedWords: revealedWords ?? this.revealedWords,
      revealedVerses: revealedVerses ?? this.revealedVerses,
    );
  }
}
