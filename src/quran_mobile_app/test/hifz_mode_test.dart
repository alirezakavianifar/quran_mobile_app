import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile_app/src/features/hifz/models/hifz_mode_model.dart';
import 'package:quran_mobile_app/src/features/hifz/presentation/hifz_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Hifz Practice Mode Model & Notifier Tests', () {
    test('Initial state is disabled with fullMask default', () {
      final notifier = HifzNotifier();
      expect(notifier.state.isEnabled, isFalse);
      expect(notifier.state.maskMode, HifzMaskMode.fullMask);
      expect(notifier.state.revealedWords, isEmpty);
      expect(notifier.state.revealedVerses, isEmpty);
    });

    test('Toggling Hifz Mode enables and resets masks', () {
      final notifier = HifzNotifier();
      notifier.toggleHifzMode();
      expect(notifier.state.isEnabled, isTrue);

      // When Hifz is enabled, unrevealed words return false
      expect(notifier.state.isWordRevealed(1, 1, 0), isFalse);
      expect(notifier.state.isVerseRevealed(1, 1), isFalse);

      // Toggle word reveal
      notifier.toggleWordReveal(1, 1, 0);
      expect(notifier.state.isWordRevealed(1, 1, 0), isTrue);
      expect(notifier.state.isWordRevealed(1, 1, 1), isFalse);

      // Toggle verse reveal
      notifier.toggleVerseReveal(1, 1);
      expect(notifier.state.isVerseRevealed(1, 1), isTrue);
      expect(notifier.state.isWordRevealed(1, 1, 1), isTrue); // word in revealed verse is visible
    });

    test('revealAllInSurah and maskAllInSurah work accurately', () {
      final notifier = HifzNotifier();
      notifier.toggleHifzMode();

      notifier.revealAllInSurah(1, 7);
      expect(notifier.state.isVerseRevealed(1, 1), isTrue);
      expect(notifier.state.isVerseRevealed(1, 7), isTrue);

      notifier.maskAllInSurah();
      expect(notifier.state.isVerseRevealed(1, 1), isFalse);
      expect(notifier.state.isVerseRevealed(1, 7), isFalse);
    });

    test('setMaskMode updates mask style', () {
      final notifier = HifzNotifier();
      notifier.setMaskMode(HifzMaskMode.firstLetterOnly);
      expect(notifier.state.maskMode, HifzMaskMode.firstLetterOnly);

      notifier.setMaskMode(HifzMaskMode.translationPrompt);
      expect(notifier.state.maskMode, HifzMaskMode.translationPrompt);
    });
  });
}
