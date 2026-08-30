import 'package:flutter/material.dart';

enum CardAspectRatio {
  square, // 1:1 Post
  story, // 9:16 Vertical Story / Status
}

enum CardThemeStyle {
  emeraldGold,
  midnightStarlight,
  parchmentSepia,
  modernGlass,
}

class AyahCardTheme {
  final CardThemeStyle style;
  final String nameFa;
  final String nameEn;
  final BoxDecoration backgroundDecoration;
  final Color arabicTextColor;
  final Color translationTextColor;
  final Color citationColor;
  final Color borderColor;
  final Color accentColor;
  final IconData themeIcon;

  const AyahCardTheme({
    required this.style,
    required this.nameFa,
    required this.nameEn,
    required this.backgroundDecoration,
    required this.arabicTextColor,
    required this.translationTextColor,
    required this.citationColor,
    required this.borderColor,
    required this.accentColor,
    required this.themeIcon,
  });

  static const List<AyahCardTheme> presets = [
    // 1. Emerald & Gold
    AyahCardTheme(
      style: CardThemeStyle.emeraldGold,
      nameFa: 'زمرد و طلا',
      nameEn: 'Emerald & Gold',
      themeIcon: Icons.eco_rounded,
      backgroundDecoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.1,
          colors: [
            Color(0xFF0F5132),
            Color(0xFF062817),
            Color(0xFF02140A),
          ],
        ),
      ),
      arabicTextColor: Color(0xFFFFDF78),
      translationTextColor: Color(0xFFE2E8F0),
      citationColor: Color(0xFFFFD700),
      borderColor: Color(0xFFFFD700),
      accentColor: Color(0xFF10B981),
    ),

    // 2. Deep Midnight & Starlight
    AyahCardTheme(
      style: CardThemeStyle.midnightStarlight,
      nameFa: 'شب سرمه‌ای',
      nameEn: 'Deep Midnight',
      themeIcon: Icons.nightlight_round,
      backgroundDecoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F172A),
            Color(0xFF0B1120),
            Color(0xFF020617),
          ],
        ),
      ),
      arabicTextColor: Color(0xFF67E8F9),
      translationTextColor: Color(0xFFCBD5E1),
      citationColor: Color(0xFF38BDF8),
      borderColor: Color(0xFF38BDF8),
      accentColor: Color(0xFF0284C7),
    ),

    // 3. Ancient Parchment & Sepia
    AyahCardTheme(
      style: CardThemeStyle.parchmentSepia,
      nameFa: 'کاغذ سنتی کهن',
      nameEn: 'Ancient Parchment',
      themeIcon: Icons.menu_book_rounded,
      backgroundDecoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFDF6E2),
            Color(0xFFF5E8C7),
            Color(0xFFEADBBA),
          ],
        ),
      ),
      arabicTextColor: Color(0xFF2C1810),
      translationTextColor: Color(0xFF4A3728),
      citationColor: Color(0xFF8B4513),
      borderColor: Color(0xFFC49A45),
      accentColor: Color(0xFF8B4513),
    ),

    // 4. Modern Glassmorphism
    AyahCardTheme(
      style: CardThemeStyle.modernGlass,
      nameFa: 'شیشه‌ای مدرن',
      nameEn: 'Modern Glass',
      themeIcon: Icons.auto_awesome_rounded,
      backgroundDecoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E1B4B),
            Color(0xFF312E81),
            Color(0xFF1E1B4B),
          ],
        ),
      ),
      arabicTextColor: Color(0xFFF472B6),
      translationTextColor: Color(0xFFE0E7FF),
      citationColor: Color(0xFFA78BFA),
      borderColor: Color(0xFF818CF8),
      accentColor: Color(0xFF8B5CF6),
    ),
  ];

  static AyahCardTheme getTheme(CardThemeStyle style) {
    return presets.firstWhere(
      (t) => t.style == style,
      orElse: () => presets.first,
    );
  }
}
