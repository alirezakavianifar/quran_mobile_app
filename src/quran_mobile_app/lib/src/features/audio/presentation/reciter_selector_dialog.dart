import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_localizations.dart';
import 'audio_player_notifier.dart';

class ReciterSelectorDialog extends ConsumerWidget {
  const ReciterSelectorDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(audioPlayerProvider);
    final notifier = ref.read(audioPlayerProvider.notifier);
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.mic_outlined, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            isPersian ? 'انتخاب قاری' : 'Select Reciter',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: state.availableReciters.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              )
            : ListView.separated(
                shrinkWrap: true,
                itemCount: state.availableReciters.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final reciter = state.availableReciters[index];
                  final isSelected = state.currentReciter?.id == reciter.id;

                  final displayName = isPersian
                      ? (reciter.namePersian.isNotEmpty ? reciter.namePersian : reciter.nameArabic)
                      : (reciter.nameEnglish.isNotEmpty ? reciter.nameEnglish : reciter.nameArabic);

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                      foregroundColor: isSelected ? Colors.white : Colors.black87,
                      child: Text(
                        reciter.nameArabic.isNotEmpty ? reciter.nameArabic[0] : 'Q',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      displayName,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Theme.of(context).colorScheme.primary : null,
                      ),
                    ),
                    subtitle: Text(
                      '${reciter.nameArabic} (${reciter.style})',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      textDirection: TextDirection.rtl,
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
                        : null,
                    onTap: () {
                      notifier.selectReciter(reciter);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(isPersian ? 'انصراف' : 'Cancel'),
        ),
      ],
    );
  }
}
