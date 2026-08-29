import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/persian_digit_converter.dart';
import '../models/ayah_note_model.dart';
import 'ayah_notes_provider.dart';

class NotesHubScreen extends ConsumerStatefulWidget {
  const NotesHubScreen({super.key});

  @override
  ConsumerState<NotesHubScreen> createState() => _NotesHubScreenState();
}

class _NotesHubScreenState extends ConsumerState<NotesHubScreen> {
  String? _selectedColorHex;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final notesMap = ref.watch(ayahNotesProvider);
    final notifier = ref.read(ayahNotesProvider.notifier);
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;

    final allItems = notesMap.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    final filteredItems = allItems.where((item) {
      if (_selectedColorHex != null && item.colorHex != _selectedColorHex) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final text = (item.noteText ?? '').toLowerCase();
        final sNum = item.surahId.toString();
        final vNum = item.verseNumber.toString();
        if (!text.contains(query) && !sNum.contains(query) && !vNum.contains(query)) {
          return false;
        }
      }
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(isPersian ? 'یادداشت‌ها و هایلایت‌ها' : 'Notes & Highlights'),
      ),
      body: Column(
        children: [
          // Search Box
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: isPersian ? 'جستجو در یادداشت‌ها...' : 'Search in notes...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
            ),
          ),

          // Filter Palette Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
              children: [
                FilterChip(
                  label: Text(isPersian ? 'همه' : 'All'),
                  selected: _selectedColorHex == null,
                  onSelected: (_) => setState(() => _selectedColorHex = null),
                ),
                const SizedBox(width: 6),
                ...AyahHighlightPalette.options.map((opt) {
                  final isSelected = _selectedColorHex == opt.hex;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: FilterChip(
                      avatar: CircleAvatar(backgroundColor: opt.color, radius: 6),
                      label: Text(isPersian ? opt.labelFa : opt.labelEn),
                      selected: isSelected,
                      onSelected: (val) {
                        setState(() {
                          _selectedColorHex = val ? opt.hex : null;
                        });
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Notes List
          Expanded(
            child: filteredItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.note_alt_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          isPersian
                              ? 'هیچ یادداشت یا هایلایتی یافت نشد.'
                              : 'No notes or highlights found.',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final color = AyahHighlightPalette.getColorFromHex(item.colorHex);
                      final sNumStr = isPersian
                          ? PersianDigitConverter.toPersian('${item.surahId}')
                          : '${item.surahId}';
                      final vNumStr = isPersian
                          ? PersianDigitConverter.toPersian('${item.verseNumber}')
                          : '${item.verseNumber}';

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: color != null
                              ? BorderSide(color: color.withValues(alpha: 0.6), width: 1.5)
                              : BorderSide.none,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      if (color != null)
                                        Container(
                                          width: 10,
                                          height: 10,
                                          margin: const EdgeInsets.only(left: 6, right: 6),
                                          decoration: BoxDecoration(
                                            color: color,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      Text(
                                        isPersian
                                            ? 'سوره $sNumStr • آیه $vNumStr'
                                            : 'Surah $sNumStr • Ayah $vNumStr',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                    tooltip: isPersian ? 'حذف' : 'Delete',
                                    onPressed: () => notifier.deleteNote(item.surahId, item.verseNumber),
                                  ),
                                ],
                              ),
                              if (item.hasNote) ...[
                                const SizedBox(height: 6),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    item.noteText!,
                                    style: const TextStyle(fontSize: 14, height: 1.5),
                                  ),
                                ),
                              ],
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
