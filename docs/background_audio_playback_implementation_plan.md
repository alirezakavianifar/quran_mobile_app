# Implementation Plan - Background Audio Playback & Prevent Inactivity Stopping

Fix the issue where audio playback stops when the screen is locked, the app goes idle, or the user stops interacting with the app for a period of time.

## User Review Required

> [!IMPORTANT]
> To enable background audio playback on mobile devices (Android and iOS), native manifest/plist permissions and audio session context configurations must be updated. This will allow the audio engine to keep the CPU awake (`WAKE_LOCK`) and maintain active audio playback streams even when screen lock or app inactivity occurs.

## Proposed Changes

### Android Platform Configuration

#### [MODIFY] [AndroidManifest.xml](file:///e:/projects/quran_mobile_app/src/quran_mobile_app/android/app/src/main/AndroidManifest.xml)
- Add permissions:
  - `android.permission.WAKE_LOCK` (prevents CPU from entering deep sleep during playback)
  - `android.permission.FOREGROUND_SERVICE`
  - `android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK` (required for background media playback on modern Android versions)

---

### iOS Platform Configuration

#### [MODIFY] [Info.plist](file:///e:/projects/quran_mobile_app/src/quran_mobile_app/ios/Runner/Info.plist)
- Add `UIBackgroundModes` key with `audio` value to allow background audio playback sessions when the app is backgrounded or screen locks.

---

### Flutter Audio Player Configuration

#### [MODIFY] [audio_player_notifier.dart](file:///e:/projects/quran_mobile_app/src/quran_mobile_app/lib/src/features/audio/presentation/audio_player_notifier.dart)
- Configure global `AudioContext` for `AudioPlayer`:
  - Set `stayAwake: true`, `isHandleAudioBecomingNoisy: true`, `contentType: AndroidContentType.music`, `usageType: AndroidUsageType.media`, and `audioFocus: AndroidAudioFocus.gain` on Android.
  - Set `category: AVAudioSessionCategory.playback` on iOS.

---

## Verification Plan

### Automated Tests
- Run `flutter test` inside `e:/projects/quran_mobile_app/src/quran_mobile_app/` to ensure all audio player notifier tests pass without regressions.
