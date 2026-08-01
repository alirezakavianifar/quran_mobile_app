import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/persian_digit_converter.dart';
import 'search_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;
    final resultsAsync = ref.watch(searchProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('search')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: loc.translate('searchPlaceholder'),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(searchProvider.notifier).performSearch('');
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (value) {
                ref.read(searchProvider.notifier).performSearch(value);
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: resultsAsync.when(
                data: (results) {
                  if (results.isEmpty) {
                    return Center(
                      child: Text(
                        _searchController.text.isEmpty
                            ? loc.translate('searchPlaceholder')
                            : 'No matching verses found.',
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final item = results[index];
                      final keyStr = PersianDigitConverter.formatAyahKey(
                        item.surahId,
                        item.verseNumber,
                        isPersian: isPersian,
                      );

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                '[$keyStr]',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item.textUthmani,
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                                style: AppTheme.getArabicQuranTextStyle(
                                    fontSize: 18),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item.translationText,
                                style: const TextStyle(fontSize: 14),
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
            ),
          ],
        ),
      ),
    );
  }
}
