import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/settings/settings_provider.dart';
import '../../core/theme/app_theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final isPersian = settings.appLanguage == 'fa';

    return Scaffold(
      appBar: AppBar(
        title: Text(isPersian ? 'تنظیمات' : 'Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: isPersian ? 'بازنشانی تنظیمات' : 'Reset to Defaults',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(isPersian ? 'بازنشانی تنظیمات' : 'Reset Settings'),
                  content: Text(
                    isPersian
                        ? 'آیا مطمئن هستید که می‌خواهید همه تنظیمات را به حالت پیش‌فرض برگردانید؟'
                        : 'Are you sure you want to reset all settings to default values?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text(isPersian ? 'انصراف' : 'Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(isPersian ? 'تایید' : 'Reset'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await settingsNotifier.resetToDefaults();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isPersian
                            ? 'تنظیمات با موفقیت بازنشانی شد'
                            : 'Settings restored to defaults',
                      ),
                    ),
                  );
                }
              }
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        children: [
          // 1. Quran Reader Settings
          _buildSectionHeader(
            context,
            icon: Icons.menu_book_rounded,
            title: isPersian ? 'تنظیمات قرائت و متن' : 'Quran Reader & Typography',
          ),
          Card(
            margin: const EdgeInsets.only(bottom: 20),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Font Family Selector
                  Text(
                    isPersian ? 'قلم متن عربی' : 'Arabic Script Font',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<String>(
                    segments: [
                      ButtonSegment(
                        value: 'Amiri',
                        label: Text(isPersian ? 'امیری' : 'Amiri'),
                      ),
                      ButtonSegment(
                        value: 'Scheherazade New',
                        label: Text(isPersian ? 'شهرزاد' : 'Scheherazade'),
                      ),
                      ButtonSegment(
                        value: 'Lateef',
                        label: Text(isPersian ? 'لطیف' : 'Lateef'),
                      ),
                    ],
                    selected: {settings.arabicFontFamily},
                    onSelectionChanged: (newSelection) {
                      settingsNotifier.updateArabicFontFamily(newSelection.first);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Arabic Font Size Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isPersian ? 'اندازه خط عربی' : 'Arabic Font Size',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('${settings.arabicFontSize.round()} pt'),
                    ],
                  ),
                  Slider(
                    value: settings.arabicFontSize,
                    min: 18.0,
                    max: 42.0,
                    divisions: 12,
                    onChanged: (val) {
                      settingsNotifier.updateArabicFontSize(val);
                    },
                  ),
                  const SizedBox(height: 12),

                  // Translation Font Size Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isPersian ? 'اندازه خط ترجمه' : 'Translation Font Size',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('${settings.translationFontSize.round()} pt'),
                    ],
                  ),
                  Slider(
                    value: settings.translationFontSize,
                    min: 12.0,
                    max: 28.0,
                    divisions: 8,
                    onChanged: (val) {
                      settingsNotifier.updateTranslationFontSize(val);
                    },
                  ),
                  const SizedBox(height: 12),

                  // Live Preview Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer.withAlpha(50),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary.withAlpha(80),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'پیش‌نمایش / Preview',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: AppTheme.getArabicQuranTextStyle(
                            fontSize: settings.arabicFontSize,
                            fontFamily: settings.arabicFontFamily,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        if (settings.showTranslation) ...[
                          const SizedBox(height: 4),
                          Text(
                            isPersian
                                ? 'به نام خداوند بخشنده مهربان'
                                : 'In the name of Allah, the Entirely Merciful, the Especially Merciful.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: settings.translationFontSize,
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Divider(height: 28),

                  SwitchListTile(
                    title: Text(isPersian ? 'نمایش ترجمه' : 'Show Translation'),
                    value: settings.showTranslation,
                    onChanged: (val) => settingsNotifier.updateShowTranslation(val),
                    contentPadding: EdgeInsets.zero,
                  ),
                  SwitchListTile(
                    title: Text(isPersian ? 'نمایش آوانویسی' : 'Show Transliteration'),
                    value: settings.showTransliteration,
                    onChanged: (val) => settingsNotifier.updateShowTransliteration(val),
                    contentPadding: EdgeInsets.zero,
                  ),
                  const Divider(height: 28),

                  // Verse Selection Action Selector
                  Text(
                    isPersian ? 'عملیات پیش‌فرض لمس آیه' : 'Default Verse Tap Action',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isPersian
                        ? 'تعیین رفتاری که با لمس مستقیم متن یا کارت آیه رخ می‌دهد'
                        : 'Choose what happens when tapping directly on a verse card',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SegmentedButton<String>(
                    segments: [
                      ButtonSegment(
                        value: 'showTafsir',
                        label: Text(isPersian ? 'تفسیر' : 'Tafsir'),
                        icon: const Icon(Icons.auto_stories_outlined, size: 18),
                      ),
                      ButtonSegment(
                        value: 'playAudio',
                        label: Text(isPersian ? 'صوت' : 'Audio'),
                        icon: const Icon(Icons.play_circle_outline, size: 18),
                      ),
                      ButtonSegment(
                        value: 'showMenu',
                        label: Text(isPersian ? 'منو' : 'Menu'),
                        icon: const Icon(Icons.menu_open_rounded, size: 18),
                      ),
                    ],
                    selected: {settings.defaultVerseTapAction},
                    onSelectionChanged: (newSelection) {
                      settingsNotifier.updateDefaultVerseTapAction(newSelection.first);
                    },
                  ),
                  const SizedBox(height: 20),

                  // Default Tafsir Edition
                  Text(
                    isPersian ? 'تفسیر پیش‌فرض' : 'Default Tafsir Edition',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: settings.defaultTafsirEdition,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'fa.noor',
                        child: Text(isPersian ? 'تفسیر نور (استاد قرائتی)' : 'Tafsir Noor (Dr. Qara\'ati)'),
                      ),
                      DropdownMenuItem(
                        value: 'fa.nemoneh',
                        child: Text(isPersian ? 'تفسیر نمونه (آیت‌الله مکارم شیرازی)' : 'Tafsir Nemoneh (Makarem Shirazi)'),
                      ),
                      DropdownMenuItem(
                        value: 'fa.almizan',
                        child: Text(isPersian ? 'تفسیر المیزان (علامه طباطبائی)' : 'Tafsir Al-Mizan (Allameh Tabataba\'i)'),
                      ),
                      DropdownMenuItem(
                        value: 'en.ibnkathir',
                        child: Text(isPersian ? 'تفسیر ابن کثیر (انگلیسی)' : 'Tafsir Ibn Kathir (English)'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        settingsNotifier.updateDefaultTafsirEdition(val);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          // 2. Audio Recitation Settings
          _buildSectionHeader(
            context,
            icon: Icons.headset_rounded,
            title: isPersian ? 'تنظیمات صوت و قاری' : 'Audio & Recitation',
          ),
          Card(
            margin: const EdgeInsets.only(bottom: 20),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isPersian ? 'قاری پیش‌فرض' : 'Default Reciter',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: settings.defaultReciterId,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'parhizgar',
                        child: Text(isPersian ? 'استاد شهریار پرهیزگار' : 'Shahriar Parhizgar'),
                      ),
                      DropdownMenuItem(
                        value: 'alafasy',
                        child: Text(isPersian ? 'مشاری راشد العفاسی' : 'Mishary Alafasy'),
                      ),
                      DropdownMenuItem(
                        value: 'basit',
                        child: Text(isPersian ? 'عبدالباسط عبدالصمد' : 'Abdul Basit'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        settingsNotifier.updateReciter(val);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isPersian ? 'سرعت پخش' : 'Playback Speed',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('${settings.playbackSpeed}x'),
                    ],
                  ),
                  Slider(
                    value: settings.playbackSpeed,
                    min: 0.75,
                    max: 2.0,
                    divisions: 5,
                    label: '${settings.playbackSpeed}x',
                    onChanged: (val) => settingsNotifier.updatePlaybackSpeed(val),
                  ),
                  SwitchListTile(
                    title: Text(isPersian ? 'پیمایش خودکار آیه هنگام پخش' : 'Auto-scroll Ayah on Playback'),
                    value: settings.autoScrollAudio,
                    onChanged: (val) => settingsNotifier.updateAutoScrollAudio(val),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ),

          // 3. Theme & Appearance Settings
          _buildSectionHeader(
            context,
            icon: Icons.palette_rounded,
            title: isPersian ? 'پوسته و زبان برنامه' : 'Appearance & Theme',
          ),
          Card(
            margin: const EdgeInsets.only(bottom: 20),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isPersian ? 'پوسته برنامه' : 'App Theme',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<String>(
                    segments: [
                      ButtonSegment(
                        value: 'system',
                        label: Text(isPersian ? 'سیستم' : 'System'),
                        icon: const Icon(Icons.settings_brightness),
                      ),
                      ButtonSegment(
                        value: 'light',
                        label: Text(isPersian ? 'روشن' : 'Light'),
                        icon: const Icon(Icons.light_mode),
                      ),
                      ButtonSegment(
                        value: 'dark',
                        label: Text(isPersian ? 'تاریک' : 'Dark'),
                        icon: const Icon(Icons.dark_mode),
                      ),
                      ButtonSegment(
                        value: 'sepia',
                        label: Text(isPersian ? 'سپیا' : 'Sepia'),
                        icon: const Icon(Icons.menu_book),
                      ),
                    ],
                    selected: {settings.themeMode},
                    onSelectionChanged: (newSelection) {
                      settingsNotifier.updateThemeMode(newSelection.first);
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isPersian ? 'زبان برنامه' : 'Interface Language',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<String>(
                    segments: [
                      ButtonSegment(value: 'fa', label: Text(isPersian ? 'فارسی' : 'Persian')),
                      ButtonSegment(value: 'en', label: Text('English')),
                    ],
                    selected: {settings.appLanguage},
                    onSelectionChanged: (newSelection) {
                      final lang = newSelection.first;
                      settingsNotifier.updateAppLanguage(lang);
                      if (lang == 'fa') {
                        ref.read(localeProvider.notifier).setPersian();
                      } else {
                        ref.read(localeProvider.notifier).setEnglish();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          // 4. AI & Search Settings
          _buildSectionHeader(
            context,
            icon: Icons.auto_awesome_rounded,
            title: isPersian ? 'هوش مصنوعی و جستجو' : 'AI Assistant & Search',
          ),
          Card(
            margin: const EdgeInsets.only(bottom: 20),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    title: Text(isPersian ? 'جستجوی ترکیبی' : 'Enable Hybrid Search'),
                    subtitle: Text(
                      isPersian
                          ? 'ترکیب جستجوی معنایی و کلیدواژه‌ای'
                          : 'Combines semantic vector search with keyword matching',
                    ),
                    value: settings.hybridSearchEnabled,
                    onChanged: (val) => settingsNotifier.updateHybridSearch(val),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ),

          // 5. Data & Storage Utilities
          _buildSectionHeader(
            context,
            icon: Icons.storage_rounded,
            title: isPersian ? 'مدیریت داده و حافظه' : 'Storage & Data Management',
          ),
          Card(
            margin: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(isPersian ? 'همگام‌سازی فقط با Wi-Fi' : 'Sync on Wi-Fi Only'),
                  value: settings.autoSyncWifiOnly,
                  onChanged: (val) => settingsNotifier.updateAutoSyncWifiOnly(val),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.cleaning_services_rounded),
                  title: Text(isPersian ? 'پاکسازی حافظه موقت صوت' : 'Clear Audio Cache'),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isPersian
                              ? 'حافظه موقت فایل‌های صوتی پاک شد'
                              : 'Audio cache cleared successfully',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/app_icon.png',
                    width: 60,
                    height: 60,
                    errorBuilder: (_, __, ___) => const Icon(Icons.menu_book, size: 48),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isPersian ? 'نرم‌افزار جامع قرآن کریم' : 'Quran Knowledge Platform',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 2),
                Text(
                  isPersian ? 'نسخه ۱.۰.۰' : 'Version 1.0.0',
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, {required IconData icon, required String title}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
