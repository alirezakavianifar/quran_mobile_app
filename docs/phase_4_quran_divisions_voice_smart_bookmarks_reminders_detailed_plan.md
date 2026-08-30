# Phase 4 Detailed Implementation Plan: Advanced Quran Divisions, Smart Bookmark Collections & Daily Reminders Hub

This document outlines the architecture, data models, UI components, and automated verification plan for **Phase 4: Advanced Quran Divisions, Smart Bookmark Collections & Daily Devotional Reminders Hub**.

---

## 🏗 Component Architecture & Data Flow

```
   ┌─────────────────────────────────────────────────────────────┐
   │            Quran Index & Divisions Engine                   │
   │  (30 Juz, 60 Hizb, 240 Quarters & Chronological Revelation) │
   └──────────────────────────────┬──────────────────────────────┘
                                  │
        ┌─────────────────────────┼─────────────────────────┐
        ▼                         ▼                         ▼
 ┌──────────────┐          ┌──────────────┐          ┌──────────────┐
 │ Multi-Index  │          │    Smart     │          │    Daily     │
 │  Navigator   │          │  Bookmarks   │          │  Reminders   │
 │ (Juz/Hizb)   │          │ & Collection │          │ & Ayah Daily │
 └──────────────┘          └──────────────┘          └──────────────┘
```

---

## 📁 Detailed File & Feature Breakdown

### 1. Advanced Quran Divisions & Chronological Revelation Index (`features/divisions/`)

#### 1.1 `lib/src/features/divisions/models/juz_division_model.dart`
* **Models**:
  - `JuzInfo`:
    - `juzNumber: int` (1 to 30)
    - `nameAr: String` (e.g. *الم*, *سیقول*, *تِلْكَ الرُّسُلُ*, *عَمَّ*)
    - `nameFa: String` / `nameEn: String`
    - `startSurahNumber: int`, `startVerseNumber: int`
    - `startPageNumber: int`, `endPageNumber: int`
    - `startAyahSnippet: String`
    - `versesCount: int`
  - `HizbInfo`:
    - `hizbNumber: int` (1 to 60)
    - `quarterNumber: int` (1 to 4: *Rub'*, *Nisf*, *Thulatha*, *Hizb*)
    - `surahNumber: int`, `verseNumber: int`, `pageNumber: int`
    - `snippet: String`
  - `RevelationOrderModel`:
    - `revelationOrder: int` (1 to 114, e.g. Surah 96 Al-Alaq is #1, Surah 68 Al-Qalam is #2, Surah 110 An-Nasr is #114)
    - `surahNumber: int`
    - `isMakki: bool`

#### 1.2 `lib/src/features/divisions/data/quran_divisions_data.dart`
* Curated catalog of all 30 Juz' boundaries, 60 Hizb / 240 Quarters, and the authentic 114 Surah chronological revelation order sequence.

#### 1.3 `lib/src/features/divisions/presentation/quran_index_screen.dart`
* **Multi-Tab Quran Index Screen**:
  - **Tab 1: Surahs (سوره‌ها)**: List of 114 Surahs with search, Makki/Madani badges, verses count, and revelation order tags.
  - **Tab 2: Juz' (جزء‌ها)**: 30 Juz cards with starting Ayah previews, page spans, and reading progress indicators.
  - **Tab 3: Hizb & Quarters (حزب و ربع‌ها)**: 60 Ahzab list with quarter navigation.
  - **Tab 4: Revelation Order (ترتیب نزول)**: Chronological revelation order view with Makki/Madani era filter.

---

### 2. Smart Bookmark Collections & Tagging Taxonomy (`features/bookmarks/`)

#### 2.1 `lib/src/features/bookmarks/models/bookmark_collection_model.dart`
* **`BookmarkCollection`**:
  - `id: String` (UUID)
  - `name: String` (e.g., *Favorite Verses*, *Tadabbur & Reflection*, *Memorization Goals*, *Friday Surahs*)
  - `colorHex: String`
  - `iconName: String`
  - `createdAt: DateTime`
* **`EnhancedBookmark`**:
  - `surahNumber: int`, `verseNumber: int`
  - `collectionId: String?`
  - `tags: List<String>` (e.g. `#Patience`, `#Mercy`, `#Hope`, `#Parents`)
  - `personalNote: String?`
  - `timestamp: DateTime`

#### 2.2 `lib/src/features/bookmarks/data/enhanced_bookmarks_repository.dart`
* SharedPreferences / JSON persistence for custom collections, tags, and categorized bookmarks.
* JSON Backup export & restore utility (`exportBookmarksToJson()` and `importBookmarksFromJson()`).

#### 2.3 `lib/src/features/bookmarks/presentation/smart_bookmarks_screen.dart`
* **Collection Folders Header**:
  - Horizontal chip carousel of custom folders with item count badges.
  - "New Folder" modal with color picker and icon selector.
* **Tag Filter Chips**:
  - Filter bookmarked verses by custom tag pills (`#صبر`, `#امید`, `#خانواده`, `#دعا`).
* **Interactive Verse Cards**:
  - Move between collections, edit tags, view Tafsir, or play recitation.
  - Export collection to text or JSON backup.

---

### 3. Daily Quranic Devotional Reminders Hub (`features/reminders/`)

#### 3.1 `lib/src/features/reminders/models/reminder_settings_model.dart`
* **Reminder Items**:
  - `dailyAyahReminderEnabled: bool`, `dailyAyahTime: String` (default `08:00`)
  - `khatmahDailyReminderEnabled: bool`, `khatmahTime: String` (default `20:00`)
  - `fridayKahfReminderEnabled: bool`, `fridayKahfTime: String` (default `10:00`)
  - `morningEveningAdhkarEnabled: bool`, `morningTime: String`, `eveningTime: String`

#### 3.2 `lib/src/features/reminders/data/daily_ayah_curator.dart`
* Curated catalog of 365 daily inspiring verses with authentic translations and moral reflections for the *Ayah of the Day* widget and notifications.

#### 3.3 `lib/src/features/reminders/presentation/reminders_screen.dart`
* Switch toggles with native TimePicker widgets for each devotional reminder.
* **Ayah of the Day Card (آیه روز)**:
  - Daily rotating verse card with copy, share, and "Read in Quran" direct navigation.

---

### 4. Integration, Navigation & Localization Updates

#### 4.1 `lib/src/core/localization/app_localizations.dart`
* Add keys for Juz/Hizb divisions, Revelation Order, Smart Collections, Tags, and Daily Reminders in both Persian and English.

#### 4.2 `lib/src/features/reader/surah_list_view.dart`
* Add direct navigation button for **Quran Divisions Index** (📑) and **Smart Bookmarks Hub** (🔖) in AppBar.

---

## 🧪 Comprehensive Verification Plan

### Automated Unit Tests
1. `test/juz_division_test.dart`:
   - Verify all 30 Juz definitions, page ranges, and starting verses.
   - Verify 60 Hizb boundaries and 114 Surah chronological revelation order consistency.
2. `test/bookmark_collection_test.dart`:
   - Test collection creation, tag assignment, bookmark filtering by collection/tag, and JSON backup export/import round-trips.
3. `test/reminders_test.dart`:
   - Test reminder settings serialization, daily Ayah rotation algorithm, and time formatting.
4. **Full Test Suite Execution**:
   - Run `flutter test` across all 80+ test cases and ensure 100% pass rate.
