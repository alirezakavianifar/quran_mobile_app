# Phase 7 Detailed Implementation Plan: Ziyarat & Sacred Duas, Quranic Parables & Islamic Wasiyyah Builder

This document details the architecture, data models, UI components, and automated testing strategy for **Phase 7: Ziyarat & Sacred Duas, Quranic Parables & Islamic Wasiyyah Builder**.

---

## 🏗 Component Architecture & Data Flow

```
   ┌─────────────────────────────────────────────────────────────────┐
   │             Islamic Companion & Productivity Suite              │
   │       (Sacred Ziyarat, Quranic Parables, Wasiyyah Builder)      │
   └───────────────────────────────┬─────────────────────────────────┘
                                   │
        ┌──────────────────────────┼──────────────────────────┐
        ▼                          ▼                          ▼
 ┌──────────────┐           ┌──────────────┐           ┌──────────────┐
 │ Ziyarat &    │           │ Quranic      │           │ Islamic      │
 │ Sacred Duas  │           │ Parables Hub │           │ Wasiyyah Doc │
 └──────────────┘           └──────────────┘           └──────────────┘
```

---

## 📁 Detailed File & Feature Breakdown

### 1. Sacred Ziyarat & Landmark Supplications (`features/ziyarat/`)

#### 1.1 `lib/src/features/ziyarat/models/ziyarat_model.dart`
* **Models**:
  - `ZiyaratSection`: `arabicText: String`, `translationFa: String`, `translationEn: String`, `targetRepeat: int`, `currentRepeat: int`, `isInteractive100x: bool`
  - `ZiyaratItem`: `id: String`, `titleFa: String`, `titleEn: String`, `titleAr: String`, `subtitle: String`, `virtueFa: String`, `virtueEn: String`, `sections: List<ZiyaratSection>`

#### 1.2 `lib/src/features/ziyarat/data/ziyarat_data.dart`
* Complete authentic texts and translations for:
  - 🕊 **Ziyarat Ashura (زیارت عاشورا)** with interactive 100x Peace & Curse counters (۱۰۰ سلام و ۱۰۰ لعن)
  - 🌟 **Ziyarat Warith (زیارت وارث)**
  - 💫 **Dua Kumayl (دعای کمیل)**
  - 🛡 **Dua Tawassul (دعای توسل)**
  - 🌿 **Ziyarat Ale Yasin (زیارت آل یاسین)**
  - 🤲 **Dua Ahd (دعای عهد)**

#### 1.3 `lib/src/features/ziyarat/presentation/ziyarat_hub_screen.dart` & `ziyarat_detail_screen.dart`
* Grid showcase of Ziyarats and Duas.
* Detail reader with line-by-line Uthmani typography, Persian/English translation, and interactive tap-to-count buttons for repeated sections (e.g. 100x Salam & La'n).

---

### 2. Quranic Parables & Metaphors (امثال قرآن) Hub (`features/parables/`)

#### 2.1 `lib/src/features/parables/models/quran_parable_model.dart`
* **Model (`QuranParable`)**:
  - `id: String`, `titleFa: String`, `titleEn: String`
  - `surahNumber: int`, `verseNumber: int`, `surahNameFa: String`, `surahNameEn: String`
  - `arabicVerse: String`, `translationFa: String`, `translationEn: String`
  - `allegorySubjectFa: String`, `allegorySubjectEn: String` (e.g. *نور خدا و چراغدان*, *تار عنکبوت و سستی شرک*, *سراب در کویر*)
  - `moralLessonFa: String`, `moralLessonEn: String`
  - `symbolicMeaningFa: String`, `symbolicMeaningEn: String`

#### 2.2 `lib/src/features/parables/data/quran_parables_data.dart`
* Curated collection of profound Quranic divine parables:
  - 💡 *The Light of Allah (آیه نور - النور: ۳۵)*
  - 🕸 *The Spider's Web & Fragility of False Idols (مَثَل عنکبوت - العنکبوت: ۴۱)*
  - 🌧 *The Rain on the Barren Rock & Hypocritical Charity (باران بر تخته سنگ - البقرة: ۲۶۴)*
  - 🌳 *The Good Word as a Pure Tree (کلمه طیبه شجره طیبه - ابراهیم: ۲۴-۲۶)*
  - 📚 *The Donkey Carrying Books (حمل تورات و غفلت - الجمعة: ۵)*
  - 🏜 *The Desert Mirage & Futility of Disbelief (سراب در بیابان - النور: ۳۹)*

#### 2.3 `lib/src/features/parables/presentation/quran_parables_screen.dart`
* Searchable card list with thematic icons, expandable symbol breakdown, and 1-tap navigation directly into the Quran reader.

---

### 3. Islamic Will & Spiritual Testament (وصیت‌نامه شرعی) Builder (`features/wasiyyah/`)

#### 3.1 `lib/src/features/wasiyyah/models/wasiyyah_model.dart`
* **Model (`IslamicWasiyyah`)**:
  - `fullName: String`, `nationalIdOrDate: String`
  - `spiritualTestimony: String` (اقرار به توحید، نبوت، امامت، معاد)
  - `prayersToMakeUp: int`, `fastsToMakeUp: int` (نماز و روزه قضا)
  - `khumsZakatStatus: String` (خمس، زکات و رد مظالم)
  - `financialDebtsAndCredits: String` (دیون، مطالبات و امانات)
  - `thirdOfEstateInstructions: String` (ثلث مال و وصایای مالی)
  - `ethicalAdviceToHeirs: String` (توصیه‌های اخلاقی و معنوی به بازماندگان)
  - `executorName: String` (وصی)
  - `lastUpdated: DateTime`

#### 3.2 `lib/src/features/wasiyyah/data/wasiyyah_repository.dart`
* Local SharedPreferences persistence with JSON backup and formatted text export.

#### 3.3 `lib/src/features/wasiyyah/presentation/wasiyyah_screen.dart`
* Multi-section stepper/form for drafting spiritual and financial testaments with preset Islamic templates and 1-tap clipboard copy/share.

---

### 4. Integration, Navigation & Localization Updates

#### 4.1 `lib/src/core/localization/app_localizations.dart`
* Add keys for Ziyarat Sanctuary, Quranic Parables, and Islamic Wasiyyah Builder in Persian and English.

#### 4.2 `lib/src/features/reader/surah_list_view.dart`
* Add shortcuts into the `PopupMenuButton` Islamic Companion Tools menu.

---

## 🧪 Comprehensive Automated Verification Plan

### Automated Tests:
1. `test/ziyarat_test.dart`:
   - Verify Ziyarat list integrity, 100x counter section properties, and model serialization.
2. `test/quran_parables_test.dart`:
   - Verify all 6+ Quranic parables, allegory topics, moral lessons, and verse citation validity.
3. `test/wasiyyah_test.dart`:
   - Verify Islamic Wasiyyah model default templates, persistence round-trips, and formatted text generation.
4. **Full Test Suite Execution**:
   - Run `flutter test` across all 115+ test cases and ensure a 100% pass rate.
