import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bookmark_collection_model.dart';

class EnhancedBookmarksRepository {
  static const String _foldersKey = 'quran_bookmark_folders_v1';
  static const String _bookmarksKey = 'quran_tagged_bookmarks_v1';

  Future<List<BookmarkFolder>> getFolders() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_foldersKey);
    if (jsonStr == null || jsonStr.isEmpty) {
      return BookmarkFolder.defaultPresets;
    }
    try {
      final list = jsonDecode(jsonStr) as List;
      return list.map((e) => BookmarkFolder.fromMap(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return BookmarkFolder.defaultPresets;
    }
  }

  Future<void> saveFolders(List<BookmarkFolder> folders) async {
    final prefs = await SharedPreferences.getInstance();
    final list = folders.map((f) => f.toMap()).toList();
    await prefs.setString(_foldersKey, jsonEncode(list));
  }

  Future<void> addFolder(BookmarkFolder folder) async {
    final current = await getFolders();
    if (!current.any((f) => f.id == folder.id)) {
      current.add(folder);
      await saveFolders(current);
    }
  }

  Future<void> deleteFolder(String folderId) async {
    if (folderId == 'default') return; // Prevent deleting default folder
    final current = await getFolders();
    current.removeWhere((f) => f.id == folderId);
    await saveFolders(current);

    // Reassign bookmarks in deleted folder to default
    final bookmarks = await getBookmarks();
    var changed = false;
    for (final key in bookmarks.keys) {
      if (bookmarks[key]!.folderId == folderId) {
        bookmarks[key] = bookmarks[key]!.copyWith(folderId: 'default');
        changed = true;
      }
    }
    if (changed) {
      await saveBookmarks(bookmarks);
    }
  }

  Future<Map<String, TaggedBookmark>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_bookmarksKey);
    if (jsonStr == null || jsonStr.isEmpty) {
      return {};
    }
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return map.map(
        (key, value) => MapEntry(
          key,
          TaggedBookmark.fromMap(value as Map<String, dynamic>),
        ),
      );
    } catch (_) {
      return {};
    }
  }

  Future<void> saveBookmarks(Map<String, TaggedBookmark> bookmarks) async {
    final prefs = await SharedPreferences.getInstance();
    final map = bookmarks.map((k, v) => MapEntry(k, v.toMap()));
    await prefs.setString(_bookmarksKey, jsonEncode(map));
  }

  Future<void> saveBookmark(TaggedBookmark bookmark) async {
    final current = await getBookmarks();
    current[bookmark.key] = bookmark;
    await saveBookmarks(current);
  }

  Future<void> removeBookmark(int surahNumber, int verseNumber) async {
    final current = await getBookmarks();
    current.remove('${surahNumber}_$verseNumber');
    await saveBookmarks(current);
  }

  Future<String> exportToJson() async {
    final folders = await getFolders();
    final bookmarks = await getBookmarks();
    final payload = {
      'exportedAt': DateTime.now().toIso8601String(),
      'folders': folders.map((f) => f.toMap()).toList(),
      'bookmarks': bookmarks.values.map((b) => b.toMap()).toList(),
    };
    return jsonEncode(payload);
  }

  Future<bool> importFromJson(String jsonString) async {
    try {
      final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
      if (decoded.containsKey('folders')) {
        final fList = (decoded['folders'] as List)
            .map((e) => BookmarkFolder.fromMap(e as Map<String, dynamic>))
            .toList();
        await saveFolders(fList);
      }
      if (decoded.containsKey('bookmarks')) {
        final bList = (decoded['bookmarks'] as List)
            .map((e) => TaggedBookmark.fromMap(e as Map<String, dynamic>))
            .toList();
        final map = {for (final b in bList) b.key: b};
        await saveBookmarks(map);
      }
      return true;
    } catch (_) {
      return false;
    }
  }
}

final enhancedBookmarksRepositoryProvider =
    Provider<EnhancedBookmarksRepository>((ref) => EnhancedBookmarksRepository());
