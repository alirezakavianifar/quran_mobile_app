# Phase 2 Detailed Implementation Plan: Audio Enhancement & Visual Social Sharing

This document provides the complete, file-by-file architectural and implementation specification for **Phase 2: Audio Enhancement & Visual Social Sharing**, covering:
1. **Recitation Sleep Timer & Fade-Out Engine (تایمر خواب پخش صوت با محوشدن ملایم)**
2. **Ayah Story & Image Card Generator (سازنده کارت تصویری و استوری آیه)**

---

## 🏗 Component Architecture & Data Flow

```
   ┌────────────────────────────────────────────────────────┐
   │             VerseDetailView (Quick Actions)            │
   └───────────────────────────┬────────────────────────────┘
                               │
                ┌──────────────┴──────────────┐
                ▼                             ▼
  ┌───────────────────────────┐ ┌───────────────────────────┐
  │     SleepTimerDialog      │ │ AyahCardGeneratorScreen   │
  │   (15m, 30m, 45m, Surah)  │ │ (1:1 Square / 9:16 Story) │
  └─────────────┬─────────────┘ └─────────────┬─────────────┘
                │                             │
                ▼                             ▼
  ┌───────────────────────────┐ ┌───────────────────────────┐
  │    AudioPlayerNotifier    │ │     RenderRepaintBoundary │
  │   (Countdown & Fade-Out)  │ │   (PNG Byte Buffer & Share)│
  └─────────────┬─────────────┘ └───────────────────────────┘
                │
                ▼
  ┌───────────────────────────┐
  │   AudioPlayerBottomBar    │
  │  (Live 💤 Countdown Badge)│
  └───────────────────────────┘
```

---

## 📁 Detailed File Plan

### 1. Recitation Sleep Timer (`lib/src/features/audio/`)

#### 1.1 `presentation/sleep_timer_dialog.dart`
* **Presets & Controls**:
  - `15 minutes` (`۱۵ دقیقه`)
  - `30 minutes` (`۳۰ دقیقه`)
  - `45 minutes` (`۴۵ دقیقه`)
  - `60 minutes` (`۱ ساعت`)
  - `End of Current Surah` (`پایان سوره فعلی`)
  - `Custom Minutes` input dialog
  - `Cancel Sleep Timer` button if currently active

#### 1.2 `presentation/audio_player_notifier.dart` Updates
* **State Properties**:
  - `Duration? sleepTimerRemaining`: Current remaining countdown
  - `bool isEndOfSurahSleepTimer`: Flag indicating playback should stop when the current Surah finishes
* **Engine Logic**:
  - `Timer.periodic(const Duration(seconds: 1))` decrementing `sleepTimerRemaining`.
  - **Gentle Volume Fade-Out**: When remaining duration $\le 15\text{ seconds}$, decrease player volume smoothly from `1.0` down to `0.0` before executing `pause()`.
  - When `isEndOfSurahSleepTimer` is true and playback advances past `totalVersesInSurah`, pause playback automatically and reset timer state.

#### 1.3 `presentation/audio_player_bottom_bar.dart` Updates
* Add live sleep timer badge in the quick actions toolbar:
  - `[💤 ۱۵:۰۰]` (counting down in real-time)
  - 1-tap opens `SleepTimerDialog` to adjust or cancel.

---

### 2. Ayah Story & Image Card Generator (`lib/src/features/card_generator/`)

#### 2.1 `models/card_theme_model.dart`
* **Enums & Themes**:
  - `enum CardAspectRatio`: `square` (1:1), `story` (9:16).
  - `enum CardThemeStyle`:
    1. 🌿 **Emerald & Gold (`emeraldGold`)**: Rich deep emerald gradient (`#064e3b` to `#022c22`) with golden calligraphy accents and decorative Islamic frame.
    2. 🌌 **Deep Midnight (`midnightStarlight`)**: Midnight navy-black gradient (`#0f172a` to `#020617`) with subtle starlight sparkles.
    3. 📜 **Ancient Parchment (`parchmentSepia`)**: Warm vintage manuscript texture (`#fef3c7` to `#fde68a`) with dark bistre typography.
    4. 💎 **Modern Glassmorphism (`modernGlass`)**: Frosted dark glass container over vibrant ambient purple/teal aura.
  - `class CardThemeData`: Background decoration, Arabic text color, translation text color, border color, icon color.

#### 2.2 `presentation/ayah_card_generator_screen.dart`
* **Interactive Live Preview**:
  - Encapsulates the styled Ayah card inside a `RepaintBoundary`.
  - Dynamic scaling fitting the mobile viewport with realistic aspect ratio preview.
* **Customization Toolbar**:
  - **Aspect Ratio Selector**: `1:1 Square (پست)` vs `9:16 Story (استوری)`.
  - **Theme Style Carousel**: 4 selectable visual themes.
  - **Typography Sliders**: Font size adjuster for Arabic Uthmani text.
  - **Translation Toggle**: Show/hide translation text and translator name.
* **Export Actions**:
  - High-DPI capture: `RenderRepaintBoundary.toImage(pixelRatio: 3.0)` $\to$ PNG bytes.
  - Save to local device storage.
  - Direct sharing via system share intent.

---

### 3. Integration & Reader Updates

#### 3.1 `lib/src/features/reader/verse_detail_view.dart`
* In `_showVerseQuickActions` bottom sheet:
  - Add `ListTile`:
    - Icon: `Icons.photo_library_outlined`
    - Title: `loc.translate('createAyahCard')` (*ساخت کارت تصویری و استوری*)
    - Tap: Opens `AyahCardGeneratorScreen` with the selected verse and translation.

#### 3.2 `lib/src/core/localization/app_localizations.dart`
* Add localized keys for:
  - `sleepTimer`, `sleepTimerSubtitle`, `endOfSurah`, `minutes`, `cancelTimer`, `timerActive`, `createAyahCard`, `aspectRatio`, `squarePost`, `verticalStory`, `themeStyle`, `saveImage`, `shareImage`, `imageSaved`.

---

## 🧪 Comprehensive Verification Plan

### Automated Tests:
1. `test/sleep_timer_test.dart`:
   - Test starting sleep timer with duration, verify periodic decrement.
   - Test volume fade-out during final seconds.
   - Test cancelling sleep timer and stopping on end-of-surah.
2. `test/card_generator_test.dart`:
   - Test `CardThemeStyle` colors, gradients, and theme tokens.
   - Test `CardAspectRatio` dimensions and calculations.
3. **Full Test Suite**:
   - Run `flutter test` and verify 100% pass rate.
