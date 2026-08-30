import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/persian_digit_converter.dart';
import '../../reader/reader_provider.dart';
import '../../reader/verse_detail_view.dart';
import '../data/enhanced_bookmarks_repository.dart';
import '../models/bookmark_collection_model.dart';

class SmartBookmarksScreen extends ConsumerStatefulWidget {
  const SmartBookmarksScreen({super.key});

  @override
  ConsumerState<SmartBookmarksScreen> createState() => _SmartBookmarksScreenState();
}

class _SmartBookmarksScreenState extends ConsumerState<SmartBookmarksScreen> {
  String _selectedFolderId = 'all';
  String? _selectedTag;
  List<BookmarkFolder> _folders = [];
  Map<String, TaggedBookmark> _bookmarks = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final repo = ref.read(enhancedBookmarksRepositoryProvider);
    final f = await repo.getFolders();
    final b = await repo.getBookmarks();
    if (mounted) {
      setState(() {
        _folders = f;
        _bookmarks = b;
        _isLoading = false;
      });
    }
  }

  void _showCreateFolderDialog() {
    final titleFaController = TextEditingController();
    final titleEnController = TextEditingController();
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isPersian ? 'ایجاد پوشه نشان جدید' : 'New Bookmark Folder'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleFaController,
              decoration: InputDecoration(
                labelText: isPersian ? 'نام پوشه (فارسی)' : 'Folder Title (Persian)',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: titleEnController,
              decoration: InputDecoration(
                labelText: isPersian ? 'نام پوشه (انگلیسی)' : 'Folder Title (English)',
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isPersian ? 'انصراف' : 'Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final fa = titleFaController.text.trim();
              final en = titleEnController.text.trim();
              if (fa.isNotEmpty || en.isNotEmpty) {
                final newFolder = BookmarkFolder(
                  id: 'folder_${DateTime.now().millisecondsSinceEpoch}',
                  titleFa: fa.isNotEmpty ? fa : en,
                  titleEn: en.isNotEmpty ? en : fa,
                );
                await ref.read(enhancedBookmarksRepositoryProvider).addFolder(newFolder);
                Navigator.pop(ctx);
                _loadData();
              }
            },
            child: Text(isPersian ? 'ایجاد' : 'Create'),
          ),
        ],
      ),
    );
  }

  void _exportBookmarks() async {
    final jsonStr = await ref.read(enhancedBookmarksRepositoryProvider).exportToJson();
    await Clipboard.setData(ClipboardData(text: jsonStr));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).isPersian
                ? 'پشتیبان نشان‌ها در کلیپ‌بورد کپی شد (JSON)'
                : 'Bookmarks backup JSON copied to clipboard',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;
    final surahsAsync = ref.watch(surahListProvider);

    var filteredBookmarks = _bookmarks.values.toList();
    if (_selectedFolderId != 'all') {
      filteredBookmarks =
          filteredBookmarks.where((b) => b.folderId == _selectedFolderId).toList();
    }
    if (_selectedTag != null) {
      filteredBookmarks =
          filteredBookmarks.where((b) => b.tags.contains(_selectedTag)).toList();
    }

    // Collect all available tags
    final allTags = <String>{};
    for (final b in _bookmarks.values) {
      allTags.addAll(b.tags);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isPersian ? 'مجموعه نشان‌ها و برچسب‌ها' : 'Smart Bookmark Collections'),
        actions: [
          IconButton(
            icon: const Icon(Icons.create_new_folder_outlined),
            tooltip: isPersian ? 'پوشه جدید' : 'New Folder',
            onPressed: _showCreateFolderDialog,
          ),
          IconButton(
            icon: const Icon(Icons.backup_outlined),
            tooltip: isPersian ? 'پشتیبان‌گیری (JSON)' : 'Export Backup',
            onPressed: _exportBookmarks,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 1. Folder Selector Carousel
                Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(isPersian ? 'همه نشان‌ها' : 'All Bookmarks'),
                          selected: _selectedFolderId == 'all',
                          onSelected: (_) => setState(() => _selectedFolderId = 'all'),
                        ),
                      ),
                      ..._folders.map((f) {
                        final count =
                            _bookmarks.values.where((b) => b.folderId == f.id).length;
                        final countStr = isPersian
                            ? PersianDigitConverter.toPersian('$count')
                            : '$count';

                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Text(
                              '${isPersian ? f.titleFa : f.titleEn} ($countStr)',
                            ),
                            selected: _selectedFolderId == f.id,
                            onSelected: (_) => setState(() => _selectedFolderId = f.id),
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                // 2. Tag Filter Chips (if any exist)
                if (allTags.isNotEmpty)
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        ...allTags.map((tag) {
                          final isSelected = _selectedTag == tag;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6.0),
                            child: ChoiceChip(
                              label: Text('#$tag', style: const TextStyle(fontSize: 11)),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedTag = selected ? tag : null;
                                });
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                const Divider(height: 1),

                // 3. Bookmarks List
                Expanded(
                  child: filteredBookmarks.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.bookmark_border_rounded,
                                size: 54,
                                color: Theme.of(context).colorScheme.outlineVariant,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                isPersian ? 'هیچ نشانی در این بخش یافت نشد.' : 'No bookmarks found.',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredBookmarks.length,
                          itemBuilder: (context, index) {
                            final b = filteredBookmarks[index];
                            final surahNumStr = isPersian
                                ? PersianDigitConverter.toPersian('${b.surahNumber}')
                                : '${b.surahNumber}';
                            final verseNumStr = isPersian
                                ? PersianDigitConverter.toPersian('${b.verseNumber}')
                                : '${b.verseNumber}';

                            final folder = _folders.firstWhere(
                              (f) => f.id == b.folderId,
                              orElse: () => _folders.first,
                            );

                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ListTile(
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primaryContainer,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '$surahNumStr:$verseNumStr',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  '${isPersian ? "سوره شماره" : "Surah"} $surahNumStr • ${isPersian ? "آیه" : "Ayah"} $verseNumStr',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surfaceContainerHighest,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        isPersian ? folder.titleFa : folder.titleEn,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                    if (b.note != null && b.note!.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        b.note!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded,
                                      size: 20, color: Colors.red),
                                  onPressed: () async {
                                    await ref
                                        .read(enhancedBookmarksRepositoryProvider)
                                        .removeBookmark(b.surahNumber, b.verseNumber);
                                    _loadData();
                                  },
                                ),
                                onTap: () {
                                  surahsAsync.whenData((surahs) {
                                    final target = surahs.firstWhere(
                                      (s) => s.number == b.surahNumber,
                                      orElse: () => surahs.first,
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => VerseDetailView(surah: target),
                                      ),
                                    );
                                  });
                                },
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
