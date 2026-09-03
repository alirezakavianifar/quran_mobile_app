import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/utils/persian_digit_converter.dart';
import '../adhkar/presentation/daily_adhkar_screen.dart';
import '../analytics/presentation/analytics_screen.dart';
import '../asmaul_husna/presentation/asmaul_husna_screen.dart';
import '../bookmarks/presentation/smart_bookmarks_screen.dart';
import '../calendar/presentation/islamic_calendar_screen.dart';
import '../divisions/presentation/quran_index_screen.dart';
import '../duas/presentation/quranic_duas_screen.dart';
import '../khatmah/presentation/khatmah_screen.dart';
import '../khatmah/presentation/widgets/khatmah_home_banner.dart';
import '../notes/presentation/notes_hub_screen.dart';
import '../parables/presentation/quran_parables_screen.dart';
import '../prayer_times/presentation/prayer_times_screen.dart';
import '../quiz/presentation/quiz_screen.dart';
import '../reminders/presentation/reminders_screen.dart';
import '../roots/presentation/quran_roots_screen.dart';
import '../tajweed/presentation/tajweed_guide_screen.dart';
import '../tasbih/presentation/tasbih_screen.dart';
import '../topics/presentation/quran_topics_screen.dart';
import '../wasiyyah/presentation/wasiyyah_screen.dart';
import '../ziyarat/presentation/ziyarat_hub_screen.dart';
import '../audio/data/quran_page_data.dart';
import 'last_read_provider.dart';
import 'models/last_read_model.dart';
import 'quick_page_jump_dialog.dart';
import 'reader_provider.dart';
import 'verse_detail_view.dart';

class SurahListView extends ConsumerStatefulWidget {
  const SurahListView({super.key});

  @override
  ConsumerState<SurahListView> createState() => _SurahListViewState();
}

class _SurahListViewState extends ConsumerState<SurahListView> {
  final TextEditingController _filterController = TextEditingController();
  String _filterQuery = '';

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  String _normalizeText(String text) {
    return text
        .replaceAll('ي', 'ی')
        .replaceAll('ك', 'ک')
        .replaceAll('إ', 'ا')
        .replaceAll('أ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '')
        .toLowerCase()
        .trim();
  }

  int? _tryParsePageNumber(String query) {
    if (query.trim().isEmpty) return null;

    final clean = query
        .toLowerCase()
        .replaceAll('صفحه', '')
        .replaceAll('صفحة', '')
        .replaceAll('page', '')
        .replaceAll('p', '')
        .replaceAll('ص', '')
        .replaceAll('#', '')
        .replaceAll(':', '')
        .trim();

    final englishDigits = PersianDigitConverter.toEnglish(clean);
    final parsed = int.tryParse(englishDigits);
    if (parsed != null && parsed >= 1 && parsed <= QuranPageData.totalPages) {
      return parsed;
    }
    return null;
  }

  void _navigateToPage(BuildContext context, int pageNumber, List<Surah> surahs) {
    final pageVerses = QuranPageData.getVersesForPage(pageNumber);
    if (pageVerses.isEmpty) return;

    final firstVerse = pageVerses.first;
    final targetSurah = surahs.firstWhere(
      (s) => s.number == firstVerse.surahId,
      orElse: () => surahs.first,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VerseDetailView(
          surah: targetSurah,
          initialVerseNumber: firstVerse.verseNumber,
        ),
      ),
    );
  }

