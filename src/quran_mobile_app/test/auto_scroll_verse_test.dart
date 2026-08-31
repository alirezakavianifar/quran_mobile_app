import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_mobile_app/src/core/settings/models/user_settings.dart';
import 'package:quran_mobile_app/src/core/settings/settings_provider.dart';
import 'package:quran_mobile_app/src/core/settings/settings_repository.dart';
import 'package:quran_mobile_app/src/features/audio/presentation/audio_player_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Auto-Scroll Active Verse & Settings Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('autoScrollAudio setting defaults to true', () {
      const settings = UserSettings();
      expect(settings.autoScrollAudio, isTrue);
    });

    test('updateAutoScrollAudio toggles state correctly in SettingsNotifier', () async {
      final repo = SettingsRepository();
      final notifier = SettingsNotifier(repo);
      await Future<void>.delayed(Duration.zero);

      expect(notifier.state.autoScrollAudio, isTrue);

      await notifier.updateAutoScrollAudio(false);
      expect(notifier.state.autoScrollAudio, isFalse);

      await notifier.updateAutoScrollAudio(true);
      expect(notifier.state.autoScrollAudio, isTrue);
    });

    test('AudioPlayerState matches active verse only when surah and verse align', () {
      final state = AudioPlayerState(
        currentSurahId: 1,
        currentVerseNumber: 3,
        isPlaying: true,
      );

      expect(state.isVerseActive(1, 3), isTrue);
      expect(state.isVerseActive(1, 4), isFalse);
      expect(state.isVerseActive(2, 3), isFalse);
    });

    test('AudioPlayerState handles transition to next verse', () {
      var state = AudioPlayerState(
        currentSurahId: 18,
        currentVerseNumber: 1,
        isPlaying: true,
      );

      expect(state.currentVerseNumber, 1);
      expect(state.isVerseActive(18, 1), isTrue);

      state = state.copyWith(currentVerseNumber: 2);
      expect(state.currentVerseNumber, 2);
      expect(state.isVerseActive(18, 1), isFalse);
      expect(state.isVerseActive(18, 2), isTrue);
    });

    test('copyWith properly updates state for different surah or stops', () {
      final state = AudioPlayerState(
        currentSurahId: 114,
        currentVerseNumber: 6,
        isPlaying: true,
      );

      final stoppedState = state.copyWith(
        isPlaying: false,
        currentVerseNumber: null,
        currentSurahId: null,
      );

      expect(stoppedState.isPlaying, isFalse);
      expect(stoppedState.currentVerseNumber, isNull);
      expect(stoppedState.currentSurahId, isNull);
      expect(stoppedState.isVerseActive(114, 6), isFalse);
    });
  });
}
