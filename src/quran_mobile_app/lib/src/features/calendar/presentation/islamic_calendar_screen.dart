import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/persian_digit_converter.dart';
import '../../reader/reader_provider.dart';
import '../../reader/verse_detail_view.dart';
import '../data/hijri_calendar_data.dart';
import '../models/hijri_calendar_model.dart';

class IslamicCalendarScreen extends ConsumerStatefulWidget {
  const IslamicCalendarScreen({super.key});

  @override
  ConsumerState<IslamicCalendarScreen> createState() => _IslamicCalendarScreenState();
}

class _IslamicCalendarScreenState extends ConsumerState<IslamicCalendarScreen> {
  int _selectedMonth = 0; // 0 = all, 1..12 = specific hijri month

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;
    final now = DateTime.now();
    final todayHijri = HijriCalendarData.convertGregorianToHijri(now);
    final moonPhase = HijriCalendarData.calculateMoonPhase(now);
    final surahsAsync = ref.watch(surahListProvider);

    final dayStr = isPersian
        ? PersianDigitConverter.toPersian('${todayHijri.day}')
        : '${todayHijri.day}';
    final yearStr = isPersian
        ? PersianDigitConverter.toPersian('${todayHijri.year}')
        : '${todayHijri.year}';
    final monthName = isPersian ? todayHijri.monthNameFa : todayHijri.monthNameEn;

    var occasions = HijriCalendarData.allOccasions;
    if (_selectedMonth > 0) {
      occasions = occasions.where((o) => o.hijriMonth == _selectedMonth).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isPersian ? 'تقویم اسلامی و مناسبت‌های مذهبی' : 'Islamic Calendar & Events'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Today Hijri Date & Moon Phase Header Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isPersian ? 'امروز در تقویم هجری قمری' : 'Today (Hijri Calendar)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '$dayStr $monthName $yearStr',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            todayHijri.monthNameAr,
                            style: AppTheme.getArabicQuranTextStyle(
                              fontSize: 16,
                              fontFamily: 'Amiri',
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                      // Moon Phase Display
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text(
                              moonPhase.icon,
                              style: const TextStyle(fontSize: 32),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isPersian ? moonPhase.phaseNameFa : moonPhase.phaseNameEn,
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${moonPhase.illuminationPercent.toStringAsFixed(0)}% ${isPersian ? "روشنایی" : "illum"}',
                              style: TextStyle(
                                fontSize: 9,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2. Month Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(isPersian ? 'همه ماه‌ها' : 'All Months'),
                    selected: _selectedMonth == 0,
                    onSelected: (_) => setState(() => _selectedMonth = 0),
                  ),
                ),
                ...List.generate(12, (index) {
                  final mNum = index + 1;
                  final mName = isPersian
                      ? HijriCalendarData.hijriMonthsFa[index]
                      : HijriCalendarData.hijriMonthsEn[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(mName),
                      selected: _selectedMonth == mNum,
                      onSelected: (_) => setState(() => _selectedMonth = mNum),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 3. Occasions List
          Text(
            isPersian ? 'مناسبت‌ها و اعیاد اسلامی:' : 'Islamic Occasions & Holidays:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),

          ...occasions.map((occ) {
            final occDayStr = isPersian
                ? PersianDigitConverter.toPersian('${occ.hijriDay}')
                : '${occ.hijriDay}';
            final occMonthName = isPersian
                ? HijriCalendarData.hijriMonthsFa[occ.hijriMonth - 1]
                : HijriCalendarData.hijriMonthsEn[occ.hijriMonth - 1];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: occ.isMajorHoliday
                    ? BorderSide(color: Colors.amber.shade700, width: 1.5)
                    : BorderSide.none,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: occ.isMajorHoliday
                                    ? Colors.amber.withValues(alpha: 0.2)
                                    : Theme.of(context).colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$occDayStr $occMonthName',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: occ.isMajorHoliday
                                      ? Colors.amber.shade900
                                      : Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            if (occ.isMajorHoliday) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  isPersian ? 'عید / مناسبت بزرگ' : 'Major Event',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isPersian ? occ.titleFa : occ.titleEn,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isPersian ? occ.descriptionFa : occ.descriptionEn,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (occ.recommendedSurah != null) ...[
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.menu_book_rounded, size: 16),
                        label: Text(
                          isPersian
                              ? 'سوره پیشنهادی این روز (سوره شماره ${occ.recommendedSurah})'
                              : 'Recommended Surah (#${occ.recommendedSurah})',
                          style: const TextStyle(fontSize: 11),
                        ),
                        onPressed: () {
                          surahsAsync.whenData((surahs) {
                            final target = surahs.firstWhere(
                              (s) => s.number == occ.recommendedSurah,
                              orElse: () => surahs.first,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => VerseDetailView(surah: target),
                              ),
                            );
                          });
                        },
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
