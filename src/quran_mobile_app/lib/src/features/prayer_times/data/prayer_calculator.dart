import 'dart:math' as math;

enum PrayerCalculationMethod {
  tehran, // Institute of Geophysics, University of Tehran
  makkah, // Umm al-Qura University, Makkah
  mwl, // Muslim World League
  isna, // Islamic Society of North America
}

class CityLocation {
  final String nameFa;
  final String nameEn;
  final double latitude;
  final double longitude;
  final double timezoneOffsetHours;

  const CityLocation({
    required this.nameFa,
    required this.nameEn,
    required this.latitude,
    required this.longitude,
    required this.timezoneOffsetHours,
  });
}

class StandardCities {
  static const List<CityLocation> presets = [
    CityLocation(nameFa: 'تهران', nameEn: 'Tehran', latitude: 35.6892, longitude: 51.3890, timezoneOffsetHours: 3.5),
    CityLocation(nameFa: 'مشهد', nameEn: 'Mashhad', latitude: 36.2972, longitude: 59.6067, timezoneOffsetHours: 3.5),
    CityLocation(nameFa: 'اصفهان', nameEn: 'Isfahan', latitude: 32.6546, longitude: 51.6680, timezoneOffsetHours: 3.5),
    CityLocation(nameFa: 'شیراز', nameEn: 'Shiraz', latitude: 29.5918, longitude: 52.5837, timezoneOffsetHours: 3.5),
    CityLocation(nameFa: 'تبریز', nameEn: 'Tabriz', latitude: 38.0800, longitude: 46.2919, timezoneOffsetHours: 3.5),
    CityLocation(nameFa: 'قم', nameEn: 'Qom', latitude: 34.6401, longitude: 50.8764, timezoneOffsetHours: 3.5),
    CityLocation(nameFa: 'کربلا', nameEn: 'Karbala', latitude: 32.6160, longitude: 44.0249, timezoneOffsetHours: 3.0),
    CityLocation(nameFa: 'نجف', nameEn: 'Najaf', latitude: 32.0000, longitude: 44.3333, timezoneOffsetHours: 3.0),
    CityLocation(nameFa: 'مکه مکرمه', nameEn: 'Makkah', latitude: 21.4225, longitude: 39.8262, timezoneOffsetHours: 3.0),
    CityLocation(nameFa: 'مدینه منوره', nameEn: 'Madinah', latitude: 24.5247, longitude: 39.5692, timezoneOffsetHours: 3.0),
    CityLocation(nameFa: 'لندن', nameEn: 'London', latitude: 51.5074, longitude: -0.1278, timezoneOffsetHours: 0.0),
    CityLocation(nameFa: 'نیویورک', nameEn: 'New York', latitude: 40.7128, longitude: -74.0060, timezoneOffsetHours: -5.0),
  ];
}

class DailyPrayerTimes {
  final DateTime date;
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime sunset;
  final DateTime maghrib;
  final DateTime isha;
  final DateTime midnight;

  DailyPrayerTimes({
    required this.date,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.sunset,
    required this.maghrib,
    required this.isha,
    required this.midnight,
  });

  Map<String, DateTime> get asMap => {
        'fajr': fajr,
        'sunrise': sunrise,
        'dhuhr': dhuhr,
        'asr': asr,
        'sunset': sunset,
        'maghrib': maghrib,
        'isha': isha,
        'midnight': midnight,
      };
}

class PrayerCalculator {
  static const double kaabaLat = 21.4225;
  static const double kaabaLng = 39.8262;

  /// Calculates Qibla direction in degrees clockwise from True North (0° to 360°)
  static double calculateQiblaDirection(double lat, double lng) {
    final phi1 = lat * (math.pi / 180.0);
    final phi2 = kaabaLat * (math.pi / 180.0);
    final deltaLambda = (kaabaLng - lng) * (math.pi / 180.0);

    final y = math.sin(deltaLambda);
    final x = math.cos(phi1) * math.tan(phi2) - math.sin(phi1) * math.cos(deltaLambda);

    final rad = math.atan2(y, x);
    var deg = rad * (180.0 / math.pi);
    if (deg < 0) {
      deg += 360.0;
    }
    return deg;
  }

  /// Calculates geodesic distance to Makkah in kilometers
  static double calculateDistanceToKaabaKm(double lat, double lng) {
    const r = 6371.0; // Earth radius in km
    final dLat = (kaabaLat - lat) * (math.pi / 180.0);
    final dLon = (kaabaLng - lng) * (math.pi / 180.0);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat * (math.pi / 180.0)) *
            math.cos(kaabaLat * (math.pi / 180.0)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return r * c;
  }

