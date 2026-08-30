# Phase 1 Detailed Implementation Plan: Daily Devotional Companion

This document provides the complete, file-by-file architectural and implementation specification for **Phase 1: Daily Devotional Companion Suite**, covering:
1. **Smart Digital Tasbih & Dhikr Counter (تسبیح‌شمار و ذکرشمار هوشمند)**
2. **40 Rabbana & Quranic Duas Hub (مجموعه ۴۰ ربنا و ادعیه قرآنی)**
3. **Obligatory & Recommended Sajdah Verses System (آیات سجده‌دار واجب و مستحب)**

---

## 🏗 Component Architecture & Data Flow

```
                                  ┌─────────────────────────────┐
                                  │   SurahListView (AppBar)    │
                                  └──────────────┬──────────────┘
                                                 │
                  ┌──────────────────────────────┼──────────────────────────────┐
                  ▼                              ▼                              ▼
    ┌───────────────────────────┐  ┌───────────────────────────┐  ┌───────────────────────────┐
    │       TasbihScreen        │  │     QuranicDuasScreen     │  │      VerseDetailView      │
    │  (Digital Dhikr Counter)  │  │  (40 Rabbana Duas Hub)    │  │  (Sajdah Indicator ۩)     │
    └─────────────┬─────────────┘  └─────────────┬─────────────┘  └─────────────┬─────────────┘
                  │                              │                              │
                  ▼                              ▼                              ▼
    ┌───────────────────────────┐  ┌───────────────────────────┐  ┌───────────────────────────┐
    │     TasbihNotifier &      │  │   QuranicDuasRepository   │  │        SajdahData         │
    │    SharedPreferences      │  │  (Curated 40 Duas Dataset)│  │ (4 Wajib & 11 Mustahab)   │
    └───────────────────────────┘  └───────────────────────────┘  └───────────────────────────┘
```

---

## 📁 Detailed File Plan

### 1. Smart Digital Tasbih (`lib/src/features/tasbih/`)

#### 1.1 `models/dhikr_model.dart`
* **Enums & Classes**:
  - `enum DhikrPresetType`:
    - `fatimaZahra`: Sequential 3-stage counter ($34 \times \text{Allahu Akbar} \to 33 \times \text{Alhamdulillah} \to 33 \times \text{Subhanallah}$).
    - `salawat`: $100 / 1000 / \infty$.
    - `istighfar`: $70 / 100 / \infty$.
    - `subhanallah`, `alhamdulillah`, `allahuAkbar`, `laIlahaIllallah`, `hasbunallah`.
    - `weekdayDhikr`: Dynamic based on current Persian day of the week (شنبه: *یا رب العالمین*, یکشنبه: *یا ذالجلال والاکرام*, ...).
    - `custom`: User-defined title, Arabic text, and target count.
  - `class DhikrStage`: `titleFa`, `titleEn`, `arabicText`, `targetCount`.
  - `class DhikrItem`: `id`, `presetType`, `titleFa`, `titleEn`, `stages`, `currentStageIndex`, `currentCount`, `totalTargetCount`, `lifetimeCount`.

#### 1.2 `data/tasbih_repository.dart`
* **Persistence**:
  - Store active Dhikr state, custom dhikr list, and lifetime count tallies in `SharedPreferences` (`tasbih_state_v1`, `tasbih_lifetime_counts_v1`).

#### 1.3 `presentation/tasbih_provider.dart`
* **`TasbihNotifier` Methods**:
  - `increment()`: Increments current count, triggers `HapticFeedback.lightImpact()`. If current stage finishes, triggers `HapticFeedback.heavyImpact()` and advances to next stage or finishes cycle.
  - `reset()`: Resets current count to 0.
  - `selectPreset(DhikrPresetType preset)`: Switches active dhikr.
  - `setCustomDhikr(String title, String arabic, int target)`: Creates and selects a custom dhikr.
  - `toggleVibration()`, `toggleSound()`: Controls feedback preferences.

#### 1.4 `presentation/tasbih_screen.dart`
* **UI Features**:
  - Circular glowing progress dial with animated sweep gradient.
  - Large, responsive full-screen tap target.
  - Display of current Arabic phrasing with Persian & English translation.
  - Stage indicator pills (e.g. `[1/3] الله اکبر` $\to$ `[2/3] الحمد لله` $\to$ `[3/3] سبحان الله`).
  - Bottom toolbar: Preset selector drawer button, Reset button, Sound/Vibration toggles, and Lifetime stats badge.

---

### 2. 40 Rabbana & Quranic Duas Hub (`lib/src/features/duas/`)

#### 2.1 `models/quranic_dua_model.dart`
* **Class `QuranicDua`**:
  - `id`: Unique identifier (1 to 40+).
  - `category`: `DuaCategory` (`forgiveness`, `family`, `faith`, `protection`, `knowledge`, `patience`).
  - `arabicText`: Full Uthmani Quranic text with *Rabbana* highlighted.
  - `translationFa`: Persian translation (Ayatollah Makarem Shirazi).
  - `translationEn`: English translation (Dr. Mustafa Khattab).
  - `surahNumber`: Source Surah ID.
  - `surahNameFa`: Surah Persian title (e.g. *بقره*, *آل عمران*, *کهف*).
  - `surahNameEn`: Surah English title.
  - `verseNumber`: Ayah number (or range).
  - `themeDescriptionFa` / `themeDescriptionEn`: Brief Tadabbur / practical context.

