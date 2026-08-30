# Phase 6 Detailed Implementation Plan: Hijri Calendar & Holy Events, Quranic Root Words & Daily Adhkar Hub

This document details the architecture, data models, UI components, and automated testing strategy for **Phase 6: Hijri Calendar & Holy Events, Quranic Root Words & Daily Adhkar Hub**.

---

## 🏗 Component Architecture & Data Flow

```
   ┌─────────────────────────────────────────────────────────────────┐
   │             Islamic Companion & Productivity Suite              │
   │       (Hijri Calendar, Quranic Root Words, Daily Adhkar)        │
   └───────────────────────────────┬─────────────────────────────────┘
                                   │
        ┌──────────────────────────┼──────────────────────────┐
        ▼                          ▼                          ▼
 ┌──────────────┐           ┌──────────────┐           ┌──────────────┐
 │ Hijri & Moon │           │ Quranic Root │           │ Morning &    │
 │ Calendar Hub │           │ Word Library │           │ Eve Adhkar   │
 └──────────────┘           └──────────────┘           └──────────────┘
```

---

## 📁 Detailed File & Feature Breakdown

### 1. Islamic Hijri Calendar, Moon Phases & Holy Events (`features/calendar/`)

#### 1.1 `lib/src/features/calendar/models/hijri_calendar_model.dart`
* **Models**:
  - `HijriDate`: `year: int`, `month: int`, `day: int`, `monthNameAr: String`, `monthNameFa: String`, `monthNameEn: String`
  - `IslamicOccasion`: `titleFa: String`, `titleEn: String`, `hijriMonth: int`, `hijriDay: int`, `isMajorHoliday: bool`, `descriptionFa: String`, `descriptionEn: String`, `recommendedSurah: int?`
  - `MoonPhase`: `phaseNameFa: String`, `phaseNameEn: String`, `illuminationPercent: double`, `icon: String`

#### 1.2 `lib/src/features/calendar/data/hijri_calendar_data.dart`
* Complete catalog of Islamic holy occasions across all 12 Hijri months:
  - *Muharram*: Tasu'a & Ashura
  - *Safar*: Arbaeen & Martyrdom of the Prophet (pbuh)
  - *Rabi' al-Awwal*: Milad an-Nabi (Unity Week)
  - *Rajab*: Mab'ath & Birth of Imam Ali (as)
  - *Sha'ban*: Mid-Sha'ban (Birth of Imam Mahdi aj)
  - *Ramadan*: Holy Month, Laylat al-Qadr (19, 21, 23)
  - *Shawwal*: Eid al-Fitr
  - *Dhu al-Hijjah*: Day of Arafah, Eid al-Adha, Eid al-Ghadir, Eid al-Mubahalah
* Hijri-Gregorian algorithmic converter and lunar illumination calculator.

#### 1.3 `lib/src/features/calendar/presentation/islamic_calendar_screen.dart`
* Interactive monthly/daily calendar view with:
  - Dual Hijri / Gregorian / Shamsi date display
  - Real-time Moon Phase illumination widget (🌕🌖🌗🌘🌑🌒🌓🌔)
  - Upcoming holy events card with countdown and recommended Surahs.

---

### 2. Quranic Vocab & Arabic Root Word Explorer (`features/roots/`)

#### 2.1 `lib/src/features/roots/models/quran_root_model.dart`
* **Model (`QuranRootWord`)**:
  - `id: String` (e.g., `r-h-m`, `a-l-m`, `s-b-r`, `n-s-r`, `k-t-b`, `h-d-y`, `k-h-l-q`)
  - `lettersAr: String` (e.g., `ر-ح-م`, `ع-ل-م`, `ص-ب-ر`)
  - `transliteration: String`
  - `occurrencesCount: int` (frequency across the Quran)
  - `coreMeaningFa: String`, `coreMeaningEn: String`
  - `derivedForms: List<RootDerivedForm>`: word derivatives (e.g. *رَحْمَة*, *رَحِيم*, *رَحْمَان*, *أَرْحَام*, *يَرْحَمُ*)
  - `sampleVerses: List<RootVerseSample>` with Surah/Verse citations and snippets.

#### 2.2 `lib/src/features/roots/data/quran_roots_data.dart`
* Curated collection of the most significant and frequent Quranic root words with morphological derivations, translations, and authentic citations.

#### 2.3 `lib/src/features/roots/presentation/quran_roots_screen.dart`
* Search by Arabic root letters or English/Persian meaning, frequency badges, expandable derivation cards, and 1-tap navigation to the Quran reader.

---

### 3. Daily Morning, Evening & Post-Salah Adhkar Hub (`features/adhkar/`)

#### 3.1 `lib/src/features/adhkar/models/adhkar_model.dart`
* **Model (`AdhkarItem`)**:
  - `id: String`
  - `category: AdhkarCategory` (`morning`, `evening`, `sleep`, `postSalah`)
  - `arabicText: String`
  - `translationFa: String`, `translationEn: String`
  - `sourceOrBenefitFa: String`, `sourceOrBenefitEn: String`
  - `targetCount: int` (e.g. 1x, 3x, 7x, 10x, 33x, 100x)
  - `currentCount: int`

#### 3.2 `lib/src/features/adhkar/data/daily_adhkar_data.dart`
* Complete authentic collection of:
  - 🌅 *Morning Adhkar (اذکار و تعقیبات صبحگاه - Ayat al-Kursi, Al-Mu'awwidhat, Sayyid al-Istighfar)*
  - 🌇 *Evening Adhkar (اذکار و تعقیبات شامگاه - Protection and Gratitude)*
  - 🛏 *Bedtime Adhkar & Sleep Sunnahs (اذکار و آداب خواب)*
  - 🕌 *Post-Salah Adhkar (تعقیبات نمازها و تسبیحات)*

#### 3.3 `lib/src/features/adhkar/presentation/daily_adhkar_screen.dart`
* Tabbed category selector, interactive tap-to-count cards with haptic feedback, progress counters, reset buttons, and completion confetti.

---

### 4. Integration, Navigation & Localization Updates

#### 4.1 `lib/src/core/localization/app_localizations.dart`
* Add keys for Islamic Calendar, Moon Phases, Quranic Roots, and Daily Adhkar in Persian and English.

#### 4.2 `lib/src/features/reader/surah_list_view.dart`
* Add shortcuts into the `PopupMenuButton` Islamic Companion Tools menu.

---

## 🧪 Comprehensive Automated Verification Plan

### Automated Tests:
1. `test/hijri_calendar_test.dart`:
   - Verify date conversion calculations, 12-month catalog completeness, major Islamic holidays, and lunar moon phase illumination formulas.
2. `test/quran_roots_test.dart`:
   - Verify root word letter formatting, occurrence counts, derived morphological forms, and verse citation integrity.
3. `test/daily_adhkar_test.dart`:
   - Verify Adhkar categories (morning, evening, sleep, postSalah), target counts, and serialization round-trips.
4. **Full Test Suite Execution**:
   - Run `flutter test` across all 105+ test cases and ensure a 100% pass rate.