  /// Astronomical calculation of prayer times
  static DailyPrayerTimes calculatePrayerTimes({
    required DateTime date,
    required double latitude,
    required double longitude,
    required double timezoneOffsetHours,
    PrayerCalculationMethod method = PrayerCalculationMethod.tehran,
  }) {
    final year = date.year;
    final month = date.month;
    final day = date.day;

    // 1. Julian Date
    final a = ((14 - month) / 12).floor();
    final y = year + 4800 - a;
    final m = month + 12 * a - 3;
    final julianDay = day +
        ((153 * m + 2) / 5).floor() +
        365 * y +
        (y / 4).floor() -
        (y / 100).floor() +
        (y / 400).floor() -
        32045;
    final double d = julianDay - 2451545.0;

    // 2. Sun's position
    final double g = (357.529 + 0.98560028 * d) % 360.0;
    final double q = (280.459 + 0.98564736 * d) % 360.0;
    final double l = (q + 1.915 * _sinD(g) + 0.020 * _sinD(2 * g)) % 360.0;
    final double e = 23.439 - 0.00000036 * d;
    final double declination = _asinD(_sinD(e) * _sinD(l));

    // 3. Equation of Time (EoT) in minutes
    final double ra = _atan2D(_cosD(e) * _sinD(l), _cosD(l)) / 15.0;
    var eot = (q / 15.0) - ra;
    while (eot < -12.0) {
      eot += 24.0;
    }
    while (eot > 12.0) {
      eot -= 24.0;
    }
    eot *= 60.0;

    // 4. Solar Noon
    final solarNoonHours = 12.0 + timezoneOffsetHours - (longitude / 15.0) - (eot / 60.0);

    // Method angles
    double fajrAngle = -17.7;
    double maghribAngle = -4.5;
    double ishaAngle = -14.0;

    switch (method) {
      case PrayerCalculationMethod.tehran:
        fajrAngle = -17.7;
        maghribAngle = -4.5;
        ishaAngle = -14.0;
        break;
      case PrayerCalculationMethod.makkah:
        fajrAngle = -18.5;
        maghribAngle = -0.833;
        ishaAngle = -19.0;
        break;
      case PrayerCalculationMethod.mwl:
        fajrAngle = -18.0;
        maghribAngle = -0.833;
        ishaAngle = -17.0;
        break;
      case PrayerCalculationMethod.isna:
        fajrAngle = -15.0;
        maghribAngle = -0.833;
        ishaAngle = -15.0;
        break;
    }

    // Helper for Hour Angle
    double hourAngle(double angle) {
      final cosH = (_sinD(angle) - _sinD(latitude) * _sinD(declination)) /
          (_cosD(latitude) * _cosD(declination));
      if (cosH > 1.0) return 0.0;
      if (cosH < -1.0) return 180.0;
      return _acosD(cosH);
    }

    // Sunrise & Sunset: sun angle = -0.833°
    final double sunRiseSetHA = hourAngle(-0.833);
    final double sunriseHours = solarNoonHours - (sunRiseSetHA / 15.0);
    final double sunsetHours = solarNoonHours + (sunRiseSetHA / 15.0);

    // Fajr
    final double fajrHA = hourAngle(fajrAngle);
    final double fajrHours = solarNoonHours - (fajrHA / 15.0);

    // Dhuhr
    final double dhuhrHours = solarNoonHours + (2.0 / 60.0); // 2 minutes past solar noon

    // Asr (Shafi'i/Ja'fari shadow ratio = 1)
    final double asrAltitude = _acotD(1.0 + _tanD((latitude - declination).abs()));
    final double asrHA = hourAngle(asrAltitude);
    final double asrHours = solarNoonHours + (asrHA / 15.0);

    // Maghrib
    double maghribHours;
    if (method == PrayerCalculationMethod.tehran) {
      final double maghribHA = hourAngle(maghribAngle);
      maghribHours = solarNoonHours + (maghribHA / 15.0);
    } else {
      maghribHours = sunsetHours + (3.0 / 60.0);
    }

    // Isha
    double ishaHours;
    if (method == PrayerCalculationMethod.makkah) {
      ishaHours = maghribHours + 1.5; // 90 minutes after Maghrib
    } else {
      final double ishaHA = hourAngle(ishaAngle);
      ishaHours = solarNoonHours + (ishaHA / 15.0);
    }

    // Islamic Midnight (midpoint between Sunset/Maghrib and next morning's Fajr)
    final double midnightHours = sunsetHours + ((24.0 + fajrHours - sunsetHours) / 2.0);

    DateTime toDateTime(double hours) {
      var h = hours;
      var dayOffset = 0;
      while (h < 0) {
        h += 24.0;
        dayOffset -= 1;
      }
      while (h >= 24.0) {
        h -= 24.0;
        dayOffset += 1;
      }

      final hour = h.floor();
      final minute = ((h - hour) * 60).floor();
      final second = ((((h - hour) * 60) - minute) * 60).round();

      return DateTime(year, month, day + dayOffset, hour, minute, second);
    }

    return DailyPrayerTimes(
      date: date,
      fajr: toDateTime(fajrHours),
      sunrise: toDateTime(sunriseHours),
      dhuhr: toDateTime(dhuhrHours),
      asr: toDateTime(asrHours),
      sunset: toDateTime(sunsetHours),
      maghrib: toDateTime(maghribHours),
      isha: toDateTime(ishaHours),
      midnight: toDateTime(midnightHours),
    );
  }

  // Trigonometric Helpers in Degrees
  static double _sinD(double d) => math.sin(d * (math.pi / 180.0));
  static double _cosD(double d) => math.cos(d * (math.pi / 180.0));
  static double _tanD(double d) => math.tan(d * (math.pi / 180.0));
  static double _asinD(double v) => math.asin(v.clamp(-1.0, 1.0)) * (180.0 / math.pi);
  static double _acosD(double v) => math.acos(v.clamp(-1.0, 1.0)) * (180.0 / math.pi);
  static double _atan2D(double y, double x) => math.atan2(y, x) * (180.0 / math.pi);
  static double _acotD(double v) => (math.pi / 2 - math.atan(v)) * (180.0 / math.pi);
}
