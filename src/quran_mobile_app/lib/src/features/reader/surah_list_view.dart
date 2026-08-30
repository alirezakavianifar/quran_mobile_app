import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

          return Column(
            children: [
              if (_filterQuery.isEmpty) const KhatmahHomeBanner(),
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
                ),
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
}
