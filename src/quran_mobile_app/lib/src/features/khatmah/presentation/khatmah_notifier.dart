import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/khatmah_repository.dart';
import '../models/khatmah_model.dart';

class KhatmahNotifier extends StateNotifier<KhatmahPlan?> {
  final KhatmahRepository _repository;

  KhatmahNotifier(this._repository) : super(null) {
    _init();
  }

  Future<void> _init() async {
    final active = await _repository.loadActiveKhatmah();
    if (active != null) {
      state = _recalculateStreakAndToday(active);
    }
  }

  KhatmahPlan _recalculateStreakAndToday(KhatmahPlan plan) {
    if (plan.lastReadDate == null) return plan;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastDate = DateTime(
      plan.lastReadDate!.year,
      plan.lastReadDate!.month,
      plan.lastReadDate!.day,
    );

    final diff = today.difference(lastDate).inDays;

    if (diff == 0) {
      // Same day, keep streak and today pages
      return plan;
    } else if (diff == 1) {
      // Yesterday, streak preserved, reset today pages
      return plan.copyWith(pagesReadToday: 0);
    } else {
      // Streak broken (missed more than 1 day)
      return plan.copyWith(pagesReadToday: 0, streakDays: 0);
    }
  }

  Future<void> createPlan({
    required String title,
    required int targetDays,
    DateTime? customTargetDate,
  }) async {
    final now = DateTime.now();
    final targetDate = customTargetDate ?? now.add(Duration(days: targetDays));
    final id = 'khatmah_${now.millisecondsSinceEpoch}';

    final newPlan = KhatmahPlan(
      id: id,
      title: title,
      targetDays: targetDays,
      startDate: now,
      targetDate: targetDate,
      completedPages: 0,
      totalPages: 604,
      lastReadPage: 1,
      streakDays: 0,
      pagesReadToday: 0,
      isCompleted: false,
    );

    state = newPlan;
    await _repository.saveActiveKhatmah(newPlan);
  }

  Future<void> logPageRead(int pageNumber) async {
    if (state == null) return;
    final current = state!;
    final now = DateTime.now();

    final newCompleted = (pageNumber > current.completedPages)
        ? pageNumber
        : current.completedPages;

    final isNewlyCompleted = newCompleted >= current.totalPages;

    // Calculate streak
    int newStreak = current.streakDays;
    int newTodayPages = current.pagesReadToday;

    if (current.lastReadDate == null) {
      newStreak = 1;
      newTodayPages = 1;
    } else {
      final today = DateTime(now.year, now.month, now.day);
      final lastDate = DateTime(
        current.lastReadDate!.year,
        current.lastReadDate!.month,
        current.lastReadDate!.day,
      );
      final diff = today.difference(lastDate).inDays;

      if (diff == 0) {
        newTodayPages += 1;
      } else if (diff == 1) {
        newStreak += 1;
        newTodayPages = 1;
      } else {
        newStreak = 1;
        newTodayPages = 1;
      }
    }

    final updated = current.copyWith(
      completedPages: newCompleted.clamp(0, current.totalPages),
      lastReadPage: pageNumber.clamp(1, current.totalPages),
      lastReadDate: now,
      pagesReadToday: newTodayPages,
      streakDays: newStreak,
      isCompleted: isNewlyCompleted,
    );

    state = updated;
    await _repository.saveActiveKhatmah(updated);
  }

  Future<void> addPagesCompleted(int pagesCount) async {
    if (state == null || pagesCount <= 0) return;
    final targetPage = (state!.completedPages + pagesCount).clamp(1, state!.totalPages);
    await logPageRead(targetPage);
  }

  Future<void> deleteActivePlan() async {
    state = null;
    await _repository.deleteActiveKhatmah();
  }
}

final khatmahProvider = StateNotifierProvider<KhatmahNotifier, KhatmahPlan?>((ref) {
  final repository = ref.watch(khatmahRepositoryProvider);
  return KhatmahNotifier(repository);
});
