# Implementation Plan - Surah Recitation & Audio Playback

Implement full audio recitation support for Surahs and Ayahs in the Flutter Quran Mobile App, integrating with the ASP.NET Core backend audio service and EveryAyah audio CDNs.

## User Review Required

> [!IMPORTANT]
> Audio playback requires adding the `audioplayers` package to `pubspec.yaml` and updating Flutter dependencies.
> Web audio policies in modern browsers require an initial user gesture (tapping Play) before playing media audio streams.

## Open Questions

> [!NOTE]
> None at this time. The plan provides full verse-by-verse recitation playback with automatic queueing of consecutive verses within a Surah.

## Proposed Changes

---

### Flutter Mobile App (`src/quran_mobile_app`)

#### [MODIFY] [pubspec.yaml](file:///e:/projects/quran_mobile_app/src/quran_mobile_app/pubspec.yaml)
- Add `audioplayers: ^6.0.0` dependency for cross-platform (Android, iOS, Web, Desktop) audio streaming.

#### [NEW] [audio_player_notifier.dart](file:///e:/projects/quran_mobile_app/src/quran_mobile_app/lib/src/features/audio/presentation/audio_player_notifier.dart)
- Create Riverpod `StateNotifier` for managing player state:
  - `AudioPlayerState` (current reciter, active surah & verse, playing/paused/loading status, duration & position).
  - Methods: `playVerse(int surahId, int verseNumber, List<int> totalVerses)`, `playSurah(int surahId)`, `togglePlayPause()`, `stop()`, `selectReciter(Reciter reciter)`.
  - Listeners on audio completion to automatically trigger playback of the next Ayah in the Surah.

#### [NEW] [audio_player_bottom_bar.dart](file:///e:/projects/quran_mobile_app/src/quran_mobile_app/lib/src/features/audio/presentation/audio_player_bottom_bar.dart)
- Create a persistent bottom audio player UI component displaying:
  - Play/Pause toggle button.
  - Active Reciter name (Arabic / Persian / English).
  - Current Surah & Verse badge.
  - Reciter selection button to open the reciter modal.
  - Progress bar / timeline.

#### [NEW] [reciter_selector_dialog.dart](file:///e:/projects/quran_mobile_app/src/quran_mobile_app/lib/src/features/audio/presentation/reciter_selector_dialog.dart)
- Modal dialog / bottom sheet enabling users to browse and switch between available reciters (e.g. Mishary Rashid Alafasy, Mahmoud Khalil Al-Husary).

#### [MODIFY] [verse_detail_view.dart](file:///e:/projects/quran_mobile_app/src/quran_mobile_app/lib/src/features/reader/verse_detail_view.dart)
- Add audio play icon button on each verse card header.
- Highlight the active reciting verse card with a distinct active theme border / container highlight.
- Attach the `AudioPlayerBottomBar` at the bottom of the `Scaffold`.

---

## Verification Plan

### Automated Tests
- Run `flutter test` to ensure existing widgets and providers pass without regressions.
- Verify `flutter analyze` produces no syntax or type errors.

### Manual Verification
- Launch the app in Flutter Web / Android.
- Open a Surah (e.g. Surah Al-Fatiha or Surah Al-Ikhlas).
- Tap the Play button on Verse 1 and verify audio plays cleanly from the selected reciter.
- Verify automatic transition: when Verse 1 finishes reciting, Verse 2 starts playing automatically and the UI highlights Verse 2.
- Test changing reciter from the selector modal and verifying the next verse uses the new reciter's audio stream.
- Test Play/Pause and Stop from the persistent audio player bottom bar.
