import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/persian_digit_converter.dart';
import '../../reader/reader_provider.dart';
import '../../reader/verse_detail_view.dart';
import '../data/quran_roots_data.dart';
import '../models/quran_root_model.dart';

class QuranRootsScreen extends ConsumerStatefulWidget {
  const QuranRootsScreen({super.key});

  @override
  ConsumerState<QuranRootsScreen> createState() => _QuranRootsScreenState();
}

class _QuranRootsScreenState extends ConsumerState<QuranRootsScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;
    final allRoots = QuranRootsData.allRoots;
    final surahsAsync = ref.watch(surahListProvider);

    var filtered = allRoots;
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      filtered = filtered.where((r) {
        return r.lettersAr.contains(q) ||
            r.transliteration.toLowerCase().contains(q) ||
            r.coreMeaningFa.toLowerCase().contains(q) ||
            r.coreMeaningEn.toLowerCase().contains(q) ||
            r.derivedForms.any((d) =>
                d.arabicWord.contains(q) ||
                d.meaningFa.toLowerCase().contains(q) ||
                d.meaningEn.toLowerCase().contains(q));
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isPersian ? 'فرهنگ ریشه‌شناسی واژگان قرآن' : 'Quranic Root Word Explorer'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: isPersian ? 'جستجوی ریشه (مثلاً: ر-ح-م یا رحمت)...' : 'Search Root (e.g. R-H-M or Mercy)...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          const Divider(height: 1),

          // Roots List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      isPersian ? 'ریشه‌ای یافت نشد.' : 'No root words found.',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final root = filtered[index];
                      final occStr = isPersian
                          ? PersianDigitConverter.toPersian('${root.occurrencesCount}')
                          : '${root.occurrencesCount}';

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: ExpansionTile(
                          shape: const RoundedRectangleBorder(side: BorderSide.none),
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              root.lettersAr,
                              style: AppTheme.getArabicQuranTextStyle(
                                fontSize: 16,
                                fontFamily: 'Amiri',
                                color: Theme.of(context).colorScheme.primary,
                              ).copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                root.transliteration,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '$occStr ${isPersian ? "تکرار در قرآن" : "occurrences"}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber.shade900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            isPersian ? root.coreMeaningFa : root.coreMeaningEn,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isPersian ? 'مشتقات و واژگان قرآنی این ریشه:' : 'Derived Quranic Words:',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: root.derivedForms.map((d) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              d.arabicWord,
                                              textDirection: TextDirection.rtl,
                                              style: AppTheme.getArabicQuranTextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Amiri',
                                                color: Theme.of(context).colorScheme.primary,
                                              ).copyWith(fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              '${isPersian ? d.meaningFa : d.meaningEn} (${d.grammaticalType})',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    isPersian ? 'نمونه آیات:' : 'Sample Verses:',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  ...root.sampleVerses.map((s) {
                                    final sNum = isPersian
                                        ? PersianDigitConverter.toPersian('${s.surahNumber}')
                                        : '${s.surahNumber}';
                                    final vNum = isPersian
                                        ? PersianDigitConverter.toPersian('${s.verseNumber}')
                                        : '${s.verseNumber}';

                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${isPersian ? "سوره" : "Surah"} ${isPersian ? s.surahNameFa : s.surahNameEn} [$sNum:$vNum]',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context).colorScheme.primary,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.arrow_circle_left_outlined, size: 20),
                                                tooltip: isPersian ? 'مشاهده در قرآن' : 'Read in Quran',
                                                onPressed: () {
                                                  surahsAsync.whenData((surahs) {
                                                    final target = surahs.firstWhere(
                                                      (surah) => surah.number == s.surahNumber,
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
                                          Text(
                                            s.arabicSnippet,
                                            textDirection: TextDirection.rtl,
                                            style: AppTheme.getArabicQuranTextStyle(
                                              fontSize: 15,
                                              fontFamily: 'Amiri',
                                              color: Theme.of(context).colorScheme.primary,
                                            ).copyWith(fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            isPersian ? s.translationFa : s.translationEn,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
