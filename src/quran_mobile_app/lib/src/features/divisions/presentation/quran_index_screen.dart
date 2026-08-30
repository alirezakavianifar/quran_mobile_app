import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/persian_digit_converter.dart';
import '../../reader/reader_provider.dart';
import '../../reader/verse_detail_view.dart';
import '../data/quran_divisions_data.dart';
import '../models/juz_division_model.dart';

class QuranIndexScreen extends ConsumerStatefulWidget {
  const QuranIndexScreen({super.key});

  @override
  ConsumerState<QuranIndexScreen> createState() => _QuranIndexScreenState();
}

class _QuranIndexScreenState extends ConsumerState<QuranIndexScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _eraFilter = 'all'; // 'all', 'makki', 'madani'

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;

    return Scaffold(
      appBar: AppBar(
        title: Text(isPersian ? 'فهرست جزء‌ها و ترتیب نزول' : 'Juz & Revelation Index'),
        bottom: TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: [
            Tab(
              icon: const Icon(Icons.menu_book_rounded, size: 20),
              text: isPersian ? 'جزء‌های ۳۰ گانه' : '30 Juz Index',
            ),
            Tab(
              icon: const Icon(Icons.history_edu_rounded, size: 20),
              text: isPersian ? 'ترتیب نزول (۱۱۴ سوره)' : 'Revelation Order',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: 30 Juz List
          _buildJuzTab(context, loc, isPersian),
          // Tab 2: Revelation Order
          _buildRevelationOrderTab(context, loc, isPersian),
        ],
      ),
    );
  }

  Widget _buildJuzTab(BuildContext context, AppLocalizations loc, bool isPersian) {
    final juzList = QuranDivisionsData.allJuzList;
    final surahsAsync = ref.watch(surahListProvider);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: juzList.length,
      itemBuilder: (context, index) {
        final juz = juzList[index];
        final juzNumStr = isPersian
            ? PersianDigitConverter.toPersian('${juz.juzNumber}')
            : '${juz.juzNumber}';
        final pageSpan = isPersian
            ? 'صفحه ${PersianDigitConverter.toPersian("${juz.startPageNumber}")} تا ${PersianDigitConverter.toPersian("${juz.endPageNumber}")}'
            : 'Pages ${juz.startPageNumber} - ${juz.endPageNumber}';
        final versesStr = isPersian
            ? '${PersianDigitConverter.toPersian("${juz.versesCount}")} آیه'
            : '${juz.versesCount} verses';

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              surahsAsync.whenData((surahs) {
                final targetSurah = surahs.firstWhere(
                  (s) => s.number == juz.startSurahNumber,
                  orElse: () => surahs.first,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VerseDetailView(surah: targetSurah),
                  ),
                );
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              juzNumStr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isPersian ? juz.nameFa : juz.nameEn,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                '$pageSpan • $versesStr',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Icon(
                        isPersian ? Icons.arrow_back_ios_rounded : Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      juz.startAyahSnippet,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.getArabicQuranTextStyle(
                        fontSize: 14,
                        fontFamily: 'Amiri',
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRevelationOrderTab(BuildContext context, AppLocalizations loc, bool isPersian) {
    var list = QuranDivisionsData.revelationOrderList;
    if (_eraFilter == 'makki') {
      list = list.where((s) => s.isMakki).toList();
    } else if (_eraFilter == 'madani') {
      list = list.where((s) => !s.isMakki).toList();
    }

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      list = list.where((s) =>
          s.nameFa.toLowerCase().contains(q) ||
          s.nameAr.toLowerCase().contains(q) ||
          s.nameEn.toLowerCase().contains(q)).toList();
    }

    final surahsAsync = ref.watch(surahListProvider);

    return Column(
      children: [
        // Filter Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: isPersian ? 'جستجوی سوره...' : 'Search Surah...',
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (val) => setState(() => _searchQuery = val),
                ),
              ),
              const SizedBox(width: 8),
              SegmentedButton<String>(
                segments: [
                  ButtonSegment(value: 'all', label: Text(isPersian ? 'همه' : 'All')),
                  ButtonSegment(value: 'makki', label: Text(isPersian ? 'مکی' : 'Makki')),
                  ButtonSegment(value: 'madani', label: Text(isPersian ? 'مدنی' : 'Madani')),
                ],
                selected: {_eraFilter},
                onSelectionChanged: (set) => setState(() => _eraFilter = set.first),
              ),
            ],
          ),
        ),
        // List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              final orderStr = isPersian
                  ? PersianDigitConverter.toPersian('${item.revelationOrder}')
                  : '${item.revelationOrder}';
              final surahNumStr = isPersian
                  ? PersianDigitConverter.toPersian('${item.surahNumber}')
                  : '${item.surahNumber}';
              final verseCountStr = isPersian
                  ? '${PersianDigitConverter.toPersian("${item.verseCount}")} آیه'
                  : '${item.verseCount} ayahs';

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  leading: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '#$orderStr',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(
                        isPersian ? item.nameFa : item.nameEn,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: item.isMakki
                              ? Colors.teal.withValues(alpha: 0.15)
                              : Colors.indigo.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.isMakki
                              ? (isPersian ? 'مکی' : 'Makki')
                              : (isPersian ? 'مدنی' : 'Madani'),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: item.isMakki ? Colors.teal.shade800 : Colors.indigo.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    '${isPersian ? "سوره شماره" : "Surah #"} $surahNumStr • $verseCountStr',
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  trailing: Text(
                    item.nameAr,
                    style: AppTheme.getArabicQuranTextStyle(
                      fontSize: 16,
                      fontFamily: 'Amiri',
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  onTap: () {
                    surahsAsync.whenData((surahs) {
                      final targetSurah = surahs.firstWhere(
                        (s) => s.number == item.surahNumber,
                        orElse: () => surahs.first,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VerseDetailView(surah: targetSurah),
                        ),
                      );
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
