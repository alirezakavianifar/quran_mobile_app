import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/utils/persian_digit_converter.dart';
import 'reader_provider.dart';
import 'verse_detail_view.dart';

class SurahListView extends ConsumerWidget {
  const SurahListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;
    final surahsAsync = ref.watch(surahListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('surahs')),
        actions: [
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
          return ListView.separated(
            itemCount: surahs.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final surah = surahs[index];
              final numberStr = isPersian
                  ? PersianDigitConverter.toPersian('${surah.number}')
                  : '${surah.number}';
              final nameStr = isPersian ? surah.namePersian : surah.nameEnglish;
              final revType = surah.revelationType == 'Makki'
                  ? loc.translate('makki')
                  : loc.translate('madani');
              final verseCountStr = isPersian
                  ? PersianDigitConverter.toPersian('${surah.verseCount}')
                  : '${surah.verseCount}';

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Text(
                    numberStr,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                title: Text(
                  '${surah.nameArabic} ($nameStr)',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('$revType • $verseCountStr ${loc.translate('versesCount')}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VerseDetailView(surah: surah),
                    ),
                  );
                },
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
