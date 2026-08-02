import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../reader/reader_provider.dart';

/// Active selected Tafsir Edition (defaults to 'fa.noor' - Tafsir Noor by Dr. Mohsen Qara'ati)
final selectedTafsirEditionProvider = StateProvider<String>((ref) => 'fa.noor');

class TafsirQueryParam {
  final int verseId;
  final String editionId;

  TafsirQueryParam({required this.verseId, required this.editionId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TafsirQueryParam &&
          runtimeType == other.runtimeType &&
          verseId == other.verseId &&
          editionId == other.editionId;

  @override
  int get hashCode => verseId.hashCode ^ editionId.hashCode;
}

final verseTafsirProvider =
    FutureProvider.family<Tafsir?, TafsirQueryParam>((ref, param) async {
  final db = ref.watch(databaseProvider);
  return await db.getTafsirForVerse(param.verseId, editionId: param.editionId);
});
