import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile_app/src/features/prayer_times/data/prayer_calculator.dart';
import 'package:quran_mobile_app/src/features/prayer_times/presentation/prayer_times_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PrayerCalculator & Qibla Direction Tests', () {
    test('Calculates Qibla bearing accurately for Tehran', () {
      // Tehran coordinates: 35.6892° N, 51.3890° E
      final qiblaTehran = PrayerCalculator.calculateQiblaDirection(35.6892, 51.3890);
      // Expected Qibla from Tehran is ~218° to 220° (South-West)
      expect(qiblaTehran, inInclusiveRange(215.0, 225.0));

      final distance = PrayerCalculator.calculateDistanceToKaabaKm(35.6892, 51.3890);
      // Distance from Tehran to Makkah is ~1940 km
      expect(distance, inInclusiveRange(1850.0, 2050.0));
    });

    test('Calculates Qibla bearing for Makkah (0 distance / local origin)', () {
      final distance = PrayerCalculator.calculateDistanceToKaabaKm(
        PrayerCalculator.kaabaLat,
        PrayerCalculator.kaabaLng,
      );
      expect(distance, closeTo(0.0, 1.0));
    });

    test('Calculates daily prayer times for Tehran accurately', () {
      final testDate = DateTime(2026, 3, 21); // Spring Equinox
      final times = PrayerCalculator.calculatePrayerTimes(
        date: testDate,
        latitude: 35.6892,
        longitude: 51.3890,
        timezoneOffsetHours: 3.5,
        method: PrayerCalculationMethod.tehran,
      );

      expect(times.fajr.isBefore(times.sunrise), isTrue);
      expect(times.sunrise.isBefore(times.dhuhr), isTrue);
      expect(times.dhuhr.isBefore(times.asr), isTrue);
      expect(times.asr.isBefore(times.sunset), isTrue);
      expect(times.sunset.isBefore(times.maghrib) || times.sunset == times.maghrib, isTrue);
      expect(times.maghrib.isBefore(times.isha), isTrue);
    });
  });

  group('PrayerTimesNotifier Unit Tests', () {
    test('Initializes with default city and computes countdown', () {
      final notifier = PrayerTimesNotifier();
      final state = notifier.state;

      expect(state.selectedCity.nameEn, 'Tehran');
      expect(state.qiblaAngle, inInclusiveRange(215.0, 225.0));
      expect(state.nextPrayerKey.isNotEmpty, isTrue);
      expect(state.timeUntilNextPrayer.isNegative, isFalse);

      notifier.dispose();
    });

    test('Switches city and updates Qibla angle', () {
      final notifier = PrayerTimesNotifier();
      final london = StandardCities.presets.firstWhere((c) => c.nameEn == 'London');
      notifier.selectCity(london);

      expect(notifier.state.selectedCity.nameEn, 'London');
      // London Qibla is ~118° to 120° (South-East)
      expect(notifier.state.qiblaAngle, inInclusiveRange(115.0, 125.0));

      notifier.dispose();
    });
  });
}
