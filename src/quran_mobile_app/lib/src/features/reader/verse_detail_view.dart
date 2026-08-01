import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/persian_digit_converter.dart';
import '../bookmarks/bookmarks_provider.dart';
import 'reader_provider.dart';

class VerseDetailView extends ConsumerWidget {
  final Surah surah;

  const VerseDetailView({super.key, required this.surah});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;
    final versesAsync = ref.watch(surahVersesProvider(surah.id));

    final surahTitle = isPersian ? surah.namePersian : surah.nameEnglish;

    return Scaffold(
      appBar: AppBar(
        title: Text('${surah.nameArabic} - $surahTitle'),
      ),
      body: versesAsync.when(
        data: (verses) {
          if (verses.isEmpty) {
            return const Center(child: Text('No Verses found.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: verses.length,
            itemBuilder: (context, index) {
              final item = verses[index];
              final verse = item.verse;
              final trans = item.translation;

              final ayahKey = PersianDigitConverter.formatAyahKey(
                surah.number,
                verse.verseNumber,
                isPersian: isPersian,
              );

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
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
                              color: Theme.of(context).colorScheme.primary,
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
                      const SizedBox(height: 12),
                      // Arabic Uthmani Text
                      Text(
                        verse.textUthmani,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: AppTheme.getArabicQuranTextStyle(fontSize: 22),
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 8),
                      // Translation
                      Text(
                        trans?.translationText ?? 'No translation available.',
                        textAlign: isPersian ? TextAlign.right : TextAlign.left,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
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
