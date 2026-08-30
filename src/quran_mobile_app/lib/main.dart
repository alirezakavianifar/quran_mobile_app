import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/core/localization/app_localizations.dart';
import 'src/core/notifications/notification_service.dart';
import 'src/core/settings/settings_provider.dart';
import 'src/core/theme/app_theme.dart';
import 'src/features/ai_chat/ai_chat_screen.dart';
import 'src/features/bookmarks/bookmarks_screen.dart';
import 'src/features/reader/surah_list_view.dart';
import 'src/features/search/search_screen.dart';
import 'src/features/settings/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await NotificationService.instance.initialize();
  } catch (e) {
    debugPrint('Failed to initialize NotificationService: $e');
  }
  runApp(const ProviderScope(child: QuranMobileApp()));
}

class QuranMobileApp extends ConsumerWidget {
  const QuranMobileApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final textDirection = ref.watch(textDirectionProvider);
    final settings = ref.watch(settingsProvider);

    ThemeData lightTheme = AppTheme.getLightTheme(locale);
    ThemeData darkTheme = AppTheme.getDarkTheme(locale);
    ThemeMode themeMode = ThemeMode.system;

    if (settings.themeMode == 'light') {
      themeMode = ThemeMode.light;
    } else if (settings.themeMode == 'dark') {
      themeMode = ThemeMode.dark;
    } else if (settings.themeMode == 'sepia') {
      themeMode = ThemeMode.light;
      lightTheme = AppTheme.getSepiaTheme(locale);
    }

    return MaterialApp(
      title: 'Quran Platform Mobile',
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: const [
        Locale('fa', 'IR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      builder: (context, child) {
        return Directionality(
          textDirection: textDirection,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    SurahListView(),
    SearchScreen(),
    AiChatScreen(),
    BookmarksScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isPersian = loc.locale.languageCode == 'fa';

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.menu_book),
            label: loc.translate('surahs'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: loc.translate('search'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.psychology),
            label: loc.translate('aiAssistant'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bookmark),
            label: loc.translate('bookmarks'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: isPersian ? 'تنظیمات' : 'Settings',
          ),
        ],
      ),
    );
  }
}
