# Offline Audio Batch Downloader Implementation Plan

## Goal Description
Implement an Offline Audio Batch Downloader allowing users to download complete Surahs for any reciter to their device, listen completely offline with zero buffering, track download progress, and manage audio storage.

---

## 1. Architecture & Capabilities
- **Storage Service (`AudioStorageService`)**: Manages cache directory under app documents (`audio_cache/{reciterId}/{surahId}/{verseId}.mp3`), checks file presence, calculates disk size, and handles file deletion.
- **Download Notifier (`AudioDownloadNotifier`)**: Manages active downloads per Surah, sequential verse downloads via Dio with progress callbacks, cancelation, and completion state.
- **Playback Integration (`AudioPlayerNotifier`)**: Automatically checks if the ayah is stored locally. If so, plays via `DeviceFileSource(filePath)` (instant offline), otherwise streams via `UrlSource(audioUrl)`.
- **UI Integration**:
  - Download action button and progress badge in `VerseDetailView` AppBar.
  - Storage usage calculation and 1-click clear cache in `SettingsScreen`.
- **Bilingual Localization**: Persian and English strings in `AppLocalizations`.

---

## 2. Implementation Steps
1. Create `AudioStorageService`.
2. Create `AudioDownloadNotifier` and state models.
3. Update `AudioPlayerNotifier` to use local files whenever available.
4. Add Download Surah button & progress in `VerseDetailView`.
5. Add Audio Storage management section in `SettingsScreen`.
6. Add localization keys in `AppLocalizations`.
7. Write unit tests in `test/audio_download_test.dart` and run test suite.
