import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/persian_digit_converter.dart';
import '../data/reading_activity_repository.dart';
import 'reading_analytics_provider.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  Color _getHeatmapColor(BuildContext context, int level) {
    switch (level) {
      case 1:
        return const Color(0xFF0E4429);
      case 2:
        return const Color(0xFF006D32);
      case 3:
        return const Color(0xFF26A641);
      case 4:
        return const Color(0xFF39D353);
      default:
        return Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(readingAnalyticsProvider);
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;

    final streakStr = isPersian
        ? PersianDigitConverter.toPersian('${state.currentStreak}')
        : '${state.currentStreak}';
    final versesStr = isPersian
        ? PersianDigitConverter.toPersian('${state.totalVersesRead}')
        : '${state.totalVersesRead}';
    final pagesStr = isPersian
        ? PersianDigitConverter.toPersian('${state.totalPagesCompleted}')
        : '${state.totalPagesCompleted}';
    final minutesStr = isPersian
        ? PersianDigitConverter.toPersian('${state.totalListeningMinutes}')
        : '${state.totalListeningMinutes}';

    // Build 52-week activity matrix (364 days backwards)
    final now = DateTime.now();
    final heatmapDays = <DailyActivity>[];
    for (int i = 363; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final k = DateFormat('yyyy-MM-dd').format(date);
      heatmapDays.add(state.activities[k] ?? DailyActivity(dateKey: k));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isPersian ? 'گزارش و نمودار تلاوت قرآن' : 'Study & Reading Analytics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Overview Metric Cards Grid
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    icon: Icons.local_fire_department_rounded,
                    iconColor: Colors.orange.shade600,
                    title: isPersian ? 'روزهای متوالی' : 'Day Streak',
                    value: '$streakStr ${isPersian ? "روز" : "days"}',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MetricCard(
                    icon: Icons.menu_book_rounded,
                    iconColor: Theme.of(context).colorScheme.primary,
                    title: isPersian ? 'کل آیات خوانده‌شده' : 'Verses Read',
                    value: '$versesStr ${isPersian ? "آیه" : "ayahs"}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    icon: Icons.auto_stories_rounded,
                    iconColor: Colors.teal.shade600,
                    title: isPersian ? 'صفحات تکمیل‌شده' : 'Pages Read',
                    value: '$pagesStr ${isPersian ? "صفحه" : "pages"}',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MetricCard(
                    icon: Icons.headphones_rounded,
                    iconColor: Colors.indigo.shade600,
                    title: isPersian ? 'زمان استماع صوت' : 'Audio Time',
                    value: '$minutesStr ${isPersian ? "دقیقه" : "min"}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 2. 52-Week GitHub Style Heatmap Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isPersian ? 'تقویم و نقشه حرارتی تلاوت (۵۲ هفته)' : '52-Week Reading Heatmap',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Icon(
                          Icons.grid_on_rounded,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: isPersian,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: List.generate(52, (weekIdx) {
                              return Column(
                                children: List.generate(7, (dayIdx) {
                                  final itemIdx = (weekIdx * 7) + dayIdx;
                                  if (itemIdx >= heatmapDays.length) {
                                    return const SizedBox.shrink();
                                  }
                                  final day = heatmapDays[itemIdx];
                                  final color = _getHeatmapColor(context, day.intensityLevel);
                                  return Tooltip(
                                    message: '${day.dateKey}\n${day.versesRead} verses, ${day.pagesCompleted} pages',
                                    child: Container(
                                      width: 11,
                                      height: 11,
                                      margin: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: color,
                                        borderRadius: BorderRadius.circular(2.5),
                                      ),
                                    ),
                                  );
                                }),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Heatmap Legend
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          isPersian ? 'کمتر' : 'Less',
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 4),
                        ...List.generate(5, (level) {
                          return Container(
                            width: 10,
                            height: 10,
                            margin: const EdgeInsets.symmetric(horizontal: 1.5),
                            decoration: BoxDecoration(
                              color: _getHeatmapColor(context, level),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          );
                        }),
                        const SizedBox(width: 4),
                        Text(
                          isPersian ? 'بیشتر' : 'More',
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 3. Weekly Activity Breakdown
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isPersian ? 'فعالیت ۷ روز گذشته' : 'Last 7 Days Breakdown',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: state.last7Days.map((act) {
                        final maxPoints = 50.0;
                        final points = act.totalActivityPoints.toDouble().clamp(0.0, maxPoints);
                        final barHeight = 20.0 + (points / maxPoints * 60.0);
                        final date = DateTime.tryParse(act.dateKey) ?? DateTime.now();
                        final dayName = DateFormat('E').format(date);

                        return Column(
                          children: [
                            Text(
                              '${act.versesRead}',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 18,
                              height: barHeight,
                              decoration: BoxDecoration(
                                color: act.totalActivityPoints > 0
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              dayName,
                              style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 4. Milestone Badges
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isPersian ? 'نشان‌های افتخار و تداوم' : 'Milestone Badges',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    _MilestoneItem(
                      icon: Icons.star_rounded,
                      title: isPersian ? 'گام اول در مسیر نور' : 'First Step in Light',
                      subtitle: isPersian ? 'ثبت اولین آیه مطالعه‌شده' : 'Logged first read verse',
                      isAchieved: state.totalVersesRead > 0,
                    ),
                    const Divider(height: 16),
                    _MilestoneItem(
                      icon: Icons.local_fire_department_rounded,
                      title: isPersian ? 'تداوم یک هفته‌ای' : '7-Day Streak Master',
                      subtitle: isPersian ? '۷ روز مطالعه پیوسته قرآن' : '7 consecutive days of reading',
                      isAchieved: state.currentStreak >= 7,
                    ),
                    const Divider(height: 16),
                    _MilestoneItem(
                      icon: Icons.workspace_premium_rounded,
                      title: isPersian ? 'همراه با کلام وحی' : '100 Verses Milestone',
                      subtitle: isPersian ? 'قرائت بیش از ۱۰۰ آیه شریفه' : 'Completed over 100 ayahs',
                      isAchieved: state.totalVersesRead >= 100,
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
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;

  const _MetricCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MilestoneItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isAchieved;

  const _MilestoneItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isAchieved,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isAchieved
                ? Colors.amber.withValues(alpha: 0.2)
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isAchieved ? Colors.amber.shade800 : Colors.grey,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: isAchieved ? null : Colors.grey,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Icon(
          isAchieved ? Icons.check_circle_rounded : Icons.lock_outline_rounded,
          size: 18,
          color: isAchieved ? Colors.green : Colors.grey,
        ),
      ],
    );
  }
}
