import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/persian_digit_converter.dart';
import 'tafsir_provider.dart';

class TafsirBottomSheet extends ConsumerWidget {
  final Surah surah;
  final Verse verse;

  const TafsirBottomSheet({
    super.key,
    required this.surah,
    required this.verse,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;
    final activeEdition = ref.watch(selectedTafsirEditionProvider);

    final param = TafsirQueryParam(verseId: verse.id, editionId: activeEdition);
    final tafsirAsync = ref.watch(verseTafsirProvider(param));

    final ayahKey = PersianDigitConverter.formatAyahKey(
      surah.number,
      verse.verseNumber,
      isPersian: isPersian,
    );

    final surahTitle = isPersian ? surah.namePersian : surah.nameEnglish;

    return Directionality(
      textDirection: isPersian ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Drag handle indicator
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),

            // Header Title & Ayah Key
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Icon(
                    Icons.auto_stories,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${loc.translate("ayahTafsirHeader")} ($surahTitle - [$ayahKey])',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            const Divider(),

            // Tafsir Edition Selector Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Row(
                children: [
                  Text(
                    '${loc.translate("selectTafsir")}:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: activeEdition,
                          isExpanded: true,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 'fa.noor',
                              child: Text(
                                loc.translate('tafsirNoor'),
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'fa.nemoneh',
                              child: Text(
                                loc.translate('tafsirNemoneh'),
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'fa.almizan',
                              child: Text(
                                loc.translate('tafsirAlmizan'),
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'en.ibnkathir',
                              child: Text(
                                loc.translate('tafsirIbnKathir'),
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              ref.read(selectedTafsirEditionProvider.notifier).state = val;
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Tafsir Content View
            Expanded(
              child: tafsirAsync.when(
                data: (tafsir) {
                  final textContent = tafsir?.contentText ?? loc.translate('noTafsirFound');

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Verse text preview box
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Text(
                            verse.textUthmani,
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style: AppTheme.getArabicQuranTextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Main Tafsir commentary body
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                            ),
                          ),
                          child: SelectableText(
                            textContent,
                            textAlign: activeEdition.startsWith('fa') ? TextAlign.right : TextAlign.left,
                            textDirection: activeEdition.startsWith('fa') ? TextDirection.rtl : TextDirection.ltr,
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.8,
                              fontFamily: isPersian ? 'Vazirmatn' : null,
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (err, _) => Center(
                  child: Text('Error loading Tafsir: $err'),
                ),
              ),
            ),

            // Action Footer (Copy button)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.copy),
                label: Text(loc.translate('copyTafsir')),
                onPressed: () {
                  final tafsirData = ref.read(verseTafsirProvider(param)).value;
                  if (tafsirData != null) {
                    final copyText = '${verse.textUthmani}\n\n[${surah.nameArabic} - $ayahKey]\n\n${tafsirData.contentText}';
                    Clipboard.setData(ClipboardData(text: copyText));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(loc.translate('copiedToClipboard')),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
