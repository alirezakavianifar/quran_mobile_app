# Khatmah / Daily Reading Plan & Progress Tracker Implementation Plan

## Goal Description
Implement a comprehensive Khatmah & Daily Quran Reading Planner (برنامه ختم قرآن و پیگیری پیشرفت مطالعه) with preset goals (30, 60, 90, 365 days), daily targets, streak tracking, home banner, and direct reader jump.

---

## 1. Requirements & Architecture
- **Data Model (`KhatmahPlan`)**:
  - Properties: `id`, `title`, `targetDays`, `startDate`, `targetDate`, `completedPages`, `totalPages` (604), `lastReadDate`, `streakDays`, `isCompleted`.
  - Computed properties: `dailyPageTarget`, `pagesReadToday`, `progressPercentage`, `daysRemaining`.
- **Repository & StateNotifier (`KhatmahRepository`, `KhatmahNotifier`)**:
  - Local JSON/SharedPreferences persistence.
  - CRUD operations on plans, logging pages, computing streaks.
- **UI Components**:
  - `KhatmahHomeBanner` in `SurahListView`.
  - `KhatmahScreen` with circular progress, streak flame, today's quota, and creation modal.
  - AppBar shortcut in `SurahListView`.
- **Localization**:
  - Persian & English translations for all Khatmah strings.

---

## 2. Implementation Steps
1. Create `KhatmahPlan` model.
2. Create `KhatmahRepository` and `KhatmahNotifier`.
3. Add `KhatmahScreen` and `KhatmahHomeBanner`.
4. Integrate into `SurahListView` and `main.dart` / AppLocalizations.
5. Write unit tests in `test/khatmah_test.dart` and run test suite.
