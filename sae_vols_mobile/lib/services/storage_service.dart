import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _key = 'vols_favoris';

  static Future<List<dynamic>> chargerFavoris() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? list = prefs.getStringList(_key);
    
    if (list == null) return [];
    
    return list.map((item) => json.decode(item)).toList();
  }

  static Future<void> sauvegarderFavoris(List<dynamic> favoris) async {
    final prefs = await SharedPreferences.getInstance();
    
    final List<String> list = favoris.map((item) => json.encode(item)).toList();
    await prefs.setStringList(_key, list);
  }
}