  Widget _buildQuickPageJumpCard(
    BuildContext context,
    AppLocalizations loc,
    bool isPersian,
    int pageNumber,
    List<Surah> surahs,
  ) {
    final pageStr = isPersian
        ? PersianDigitConverter.toPersian('$pageNumber')
        : '$pageNumber';
    final pageSummary = QuranPageData.getPageSummary(pageNumber, isPersian: isPersian);

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.surfaceContainerHighest,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _navigateToPage(context, pageNumber, surahs),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_stories_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${loc.translate("jumpDirectlyToPage")} $pageStr',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isPersian ? 'صفحه قرآن' : 'Quran Page',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        pageSummary,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.tonalIcon(
                  onPressed: () => _navigateToPage(context, pageNumber, surahs),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                  label: Text(loc.translate('goToPage')),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;
    final surahsAsync = ref.watch(surahListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('surahs')),
        actions: [
          IconButton(
            icon: const Icon(Icons.find_in_page_rounded),
            tooltip: loc.translate('quickPageJump'),
            onPressed: () {
              final surahs = surahsAsync.valueOrNull ?? [];
              QuickPageJumpDialog.show(
                context,
                onPageSelected: (pageNum) {
                  Navigator.pop(context);
                  _navigateToPage(context, pageNum, surahs);
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.view_list_rounded),
            tooltip: loc.translate('quranIndex'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QuranIndexScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.volunteer_activism_outlined),
            tooltip: loc.translate('quranicDuas'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QuranicDuasScreen()),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.apps_rounded),
            tooltip: isPersian ? 'ابزارها و امکانات اسلامی' : 'Islamic Companion Tools',
            onSelected: (val) {
              Widget? screen;
              switch (val) {
                case 'ziyarat':
                  screen = const ZiyaratHubScreen();
                  break;
                case 'parables':
                  screen = const QuranParablesScreen();
                  break;
                case 'wasiyyah':
                  screen = const WasiyyahScreen();
                  break;
                case 'calendar':
                  screen = const IslamicCalendarScreen();
                  break;
                case 'roots':
                  screen = const QuranRootsScreen();
                  break;
                case 'adhkar':
                  screen = const DailyAdhkarScreen();
                  break;
                case 'tajweed':
                  screen = const TajweedGuideScreen();
                  break;
                case 'topics':
                  screen = const QuranTopicsScreen();
                  break;
                case 'asmaul_husna':
                  screen = const AsmaulHusnaScreen();
                  break;
                case 'smart_bookmarks':
                  screen = const SmartBookmarksScreen();
                  break;
                case 'reminders':
                  screen = const RemindersScreen();
                  break;
                case 'analytics':
                  screen = const AnalyticsScreen();
                  break;
                case 'quiz':
                  screen = const QuizScreen();
                  break;
                case 'tasbih':
                  screen = const TasbihScreen();
                  break;
                case 'prayer_times':
                  screen = const PrayerTimesScreen();
                  break;
                case 'notes':
                  screen = const NotesHubScreen();
                  break;
                case 'khatmah':
                  screen = const KhatmahScreen();
                  break;
              }
              if (screen != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => screen!),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'ziyarat',
                child: Row(
                  children: [
                    const Icon(Icons.mosque_outlined, size: 20),
                    const SizedBox(width: 10),
                    Text(loc.translate('ziyaratSanctuary')),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'parables',
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb_outline_rounded, size: 20),
                    const SizedBox(width: 10),
                    Text(loc.translate('quranParables')),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'wasiyyah',
                child: Row(
                  children: [
                    const Icon(Icons.history_edu_outlined, size: 20),
                    const SizedBox(width: 10),
                    Text(loc.translate('wasiyyahBuilder')),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'calendar',
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined, size: 20),
                    const SizedBox(width: 10),
                    Text(loc.translate('islamicCalendar')),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'roots',
                child: Row(
                  children: [
                    const Icon(Icons.auto_stories_outlined, size: 20),
                    const SizedBox(width: 10),
                    Text(loc.translate('quranRoots')),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'adhkar',
                child: Row(
                  children: [
                    const Icon(Icons.wb_twilight_outlined, size: 20),
                    const SizedBox(width: 10),
                    Text(loc.translate('dailyAdhkar')),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'tajweed',
                child: Row(
                  children: [
                    const Icon(Icons.palette_outlined, size: 20),
                    const SizedBox(width: 10),
                    Text(loc.translate('tajweedGuide')),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'topics',
                child: Row(
                  children: [
                    const Icon(Icons.category_outlined, size: 20),
                    const SizedBox(width: 10),
                    Text(loc.translate('quranTopics')),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'asmaul_husna',
                child: Row(
                  children: [
                    const Icon(Icons.stars_outlined, size: 20),
                    const SizedBox(width: 10),
                    Text(loc.translate('asmaulHusna')),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'smart_bookmarks',
                child: Row(
                  children: [
                    const Icon(Icons.collections_bookmark_outlined, size: 20),
                    const SizedBox(width: 10),
                    Text(loc.translate('smartBookmarks')),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'reminders',
                child: Row(
                  children: [
                    const Icon(Icons.notifications_active_outlined, size: 20),
                    const SizedBox(width: 10),
                    Text(loc.translate('reminders')),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'analytics',
                child: Row(
                  children: [
                    const Icon(Icons.analytics_outlined, size: 20),
                    const SizedBox(width: 10),
                    Text(loc.translate('readingAnalytics')),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'quiz',
                child: Row(
                  children: [
                    const Icon(Icons.quiz_outlined, size: 20),
                    const SizedBox(width: 10),
                    Text(loc.translate('quranQuiz')),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'tasbih',
                child: Row(
                  children: [
                    const Icon(Icons.touch_app_outlined, size: 20),
                    const SizedBox(width: 10),
                    Text(loc.translate('digitalTasbih')),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'prayer_times',
                child: Row(
                  children: [
                    const Icon(Icons.explore_outlined, size: 20),
                    const SizedBox(width: 10),
                    Text(loc.translate('prayerTimesAndQibla')),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'notes',
                child: Row(
                  children: [
                    const Icon(Icons.note_alt_outlined, size: 20),
                    const SizedBox(width: 10),
                    Text(loc.translate('notesAndHighlights')),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'khatmah',
                child: Row(
                  children: [
                    const Icon(Icons.auto_stories_outlined, size: 20),
                    const SizedBox(width: 10),
                    Text(loc.translate('khatmah')),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(isPersian ? Icons.language : Icons.g_translate),
            tooltip: loc.translate('language'),
            onPressed: () {
              ref.read(localeProvider.notifier).toggleLanguage();
            },
          ),
        ],
      ),
      body: surahsAsync.when(
        data: (surahs) {
          if (surahs.isEmpty) {
            return const Center(child: Text('No Surahs found.'));
          }

          final cleanQuery = _normalizeText(_filterQuery)
              .replaceAll('سوره', '')
              .replaceAll('سورة', '')
              .replaceAll('surah', '')
              .replaceAll('sura', '')
              .trim();

          final filteredSurahs = cleanQuery.isEmpty
              ? surahs
              : surahs.where((surah) {
                  final sNum = surah.number.toString();
                  final sNumFa = PersianDigitConverter.toPersian(sNum);
                  final nameAr = _normalizeText(surah.nameArabic);
                  final nameFa = _normalizeText(surah.namePersian);
                  final nameEn = surah.nameEnglish.toLowerCase();

                  return sNum == cleanQuery ||
                      sNumFa == cleanQuery ||
                      nameAr.contains(cleanQuery) ||
                      nameFa.contains(cleanQuery) ||
                      nameEn.contains(cleanQuery);
                }).toList();

          final lastRead = ref.watch(lastReadProvider);

          return Column(
            children: [
              if (_filterQuery.isEmpty) ...[
                if (lastRead != null)
                  _buildLastReadBanner(context, loc, isPersian, lastRead, surahs),
                const KhatmahHomeBanner(),
              ],
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _filterController,
                  decoration: InputDecoration(
                    hintText: isPersian
                        ? 'جستجوی سوره (نام، شماره، معنی...)'
                        : 'Search Surah (name, number, meaning...)',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _filterQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _filterController.clear();
                              setState(() {
                                _filterQuery = '';
                              });
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _filterQuery = value;
                    });
                  },
                  onSubmitted: (value) {
                    final targetPage = _tryParsePageNumber(value);
                    if (targetPage != null) {
                      _navigateToPage(context, targetPage, surahs);
                    }
                  },
                ),
              ),
              if (_tryParsePageNumber(_filterQuery) != null)
                _buildQuickPageJumpCard(
                  context,
                  loc,
                  isPersian,
                  _tryParsePageNumber(_filterQuery)!,
                  surahs,
                ),
              Expanded(
                child: filteredSurahs.isEmpty
                    ? Center(
                        child: Text(
                          isPersian ? 'سوره‌ای یافت نشد.' : 'No matching Surah found.',
                        ),
                      )
                    : ListView.separated(
                        itemCount: filteredSurahs.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final surah = filteredSurahs[index];
                          final numberStr = isPersian
                              ? PersianDigitConverter.toPersian('${surah.number}')
                              : '${surah.number}';
                          final rawNameStr =
                              isPersian ? surah.namePersian : surah.nameEnglish;
                          final cleanNameStr = rawNameStr
                              .replaceAll(RegExp(r'\s*\([^)]*\)'), '')
                              .trim();
                          final revType = surah.revelationType == 'Makki'
                              ? loc.translate('makki')
                              : loc.translate('madani');
                          final verseCountStr = isPersian
                              ? PersianDigitConverter.toPersian(
                                  '${surah.verseCount}')
                              : '${surah.verseCount}';

                          final formattedTitle =
                              (cleanNameStr.isEmpty || cleanNameStr == surah.nameArabic)
                                  ? surah.nameArabic
                                  : '${surah.nameArabic} ($cleanNameStr)';

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              child: Text(
                                numberStr,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              ),
                            ),
                            title: Text(
                              formattedTitle,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                                '$revType • $verseCountStr ${loc.translate('versesCount')}'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      VerseDetailView(surah: surah),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildLastReadBanner(
    BuildContext context,
    AppLocalizations loc,
    bool isPersian,
    LastReadEntry lastRead,
    List<Surah> surahs,
  ) {
    final surahName = isPersian
        ? (lastRead.surahNamePersian.isNotEmpty ? lastRead.surahNamePersian : lastRead.surahNameArabic)
        : (lastRead.surahNameEnglish.isNotEmpty ? lastRead.surahNameEnglish : lastRead.surahNameArabic);

    final cleanSurahName = surahName.replaceAll(RegExp(r'\s*\([^)]*\)'), '').trim();
    final verseNumStr = isPersian
        ? PersianDigitConverter.toPersian('${lastRead.verseNumber}')
        : '${lastRead.verseNumber}';
    final pageNumStr = isPersian
        ? PersianDigitConverter.toPersian('${lastRead.pageNumber}')
        : '${lastRead.pageNumber}';
    final juzNumStr = isPersian
        ? PersianDigitConverter.toPersian('${lastRead.juzNumber}')
        : '${lastRead.juzNumber}';

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.6),
            Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            final targetSurah = surahs.firstWhere(
              (s) => s.number == lastRead.surahId,
              orElse: () => surahs.first,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VerseDetailView(
                  surah: targetSurah,
                  initialVerseNumber: lastRead.verseNumber,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.auto_stories_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                loc.translate('lastRead'),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${loc.translate("page")} $pageNumStr • ${loc.translate("juz")} $juzNumStr',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$cleanSurahName (${lastRead.surahNameArabic}) - ${isPersian ? "آیه" : "Ayah"} $verseNumStr',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FilledButton.tonalIcon(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: () {
                        final targetSurah = surahs.firstWhere(
                          (s) => s.number == lastRead.surahId,
                          orElse: () => surahs.first,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VerseDetailView(
                              surah: targetSurah,
                              initialVerseNumber: lastRead.verseNumber,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_arrow_rounded, size: 18),
                      label: Text(
                        loc.translate('continueReading'),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                if (lastRead.verseTextPreview != null && lastRead.verseTextPreview!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    lastRead.verseTextPreview!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
