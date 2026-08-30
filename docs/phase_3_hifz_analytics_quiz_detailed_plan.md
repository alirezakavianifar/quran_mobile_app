# Phase 3 Detailed Implementation Plan: Interactive Hifz, Activity Analytics & Quranic Quiz Suite

This document outlines the complete architectural, data model, UI specification, and automated testing strategy for **Phase 3: Interactive Hifz, Study Analytics & Quranic Quiz Suite**.

---

## 🏗 Component Architecture & Data Flow

```
   ┌─────────────────────────────────────────────────────────────┐
   │             Reader & Khatmah Activity Events                │
   │      (Verse Navigation, Audio Playback, Page Read)          │
   └──────────────────────────────┬──────────────────────────────┘
                                  │
                                  ▼
   ┌─────────────────────────────────────────────────────────────┐
   │             ReadingActivityRepository & Drift DB            │
   │    (Logs: timestamp, surah, verse, pages, active minutes)   │
   └──────────────────────────────┬──────────────────────────────┘
                                  │
        ┌─────────────────────────┼─────────────────────────┐
        ▼                         ▼                         ▼
 ┌──────────────┐          ┌──────────────┐          ┌──────────────┐
 │  Hifz Mask   │          │ 52-Week Grid │          │ Quran Quiz   │
 │ Testing Mode │          │   Heatmap    │          │    Engine    │
 └──────────────┘          └──────────────┘          └──────────────┘
```

---

## 📁 Detailed File & Feature Breakdown

### 1. Hifz Hide-and-Reveal Testing Mode (`features/reader/` & `features/hifz/`)

#### 1.1 `lib/src/features/hifz/models/hifz_mode_model.dart`
* **Mask Modes (`enum HifzMaskMode`)**:
  1. `fullMask`: All words are blurred/hidden behind interactive tap pills. Tapping a word or verse reveals it.
  2. `firstLetterOnly`: Shows only the first letter of each Arabic word as a memory prompt.
  3. `translationPrompt`: Masks the entire Arabic text completely, prompting the reciter to recall the Ayah from the translation.
* **State**:
  - `Set<String> revealedWords`: Set of `surah_verse_wordIndex` strings currently unmasked.
  - `Set<String> revealedVerses`: Set of `surah_verse` strings whose entire Arabic text is visible.

#### 1.2 `lib/src/features/hifz/presentation/hifz_provider.dart`
* `StateNotifier<HifzState>`:
  - `toggleHifzMode()`: Enables/disables Hifz practice mode.
  - `setMaskMode(HifzMaskMode mode)`: Changes active testing style.
  - `toggleWordReveal(int surah, int verse, int wordIdx)`: Reveals/masks individual word.
  - `toggleVerseReveal(int surah, int verse)`: Reveals/masks full verse card.
  - `revealAllInSurah()` / `maskAllInSurah()`.

#### 1.3 `lib/src/features/reader/verse_detail_view.dart` Updates
* AppBar Toggle Button for Hifz Practice Mode (`Icons.visibility_off_outlined`).
* When Hifz Mode is active:
  - Renders Arabic text as interactive word tokens with smooth blur/mask transitions.
  - Quick action to "Reveal All" or "Mask All".

---

### 2. Reading Activity Heatmap & Analytics Engine (`features/analytics/`)

#### 2.1 `lib/src/features/analytics/data/reading_activity_repository.dart`
* **Drift / SharedPreferences Persistence**:
  - Stores daily log aggregates: `Map<String, DailyActivityLog>` keyed by date format `YYYY-MM-DD`.
  - Properties per day: `date`, `versesReadCount`, `pagesCompletedCount`, `listeningMinutes`, `streakMaintained`.
* **Activity Auto-Logger**:
  - Automatically records activity when user reads verses, logs Khatmah pages, or listens to recitations.

#### 2.2 `lib/src/features/analytics/presentation/reading_analytics_provider.dart`
* **Metrics Computed**:
  - `currentStreakDays`: Current consecutive active daily streak (🔥).
  - `longestStreakDays`: Best historical streak.
  - `totalVersesRead`: All-time verse counter.
  - `totalListeningMinutes`: Total listening duration.
  - `last365DaysActivity`: Normalized intensity grid ($0 \to 4$) for the 52-week heatmap.

#### 2.3 `lib/src/features/analytics/presentation/analytics_screen.dart`
* **Interactive Dashboard**:
  - **Overview Stats Cards**: Total Verses, Today's Verses, Active Streak (🔥), All-Time Reading Days.
  - **GitHub-style 52-Week Matrix Heatmap**: Horizontally scrollable year-round activity grid with tooltips showing verses read per day.
  - **Weekly Reading Bar Chart**: Day-by-day comparison for current week.
  - **Achievement Badges**: *7-Day Streak, 30-Day Ramadan Master, 1000 Verses Read, Surah Completionist*.

---

### 3. Interactive Quranic Ayah & Vocabulary Quiz Engine (`features/quiz/`)

#### 3.1 `lib/src/features/quiz/models/quiz_question_model.dart`
* **Quiz Question Types (`enum QuizType`)**:
  - `nextVerse`: "What is the next Ayah?" (آیه بعدی کدام است؟)
  - `missingWord`: "Fill in the missing Quranic word" (کلمه جاافتاده در آیه چیست؟)
  - `surahIdentification`: "Which Surah does this Ayah belong to?" (این آیه شریفه متعلق به کدام سوره است؟)
* **Quiz Model**:
  - `questionText`: String
  - `options`: List<String> (4 multiple-choice options)
  - `correctIndex`: int
  - `ayahCitation`: String
  - `explanation`: String

#### 3.2 `lib/src/features/quiz/data/quiz_data_generator.dart`
* Curated & programmatic question generation pulling verses from `AppDatabase`.

#### 3.3 `lib/src/features/quiz/presentation/quiz_screen.dart`
* **Game Experience**:
  - 10-Question timed/casual rounds.
  - Instant tactile feedback (green/red feedback animations with haptic feedback).
  - Scoreboard, streak multiplier, and final performance summary with Ayah citations.

---

### 4. Core Localization & Navigation Updates

#### 4.1 `lib/src/core/localization/app_localizations.dart`
* Add keys for Hifz modes, Analytics dashboard, and Quiz engine in both Persian and English.

#### 4.2 `lib/src/features/reader/surah_list_view.dart`
* Add shortcuts for **Analytics Dashboard** (📊) and **Quran Quiz** (🎯) in AppBar actions / drawer.

---

## 🧪 Comprehensive Verification Plan

### Automated Tests
1. `test/hifz_mode_test.dart`:
   - Test Hifz state toggling, word reveal tracking, and masking modes.
2. `test/reading_analytics_test.dart`:
   - Test activity logging, daily streak computation, and heatmap intensity calculations.
3. `test/quiz_test.dart`:
   - Test question generator, scoring rules, and answer verification.
4. **Full Test Suite**:
   - Run `flutter test` and verify 100% pass rate.
