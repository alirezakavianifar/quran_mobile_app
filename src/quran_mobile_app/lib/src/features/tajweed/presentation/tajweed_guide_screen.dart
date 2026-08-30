import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../reader/reader_provider.dart';
import '../../reader/verse_detail_view.dart';
import '../data/tajweed_rules_data.dart';
import '../models/tajweed_rule_model.dart';

class TajweedGuideScreen extends ConsumerWidget {
  const TajweedGuideScreen({super.key});

  Color _parseColor(String hex) {
    try {
      final clean = hex.replaceAll('#', '');
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;
    final rules = TajweedRulesData.allRules;
    final surahsAsync = ref.watch(surahListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isPersian ? 'راهنمای تجوید و احکام قرائت' : 'Tajweed Rules & Phonetics'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          // Color Guide Summary Header
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.palette_rounded,
                          size: 20, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        isPersian ? 'راهنمای رنگی احکام تجوید' : 'Color Coding Legend',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: rules.map((r) {
                      final color = _parseColor(r.colorHex);
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: color.withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              r.nameAr,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Rule Cards
          ...rules.map((rule) {
            final color = _parseColor(rule.colorHex);

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: color.withValues(alpha: 0.3), width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                rule.nameAr,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              isPersian ? rule.nameFa : rule.nameEn,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Description
                    Text(
                      isPersian ? rule.descriptionFa : rule.descriptionEn,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Letters
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          isPersian ? 'حروف قاعده:' : 'Letters:',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: rule.letters.map((l) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  l,
                                  style: AppTheme.getArabicQuranTextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Amiri',
                                    color: color,
                                  ).copyWith(fontWeight: FontWeight.bold),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Divider(height: 1),
                    const SizedBox(height: 12),

                    // Quranic Examples
                    Text(
                      isPersian ? 'نمونه‌های قرآنی:' : 'Quranic Examples:',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    ...rule.examples.map((ex) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ex.arabicText,
                                    textDirection: TextDirection.rtl,
                                    style: AppTheme.getArabicQuranTextStyle(
                                      fontSize: 17,
                                      fontFamily: 'Amiri',
                                      color: color,
                                    ).copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    ex.explanation,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.arrow_circle_left_outlined, size: 22),
                              tooltip: isPersian ? 'مشاهده در سوره' : 'View in Surah',
                              onPressed: () {
                                surahsAsync.whenData((surahs) {
                                  final target = surahs.firstWhere(
                                    (s) => s.number == ex.surahNumber,
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
                        ),
                      );
                    }),
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
