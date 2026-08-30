import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dhikr_model.dart';

class TasbihRepository {
  static const String _activeDhikrKey = 'tasbih_active_dhikr_v1';
  static const String _customDhikrsKey = 'tasbih_custom_dhikrs_v1';
  static const String _lifetimeTotalKey = 'tasbih_lifetime_total_v1';

  Future<DhikrItem> loadActiveDhikr() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_activeDhikrKey);
    if (jsonStr == null) {
      return DhikrItem.getFatimaZahra();
    }
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return DhikrItem.fromMap(map);
    } catch (_) {
      return DhikrItem.getFatimaZahra();
    }
  }

  Future<void> saveActiveDhikr(DhikrItem dhikr) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeDhikrKey, jsonEncode(dhikr.toMap()));
  }

  Future<List<DhikrItem>> loadCustomDhikrs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_customDhikrsKey);
    if (jsonList == null) return [];
    return jsonList
        .map((s) {
          try {
            return DhikrItem.fromMap(jsonDecode(s) as Map<String, dynamic>);
          } catch (_) {
            return null;
          }
        })
        .whereType<DhikrItem>()
        .toList();
  }

  Future<void> saveCustomDhikr(DhikrItem customDhikr) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await loadCustomDhikrs();
    final index = current.indexWhere((d) => d.id == customDhikr.id);
    if (index >= 0) {
      current[index] = customDhikr;
    } else {
      current.add(customDhikr);
    }
    final encoded = current.map((d) => jsonEncode(d.toMap())).toList();
    await prefs.setStringList(_customDhikrsKey, encoded);
  }

  Future<void> deleteCustomDhikr(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await loadCustomDhikrs();
    current.removeWhere((d) => d.id == id);
    final encoded = current.map((d) => jsonEncode(d.toMap())).toList();
    await prefs.setStringList(_customDhikrsKey, encoded);
  }

  Future<int> loadLifetimeTotal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_lifetimeTotalKey) ?? 0;
  }

  Future<void> incrementLifetimeTotal([int amount = 1]) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_lifetimeTotalKey) ?? 0;
    await prefs.setInt(_lifetimeTotalKey, current + amount);
  }
}
