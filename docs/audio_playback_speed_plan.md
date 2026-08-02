# Audio Playback Speed Control Implementation Plan

Enable users to adjust the audio playback speed (e.g., 0.5x, 0.75x, 1.0x, 1.25x, 1.5x, 2.0x) while listening to verse recitations.

## Proposed Changes

### Audio Feature

#### [MODIFY] [audio_player_notifier.dart](file:///e:/projects/quran_mobile_app/src/quran_mobile_app/lib/src/features/audio/presentation/audio_player_notifier.dart)
- Add `playbackSpeed` (default `1.0`) to `AudioPlayerState` and update `copyWith()`.
- Add `setPlaybackSpeed(double speed)` to `AudioPlayerNotifier` to update state and set rate on `AudioPlayer` via `_player.setPlaybackRate(speed)`.
- Apply `_player.setPlaybackRate(state.playbackSpeed)` whenever playing a verse audio URL in `playVerse()`.

#### [MODIFY] [audio_player_bottom_bar.dart](file:///e:/projects/quran_mobile_app/src/quran_mobile_app/lib/src/features/audio/presentation/audio_player_bottom_bar.dart)
- Add a speed selector button in `AudioPlayerBottomBar` displaying the active speed badge (e.g., `1.0x`, `1.25x`).
- Open a PopupMenu / Modal with speed options (`0.5x`, `0.75x`, `1.0x`, `1.25x`, `1.5x`, `2.0x`).
- Wire the selection to update the active audio player speed and sync with user settings `SettingsNotifier.updatePlaybackSpeed`.

### Tests

#### [MODIFY] [audio_player_test.dart](file:///e:/projects/quran_mobile_app/src/quran_mobile_app/test/audio_player_test.dart)
- Add `setPlaybackRate` method to `FakeAudioPlayer`.
- Add unit tests for changing playback speed in `AudioPlayerNotifier`.

## Verification Plan

### Automated Tests
- Run `flutter test test/audio_player_test.dart` to verify unit test passing.

### Manual Verification
- Test playing verse audio and changing speed through the speed selector in `AudioPlayerBottomBar`.
