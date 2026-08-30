# Phase 5 Detailed Implementation Plan: Tajweed Guide, Conceptual Topics Index & Asmaul Husna Hub

This document outlines the architecture, data models, UI components, and automated verification plan for **Phase 5: Tajweed Guide, Conceptual Topics Index & Asmaul Husna Hub**.

---

## 🏗 Component Architecture & Data Flow

```
   ┌─────────────────────────────────────────────────────────────┐
   │             Quran Study & Islamic Knowledge Suite           │
   │  (Phonetic Tajweed, Conceptual Thematic Index, 99 Names)   │
   └──────────────────────────────┬──────────────────────────────┘
                                  │
        ┌─────────────────────────┼─────────────────────────┐
        ▼                         ▼                         ▼
 ┌──────────────┐          ┌──────────────┐          ┌──────────────┐
 │   Tajweed    │          │  Conceptual  │          │ Asmaul Husna │
 │ Color Guide  │          │ Topics Index │          │ 99 Names Hub │
 └──────────────┘          └──────────────┘          └──────────────┘
```

---

## 📁 Detailed File & Feature Breakdown

### 1. Phonetic Tajweed Rules & Reference Guide (`features/tajweed/`)

#### 1.1 `lib/src/features/tajweed/models/tajweed_rule_model.dart`
* **Tajweed Rule Taxonomy (`TajweedRuleType`)**:
  - `ghunnah`: 🔴 Red (#E53935) — Nasalization in Noon/Meem Mushaddad (*غنه*)
  - `ikhfa`: 🟢 Green (#43A047) — Hiding/Masking sound (*اخفاء*)
  - `idgham`: 🟠 Orange (#FB8C00) — Assimilation/Merging (*ادغام*)
  - `qalqalah`: 🔵 Blue (#1E88E5) — Echoing/Bouncing consonants (ق، ط، ب، ج، د) (*قلقله*)
  - `madd`: 🟣 Purple (#8E24AA) — Prolongation/Elongation (*مد واجب، منفصل و متصل*)
  - `iqlab`: 🟡 Amber/Brown (#8D6E63) — Conversion of Noon into Meem (*اقلاب*)
* **Model**:
  - `id: String`, `nameAr: String`, `nameFa: String`, `nameEn: String`
  - `colorHex: String`, `descriptionFa: String`, `descriptionEn: String`
  - `letters: List<String>`, `examples: List<TajweedExample>`

#### 1.2 `lib/src/features/tajweed/data/tajweed_rules_data.dart`
* Complete catalog of all 6 core Tajweed rule families with authentic Quranic examples, letters, and pronunciation guidance.

#### 1.3 `lib/src/features/tajweed/presentation/tajweed_guide_screen.dart`
* Interactive color-coded guide cards with expandable example cards, letter badges, and rule descriptions.

---

### 2. Conceptual Quranic Topics Index (`features/topics/`)

#### 2.1 `lib/src/features/topics/models/quran_topic_model.dart`
* **Model**:
  - `id: String`, `titleFa: String`, `titleEn: String`, `iconName: String`
  - `descriptionFa: String`, `descriptionEn: String`
  - `category: String` (e.g., *Faith & Belief*, *Ethics & Morality*, *Prophets*, *Creation & Science*, *Social Justice*)
  - `verses: List<TopicVerseReference>` (Surah, Verse, Arabic snippet, key excerpt)

#### 2.2 `lib/src/features/topics/data/quran_topics_data.dart`
* Comprehensive thematic index covering major themes:
  - ⚖️ *Justice, Ethics & Morals (عدالت و اخلاق)*
  - 🌿 *Nature, Creation & Science (طبیعت و شگفتی‌های آفرینش)*
  - 📜 *Stories of the Prophets (قصص انبیاء: ابراهیم، موسی، عیسی، یوسف و...)*
  - 🕊 *Brotherhood, Peace & Charity (برادری، صلح و انفاق)*
  - 🛡 *Patience & Steadfastness (صبر و استقامت در مصائب)*
  - 🌙 *Resurrection & Afterlife (معاد، بهشت و سرای باقی)*

#### 2.3 `lib/src/features/topics/presentation/quran_topics_screen.dart`
* Category filter tabs, search bar, topic cards with verse counters, and expandable verse list with 1-tap navigation to `VerseDetailView`.

---

### 3. Asmaul Husna (99 Beautiful Names of Allah) Hub (`features/asmaul_husna/`)

#### 3.1 `lib/src/features/asmaul_husna/models/asmaul_husna_model.dart`
* **Model**:
  - `number: int` (1 to 99)
  - `nameAr: String` (e.g., *الرَّحْمَنُ*, *الرَّحِيمُ*, *المَلِكُ*, *القُدُّوسُ*, *السَّلامُ*)
  - `transliteration: String`
  - `meaningFa: String`, `meaningEn: String`
  - `quranCitation: String` (e.g. *[طه: ۸]*, *[الحشر: ۲۳]*)
  - `spiritualBenefitFa: String`, `spiritualBenefitEn: String`

#### 3.2 `lib/src/features/asmaul_husna/data/asmaul_husna_data.dart`
* Full authentic catalog of all 99 Divine Names with meanings, Quranic citations, and spiritual reflections.

#### 3.3 `lib/src/features/asmaul_husna/presentation/asmaul_husna_screen.dart`
* **Grid & List Views**:
  - Gold/emerald calligraphy cards displaying Arabic script, transliteration, and meaning.
  - Search by Arabic, Persian, or English name.
  - Detail dialog with Quranic citations and 1-tap "Count Dhikr in Tasbih" shortcut.

---

### 4. Integration, Navigation & Localization Updates

#### 4.1 `lib/src/core/localization/app_localizations.dart`
* Add keys for Tajweed Guide, Quranic Topics, and Asmaul Husna in Persian and English.

#### 4.2 `lib/src/features/reader/surah_list_view.dart`
* Add direct navigation shortcuts in AppBar / Drawer.

---

## 🧪 Comprehensive Verification Plan

### Automated Unit Tests
1. `test/tajweed_rules_test.dart`:
   - Verify all 6 Tajweed rule families, colors, letter mappings, and example serialization.
2. `test/quran_topics_test.dart`:
   - Verify all thematic categories, topic items, verse reference validity, and search queries.
3. `test/asmaul_husna_test.dart`:
   - Verify all 99 Divine Names count, unique numbers (1 to 99), non-empty Arabic names, Persian/English meanings, and citations.
4. **Full Test Suite Execution**:
   - Run `flutter test` across all 95+ test cases and ensure 100% pass rate.
