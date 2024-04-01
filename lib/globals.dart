import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'backend/backend.dart';

class GlobalVariables {
  static late SharedPreferences _prefs;

  static String globalAgencyName = "";
  static String globalPurchaseAds = "";
  static String globalAgencyLogo = "";
  static String globalAgencyCode = "";
  static List<String> globalFavorites = [];
  static List<Color> colorTheme = [Colors.grey, Color(0xFF242935)];



  // Initialize SharedPreferences in a static initializer
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    // Load values from SharedPreferences
    globalAgencyName = _prefs.getString('globalAgencyName') ?? "";
    globalAgencyLogo = _prefs.getString('globalAgencyLogo') ?? "";
    globalAgencyCode = _prefs.getString('globalAgencyCode') ?? "";
    globalPurchaseAds = _prefs.getString('globalPurchaseAds') ?? "";

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
    await _prefs.setString('globalPurchaseAds', globalPurchaseAds);

    // Store globalFavorites in SharedPreferences
    await _prefs.setStringList('globalFavorites', globalFavorites);
  }
}




class ButtonStyles {
  static ButtonStyle customButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0), // Match the padding
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Match the borderRadius
        side: BorderSide(color: Colors.black, width: 1.0), // Match the borderSide
      ),
      elevation: 3.0,
      // You can set textStyle based on FlutterFlowTheme.of(context).titleLarge.override
      // if that's defined in your app's theme.
      textStyle: TextStyle(
        fontFamily: 'Readex Pro',
        color: Color(0xFF000000),
        fontSize: 18.0, // Adjust the fontSize as needed
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.none, // Match the decoration
      ),
    ).copyWith(
      minimumSize: MaterialStateProperty.all(Size(50, 40)),
    );
  }
}


