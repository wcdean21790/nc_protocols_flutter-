import 'package:shared_preferences/shared_preferences.dart';

class GlobalVariables {
  static late SharedPreferences _prefs;

  static String globalAgencyName = "";
  static String globalAgencyLogo = "";
  static String globalAgencyCode = "";
  static List<String> globalFavorites = [];

  // Initialize SharedPreferences in a static initializer
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    // Load values from SharedPreferences
    globalAgencyName = _prefs.getString('globalAgencyName') ?? "";
    globalAgencyLogo = _prefs.getString('globalAgencyLogo') ?? "";
    globalAgencyCode = _prefs.getString('globalAgencyCode') ?? "";

    // Load globalFavorites from SharedPreferences
    final favorites = _prefs.getStringList('globalFavorites');
    if (favorites != null) {
      globalFavorites = favorites;
    }
  }

  // Store global variables in SharedPreferences
  static Future<void> saveGlobalVariables() async {
    await _prefs.setString('globalAgencyName', globalAgencyName);
    await _prefs.setString('globalAgencyLogo', globalAgencyLogo);
    await _prefs.setString('globalAgencyCode', globalAgencyCode);

    // Store globalFavorites in SharedPreferences
    await _prefs.setStringList('globalFavorites', globalFavorites);
  }
}

