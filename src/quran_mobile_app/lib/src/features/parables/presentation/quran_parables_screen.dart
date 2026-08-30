import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/persian_digit_converter.dart';
import '../../reader/reader_provider.dart';
import '../../reader/verse_detail_view.dart';
import '../data/quran_parables_data.dart';

class QuranParablesScreen extends ConsumerStatefulWidget {
  const QuranParablesScreen({super.key});

  @override
  ConsumerState<QuranParablesScreen> createState() => _QuranParablesScreenState();
}

class _QuranParablesScreenState extends ConsumerState<QuranParablesScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;
    final allParables = QuranParablesData.allParables;
    final surahsAsync = ref.watch(surahListProvider);

    var list = allParables;
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      list = list.where((p) {
        return p.titleFa.toLowerCase().contains(q) ||
            p.titleEn.toLowerCase().contains(q) ||
            p.allegorySubjectFa.toLowerCase().contains(q) ||
            p.allegorySubjectEn.toLowerCase().contains(q) ||
            p.moralLessonFa.toLowerCase().contains(q) ||
            p.moralLessonEn.toLowerCase().contains(q) ||
            p.arabicVerse.contains(q) ||
            p.translationFa.contains(q);
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isPersian ? 'مَثَل‌ها و تمثیلات قرآن کریم' : 'Quranic Parables & Metaphors'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: isPersian ? 'جستجوی مَثَل قرآنی یا موضوع...' : 'Search Parable or Topic...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          const Divider(height: 1),

          // Parables List
          Expanded(
            child: list.isEmpty
                ? Center(
                    child: Text(
                      isPersian ? 'مَثَلی یافت نشد.' : 'No parables found.',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final parable = list[index];
                      final sNumStr = isPersian
                          ? PersianDigitConverter.toPersian('${parable.surahNumber}')
                          : '${parable.surahNumber}';
                      final vNumStr = isPersian
                          ? PersianDigitConverter.toPersian('${parable.verseNumber}')
                          : '${parable.verseNumber}';

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: ExpansionTile(
                          shape: const RoundedRectangleBorder(side: BorderSide.none),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.lightbulb_outline_rounded,
                              color: Theme.of(context).colorScheme.primary,
                              size: 22,
                            ),
                          ),
                          title: Text(
                            isPersian ? parable.titleFa : parable.titleEn,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          subtitle: Text(
                            '${isPersian ? "سوره" : "Surah"} ${isPersian ? parable.surahNameFa : parable.surahNameEn} [$sNumStr:$vNumStr]',
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Arabic Verse
                                  Text(
                                    parable.arabicVerse,
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                    style: AppTheme.getArabicQuranTextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Amiri',
                                      color: Theme.of(context).colorScheme.primary,
                                    ).copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),

                                  // Translation
                                  Text(
                                    isPersian ? parable.translationFa : parable.translationEn,
                                    textAlign: isPersian ? TextAlign.right : TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // Allegory Subject
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          isPersian ? 'موضوع تمثیل:' : 'Allegory Subject:',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          isPersian ? parable.allegorySubjectFa : parable.allegorySubjectEn,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          isPersian ? 'پیام و حکمت تربیتی:' : 'Moral Wisdom:',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          isPersian ? parable.moralLessonFa : parable.moralLessonEn,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          isPersian ? 'رمزگشایی نمادها:' : 'Symbolic Meanings:',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          isPersian ? parable.symbolicMeaningFa : parable.symbolicMeaningEn,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // Read in Quran Button
                                  OutlinedButton.icon(
                                    icon: const Icon(Icons.arrow_circle_left_outlined, size: 18),
                                    label: Text(isPersian ? 'مطالعه آیه در قرآن' : 'Read Verse in Quran'),
                                    onPressed: () {
                                      surahsAsync.whenData((surahs) {
                                        final target = surahs.firstWhere(
                                          (s) => s.number == parable.surahNumber,
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
