import 'package:shared_preferences/shared_preferences.dart';

class Support {
  // List of variables that will be loaded at startup
  static const String appName = 'MyApp';

  // Default values
  static bool firstTimeOpen = true;
  static bool globalPurchaseSupport = false; // Default to false (ads enabled by default)

  // Method to set and save 'firstTimeOpen' value using SharedPreferences
  static Future<void> setFirstTimeOpen(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('First_Time_Open', value);
    firstTimeOpen = value;
  }

  // Method to load 'firstTimeOpen' value using SharedPreferences
  static Future<void> loadFirstTimeOpen() async {
    final prefs = await SharedPreferences.getInstance();
    firstTimeOpen = prefs.getBool('First_Time_Open') ?? true;
  }

  // Method to set and save 'globalPurchaseAds' value using SharedPreferences
  static Future<void> setGlobalPurchaseAds(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('globalPurchaseSupport', value);
    globalPurchaseSupport = value;
  }

  // Method to load 'globalPurchaseAds' value using SharedPreferences
  static Future<void> loadGlobalPurchaseAds() async {
    final prefs = await SharedPreferences.getInstance();
    globalPurchaseSupport = prefs.getBool('globalPurchaseSupport') ?? false;
  }
}
