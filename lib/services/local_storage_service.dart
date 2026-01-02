import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Key for storing favorites
  static const String _favoritesKey = 'favorite_coins';

  // Get list of favorite coin IDs
  List<String> getFavorites() {
    return _prefs.getStringList(_favoritesKey) ?? [];
  }

  // Save list of favorite coin IDs
  Future<void> saveFavorites(List<String> favorites) async {
    await _prefs.setStringList(_favoritesKey, favorites);
  }

  // Locale
  static const String _localeKey = 'app_locale';

  String? getLocale() {
    return _prefs.getString(_localeKey);
  }

  Future<void> saveLocale(String code) async {
    await _prefs.setString(_localeKey, code);
  }

  // Currency
  static const String _currencyKey = 'app_currency';

  String getCurrency() {
    return _prefs.getString(_currencyKey) ?? 'usd';
  }

  Future<void> saveCurrency(String code) async {
    await _prefs.setString(_currencyKey, code);
  }
}
