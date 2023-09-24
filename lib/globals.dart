import 'package:shared_preferences/shared_preferences.dart';

class GlobalVariables {
  static late SharedPreferences _prefs;

  static String globalAgencyName = "";
  static String globalAgencyLogo = "";
  static String globalAgencyCode = "";

  // Initialize SharedPreferences in a static initializer
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    // Load values from SharedPreferences
    globalAgencyName = _prefs.getString('globalAgencyName') ?? "";
    globalAgencyLogo = _prefs.getString('globalAgencyLogo') ?? "";
    globalAgencyCode = _prefs.getString('globalAgencyCode') ?? "";
  }

  // Store global variables in SharedPreferences
  static Future<void> saveGlobalVariables() async {
    await _prefs.setString('globalAgencyName', globalAgencyName);
    await _prefs.setString('globalAgencyLogo', globalAgencyLogo);
    await _prefs.setString('globalAgencyCode', globalAgencyCode);
  }
}
