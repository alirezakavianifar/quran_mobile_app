# Implementation Plan: Islamic Companion & Productivity Suite

This implementation plan outlines the architecture, data models, UI components, and verification steps for adding high-impact Islamic devotional and Quranic productivity features to the platform.

---

## 🏗 Modular Phases Overview

```
┌─────────────────────────────────────────────────────────────────────────┐
│                 Islamic Companion & Productivity Suite                  │
├────────────────────────┬────────────────────────┬───────────────────────┤
│        Phase 1         │        Phase 2         │        Phase 3        │
│   Daily Devotionals    │ Audio & Visual Sharing │   Hifz & Analytics    │
├────────────────────────┼────────────────────────┼───────────────────────┤
│ • Smart Digital Tasbih │ • Audio Sleep Timer    │ • Hifz Mask Mode      │
│ • 40 Rabbana Duas Hub  │ • Ayah Card Generator  │ • Activity Heatmap    │
│ • Sajdah Verse Guides  │ • Story Image Exporter │ • Quran Quiz Engine   │
└────────────────────────┴────────────────────────┴───────────────────────┘
```

---

## 📋 Phase 1: Daily Devotional Companion

### 1.1 Smart Digital Tasbih / Dhikr Counter (`features/tasbih/`)
* **Data Model (`dhikr_model.dart`)**:
  - `id`: Unique identifier
  - `titleFa` / `titleEn` / `titleAr`: Localized Dhikr titles (e.g. *تسبیحات حضرت زهرا (س)*, *صلوات*, *استغفار*)
  - `arabicText`: Full Arabic phrasing (e.g. *الله أكبر*, *سبحان الله*, *الحمد لله*, *اللهم صل علی محمد و آل محمد*)
  - `targetCount`: Step limit (e.g. 34 -> 33 -> 33 for Fatima Zahra Tasbih, or 100, 1000, ∞)
  - `currentCount`: Current tap progress
  - `lifetimeCount`: All-time accumulated total
* **Audio & Haptics (`tasbih_notifier.dart`)**:
  - `HapticFeedback.lightImpact()` on every regular increment
  - `HapticFeedback.heavyImpact()` + celebration animation upon hitting target counts
  - Sound effect toggle (subtle click sound)
* **UI Screen (`tasbih_screen.dart`)**:
  - Full-screen tap surface with animated circular progress ring and bead counter
  - Preset Dhikr selector drawer (Fatima Zahra, Asmaul Husna, Daily Weekday Dhikrs, Custom)
  - Quick Reset, Target Selector, and Sound/Vibration toggles

### 1.2 40 Rabbana & Quranic Duas Hub (`features/duas/`)
* **Data & Catalog (`quranic_duas_repository.dart`)**:
  - Complete curated list of all 40 Quranic Duas beginning with *Rabbana* (ربنا) and *Rabbi* (ربّ)
  - Thematic taxonomy:
    1. 🛡 *Forgiveness & Mercy (آمرزش و بخشش)*
    2. 👨‍👩‍👧‍👦 *Family & Children (خانواده و فرزندان)*
    3. 🌟 *Guidance & Faith (هدایت و ثبات قدم)*
    4. 🤲 *Health, Provision & Ease (سلامتی، رزق و آسانی)*
    5. 📖 *Wisdom & Knowledge (علم و حکمت)*
* **UI Screen (`quranic_duas_screen.dart`)**:
  - Category filter chips
  - Dual Persian/English cards with Uthmani script, translation, and Ayah citation link (e.g. *[Al-Baqarah: 201]*)
  - 1-tap audio recitation, tafsir viewer, copy, and bookmarking

### 1.3 Obligatory & Recommended Sajdah Verses System (`features/sajdah/`)
* **Fiqh Taxonomy**:
  - 4 Wajib Sajdah Verses: Surah As-Sajdah (32:15), Surah Fussilat (41:38), Surah An-Najm (53:62), Surah Al-Alaq (96:19)
  - 11 Mustahab Sajdah Verses: (7:206, 13:15, 16:50, 17:109, 19:58, 22:18, 22:77, 25:60, 27:26, 38:24, 84:21)
* **Visual Marker & Guidance**:
  - Sajdah symbol (`۩`) and color-coded badge in `VerseDetailView`
  - 1-tap popup modal displaying the recommended Sajdah supplication (*لا إلهَ إلاَّ اللهُ حَقّاً حَقّاً...*) and fiqh notes

---

## 🎨 Phase 2: Audio Enhancement & Visual Inspiration

### 2.1 Audio Sleep Timer (`features/audio/`)
* **Countdown Engine in `AudioPlayerNotifier`**:
  - Preset durations: `15m`, `30m`, `45m`, `60m`, or `"End of Surah"`
  - Gentle fade-out volume curve over the final 15 seconds before pausing
  - Remaining time badge on `AudioPlayerBottomBar`

### 2.2 Ayah Card Image & Story Generator (`features/card_generator/`)
* **Visual Rendering Engine (`ayah_card_generator.dart`)**:
  - `RepaintBoundary` rendering high-DPI image buffers from customized widgets
  - Ratio presets: `1:1 Square` (Instagram / Telegram post) and `9:16 Vertical` (Story / Status)
  - Theme Styles:
    - 🌿 *Emerald & Gold (زمرد و طلا)*
    - 🌌 *Deep Midnight (شب سرمه‌ای)*
    - 📜 *Parchment & Warm Sepia (کاغذ سنتی کهن)*
    - 💎 *Minimalist Glassmorphism (شیشه‌ای مدرن)*
  - 1-tap direct export to image file and native social sharing

---

## 🧠 Phase 3: Interactive Hifz & Study Analytics

### 3.1 Hifz Hide-and-Reveal Mode (`features/reader/`)
* Blur/Mask overlay on Arabic words in `VerseDetailView`
* 1-tap to reveal individual words or entire ayah to test recall

### 3.2 Reading Activity Heatmap & Analytics (`features/analytics/`)
* Daily reading session tracker logging verses and timestamp
* 52-week activity calendar heatmap (GitHub style) displaying daily consistency and milestones

---

## 🧪 Verification & Testing Strategy

1. **Unit Tests**:
   - `test/tasbih_test.dart`: Test count incrementation, Fatima Zahra multi-step targets (34-33-33), and persistence.
   - `test/quranic_duas_test.dart`: Verify dataset integrity, thematic filtering, and model serialization.
   - `test/sleep_timer_test.dart`: Verify timer decrement and audio stop trigger.
2. **Widget Tests**:
   - `test/sajdah_indicator_test.dart`: Ensure Sajdah badge renders on designated verses.
3. **Full Suite Execution**:
   - Run `flutter test` across all unit/widget tests.
