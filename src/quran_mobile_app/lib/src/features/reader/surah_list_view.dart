import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/utils/persian_digit_converter.dart';
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
                          final nameStr =
                              isPersian ? surah.namePersian : surah.nameEnglish;
                          final revType = surah.revelationType == 'Makki'
                              ? loc.translate('makki')
                              : loc.translate('madani');
                          final verseCountStr = isPersian
                              ? PersianDigitConverter.toPersian(
                                  '${surah.verseCount}')
                              : '${surah.verseCount}';

                          final formattedTitle = nameStr.contains('(')
                              ? '${surah.nameArabic} - $nameStr'
                              : '${surah.nameArabic} ($nameStr)';

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
