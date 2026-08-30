import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/persian_digit_converter.dart';
import '../data/daily_adhkar_data.dart';
import '../models/adhkar_model.dart';

class DailyAdhkarScreen extends ConsumerStatefulWidget {
  const DailyAdhkarScreen({super.key});

  @override
  ConsumerState<DailyAdhkarScreen> createState() => _DailyAdhkarScreenState();
}

class _DailyAdhkarScreenState extends ConsumerState<DailyAdhkarScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, int> _counts = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _increment(AdhkarItem item) {
    HapticFeedback.lightImpact();
    setState(() {
      final current = _counts[item.id] ?? 0;
      if (current < item.targetCount) {
        _counts[item.id] = current + 1;
        if (_counts[item.id] == item.targetCount) {
          HapticFeedback.heavyImpact();
        }
      }
    });
  }

  void _reset(AdhkarItem item) {
    setState(() {
      _counts[item.id] = 0;
    });
  }

  Widget _buildAdhkarList(List<AdhkarItem> items, bool isPersian) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final current = _counts[item.id] ?? 0;
        final isDone = current >= item.targetCount;
        final curStr = isPersian ? PersianDigitConverter.toPersian('$current') : '$current';
        final tarStr = isPersian ? PersianDigitConverter.toPersian('${item.targetCount}') : '${item.targetCount}';

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: isDone
                ? const BorderSide(color: Colors.green, width: 1.5)
                : BorderSide.none,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        isPersian ? item.titleFa : item.titleEn,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    if (isDone)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle_rounded, size: 14, color: Colors.green),
                            const SizedBox(width: 4),
                            Text(
                              isPersian ? 'تکمیل شد' : 'Done',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Arabic Text
                Text(
                  item.arabicText,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: AppTheme.getArabicQuranTextStyle(
                    fontSize: 18,
                    fontFamily: 'Amiri',
                    color: Theme.of(context).colorScheme.primary,
                  ).copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // Translation
                Text(
                  isPersian ? item.translationFa : item.translationEn,
                  textAlign: isPersian ? TextAlign.right : TextAlign.left,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 10),

                // Virtue Note
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline_rounded,
                          size: 14, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          isPersian ? item.sourceOrBenefitFa : item.sourceOrBenefitEn,
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const Divider(height: 1),
                const SizedBox(height: 10),

                // Tap & Counter Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded, size: 20),
                      tooltip: isPersian ? 'شروع دوباره' : 'Reset',
                      onPressed: () => _reset(item),
                    ),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: isDone ? Colors.green : null,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      icon: Icon(isDone ? Icons.check : Icons.touch_app_rounded, size: 18),
                      label: Text('$curStr / $tarStr'),
                      onPressed: () => _increment(item),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;

    final morning = DailyAdhkarData.allAdhkar.where((a) => a.category == AdhkarCategory.morning).toList();
    final evening = DailyAdhkarData.allAdhkar.where((a) => a.category == AdhkarCategory.evening).toList();
    final sleep = DailyAdhkarData.allAdhkar.where((a) => a.category == AdhkarCategory.sleep).toList();
    final postSalah = DailyAdhkarData.allAdhkar.where((a) => a.category == AdhkarCategory.postSalah).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(isPersian ? 'اذکار و تعقیبات روزانه' : 'Daily Adhkar & Supplications'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(text: isPersian ? '🌅 صبحگاه' : '🌅 Morning'),
            Tab(text: isPersian ? '🌇 شامگاه' : '🌇 Evening'),
            Tab(text: isPersian ? '🛏 پیش از خواب' : '🛏 Bedtime'),
            Tab(text: isPersian ? '🕌 تعقیبات نماز' : '🕌 Post-Salah'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAdhkarList(morning, isPersian),
          _buildAdhkarList(evening, isPersian),
          _buildAdhkarList(sleep, isPersian),
          _buildAdhkarList(postSalah, isPersian),
        ],
      ),
    );
  }
}
