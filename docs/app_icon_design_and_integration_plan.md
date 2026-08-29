# App Icon Design & Multi-Platform Integration Plan

## Goal Description
Integrate the custom-designed Holy Quran mobile app icon across Android, iOS, Web, Windows, and Flutter in-app asset catalogs.

---

## 1. Icon Concept & Aesthetics
- **Theme**: Sacred Holy Quran (*قرآن مجید*) with glowing gold calligraphy on a rehal stand.
- **Palette**: Deep Islamic emerald green (`#0C3B2E`), celestial sapphire blue (`#0A192F`), radiant gold (`#D4AF37`), and cream parchment.
- **Style**: Modern 3D squircle app icon with arabesque geometric lattice pattern and ambient rays.

---

## 2. Asset Resolution Targets
- **Android**:
  - `mipmap-mdpi/ic_launcher.png` (48x48)
  - `mipmap-hdpi/ic_launcher.png` (72x72)
  - `mipmap-xhdpi/ic_launcher.png` (96x96)
  - `mipmap-xxhdpi/ic_launcher.png` (144x144)
  - `mipmap-xxxhdpi/ic_launcher.png` (192x192)
- **iOS**:
  - `AppIcon.appiconset` (20pt, 29pt, 40pt, 60pt, 76pt, 83.5pt @1x, @2x, @3x, 1024x1024 App Store icon)
- **Web**:
  - `web/favicon.png` (32x32)
  - `web/icons/Icon-192.png` (192x192)
  - `web/icons/Icon-512.png` (512x512)
  - `web/icons/Icon-maskable-192.png` (192x192)
  - `web/icons/Icon-maskable-512.png` (512x512)
- **Windows**:
  - `windows/runner/resources/app_icon.ico`
- **Flutter Assets**:
  - `assets/images/app_icon.png` (512x512)

---

## 3. Execution Plan
1. Create `scripts/generate_app_icons.py`.
2. Save generated master icon to `icon.png`.
3. Execute generator to produce all density variants.
4. Register `assets/images/` in `pubspec.yaml`.
5. Run tests to ensure complete validation.
