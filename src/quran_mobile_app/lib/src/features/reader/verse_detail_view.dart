import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/persian_digit_converter.dart';
import '../audio/presentation/audio_player_bottom_bar.dart';
import '../audio/presentation/audio_player_notifier.dart';
import '../audio/presentation/reciter_selector_dialog.dart';
import '../bookmarks/bookmarks_provider.dart';
import '../tafsir/tafsir_bottom_sheet.dart';
import '../../core/settings/settings_provider.dart';
import 'reader_provider.dart';

class VerseDetailView extends ConsumerWidget {
  final Surah surah;

  const VerseDetailView({super.key, required this.surah});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;
    final versesAsync = ref.watch(surahVersesProvider(surah.number));
    final audioState = ref.watch(audioPlayerProvider);
    final audioNotifier = ref.read(audioPlayerProvider.notifier);
    final surahTitle = isPersian ? surah.namePersian : surah.nameEnglish;
    final settings = ref.watch(settingsProvider);

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

    return Scaffold(
      appBar: AppBar(
        title: Text('${surah.nameArabic} - $surahTitle'),
        actions: [
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
      body: versesAsync.when(
        data: (verses) {
          if (verses.isEmpty) {
            return const Center(child: Text('No Verses found.'));
          }
          final showBismillahHeader = surah.number != 1 && surah.number != 9;
          final totalCount = showBismillahHeader ? verses.length + 1 : verses.length;

          return ListView.builder(
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

              var arabicText = verse.textUthmani;
              if (surah.number != 1 && surah.number != 9 && verse.verseNumber == 1) {
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
                surah.number,
                verse.verseNumber,
                isPersian: isPersian,
              );

              final isAudioActive = audioState.isVerseActive(surah.number, verse.verseNumber);
              final isPlayingThisVerse = isAudioActive && audioState.isPlaying;
              final isLoadingThisVerse = isAudioActive && audioState.isLoading;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: isAudioActive ? 4 : 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isAudioActive
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    width: isAudioActive ? 2 : 0,
                  ),
                ),
                color: isAudioActive
                    ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.15)
                    : null,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isAudioActive
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.secondary,
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
                                          surah.number,
                                          verse.verseNumber,
                                          verses.length,
                                        );
                                      },
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
                                      surah: surah,
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
                                      .addBookmark(surah.number, verse.verseNumber);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${loc.translate("addBookmark")} $ayahKey',
                                      ),
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
                      // Arabic Uthmani Text with dynamic font & size from settings
                      Text(
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
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
