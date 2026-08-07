import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/app_localizations.dart';
import 'ai_chat_provider.dart';

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final TextEditingController _inputController = TextEditingController();

  Widget _buildFormattedMessage(String content, TextStyle baseStyle) {
    final lines = content.split('\n');
    final List<Widget> widgets = [];

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed == '---') {
        widgets.add(const Divider(height: 16));
        continue;
      }

      var textLine = line;
      bool isBullet = false;
      if (textLine.trimLeft().startsWith('* ')) {
        isBullet = true;
        textLine = textLine.trimLeft().substring(2);
      }

      final List<InlineSpan> spans = [];
      final regExp = RegExp(r'\*\*(.*?)\*\*');
      int lastMatchEnd = 0;

      for (final match in regExp.allMatches(textLine)) {
        if (match.start > lastMatchEnd) {
          spans.add(TextSpan(
            text: textLine.substring(lastMatchEnd, match.start),
            style: baseStyle,
          ));
        }
        spans.add(TextSpan(
          text: match.group(1),
          style: baseStyle.copyWith(fontWeight: FontWeight.bold),
        ));
        lastMatchEnd = match.end;
      }

      if (lastMatchEnd < textLine.length) {
        spans.add(TextSpan(
          text: textLine.substring(lastMatchEnd),
          style: baseStyle,
        ));
      }

      if (isBullet) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 4.0, top: 2.0, bottom: 2.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: baseStyle.copyWith(fontWeight: FontWeight.bold)),
                Expanded(child: SelectableText.rich(TextSpan(children: spans))),
              ],
            ),
          ),
        );
      } else {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: SelectableText.rich(TextSpan(children: spans)),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;
    final messages = ref.watch(aiChatProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('aiAssistant')),
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.psychology,
                            size: 64,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            loc.translate('askAiPlaceholder'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isUser = msg.senderRole == 'user';

                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.8,
                          ),
                          decoration: BoxDecoration(
                            color: isUser
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFormattedMessage(
                                msg.content,
                                TextStyle(
                                  color: isUser
                                      ? Colors.white
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color,
                                  fontSize: 15,
                                  height: 1.4,
                                ),
                              ),
                              if (msg.citations.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 6,
                                  children: msg.citations
                                      .map(
                                        (c) => Chip(
                                          label: Text(
                                            c,
                                            style: const TextStyle(fontSize: 11),
                                          ),
                                          visualDensity: VisualDensity.compact,
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    decoration: InputDecoration(
                      hintText: loc.translate('askAiPlaceholder'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final text = _inputController.text;
                    _inputController.clear();
                    ref
                        .read(aiChatProvider.notifier)
                        .sendQuestion(text, isPersian);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
