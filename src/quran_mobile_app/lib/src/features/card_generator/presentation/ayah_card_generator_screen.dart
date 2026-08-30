import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/persian_digit_converter.dart';
import '../models/card_theme_model.dart';

class AyahCardGeneratorScreen extends ConsumerStatefulWidget {
  final String surahNameFa;
  final String surahNameEn;
  final int surahNumber;
  final int verseNumber;
  final String arabicText;
  final String translationText;

  const AyahCardGeneratorScreen({
    super.key,
    required this.surahNameFa,
    required this.surahNameEn,
    required this.surahNumber,
    required this.verseNumber,
    required this.arabicText,
    required this.translationText,
  });

  @override
  ConsumerState<AyahCardGeneratorScreen> createState() =>
      _AyahCardGeneratorScreenState();
}

class _AyahCardGeneratorScreenState extends ConsumerState<AyahCardGeneratorScreen> {
  final GlobalKey _cardBoundaryKey = GlobalKey();
  CardAspectRatio _aspectRatio = CardAspectRatio.square;
  CardThemeStyle _selectedStyle = CardThemeStyle.emeraldGold;
  double _arabicFontSize = 24.0;
  bool _showTranslation = true;
  bool _showBismillah = true;
  bool _isGenerating = false;

  Future<void> _exportCard(BuildContext context, bool isPersian) async {
    setState(() => _isGenerating = true);
    try {
      final boundary =
          _cardBoundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      final pngBytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final filePath =
          '${tempDir.path}/ayah_${widget.surahNumber}_${widget.verseNumber}_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(filePath);
      await file.writeAsBytes(pngBytes);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isPersian
                        ? 'تصویر آیه با کیفیت بالا ذخیره شد ($filePath)'
                        : 'Ayah card image exported successfully ($filePath)',
                  ),
                ),
              ],
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error exporting image: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;
    final activeTheme = AyahCardTheme.getTheme(_selectedStyle);

    final surahTitle = isPersian ? widget.surahNameFa : widget.surahNameEn;
    final ayahKey = PersianDigitConverter.formatAyahKey(
      widget.surahNumber,
      widget.verseNumber,
      isPersian: isPersian,
    );
    final citation = '$surahTitle - [$ayahKey]';

    return Scaffold(
      appBar: AppBar(
        title: Text(isPersian ? 'سازنده کارت تصویری و استوری آیه' : 'Ayah Story & Card Designer'),
        actions: [
          IconButton(
            icon: _isGenerating
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.download_rounded),
            tooltip: isPersian ? 'ذخیره تصویر' : 'Export Image',
            onPressed: _isGenerating ? null : () => _exportCard(context, isPersian),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Live Preview Stage
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: AspectRatio(
                  aspectRatio: _aspectRatio == CardAspectRatio.square ? 1.0 : 9.0 / 16.0,
                  child: RepaintBoundary(
                    key: _cardBoundaryKey,
                    child: Container(
                      decoration: activeTheme.backgroundDecoration.copyWith(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: activeTheme.borderColor.withValues(alpha: 0.6),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Top Header: Bismillah / Islamic Ornament
                          Column(
                            children: [
                              if (_showBismillah)
                                Text(
                                  'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.rtl,
                                  style: AppTheme.getArabicQuranTextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Amiri',
                                    color: activeTheme.citationColor,
                                  ),
                                ),
                              const SizedBox(height: 6),
                              Container(
                                width: 60,
                                height: 2,
                                decoration: BoxDecoration(
                                  color: activeTheme.citationColor.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            ],
                          ),

                          // Center: Arabic Text & Translation
                          Expanded(
                            child: Center(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      widget.arabicText,
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                      style: AppTheme.getArabicQuranTextStyle(
                                        fontSize: _arabicFontSize,
                                        fontFamily: 'Amiri',
                                        color: activeTheme.arabicTextColor,
                                      ).copyWith(
                                        height: 1.6,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (_showTranslation && widget.translationText.isNotEmpty) ...[
                                      const SizedBox(height: 16),
                                      Container(
                                        width: 40,
                                        height: 1,
                                        color: activeTheme.borderColor.withValues(alpha: 0.3),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        widget.translationText,
                                        textAlign: TextAlign.center,
                                        textDirection:
                                            isPersian ? TextDirection.rtl : TextDirection.ltr,
                                        style: TextStyle(
                                          fontSize: 13,
                                          height: 1.5,
                                          color: activeTheme.translationTextColor,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Bottom Footer: Citation & App Attribution
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: activeTheme.citationColor.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.menu_book_rounded, size: 14, color: activeTheme.citationColor),
                                const SizedBox(width: 6),
                                Text(
                                  citation,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: activeTheme.citationColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 2. Customization Controls Card
            Card(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Aspect Ratio Selector
                    Text(
                      isPersian ? 'ابعاد کارت:' : 'Aspect Ratio:',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            avatar: const Icon(Icons.crop_square_rounded, size: 16),
                            label: Text(isPersian ? 'پست (۱:۱ مربع)' : 'Square (1:1)'),
                            selected: _aspectRatio == CardAspectRatio.square,
                            onSelected: (_) =>
                                setState(() => _aspectRatio = CardAspectRatio.square),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ChoiceChip(
                            avatar: const Icon(Icons.stay_current_portrait_rounded, size: 16),
                            label: Text(isPersian ? 'استوری (۹:۱۶ عمودی)' : 'Story (9:16)'),
                            selected: _aspectRatio == CardAspectRatio.story,
                            onSelected: (_) =>
                                setState(() => _aspectRatio = CardAspectRatio.story),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // Theme Selector
                    Text(
                      isPersian ? 'قالب و سبک طراحی:' : 'Card Theme Style:',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: AyahCardTheme.presets.map((t) {
                        final isSelected = _selectedStyle == t.style;
                        return ChoiceChip(
                          avatar: Icon(t.themeIcon, size: 16),
                          label: Text(isPersian ? t.nameFa : t.nameEn),
                          selected: isSelected,
                          onSelected: (_) => setState(() => _selectedStyle = t.style),
                        );
                      }).toList(),
                    ),
                    const Divider(height: 24),

                    // Font Size Slider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isPersian ? 'اندازه قلم عربی:' : 'Arabic Font Size:',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        Text('${_arabicFontSize.toInt()} pt', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Slider(
                      min: 18.0,
                      max: 34.0,
                      divisions: 8,
                      value: _arabicFontSize,
                      onChanged: (val) => setState(() => _arabicFontSize = val),
                    ),
                    const Divider(height: 16),

                    // Toggles
                    SwitchListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(isPersian ? 'نمایش ترجمه' : 'Show Translation'),
                      value: _showTranslation,
                      onChanged: (val) => setState(() => _showTranslation = val),
                    ),
                    SwitchListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(isPersian ? 'نمایش بسم‌الله' : 'Show Bismillah'),
                      value: _showBismillah,
                      onChanged: (val) => setState(() => _showBismillah = val),
                    ),

                    const SizedBox(height: 12),

                    // Export Button
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        icon: const Icon(Icons.download_rounded),
                        label: Text(
                          isPersian ? 'ذخیره و ایجاد تصویر آیه' : 'Export & Save Ayah Card',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: _isGenerating ? null : () => _exportCard(context, isPersian),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
