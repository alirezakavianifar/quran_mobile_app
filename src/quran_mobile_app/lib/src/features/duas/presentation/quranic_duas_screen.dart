import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/persian_digit_converter.dart';
import '../../audio/presentation/audio_player_notifier.dart';
import '../data/quranic_duas_data.dart';
import '../models/quranic_dua_model.dart';

class QuranicDuasScreen extends ConsumerStatefulWidget {
  const QuranicDuasScreen({super.key});

  @override
  ConsumerState<QuranicDuasScreen> createState() => _QuranicDuasScreenState();
}

class _QuranicDuasScreenState extends ConsumerState<QuranicDuasScreen> {
  DuaCategory? _selectedCategory;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _normalize(String text) {
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
    final audioNotifier = ref.read(audioPlayerProvider.notifier);
    final audioState = ref.watch(audioPlayerProvider);

    final categories = [
      (null, isPersian ? 'همه ادعیه' : 'All Duas', Icons.all_inclusive_rounded),
      (DuaCategory.forgiveness, isPersian ? 'آمرزش و توبه' : 'Forgiveness', Icons.shield_outlined),
      (DuaCategory.family, isPersian ? 'خانواده و فرزندان' : 'Family & Parents', Icons.family_restroom_rounded),
      (DuaCategory.faith, isPersian ? 'هدایت و ایمان' : 'Faith & Guidance', Icons.auto_awesome_rounded),
      (DuaCategory.protection, isPersian ? 'آسانی و رفع سختی' : 'Relief & Ease', Icons.volunteer_activism_rounded),
      (DuaCategory.knowledge, isPersian ? 'علم و حکمت' : 'Knowledge', Icons.menu_book_rounded),
      (DuaCategory.patience, isPersian ? 'صبر و پیروزی' : 'Patience', Icons.flag_rounded),
    ];

    final filteredDuas = QuranicDuasData.allDuas.where((dua) {
      if (_selectedCategory != null && dua.category != _selectedCategory) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _normalize(_searchQuery);
        final inArabic = _normalize(dua.arabicText).contains(q);
        final inFa = _normalize(dua.translationFa).contains(q);
        final inEn = dua.translationEn.toLowerCase().contains(q);
        final inSurah = _normalize(dua.surahNameFa).contains(q) ||
            dua.surahNameEn.toLowerCase().contains(q);
        return inArabic || inFa || inEn || inSurah;
      }
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(isPersian ? 'ادعیه و ۴۰ ربنای قرآن' : 'Quranic Duas & 40 Rabbana'),
      ),
      body: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: isPersian
                    ? 'جستجو در متن دعا، ترجمه یا نام سوره...'
                    : 'Search duas, translations, or surahs...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),

          // 2. Category Filter Chips
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, idx) {
                final cat = categories[idx];
                final isSelected = _selectedCategory == cat.$1;
                return ChoiceChip(
                  avatar: Icon(
                    cat.$3,
                    size: 16,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.primary,
                  ),
                  label: Text(cat.$2),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() => _selectedCategory = cat.$1);
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // 3. Duas List
          Expanded(
            child: filteredDuas.isEmpty
                ? Center(
                    child: Text(
                      isPersian ? 'دعایی یافت نشد.' : 'No duas found matching query.',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                    itemCount: filteredDuas.length,
                    itemBuilder: (context, idx) {
                      final item = filteredDuas[idx];
                      final surahTitle = isPersian ? item.surahNameFa : item.surahNameEn;
                      final verseStr = isPersian
                          ? PersianDigitConverter.toPersian('${item.verseNumber}')
                          : '${item.verseNumber}';
                      final citation = '[$surahTitle: $verseStr]';

                      final isAudioPlaying = audioState.isVerseActive(item.surahNumber, item.verseNumber) &&
                          audioState.isPlaying;

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Card Header: Category & Citation Badge
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      citation,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          isAudioPlaying
                                              ? Icons.pause_circle_filled
                                              : Icons.play_circle_outline,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                        tooltip: isPersian ? 'تلاوت صوتی' : 'Play Recitation',
                                        onPressed: () {
                                          audioNotifier.playVerse(
                                            item.surahNumber,
                                            item.verseNumber,
                                            item.verseNumber,
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.copy_outlined, size: 20),
                                        tooltip: isPersian ? 'کپی دعا' : 'Copy Dua',
                                        onPressed: () {
                                          final copyText =
                                              '${item.arabicText}\n\n${isPersian ? item.translationFa : item.translationEn}\n\n$citation';
                                          Clipboard.setData(ClipboardData(text: copyText));
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(isPersian
                                                  ? 'متن دعا در حافظه کپی شد'
                                                  : 'Dua copied to clipboard'),
                                              duration: const Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Arabic Text
                              Text(
                                item.arabicText,
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                                style: AppTheme.getArabicQuranTextStyle(
                                  fontSize: 22,
                                  fontFamily: 'Amiri',
                                  color: Theme.of(context).colorScheme.primary,
                                ).copyWith(fontWeight: FontWeight.bold, height: 1.5),
                              ),
                              const SizedBox(height: 12),
                              const Divider(),
                              const SizedBox(height: 8),

                              // Translation
                              Text(
                                isPersian ? item.translationFa : item.translationEn,
                                textAlign: isPersian ? TextAlign.right : TextAlign.left,
                                style: const TextStyle(fontSize: 14, height: 1.5),
                              ),
                              const SizedBox(height: 10),

                              // Theme Context Note
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.lightbulb_outline_rounded,
                                      size: 16,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        isPersian
                                            ? item.themeDescriptionFa
                                            : item.themeDescriptionEn,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
