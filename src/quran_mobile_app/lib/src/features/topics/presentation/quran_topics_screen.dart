import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/persian_digit_converter.dart';
import '../../reader/reader_provider.dart';
import '../../reader/verse_detail_view.dart';
import '../data/quran_topics_data.dart';
import '../models/quran_topic_model.dart';

class QuranTopicsScreen extends ConsumerStatefulWidget {
  const QuranTopicsScreen({super.key});

  @override
  ConsumerState<QuranTopicsScreen> createState() => _QuranTopicsScreenState();
}

class _QuranTopicsScreenState extends ConsumerState<QuranTopicsScreen> {
  String _selectedCategory = 'all';
  String _searchQuery = '';

  IconData _getTopicIcon(String name) {
    switch (name) {
      case 'gavel':
        return Icons.gavel_rounded;
      case 'shield':
        return Icons.shield_rounded;
      case 'eco':
        return Icons.eco_rounded;
      case 'auto_stories':
        return Icons.auto_stories_rounded;
      case 'favorite':
        return Icons.favorite_rounded;
      case 'stars':
        return Icons.stars_rounded;
      default:
        return Icons.menu_book_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;
    final allTopics = QuranTopicsData.allTopics;
    final surahsAsync = ref.watch(surahListProvider);

    // Extract unique categories
    final categories = <String>{};
    for (final t in allTopics) {
      categories.add(isPersian ? t.categoryFa : t.categoryEn);
    }

    var filteredTopics = allTopics;
    if (_selectedCategory != 'all') {
      filteredTopics = filteredTopics.where((t) {
        final cat = isPersian ? t.categoryFa : t.categoryEn;
        return cat == _selectedCategory;
      }).toList();
    }

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      filteredTopics = filteredTopics.where((t) {
        return t.titleFa.toLowerCase().contains(q) ||
            t.titleEn.toLowerCase().contains(q) ||
            t.descriptionFa.toLowerCase().contains(q) ||
            t.descriptionEn.toLowerCase().contains(q) ||
            t.verses.any((v) =>
                v.arabicText.contains(q) ||
                v.translationFa.contains(q) ||
                v.translationEn.toLowerCase().contains(q));
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isPersian ? 'نمایه و جستجوی موضوعی قرآن' : 'Thematic Quranic Topics'),
      ),
      body: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: isPersian ? 'جستجوی موضوع یا مفهوم...' : 'Search topic or keyword...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),

          // 2. Category Filter Carousel
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(isPersian ? 'همه موضوعات' : 'All Topics'),
                    selected: _selectedCategory == 'all',
                    onSelected: (_) => setState(() => _selectedCategory = 'all'),
                  ),
                ),
                ...categories.map((cat) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(cat),
                      selected: _selectedCategory == cat,
                      onSelected: (_) => setState(() => _selectedCategory = cat),
                    ),
                  );
                }),
              ],
            ),
          ),
          const Divider(height: 1),

          // 3. Topics List
          Expanded(
            child: filteredTopics.isEmpty
                ? Center(
                    child: Text(
                      isPersian ? 'موضوعی یافت نشد.' : 'No topics found.',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredTopics.length,
                    itemBuilder: (context, index) {
                      final topic = filteredTopics[index];
                      final countStr = isPersian
                          ? PersianDigitConverter.toPersian('${topic.verses.length}')
                          : '${topic.verses.length}';

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: ExpansionTile(
                          shape: const RoundedRectangleBorder(side: BorderSide.none),
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getTopicIcon(topic.iconName),
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            isPersian ? topic.titleFa : topic.titleEn,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          subtitle: Text(
                            '${isPersian ? topic.categoryFa : topic.categoryEn} • $countStr ${isPersian ? "آیه" : "ayahs"}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                              child: Text(
                                isPersian ? topic.descriptionFa : topic.descriptionEn,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            ...topic.verses.map((v) {
                              final surahNumStr = isPersian
                                  ? PersianDigitConverter.toPersian('${v.surahNumber}')
                                  : '${v.surahNumber}';
                              final verseNumStr = isPersian
                                  ? PersianDigitConverter.toPersian('${v.verseNumber}')
                                  : '${v.verseNumber}';

                              return Container(
                                margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${isPersian ? "سوره" : "Surah"} ${isPersian ? v.surahNameFa : v.surahNameEn} [$surahNumStr:$verseNumStr]',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.arrow_circle_left_outlined, size: 20),
                                          tooltip: isPersian ? 'مشاهده آیه' : 'Read Ayah',
                                          onPressed: () {
                                            surahsAsync.whenData((surahs) {
                                              final target = surahs.firstWhere(
                                                (s) => s.number == v.surahNumber,
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
                                    const SizedBox(height: 6),
                                    Text(
                                      v.arabicText,
                                      textAlign: TextAlign.right,
                                      textDirection: TextDirection.rtl,
                                      style: AppTheme.getArabicQuranTextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Amiri',
                                        color: Theme.of(context).colorScheme.primary,
                                      ).copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      isPersian ? v.translationFa : v.translationEn,
                                      textAlign: isPersian ? TextAlign.right : TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
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
