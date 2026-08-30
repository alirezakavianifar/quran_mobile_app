import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../core/database/app_database.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/settings/models/user_settings.dart';
import '../../core/settings/settings_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/persian_digit_converter.dart';
import '../audio/presentation/audio_download_notifier.dart';
import '../audio/presentation/audio_player_bottom_bar.dart';
import '../audio/presentation/audio_player_notifier.dart';
import '../audio/presentation/reciter_selector_dialog.dart';
import '../analytics/presentation/reading_analytics_provider.dart';
import '../bookmarks/bookmarks_provider.dart';
import '../card_generator/presentation/ayah_card_generator_screen.dart';
import '../hifz/models/hifz_mode_model.dart';
import '../hifz/presentation/hifz_provider.dart';
import '../notes/models/ayah_note_model.dart';
import '../notes/presentation/ayah_notes_provider.dart';
import '../sajdah/models/sajdah_model.dart';
import '../sajdah/presentation/sajdah_dialog.dart';
import '../tafsir/tafsir_bottom_sheet.dart';
import 'reader_provider.dart';

class VerseDetailView extends ConsumerStatefulWidget {
  final Surah surah;

  const VerseDetailView({super.key, required this.surah});

  @override
  ConsumerState<VerseDetailView> createState() => _VerseDetailViewState();
}

