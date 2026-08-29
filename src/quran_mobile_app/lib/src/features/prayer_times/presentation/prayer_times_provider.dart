import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/prayer_calculator.dart';

class PrayerTimesState {
  final CityLocation selectedCity;
  final PrayerCalculationMethod calculationMethod;
  final DailyPrayerTimes prayerTimes;
  final double qiblaAngle;
  final double distanceToKaabaKm;
  final String nextPrayerKey;
  final DateTime nextPrayerTime;
  final Duration timeUntilNextPrayer;

  PrayerTimesState({
    required this.selectedCity,
    required this.calculationMethod,
    required this.prayerTimes,
    required this.qiblaAngle,
    required this.distanceToKaabaKm,
    required this.nextPrayerKey,
    required this.nextPrayerTime,
    required this.timeUntilNextPrayer,
  });

  PrayerTimesState copyWith({
    CityLocation? selectedCity,
    PrayerCalculationMethod? calculationMethod,
    DailyPrayerTimes? prayerTimes,
    double? qiblaAngle,
    double? distanceToKaabaKm,
    String? nextPrayerKey,
    DateTime? nextPrayerTime,
    Duration? timeUntilNextPrayer,
  }) {
    return PrayerTimesState(
      selectedCity: selectedCity ?? this.selectedCity,
      calculationMethod: calculationMethod ?? this.calculationMethod,
      prayerTimes: prayerTimes ?? this.prayerTimes,
      qiblaAngle: qiblaAngle ?? this.qiblaAngle,
      distanceToKaabaKm: distanceToKaabaKm ?? this.distanceToKaabaKm,
      nextPrayerKey: nextPrayerKey ?? this.nextPrayerKey,
      nextPrayerTime: nextPrayerTime ?? this.nextPrayerTime,
      timeUntilNextPrayer: timeUntilNextPrayer ?? this.timeUntilNextPrayer,
    );
  }
}

class PrayerTimesNotifier extends StateNotifier<PrayerTimesState> {
  Timer? _countdownTimer;

  PrayerTimesNotifier() : super(_computeInitialState()) {
    _startCountdownTimer();
  }

  static PrayerTimesState _computeInitialState({
    CityLocation? city,
    PrayerCalculationMethod method = PrayerCalculationMethod.tehran,
  }) {
    final selectedCity = city ?? StandardCities.presets.first; // Default Tehran
    final now = DateTime.now();

    final prayerTimes = PrayerCalculator.calculatePrayerTimes(
      date: now,
      latitude: selectedCity.latitude,
      longitude: selectedCity.longitude,
      timezoneOffsetHours: selectedCity.timezoneOffsetHours,
      method: method,
    );

    final qibla = PrayerCalculator.calculateQiblaDirection(
      selectedCity.latitude,
      selectedCity.longitude,
    );

    final distance = PrayerCalculator.calculateDistanceToKaabaKm(
      selectedCity.latitude,
      selectedCity.longitude,
    );

    final next = _findNextPrayer(now, prayerTimes, selectedCity, method);

    return PrayerTimesState(
      selectedCity: selectedCity,
      calculationMethod: method,
      prayerTimes: prayerTimes,
      qiblaAngle: qibla,
      distanceToKaabaKm: distance,
      nextPrayerKey: next.$1,
      nextPrayerTime: next.$2,
      timeUntilNextPrayer: next.$2.difference(now),
    );
  }

  static (String, DateTime) _findNextPrayer(
    DateTime now,
    DailyPrayerTimes today,
    CityLocation city,
    PrayerCalculationMethod method,
  ) {
    final ordered = [
      ('fajr', today.fajr),
      ('sunrise', today.sunrise),
      ('dhuhr', today.dhuhr),
      ('asr', today.asr),
      ('sunset', today.sunset),
      ('maghrib', today.maghrib),
      ('isha', today.isha),
      ('midnight', today.midnight),
    ];

    for (final entry in ordered) {
      if (entry.$2.isAfter(now)) {
        return entry;
      }
    }

    // After midnight, next is tomorrow's Fajr
    final tomorrow = now.add(const Duration(days: 1));
    final tomorrowTimes = PrayerCalculator.calculatePrayerTimes(
      date: tomorrow,
      latitude: city.latitude,
      longitude: city.longitude,
      timezoneOffsetHours: city.timezoneOffsetHours,
      method: method,
    );
    return ('fajr', tomorrowTimes.fajr);
  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final diff = state.nextPrayerTime.difference(now);
      if (diff.isNegative) {
        _recompute();
      } else {
        state = state.copyWith(timeUntilNextPrayer: diff);
      }
    });
  }

  void selectCity(CityLocation city) {
    state = _computeInitialState(city: city, method: state.calculationMethod);
  }

  void setMethod(PrayerCalculationMethod method) {
    state = _computeInitialState(city: state.selectedCity, method: method);
  }

  void _recompute() {
    state = _computeInitialState(
      city: state.selectedCity,
      method: state.calculationMethod,
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }
}

final prayerTimesProvider =
    StateNotifierProvider<PrayerTimesNotifier, PrayerTimesState>((ref) {
  return PrayerTimesNotifier();
});
