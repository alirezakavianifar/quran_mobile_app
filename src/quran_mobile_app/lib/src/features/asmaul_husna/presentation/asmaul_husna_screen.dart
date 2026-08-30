import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/persian_digit_converter.dart';
import '../../tasbih/presentation/tasbih_screen.dart';
import '../data/asmaul_husna_data.dart';
import '../models/asmaul_husna_model.dart';

class AsmaulHusnaScreen extends ConsumerStatefulWidget {
  const AsmaulHusnaScreen({super.key});

  @override
  ConsumerState<AsmaulHusnaScreen> createState() => _AsmaulHusnaScreenState();
}

class _AsmaulHusnaScreenState extends ConsumerState<AsmaulHusnaScreen> {
  String _searchQuery = '';

  void _showNameDetail(DivineName name, bool isPersian) {
    final numStr = isPersian
        ? PersianDigitConverter.toPersian('${name.number}')
        : '${name.number}';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '#$numStr',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.amber.shade900,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name.nameAr,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: AppTheme.getArabicQuranTextStyle(
                fontSize: 32,
                fontFamily: 'Amiri',
                color: Theme.of(context).colorScheme.primary,
              ).copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              name.transliteration,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              isPersian ? 'معنا و مفهوم:' : 'Meaning:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              isPersian ? name.meaningFa : name.meaningEn,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isPersian ? 'اثر معنوی و برکت ذکر:' : 'Spiritual Reflection:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              isPersian ? name.spiritualBenefitFa : name.spiritualBenefitEn,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.menu_book_rounded,
                      size: 16, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      name.quranCitation,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              icon: const Icon(Icons.touch_app_rounded),
              label: Text(isPersian ? 'ذکر در تسبیح‌شمار' : 'Count in Tasbih'),
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TasbihScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;
    var list = AsmaulHusnaData.allNames;

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      list = list.where((n) {
        return n.nameAr.contains(q) ||
            n.transliteration.toLowerCase().contains(q) ||
            n.meaningFa.toLowerCase().contains(q) ||
            n.meaningEn.toLowerCase().contains(q);
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isPersian ? 'اسماء الحسنی (نام‌های نیکوی خداوند)' : 'Asmaul Husna (99 Names)'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: isPersian ? 'جستجوی نام یا معنا...' : 'Search Name or Meaning...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          const Divider(height: 1),

          // 99 Names Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.95,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final name = list[index];
                final numStr = isPersian
                    ? PersianDigitConverter.toPersian('${name.number}')
                    : '${name.number}';

                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => _showNameDetail(name, isPersian),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '#$numStr',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber.shade900,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            name.nameAr,
                            textDirection: TextDirection.rtl,
                            style: AppTheme.getArabicQuranTextStyle(
                              fontSize: 20,
                              fontFamily: 'Amiri',
                              color: Theme.of(context).colorScheme.primary,
                            ).copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            name.transliteration,
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.outline,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isPersian ? name.meaningFa : name.meaningEn,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
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
