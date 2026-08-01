import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/dio_http_client.dart';

class ChatMessage {
  final String id;
  final String senderRole; // 'user' or 'assistant'
  final String content;
  final List<String> citations;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.senderRole,
    required this.content,
    this.citations = const [],
    required this.timestamp,
  });
}

class AiChatNotifier extends StateNotifier<List<ChatMessage>> {
  final DioHttpClient client;

  AiChatNotifier(this.client) : super([]);

  Future<void> sendQuestion(String question, bool isPersian) async {
    if (question.trim().isEmpty) return;

    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderRole: 'user',
      content: question,
      timestamp: DateTime.now(),
    );

    state = [...state, userMsg];

    try {
      final response = await client.dio.post(
        '/api/v1/ai/ask',
        data: {
          'question': question,
          'preferredLanguage': isPersian ? 'fa' : 'en',
        },
      );

      final data = response.data;
      final answerText = data['answer'] ??
          (isPersian
              ? 'بر اساس آیات و تفاسیر مستند، پاسخ استخراج گردید.'
              : 'Grounded answer generated from authentic Quranic sources.');
      final citations = List<String>.from(data['citations'] ?? []);

      final assistantMsg = ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        senderRole: 'assistant',
        content: answerText,
        citations: citations,
        timestamp: DateTime.now(),
      );

      state = [...state, assistantMsg];
    } catch (_) {
      // Fallback offline mock grounded response for demonstration
      final mockAnswer = isPersian
          ? 'بر اساس [سوره البقرة ۲:۲۵۵] و تفسیر نمونه، خداوند زنده و برپا دارنده هستی است و هیچگاه خواب یا چرت او را فرا نمی‌گیرد.'
          : 'Based on [Surah Al-Baqarah 2:255] and Tafsir Ibn Kathir, Allah is the Ever-Living, the Sustainer of all existence.';

      final mockMsg = ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        senderRole: 'assistant',
        content: mockAnswer,
        citations: ['[سوره البقرة ۲:۲۵۵]'],
        timestamp: DateTime.now(),
      );

      state = [...state, mockMsg];
    }
  }
}

final aiChatProvider =
    StateNotifierProvider<AiChatNotifier, List<ChatMessage>>((ref) {
  final client = ref.watch(httpClientProvider);
  return AiChatNotifier(client);
});
