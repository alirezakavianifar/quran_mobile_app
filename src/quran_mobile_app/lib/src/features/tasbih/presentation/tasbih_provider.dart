import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/tasbih_repository.dart';
import '../models/dhikr_model.dart';

class TasbihState {
  final DhikrItem activeDhikr;
  final List<DhikrItem> customDhikrs;
  final int lifetimeTotal;
  final bool isCompletedCelebration;

  const TasbihState({
    required this.activeDhikr,
    this.customDhikrs = const [],
    this.lifetimeTotal = 0,
    this.isCompletedCelebration = false,
  });

  TasbihState copyWith({
    DhikrItem? activeDhikr,
    List<DhikrItem>? customDhikrs,
    int? lifetimeTotal,
    bool? isCompletedCelebration,
  }) {
    return TasbihState(
      activeDhikr: activeDhikr ?? this.activeDhikr,
      customDhikrs: customDhikrs ?? this.customDhikrs,
      lifetimeTotal: lifetimeTotal ?? this.lifetimeTotal,
      isCompletedCelebration: isCompletedCelebration ?? this.isCompletedCelebration,
    );
  }
}

class TasbihNotifier extends StateNotifier<TasbihState> {
  final TasbihRepository _repository;

  TasbihNotifier(this._repository)
      : super(TasbihState(activeDhikr: DhikrItem.getFatimaZahra())) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final active = await _repository.loadActiveDhikr();
    final customs = await _repository.loadCustomDhikrs();
    final lifetime = await _repository.loadLifetimeTotal();
    state = state.copyWith(
      activeDhikr: active,
      customDhikrs: customs,
      lifetimeTotal: lifetime,
    );
  }

  Future<void> increment() async {
    final current = state.activeDhikr;
    final nextCount = current.currentCount + 1;
    final nextLifetime = state.lifetimeTotal + 1;

    // Haptic feedback
    if (current.isVibrationEnabled) {
      try {
        HapticFeedback.lightImpact();
      } catch (_) {}
    }

    final stageTarget = current.currentStageTarget;
    final isStageFinished = stageTarget > 0 && nextCount >= stageTarget;

    if (isStageFinished) {
      final isLastStage = current.currentStageIndex >= current.stages.length - 1;

      if (!isLastStage) {
        // Advance to next stage (e.g. Fatima Zahra 34 -> 33)
        if (current.isVibrationEnabled) {
          try {
            HapticFeedback.mediumImpact();
          } catch (_) {}
        }
        final updatedDhikr = current.copyWith(
          currentStageIndex: current.currentStageIndex + 1,
          currentCount: 0,
          lifetimeCount: current.lifetimeCount + 1,
        );
        state = state.copyWith(
          activeDhikr: updatedDhikr,
          lifetimeTotal: nextLifetime,
          isCompletedCelebration: false,
        );
        await _repository.saveActiveDhikr(updatedDhikr);
        await _repository.incrementLifetimeTotal(1);
      } else {
        // Full cycle completed!
        if (current.isVibrationEnabled) {
          try {
            HapticFeedback.heavyImpact();
          } catch (_) {}
        }
        final updatedDhikr = current.copyWith(
          currentStageIndex: 0,
          currentCount: 0,
          lifetimeCount: current.lifetimeCount + 1,
        );
        state = state.copyWith(
          activeDhikr: updatedDhikr,
          lifetimeTotal: nextLifetime,
          isCompletedCelebration: true,
        );
        await _repository.saveActiveDhikr(updatedDhikr);
        await _repository.incrementLifetimeTotal(1);
      }
    } else {
      // Regular increment
      final updatedDhikr = current.copyWith(
        currentCount: nextCount,
        lifetimeCount: current.lifetimeCount + 1,
      );
      state = state.copyWith(
        activeDhikr: updatedDhikr,
        lifetimeTotal: nextLifetime,
        isCompletedCelebration: false,
      );
      await _repository.saveActiveDhikr(updatedDhikr);
      await _repository.incrementLifetimeTotal(1);
    }
  }

  Future<void> reset() async {
    final updated = state.activeDhikr.copyWith(
      currentCount: 0,
      currentStageIndex: 0,
    );
    state = state.copyWith(activeDhikr: updated, isCompletedCelebration: false);
    await _repository.saveActiveDhikr(updated);
  }

  Future<void> selectDhikr(DhikrItem dhikr) async {
    state = state.copyWith(activeDhikr: dhikr, isCompletedCelebration: false);
    await _repository.saveActiveDhikr(dhikr);
  }

  Future<void> createCustomDhikr({
    required String titleFa,
    required String titleEn,
    required String arabicText,
    required int targetCount,
  }) async {
    final newCustom = DhikrItem(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      presetType: DhikrPresetType.custom,
      titleFa: titleFa,
      titleEn: titleEn,
      stages: [
        DhikrStage(
          titleFa: titleFa,
          titleEn: titleEn,
          arabicText: arabicText,
          targetCount: targetCount,
        ),
      ],
    );
    await _repository.saveCustomDhikr(newCustom);
    final customs = await _repository.loadCustomDhikrs();
    state = state.copyWith(
      customDhikrs: customs,
      activeDhikr: newCustom,
      isCompletedCelebration: false,
    );
    await _repository.saveActiveDhikr(newCustom);
  }

  Future<void> toggleVibration() async {
    final updated = state.activeDhikr.copyWith(
      isVibrationEnabled: !state.activeDhikr.isVibrationEnabled,
    );
    state = state.copyWith(activeDhikr: updated);
    await _repository.saveActiveDhikr(updated);
  }

  Future<void> toggleSound() async {
    final updated = state.activeDhikr.copyWith(
      isSoundEnabled: !state.activeDhikr.isSoundEnabled,
    );
    state = state.copyWith(activeDhikr: updated);
    await _repository.saveActiveDhikr(updated);
  }
}

final tasbihRepositoryProvider = Provider<TasbihRepository>((ref) {
  return TasbihRepository();
});

final tasbihProvider = StateNotifierProvider<TasbihNotifier, TasbihState>((ref) {
  final repo = ref.watch(tasbihRepositoryProvider);
  return TasbihNotifier(repo);
});
