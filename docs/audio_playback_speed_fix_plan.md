# Audio Playback Speed Fix Implementation Plan

Fix issue where changing audio playback speed disposes the audio player instance, causing audio playback to stop completely and requiring user to re-select audio.

## Problem Statement
`audioPlayerProvider` watches `settingsProvider.playbackSpeed` via `ref.watch(settingsProvider.select((s) => s.playbackSpeed))`. When `updatePlaybackSpeed` updates settings, Riverpod disposes the active `AudioPlayerNotifier` and its native `AudioPlayer` instance, causing active audio playback to terminate and state to reset.

## Proposed Changes

### Audio Feature

#### [MODIFY] [audio_player_notifier.dart](file:///e:/projects/quran_mobile_app/src/quran_mobile_app/lib/src/features/audio/presentation/audio_player_notifier.dart)
- Replace `ref.watch(settingsProvider.select((s) => s.playbackSpeed))` with `ref.read(settingsProvider).playbackSpeed` in `audioPlayerProvider` factory so `AudioPlayerNotifier` is not destroyed when settings update.
- Ensure `setPlaybackSpeed(speed)` dynamically updates the current `_player` rate in real-time.

### Tests

#### [MODIFY] [audio_player_test.dart](file:///e:/projects/quran_mobile_app/src/quran_mobile_app/test/audio_player_test.dart)
- Add test coverage verifying `audioPlayerProvider` behavior when speed settings update.

## Verification Plan

### Automated Tests
- Run `flutter test test/audio_player_test.dart`
- Run `flutter test` across all unit test suites.
