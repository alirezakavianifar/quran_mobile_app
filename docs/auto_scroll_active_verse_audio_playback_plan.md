# Auto-Scroll Active Verse During Audio Playback Implementation Plan

## Problem Description
During Quran audio recitation, if the active verse advances or if the user scrolls the view away from the active verse, the reader screen does not automatically scroll to keep the currently playing verse in view.
Although a user setting `autoScrollAudio` exists in `UserSettings` and `settings_screen.dart`, it is not consumed in `VerseDetailView`, and no listener triggers programmatic scrolling on `_scrollController`.

## Proposed Solution
Implement a smooth, robust auto-scrolling mechanism in `VerseDetailView`:
1. Maintain `GlobalKey` references for verse items.
2. Listen to `audioPlayerProvider` state changes for `currentVerseNumber` and `currentSurahId`.
3. Check the `autoScrollAudio` user setting before scrolling.
4. Smoothly scroll (`Scrollable.ensureVisible` / fallback estimated scroll offset animation) to center or position the active verse near the top-quarter of the screen.

## Proposed Changes

### Reader Feature

#### [MODIFY] [verse_detail_view.dart](file:///e:/projects/quran_mobile_app/src/quran_mobile_app/lib/src/features/reader/verse_detail_view.dart)
- Maintain `final Map<int, GlobalKey> _verseKeys = {};` in `_VerseDetailViewState`.
- Assign `key: _verseKeys.putIfAbsent(verse.verseNumber, () => GlobalKey())` to each verse card.
- Implement `void _scrollToVerse(int verseNumber, {bool animate = true})`:
  - If the widget for `verseNumber` is mounted (`key.currentContext != null`), use `Scrollable.ensureVisible(key.currentContext!, duration: const Duration(milliseconds: 400), curve: Curves.easeInOutCubic, alignment: 0.25)`.
  - If unmounted (scrolled far away), calculate estimated target offset using `verseIndex` and list metrics, animate `_scrollController` towards the target offset, then call `Scrollable.ensureVisible` in a post-frame callback.
- In `build()`, expand `ref.listen<AudioPlayerState>(audioPlayerProvider, (previous, next) { ... })`:
  - When `next.currentSurahId == widget.surah.number` and `next.currentVerseNumber != null`:
    - If `ref.read(settingsProvider).autoScrollAudio`:
      - If `next.currentVerseNumber != previous?.currentVerseNumber` or (`next.isPlaying && previous?.isPlaying != true`):
        - Call `_scrollToVerse(next.currentVerseNumber!)`.

### Testing

#### [NEW] [auto_scroll_verse_test.dart](file:///e:/projects/quran_mobile_app/src/quran_mobile_app/test/auto_scroll_verse_test.dart)
- Unit and widget test suite verifying:
  1. Auto-scroll triggers when `currentVerseNumber` updates and `autoScrollAudio` is `true`.
  2. Auto-scroll is bypassed when `autoScrollAudio` is `false`.
  3. Audio playback for a different Surah does not trigger scroll in the current view.
  4. Verse key registration and graceful fallback handling.

## Verification Plan

### Automated Tests
- Run `flutter test test/auto_scroll_verse_test.dart`
- Run the full test suite `flutter test`

### Manual Verification
- Start Surah playback and verify verse highlights and auto-scrolls into view on verse transitions.
- Scroll far up/down while playing, verify that when the next verse starts (or when re-engaging), it scrolls back to the active verse.
- Toggle off "Auto Scroll with Audio" in Settings and verify the reader remains stationary during playback.
