# Remove English Parentheses & Persian Font Names Implementation Plan

## Goal
Remove English names inside parentheses in Persian UI strings across the mobile app, and translate the font selector labels (Image 3: Amiri, Scheherazade, Lateef) into Persian (`امیری`, `شهرزاد`, `لطیف`).

## Proposed Changes

### [settings_screen.dart](file:///e:/projects/quran_mobile_app/src/quran_mobile_app/lib/src/features/settings/settings_screen.dart)
- Update `SegmentedButton` labels for Arabic fonts:
  - 'Amiri' -> `isPersian ? 'امیری' : 'Amiri'`
  - 'Scheherazade New' -> `isPersian ? 'شهرزاد' : 'Scheherazade'`
  - 'Lateef' -> `isPersian ? 'لطیف' : 'Lateef'`
- Remove English parenthetical texts in Persian strings:
  - Transliteration toggle: `'نمایش آوانویسی'` (removed `(Transliteration)`)
  - Reciters dropdown items:
    - `'استاد شهریار پرهیزگار'` (removed `(Shahriar Parhizgar)`)
    - `'مشاری راشد العفاسی'` (removed `(Mishary Alafasy)`)
    - `'عبدالباسط عبدالصمد'` (removed `(Abdul Basit)`)
  - Language toggle: `'فارسی'` / `'Persian'` (removed `(Persian)`)
  - Hybrid search toggle: `'جستجوی ترکیبی'` (removed `(Hybrid Search)`)

## Verification Plan
1. Run Flutter unit and widget tests:
   `flutter test` in `src/quran_mobile_app`.
2. Confirm the UI compiles cleanly without errors.