class _VerseDetailViewState extends ConsumerState<VerseDetailView> {
  final ScrollController _scrollController = ScrollController();
  int _currentVisiblePage = 0;
  int _currentVisibleJuz = 0;
  List<VerseWithTranslation>? _lastVerses;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyWakelock(ref.read(settingsProvider).keepScreenOn);
      final currentReciterId = ref.read(settingsProvider).defaultReciterId;
      ref.read(audioDownloadProvider.notifier).checkSurahStatus(
            currentReciterId,
            widget.surah.number,
            widget.surah.verseCount,
          );
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    try {
      WakelockPlus.disable().catchError((_) {});
    } catch (_) {}
    super.dispose();
  }

  void _applyWakelock(bool keepOn) {
    try {
      if (keepOn) {
        WakelockPlus.enable().catchError((_) {});
      } else {
        WakelockPlus.disable().catchError((_) {});
      }
    } catch (_) {}
  }

  void _onScroll() {
    final verses = _lastVerses;
    if (verses == null || verses.isEmpty || !_scrollController.hasClients) return;

    const double estimatedItemHeight = 200.0;
    final offset = _scrollController.offset;
    final index = (offset / estimatedItemHeight).floor().clamp(0, verses.length - 1);
    final verse = verses[index].verse;

    if (verse.pageNumber != _currentVisiblePage || verse.juzNumber != _currentVisibleJuz) {
      setState(() {
        _currentVisiblePage = verse.pageNumber;
        _currentVisibleJuz = verse.juzNumber;
      });
    }
  }

  Widget _buildPageHeader(BuildContext context, AppLocalizations loc, bool isPersian, int pageNum, int juzNum) {
    final pageText = isPersian
        ? PersianDigitConverter.toPersian('$pageNum')
        : '$pageNum';
    final juzText = isPersian
        ? PersianDigitConverter.toPersian('$juzNum')
        : '$juzNum';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              thickness: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    size: 16,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${loc.translate("page")} $pageText • ${loc.translate("juz")} $juzText',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  void _showNoteAndHighlightDialog(
    BuildContext context,
    int surahNumber,
    int verseNumber,
    AppLocalizations loc,
  ) {
    final isPersian = loc.isPersian;
    final noteState = ref.read(ayahNotesProvider.notifier).getNote(surahNumber, verseNumber);
    final textController = TextEditingController(text: noteState?.noteText ?? '');
    String? selectedColorHex = noteState?.colorHex;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(loc.translate('addNoteAndHighlight')),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.translate('highlightColor'),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...AyahHighlightPalette.options.map((opt) {
                      final isSelected = selectedColorHex == opt.hex;
                      return InkWell(
                        onTap: () {
                          setDialogState(() {
                            selectedColorHex = isSelected ? null : opt.hex;
                          });
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: opt.color.withValues(alpha: isSelected ? 0.35 : 0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: opt.color,
                              width: isSelected ? 2.5 : 1.0,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(backgroundColor: opt.color, radius: 5),
                              const SizedBox(width: 6),
                              Text(
                                isPersian ? opt.labelFa : opt.labelEn,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    if (selectedColorHex != null)
                      ActionChip(
                        avatar: const Icon(Icons.close, size: 14),
                        label: Text(loc.translate('removeHighlight'), style: const TextStyle(fontSize: 11)),
                        onPressed: () {
                          setDialogState(() {
                            selectedColorHex = null;
                          });
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  isPersian ? 'یادداشت یا تدبر شخصی:' : 'Personal Reflection / Note:',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: textController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: loc.translate('personalNoteHint'),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(isPersian ? 'انصراف' : 'Cancel'),
            ),
            FilledButton(
              onPressed: () {
                ref.read(ayahNotesProvider.notifier).saveAyahNote(
                      surahId: surahNumber,
                      verseNumber: verseNumber,
                      noteText: textController.text.trim(),
                      colorHex: selectedColorHex,
                    );
                Navigator.pop(ctx);
              },
              child: Text(loc.translate('saveNote')),
            ),
          ],
        ),
      ),
    );
  }

  void _showVerseQuickActions({
    required BuildContext context,
    required Surah surah,
    required Verse verse,
    required Translation? trans,
    required int totalVerses,
    required AppLocalizations loc,
    required AudioPlayerNotifier audioNotifier,
    required AudioPlayerState audioState,
  }) {
    final isPersian = loc.isPersian;
    final isAudioActive = audioState.isVerseActive(surah.number, verse.verseNumber);
    final isPlaying = isAudioActive && audioState.isPlaying;
    final ayahKey = PersianDigitConverter.formatAyahKey(
      surah.number,
      verse.verseNumber,
      isPersian: isPersian,
    );
    final surahTitle = (isPersian ? surah.namePersian : surah.nameEnglish)
        .replaceAll(RegExp(r'\s*\([^)]*\)'), '')
        .trim();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Directionality(
        textDirection: isPersian ? TextDirection.rtl : TextDirection.ltr,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '$surahTitle - [$ayahKey]',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: Icon(
                  isPlaying ? Icons.pause_circle_filled : Icons.play_circle_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(loc.translate('listenAyah')),
                onTap: () {
                  Navigator.pop(ctx);
                  audioNotifier.playVerse(surah.number, verse.verseNumber, totalVerses);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.auto_stories_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(loc.translate('ayahTafsirHeader')),
                onTap: () {
                  Navigator.pop(ctx);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => TafsirBottomSheet(surah: surah, verse: verse),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.palette_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(loc.translate('addNoteAndHighlight')),
                onTap: () {
                  Navigator.pop(ctx);
                  _showNoteAndHighlightDialog(context, surah.number, verse.verseNumber, loc);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.bookmark_border,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(loc.translate('addBookmark')),
                onTap: () {
                  Navigator.pop(ctx);
                  ref.read(bookmarksProvider.notifier).addBookmark(surah.number, verse.verseNumber);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${loc.translate("addBookmark")} $ayahKey'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.copy_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(loc.translate('copyAyah')),
                onTap: () {
                  Navigator.pop(ctx);
                  final textToCopy = '${verse.textUthmani}\n${trans?.translationText ?? ""}\n[$surahTitle - $ayahKey]';
                  Clipboard.setData(ClipboardData(text: textToCopy));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(loc.translate('ayahCopied')),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(loc.translate('createAyahCard')),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AyahCardGeneratorScreen(
                        surahNameFa: surah.namePersian,
                        surahNameEn: surah.nameEnglish,
                        surahNumber: surah.number,
                        verseNumber: verse.verseNumber,
                        arabicText: verse.textUthmani,
                        translationText: trans?.translationText ?? '',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onVerseSelected({
    required BuildContext context,
    required Surah surah,
    required Verse verse,
    required Translation? trans,
    required int totalVerses,
    required UserSettings settings,
    required AppLocalizations loc,
    required AudioPlayerNotifier audioNotifier,
    required AudioPlayerState audioState,
  }) {
    switch (settings.defaultVerseTapAction) {
      case 'playAudio':
        audioNotifier.playVerse(surah.number, verse.verseNumber, totalVerses);
        break;
      case 'showMenu':
        _showVerseQuickActions(
          context: context,
          surah: surah,
          verse: verse,
          trans: trans,
          totalVerses: totalVerses,
          loc: loc,
          audioNotifier: audioNotifier,
          audioState: audioState,
        );
        break;
      case 'showTafsir':
      default:
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => TafsirBottomSheet(
            surah: surah,
            verse: verse,
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;
    final versesAsync = ref.watch(surahVersesProvider(widget.surah.number));
    final audioState = ref.watch(audioPlayerProvider);
    final audioNotifier = ref.read(audioPlayerProvider.notifier);
    final surahTitle = (isPersian ? widget.surah.namePersian : widget.surah.nameEnglish)
        .replaceAll(RegExp(r'\s*\([^)]*\)'), '')
        .trim();
    final settings = ref.watch(settingsProvider);

    ref.listen<bool>(settingsProvider.select((s) => s.keepScreenOn), (previous, next) {
      _applyWakelock(next);
    });

    ref.listen<AudioPlayerState>(audioPlayerProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    final activePageStr = _currentVisiblePage > 0
        ? (isPersian ? PersianDigitConverter.toPersian('$_currentVisiblePage') : '$_currentVisiblePage')
        : '';
    final activeJuzStr = _currentVisibleJuz > 0
        ? (isPersian ? PersianDigitConverter.toPersian('$_currentVisibleJuz') : '$_currentVisibleJuz')
        : '';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${widget.surah.nameArabic} - $surahTitle', style: const TextStyle(fontSize: 17)),
            if (_currentVisiblePage > 0) ...[
              const SizedBox(height: 2),
              Text(
                '${loc.translate("page")} $activePageStr • ${loc.translate("juz")} $activeJuzStr',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ],
        ),
        actions: [
          Consumer(
            builder: (context, ref, _) {
              final currentReciterId = ref.watch(audioPlayerProvider).currentReciter?.id ??
                  ref.watch(settingsProvider).defaultReciterId;
              final downloadMap = ref.watch(audioDownloadProvider);
              final key = '${currentReciterId}_${widget.surah.number}';
              final downloadState = downloadMap[key] ??
                  SurahDownloadState(
                    reciterId: currentReciterId,
                    surahId: widget.surah.number,
                    totalVerses: widget.surah.verseCount,
                  );
              final notifier = ref.read(audioDownloadProvider.notifier);

              if (downloadState.isDownloading) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: downloadState.progressRatio,
                            strokeWidth: 3,
                          ),
                          Text(
                            '${(downloadState.progressRatio * 100).toInt()}%',
                            style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else if (downloadState.isCompleted) {
                return PopupMenuButton<String>(
                  icon: const Icon(Icons.offline_pin_rounded, color: Colors.green),
                  tooltip: loc.translate('surahDownloadedReady'),
                  onSelected: (val) {
                    if (val == 'delete') {
                      notifier.deleteSurahDownload(
                        currentReciterId,
                        widget.surah.number,
                        widget.surah.verseCount,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(loc.translate('deleteSurahAudio'))),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                          const SizedBox(width: 8),
                          Text(loc.translate('deleteSurahAudio')),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.download_for_offline_outlined),
                  tooltip: loc.translate('downloadSurahTooltip'),
                  onPressed: () {
                    notifier.downloadSurah(
                      currentReciterId,
                      widget.surah.number,
                      widget.surah.verseCount,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(loc.translate('downloadingSurah'))),
                    );
                  },
                );
              }
            },
          ),
          IconButton(
            icon: Icon(
              ref.watch(hifzProvider).isEnabled
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_outlined,
              color: ref.watch(hifzProvider).isEnabled
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
            tooltip: loc.translate('hifzMode'),
            onPressed: () {
              ref.read(hifzProvider.notifier).toggleHifzMode();
            },
          ),
          IconButton(
            icon: const Icon(Icons.mic_outlined),
            tooltip: isPersian ? 'انتخاب قاری' : 'Select Reciter',
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const ReciterSelectorDialog(),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const AudioPlayerBottomBar(),
      body: Column(
        children: [
          if (ref.watch(hifzProvider).isEnabled)
            _buildHifzControlBar(context, ref, loc, isPersian),
          Expanded(
            child: versesAsync.when(
              data: (verses) {
                if (verses.isEmpty) {
                  return const Center(child: Text('No Verses found.'));
                }

                _lastVerses = verses;
                if (_currentVisiblePage == 0) {
                  _currentVisiblePage = verses.first.verse.pageNumber;
                  _currentVisibleJuz = verses.first.verse.juzNumber;
                }

                final showBismillahHeader = widget.surah.number != 1 && widget.surah.number != 9;
                final totalCount = showBismillahHeader ? verses.length + 1 : verses.length;

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            itemCount: totalCount,
            itemBuilder: (context, index) {
              if (showBismillahHeader && index == 0) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: AppTheme.getArabicQuranTextStyle(
                        fontSize: settings.arabicFontSize + 2,
                        fontFamily: settings.arabicFontFamily,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ).copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }

              final verseIndex = showBismillahHeader ? index - 1 : index;
              final item = verses[verseIndex];
              final verse = item.verse;
              final trans = item.translation;

              final isFirstVerseOfPage = verseIndex == 0 ||
                  verses[verseIndex - 1].verse.pageNumber != verse.pageNumber;

              var arabicText = verse.textUthmani;
              if (widget.surah.number != 1 && widget.surah.number != 9 && verse.verseNumber == 1) {
                const bismillahPatterns = [
                  'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ ',
                  'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
                  'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ ',
                  'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
                  'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ ',
                  'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ',
                ];
                for (final pat in bismillahPatterns) {
                  if (arabicText.startsWith(pat)) {
                    arabicText = arabicText.substring(pat.length).trim();
                    break;
                  }
                }
              }

              final ayahKey = PersianDigitConverter.formatAyahKey(
                widget.surah.number,
                verse.verseNumber,
                isPersian: isPersian,
              );

              final pageNumberStr = isPersian
                  ? PersianDigitConverter.toPersian('${verse.pageNumber}')
                  : '${verse.pageNumber}';

              final isAudioActive = audioState.isVerseActive(widget.surah.number, verse.verseNumber);
              final isPlayingThisVerse = isAudioActive && audioState.isPlaying;
              final isLoadingThisVerse = isAudioActive && audioState.isLoading;

              final notesMap = ref.watch(ayahNotesProvider);
              final ayahNote = notesMap['${widget.surah.number}_${verse.verseNumber}'];
              final highlightColor = AyahHighlightPalette.getColorFromHex(ayahNote?.colorHex);
              final sajdahInfo = SajdahData.getSajdahInfo(widget.surah.number, verse.verseNumber);

              final verseCard = Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: isAudioActive ? 4 : (highlightColor != null ? 2 : 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isAudioActive
                        ? Theme.of(context).colorScheme.primary
                        : (highlightColor ?? Colors.transparent),
                    width: isAudioActive ? 2 : (highlightColor != null ? 1.5 : 0),
                  ),
                ),
                color: isAudioActive
                    ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.15)
                    : (highlightColor != null ? highlightColor.withValues(alpha: 0.12) : null),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    _onVerseSelected(
                      context: context,
                      surah: widget.surah,
                      verse: verse,
                      trans: trans,
                      totalVerses: verses.length,
                      settings: settings,
                      loc: loc,
                      audioNotifier: audioNotifier,
                      audioState: audioState,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isAudioActive
                                        ? Theme.of(context).colorScheme.primary
                                        : (highlightColor ?? Theme.of(context).colorScheme.secondary),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '[$ayahKey]',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${loc.translate("page")} $pageNumberStr',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                if (sajdahInfo != null) ...[
                                  const SizedBox(width: 6),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => SajdahDialog(sajdahInfo: sajdahInfo),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: sajdahInfo.isWajib
                                            ? Colors.red.withValues(alpha: 0.15)
                                            : Colors.amber.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: sajdahInfo.isWajib
                                              ? Colors.red.shade700
                                              : Colors.amber.shade800,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '۩',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: sajdahInfo.isWajib
                                                  ? Colors.red.shade700
                                                  : Colors.amber.shade800,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            sajdahInfo.isWajib
                                                ? loc.translate('wajibSajdah')
                                                : loc.translate('mustahabSajdah'),
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: sajdahInfo.isWajib
                                                  ? Colors.red.shade700
                                                  : Colors.amber.shade800,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            Row(
                              children: [
                                isLoadingThisVerse
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        ),
                                      )
                                    : IconButton(
                                        icon: Icon(
                                          isPlayingThisVerse
                                              ? Icons.pause_circle_filled
                                              : Icons.play_circle_outline,
                                          color: isAudioActive
                                              ? Theme.of(context).colorScheme.primary
                                              : Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                                        ),
                                        tooltip: isPersian ? 'پخش تلاوت' : 'Recite Ayah',
                                        onPressed: () {
                                          audioNotifier.playVerse(
                                            widget.surah.number,
                                            verse.verseNumber,
                                            verses.length,
                                          );
                                        },
                                      ),
                                IconButton(
                                  icon: Icon(
                                    ayahNote?.hasNote == true
                                        ? Icons.note_alt_rounded
                                        : (ayahNote?.hasHighlight == true ? Icons.palette : Icons.palette_outlined),
                                    color: highlightColor ?? (ayahNote?.hasNote == true ? Theme.of(context).colorScheme.primary : null),
                                    size: 20,
                                  ),
                                  tooltip: loc.translate('addNoteAndHighlight'),
                                  onPressed: () => _showNoteAndHighlightDialog(
                                    context,
                                    widget.surah.number,
                                    verse.verseNumber,
                                    loc,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.auto_stories_outlined),
                                  tooltip: isPersian ? 'تفسیر آیه (استاد قرائتی / نمونه)' : 'Ayah Tafsir',
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (_) => TafsirBottomSheet(
                                        surah: widget.surah,
                                        verse: verse,
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.bookmark_border),
                                  onPressed: () {
                                    ref
                                        .read(bookmarksProvider.notifier)
                                        .addBookmark(widget.surah.number, verse.verseNumber);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${loc.translate("addBookmark")} $ayahKey'),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Arabic Uthmani Text (Standard or Hifz Mask Mode)
                        ref.watch(hifzProvider).isEnabled
                            ? _buildHifzArabicText(
                                context,
                                verse,
                                arabicText,
                                settings,
                                isAudioActive,
                                ref.watch(hifzProvider),
                                ref,
                              )
                            : Text(
                                arabicText,
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                                style: AppTheme.getArabicQuranTextStyle(
                                  fontSize: settings.arabicFontSize,
                                  fontFamily: settings.arabicFontFamily,
                                  color: isAudioActive ? Theme.of(context).colorScheme.primary : null,
                                ).copyWith(
                                  fontWeight: isAudioActive ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                        if (settings.showTranslation && trans != null) ...[
                          const SizedBox(height: 12),
                          const Divider(),
                          const SizedBox(height: 8),
                          // Translation with dynamic font size
                          Text(
                            trans.translationText,
                            textAlign: isPersian ? TextAlign.right : TextAlign.left,
                            style: TextStyle(
                              fontSize: settings.translationFontSize,
                              height: 1.5,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            trans.authorName,
                            style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ],
                        if (ayahNote?.hasNote == true && ayahNote!.noteText != null) ...[
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: (highlightColor ?? Theme.of(context).colorScheme.primaryContainer)
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: (highlightColor ?? Theme.of(context).colorScheme.primary)
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.edit_note_rounded,
                                  size: 18,
                                  color: highlightColor ?? Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    ayahNote!.noteText!,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      height: 1.4,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );

              if (isFirstVerseOfPage) {
                return Column(
                  children: [
                    _buildPageHeader(context, loc, isPersian, verse.pageNumber, verse.juzNumber),
                    verseCard,
                  ],
                );
              }

              return verseCard;
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
          ),
        ],
      ),
    );
  }

  Widget _buildHifzControlBar(
      BuildContext context, WidgetRef ref, AppLocalizations loc, bool isPersian) {
    final notifier = ref.read(hifzProvider.notifier);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.visibility_off_rounded,
                  size: 16, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                loc.translate('hifzMode'),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              TextButton(
                onPressed: () => notifier.maskAllInSurah(),
                child: Text(loc.translate('hifzMaskAll'),
                    style: const TextStyle(fontSize: 11)),
              ),
              TextButton(
                onPressed: () => notifier.revealAllInSurah(
                    widget.surah.number, widget.surah.verseCount),
                child: Text(loc.translate('hifzRevealAll'),
                    style: const TextStyle(fontSize: 11)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHifzArabicText(
    BuildContext context,
    Verse verse,
    String arabicText,
    UserSettings settings,
    bool isAudioActive,
    HifzState hifzState,
    WidgetRef ref,
  ) {
    if (hifzState.isVerseRevealed(widget.surah.number, verse.verseNumber)) {
      return Text(
        arabicText,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        style: AppTheme.getArabicQuranTextStyle(
          fontSize: settings.arabicFontSize,
          fontFamily: settings.arabicFontFamily,
          color: isAudioActive ? Theme.of(context).colorScheme.primary : null,
        ),
      );
    }

    final words =
        arabicText.split(' ').where((w) => w.trim().isNotEmpty).toList();

    return Wrap(
      alignment: WrapAlignment.end,
      textDirection: TextDirection.rtl,
      spacing: 6,
      runSpacing: 8,
      children: List.generate(words.length, (wordIdx) {
        final word = words[wordIdx];
        final isRevealed = hifzState.isWordRevealed(
            widget.surah.number, verse.verseNumber, wordIdx);

        if (isRevealed) {
          return InkWell(
            onTap: () => ref.read(hifzProvider.notifier).toggleWordReveal(
                widget.surah.number, verse.verseNumber, wordIdx),
            child: Text(
              word,
              textDirection: TextDirection.rtl,
              style: AppTheme.getArabicQuranTextStyle(
                fontSize: settings.arabicFontSize,
                fontFamily: settings.arabicFontFamily,
                color: Theme.of(context).colorScheme.primary,
              ).copyWith(fontWeight: FontWeight.bold),
            ),
          );
        }

        String maskedText;
        if (hifzState.maskMode == HifzMaskMode.firstLetterOnly &&
            word.isNotEmpty) {
          maskedText = '${word[0]}...';
        } else {
          maskedText = ' ۞ ';
        }

        return InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => ref.read(hifzProvider.notifier).toggleWordReveal(
              widget.surah.number, verse.verseNumber, wordIdx),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: 1,
              ),
            ),
            child: Text(
              maskedText,
              textDirection: TextDirection.rtl,
              style: AppTheme.getArabicQuranTextStyle(
                fontSize: settings.arabicFontSize * 0.85,
                fontFamily: settings.arabicFontFamily,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        );
      }),
    );
  }
}