#### 2.2 `data/quranic_duas_data.dart`
* **Complete Curated Catalog**:
  - 40+ Quranic supplications with exact Surah/Ayah references, categorized into 6 thematic sections:
    1. 🛡 *آمرزش، مغفرت و توبه (Forgiveness & Mercy)*
    2. 👨‍👩‍👧‍👦 *خانواده، فرزندان نیکو و پدر و مادر (Family, Parents & Righteous Offspring)*
    3. 🌟 *هدایت، نور ایمان و ثبات قدم (Guidance, Faith & Steadfastness)*
    4. 🤲 *آسانی، شفای بیماری و رفع گرفتاری (Ease, Healing & Relief from Hardship)*
    5. 📖 *علم، معرفت و حکمت (Knowledge, Wisdom & Insight)*
    6. ⚔️ *پیروزی، صبر و استقامت (Patience, Endurance & Victory)*

#### 2.3 `presentation/quranic_duas_screen.dart`
* **UI Features**:
  - Filter chips by category.
  - Instant search across Arabic text, translations, and Surah names.
  - Dua Card with Uthmani typography, translation, and Ayah citation tag (`[Al-Baqarah: 201]`).
  - Card Action Bar:
    - ▶️ **Play Audio**: 1-tap recitation using `AudioPlayerNotifier`.
    - 📖 **Tafsir**: Opens `TafsirBottomSheet` for deeper commentary.
    - 📋 **Copy**: Copies Arabic + Translation + Citation.
    - 🔗 **Go to Ayah in Reader**: Jumps directly to the verse in `VerseDetailView`.

---

### 3. Obligatory & Recommended Sajdah Verses System (`lib/src/features/sajdah/`)

#### 3.1 `models/sajdah_model.dart`
* **Fiqh Taxonomy & Dataset**:
  - `enum SajdahType`: `wajib` (Obligatory) vs `mustahab` (Recommended).
  - `class SajdahVerseInfo`:
    - `surahNumber`, `verseNumber`, `type`, `surahNameFa`, `surahNameEn`.
    - `prescribedDuaArabic`:
      > سَجَدْتُ لِلَّهِ تَعَالَى خُضُوعاً وَ خُشُوعاً... لا إِلَهَ إِلا اللَّهُ حَقّاً حَقّاً...
    - `prescribedDuaTranslationFa` / `prescribedDuaTranslationEn`.
    - `fiqhRulingFa` / `fiqhRulingEn`.
  - **4 Wajib Sajdah Verses**:
    1. Surah As-Sajdah (32:15)
    2. Surah Fussilat (41:38)
    3. Surah An-Najm (53:62)
    4. Surah Al-Alaq (96:19)
  - **11 Mustahab Sajdah Verses**:
    - 7:206, 13:15, 16:50, 17:109, 19:58, 22:18, 22:77, 25:60, 27:26, 38:24, 84:21.

#### 3.2 `presentation/sajdah_dialog.dart`
* **Dialog Content**:
  - Prominent Sajdah Symbol (`۩`) with Wajib/Mustahab colored badge.
  - Prescribed Sajdah supplication text with Persian & English translation.
  - Fiqh instructions regarding immediate prostration upon reciting or hearing.

#### 3.3 `lib/src/features/reader/verse_detail_view.dart` Updates
* In `verseCard`:
  - Check `SajdahData.getSajdahInfo(surahNumber, verseNumber)`.
  - If present, render an attractive gold/red Sajdah badge (`۩ سجده واجب` / `۩ سجده مستحب`) in the card header.
  - Tapping the badge opens `SajdahDialog`.

---

### 4. Integration & Localization Updates

#### 4.1 `lib/src/features/reader/surah_list_view.dart`
* Add AppBar Action Icons:
  - 📿 **Tasbih Counter Icon** $\to$ Navigates to `TasbihScreen`.
  - 🤲 **Quranic Duas Icon** $\to$ Navigates to `QuranicDuasScreen`.

#### 4.2 `lib/src/core/localization/app_localizations.dart`
* Add localized keys for:
  - `digitalTasbih`, `quranicDuas`, `sajdahVerses`, `wajibSajdah`, `mustahabSajdah`, `sajdahDua`, `fatimaZahraTasbih`, `salawat`, `istighfar`, `lifetimeCount`, `resetCounter`, `targetReached`.

---

## 🧪 Comprehensive Verification Plan

### Automated Tests:
1. `test/tasbih_test.dart`:
   - Test count incrementation and cycle progression.
   - Test Fatima Zahra multi-stage transitions ($34 \to 33 \to 33$).
   - Test custom dhikr creation and target validation.
   - Test SharedPreferences state loading and saving.
2. `test/quranic_duas_test.dart`:
   - Verify dataset contains 40 valid Quranic supplications with non-empty fields.
   - Test thematic filtering across all 6 categories.
   - Test search query matching in Persian, Arabic, and English.
3. `test/sajdah_test.dart`:
   - Verify all 4 Wajib and 11 Mustahab Sajdah verses are correctly identified.
   - Test Sajdah dialog rendering and prescribed dua retrieval.
4. **Full Test Suite**:
   - Run `flutter test` and confirm 100% pass rate.
