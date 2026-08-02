# Implementation Plan: Default Verse Text Color and Dark Theme Contrast Fix

Fix the issue where default green color for verse texts and preview text in dark theme is unreadable due to low contrast.

## Problem Analysis
1. `AppTheme.getArabicQuranTextStyle` currently defaults `color` to `primaryGreen` (`Color(0xFF0F5132)`), a dark forest green color. When rendered on dark backgrounds in Dark Theme (`#12181B`), dark green text is nearly illegible (< 2:1 contrast ratio).
2. In `getDarkTheme()`, `colorScheme.primary` is explicitly set to `primaryGreen` (`#0F5132`), causing primary UI elements, icons, and headers in Dark Mode to use dark green on a dark background.
3. In `SettingsScreen` preview box, Bismillah text explicitly used `colorScheme.primary`, rendering dark green text on dark background in dark mode.

## Proposed Changes

### 1. `lib/src/core/theme/app_theme.dart`
- Add `darkPrimaryGreen` (`Color(0xFF4EBA6F)`) as primary accent color for Dark Theme.
- Update `getDarkTheme()` to use `darkPrimaryGreen` for `colorScheme.primary` and seed color.
- Modify `getArabicQuranTextStyle()` so `color` defaults to `null` (inheriting theme text color, such as `onSurface` / `bodyLarge` color), instead of forcing `primaryGreen`.

### 2. `lib/src/features/settings/settings_screen.dart`
- Update the Arabic verse preview text (`بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ`) to use `Theme.of(context).textTheme.bodyLarge?.color` so the preview accurately mirrors high-contrast reader text.

### 3. `lib/src/features/tafsir/tafsir_bottom_sheet.dart`
- Update verse text style in Tafsir sheet to use `Theme.of(context).textTheme.bodyLarge?.color`.

## Verification Plan

### Automated Tests
- Run unit/widget tests: `flutter test` inside `src/quran_mobile_app` directory.

### Manual Verification
- Check preview block in Settings screen under Light and Dark themes.
- Check verse text in Surah reader and Tafsir bottom sheet under Light, Dark, and Sepia themes.
