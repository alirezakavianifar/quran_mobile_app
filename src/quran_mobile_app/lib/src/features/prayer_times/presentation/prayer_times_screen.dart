import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/persian_digit_converter.dart';
import '../data/prayer_calculator.dart';
import 'prayer_times_provider.dart';

class PrayerTimesScreen extends ConsumerWidget {
  const PrayerTimesScreen({super.key});

  String _formatTime(DateTime dt, bool isPersian) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final formatted = '${twoDigits(dt.hour)}:${twoDigits(dt.minute)}';
    return isPersian ? PersianDigitConverter.toPersian(formatted) : formatted;
  }

  String _formatDuration(Duration d, bool isPersian) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    final formatted = '$hours:$minutes:$seconds';
    return isPersian ? PersianDigitConverter.toPersian(formatted) : formatted;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(prayerTimesProvider);
    final notifier = ref.read(prayerTimesProvider.notifier);
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;

    final cityTitle = isPersian ? state.selectedCity.nameFa : state.selectedCity.nameEn;
    final qiblaAngle = state.qiblaAngle;
    final distanceKm = state.distanceToKaabaKm.round();
    final distanceStr = isPersian
        ? PersianDigitConverter.toPersian('$distanceKm')
        : '$distanceKm';

    final prayerLabels = {
      'fajr': isPersian ? 'اذان صبح' : 'Fajr',
      'sunrise': isPersian ? 'طلوع آفتاب' : 'Sunrise',
      'dhuhr': isPersian ? 'اذان ظهر' : 'Dhuhr',
      'asr': isPersian ? 'عصر' : 'Asr',
      'sunset': isPersian ? 'غروب آفتاب' : 'Sunset',
      'maghrib': isPersian ? 'اذان مغرب' : 'Maghrib',
      'isha': isPersian ? 'عشاء' : 'Isha',
      'midnight': isPersian ? 'نیمه‌شب شرعی' : 'Midnight',
    };

    final nextPrayerName = prayerLabels[state.nextPrayerKey] ?? state.nextPrayerKey;

    return Scaffold(
      appBar: AppBar(
        title: Text(isPersian ? 'اوقات شرعی و قبله‌نما' : 'Prayer Times & Qibla'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. City & Next Prayer Hero Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on_rounded, color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 6),
                            Text(
                              cityTitle,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        DropdownButton<CityLocation>(
                          value: state.selectedCity,
                          underline: const SizedBox.shrink(),
                          icon: const Icon(Icons.arrow_drop_down),
                          items: StandardCities.presets.map((city) {
                            return DropdownMenuItem<CityLocation>(
                              value: city,
                              child: Text(isPersian ? city.nameFa : city.nameEn),
                            );
                          }).toList(),
                          onChanged: (city) {
                            if (city != null) {
                              notifier.selectCity(city);
                            }
                          },
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Text(
                      isPersian ? 'تا $nextPrayerName' : 'Time Until $nextPrayerName',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formatDuration(state.timeUntilNextPrayer, isPersian),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 2. Qibla Compass Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.explore_rounded, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          isPersian ? 'جهت قبله و فاصله تا مکه' : 'Qibla Direction & Distance',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Compass Dial
                    SizedBox(
                      width: 170,
                      height: 170,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Compass Ring
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outlineVariant,
                                width: 3,
                              ),
                            ),
                          ),
                          // Cardinal Directions
                          const Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text('N', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.red)),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text('S', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text('E', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text('W', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                          ),
                          // Qibla Pointer Needle
                          Transform.rotate(
                            angle: qiblaAngle * (math.pi / 180.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.navigation_rounded,
                                  size: 48,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                          // Kaaba Icon Center
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              shape: BoxShape.circle,
                            ),
                            child: const Text('🕋', style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isPersian
                          ? 'زاویه قبله: ${PersianDigitConverter.toPersian(qiblaAngle.toStringAsFixed(1))}°'
                          : 'Qibla Angle: ${qiblaAngle.toStringAsFixed(1)}°',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isPersian
                          ? 'فاصله هوایی تا کعبه: $distanceStr کیلومتر'
                          : 'Distance to Kaaba: $distanceStr km',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 3. Daily Prayer Times List Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                child: Column(
                  children: [
                    _buildPrayerRow(
                      context,
                      label: prayerLabels['fajr']!,
                      time: _formatTime(state.prayerTimes.fajr, isPersian),
                      icon: Icons.wb_twilight_rounded,
                      isActive: state.nextPrayerKey == 'fajr',
                    ),
                    const Divider(height: 1),
                    _buildPrayerRow(
                      context,
                      label: prayerLabels['sunrise']!,
                      time: _formatTime(state.prayerTimes.sunrise, isPersian),
                      icon: Icons.wb_sunny_outlined,
                      isActive: state.nextPrayerKey == 'sunrise',
                    ),
                    const Divider(height: 1),
                    _buildPrayerRow(
                      context,
                      label: prayerLabels['dhuhr']!,
                      time: _formatTime(state.prayerTimes.dhuhr, isPersian),
                      icon: Icons.wb_sunny_rounded,
                      isActive: state.nextPrayerKey == 'dhuhr',
                    ),
                    const Divider(height: 1),
                    _buildPrayerRow(
                      context,
                      label: prayerLabels['asr']!,
                      time: _formatTime(state.prayerTimes.asr, isPersian),
                      icon: Icons.sunny,
                      isActive: state.nextPrayerKey == 'asr',
                    ),
                    const Divider(height: 1),
                    _buildPrayerRow(
                      context,
                      label: prayerLabels['sunset']!,
                      time: _formatTime(state.prayerTimes.sunset, isPersian),
                      icon: Icons.wb_twilight_outlined,
                      isActive: state.nextPrayerKey == 'sunset',
                    ),
                    const Divider(height: 1),
                    _buildPrayerRow(
                      context,
                      label: prayerLabels['maghrib']!,
                      time: _formatTime(state.prayerTimes.maghrib, isPersian),
                      icon: Icons.nights_stay_rounded,
                      isActive: state.nextPrayerKey == 'maghrib',
                    ),
                    const Divider(height: 1),
                    _buildPrayerRow(
                      context,
                      label: prayerLabels['isha']!,
                      time: _formatTime(state.prayerTimes.isha, isPersian),
                      icon: Icons.bedtime_rounded,
                      isActive: state.nextPrayerKey == 'isha',
                    ),
                    const Divider(height: 1),
                    _buildPrayerRow(
                      context,
                      label: prayerLabels['midnight']!,
                      time: _formatTime(state.prayerTimes.midnight, isPersian),
                      icon: Icons.dark_mode_rounded,
                      isActive: state.nextPrayerKey == 'midnight',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerRow(
    BuildContext context, {
    required String label,
    required String time,
    required IconData icon,
    required bool isActive,
  }) {
    return Container(
      color: isActive ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3) : null,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isActive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? Theme.of(context).colorScheme.primary : null,
                ),
              ),
            ],
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
              fontFamily: 'monospace',
              color: isActive ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
        ],
      ),
    );
  }
}
