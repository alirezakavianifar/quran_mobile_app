import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/utils/persian_digit_converter.dart';
import 'bookmarks_provider.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;
    final bookmarksAsync = ref.watch(bookmarksProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('bookmarks')),
      ),
      body: bookmarksAsync.when(
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: Text(
                loc.translate('noBookmarks'),
                style: const TextStyle(fontSize: 16),
              ),
            );
          }
          return ListView.separated(
            itemCount: list.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = list[index];
              final keyStr = PersianDigitConverter.formatAyahKey(
                item.surahId,
                item.verseNumber,
                isPersian: isPersian,
              );

              return ListTile(
                leading: const Icon(Icons.bookmark, color: Colors.amber),
                title: Text('${loc.translate("versesCount")} [$keyStr]'),
                subtitle: item.note != null && item.note!.isNotEmpty
                    ? Text(item.note!)
                    : Text('Saved on ${item.createdAt.toString().substring(0, 10)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    ref.read(bookmarksProvider.notifier).removeBookmark(item.id);
                  },
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
