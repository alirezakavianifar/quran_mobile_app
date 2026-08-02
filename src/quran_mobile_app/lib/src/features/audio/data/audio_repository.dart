import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_http_client.dart';

class Reciter {
  final String id;
  final String nameArabic;
  final String namePersian;
  final String nameEnglish;
  final String style;
  final String baseUrl;

  Reciter({
    required this.id,
    required this.nameArabic,
    required this.namePersian,
    required this.nameEnglish,
    required this.style,
    required this.baseUrl,
  });

  factory Reciter.fromJson(Map<String, dynamic> json) {
    return Reciter(
      id: json['id'] ?? '',
      nameArabic: json['nameArabic'] ?? '',
      namePersian: json['namePersian'] ?? '',
      nameEnglish: json['nameEnglish'] ?? '',
      style: json['style'] ?? '',
      baseUrl: json['baseUrl'] ?? '',
    );
  }
}

class AudioRepository {
  final DioHttpClient _client;

  AudioRepository(this._client);

  Future<List<Reciter>> fetchReciters() async {
    try {
      final response = await _client.dio.get('/api/v1/audio/reciters');
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List).map((e) => Reciter.fromJson(e)).toList();
      }
      return _getFallbackReciters();
    } catch (e) {
      return _getFallbackReciters();
    }
  }

  Future<String> getAyahAudioUrl(String reciterId, int surahId, int verseId) async {
    try {
      final response = await _client.dio.get('/api/v1/audio/ayah/$reciterId/$surahId/$verseId');
      if (response.statusCode == 200 && response.data != null) {
        return response.data['audioUrl'] ?? '';
      }
      return _buildFallbackUrl(reciterId, surahId, verseId);
    } catch (e) {
      return _buildFallbackUrl(reciterId, surahId, verseId);
    }
  }

  List<Reciter> _getFallbackReciters() {
    return [
      Reciter(
        id: 'alafasy',
        nameArabic: 'مشاري راشد العفاسي',
        namePersian: 'مشاری راشد العفاسی',
        nameEnglish: 'Mishary Rashid Alafasy',
        style: 'Murattal',
        baseUrl: 'https://everyayah.com/data/Alafasy_128kbps/',
      ),
      Reciter(
        id: 'husary',
        nameArabic: 'محمود خليل الحصري',
        namePersian: 'محمود خلیل الحصری',
        nameEnglish: 'Mahmoud Khalil Al-Husary',
        style: 'Murattal',
        baseUrl: 'https://everyayah.com/data/Husary_128kbps/',
      )
    ];
  }

  String _buildFallbackUrl(String reciterId, int surahId, int verseId) {
    final s = surahId.toString().padLeft(3, '0');
    final v = verseId.toString().padLeft(3, '0');
    final folderName = switch (reciterId.toLowerCase()) {
      'husary' => 'Husary_128kbps',
      'abdulbasit' => 'Abdul_Basit_Mujawwad_128kbps',
      'parhizgar' => 'Parhizgar_48kbps',
      _ => 'Alafasy_128kbps',
    };
    return 'https://everyayah.com/data/$folderName/$s$v.mp3';
  }
}

final audioRepositoryProvider = Provider<AudioRepository>((ref) {
  final client = ref.watch(httpClientProvider);
  return AudioRepository(client);
});
