import 'package:purchases_flutter/purchases_flutter.dart';
import 'dart:io';
import 'package:n_c_protocols/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchaseApi {
  static PurchasesConfiguration? _configuration;

  // Initialization function to configure Purchases with a unique appUserID
  static Future<void> init() async {
    // Get a unique appUserID based on a locally generated unique ID
    String appUserID = await _getUniqueUserID();

    // Configure Purchases based on platform with the unique appUserID
    if (Platform.isAndroid) {
      _configuration = PurchasesConfiguration('goog_ddKETmScjCJwnxZwxYBcwDoFhbH')..appUserID = 'Android_$appUserID';
    } else if (Platform.isIOS) {
      _configuration = PurchasesConfiguration('appl_TsgDckZzHJUlHVWMbVzrXgBAaba')..appUserID = 'iOS_$appUserID';
    }
    await Purchases.configure(_configuration!);

    // After initialization, check the subscription status
    await refreshPurchaseInfo();
  }

  // Fetch offers by specific IDs
  static Future<List<Offering>> fetchOffersByIds(List<String> ids) async {
    final offers = await fetchOffers();
    return offers.where((offer) => ids.contains(offer.identifier)).toList();
  }

  // Fetch all offers or just the current offering
  static Future<List<Offering>> fetchOffers({bool all = true}) async {
    try {
      final offerings = await Purchases.getOfferings();
      return all ? offerings.all.values.toList() : offerings.current != null ? [offerings.current!] : [];
    } catch (e) {
      print("Failed to fetch offers: $e");
      return [];
    }
  }

  // Function to initiate a purchase of a specific package
  static Future<bool> purchasePackage(Package package) async {
    try {
      print("Attempting to purchase package...");
      await Purchases.purchasePackage(package);
      print("Successful purchase");

      // Refresh customer info after purchase to verify subscription status
      await refreshPurchaseInfo();
      return true;
    } catch (e) {
      print("NOT a successful purchase: $e");
      return false;
    }
  }

  // Manually refresh purchaser information, useful to check the latest subscription status
  static Future<void> refreshPurchaseInfo() async {
    try {
      print("Attempting to refresh customer info...");
      await Purchases.syncPurchases();
      final purchaserInfo = await Purchases.getCustomerInfo();
      print("Customer info refreshed: ${purchaserInfo.toString()}");

      // Log each entitlement for debugging purposes
      purchaserInfo.entitlements.all.forEach((key, entitlement) {
        print("Entitlement ID: $key, Active: ${entitlement.isActive}");
      });

      // Check for entitlement to remove ads
      final hasAccess = purchaserInfo.entitlements.all['No ads']?.isActive ?? false;
      print("Entitlement access checked: $hasAccess");

      // Update SharedPreferences with the new subscription status
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('globalPurchaseSupport', hasAccess);
      await prefs.setBool('globalPurchaseAds', hasAccess);

      // Update global variables
      GlobalVariables.globalPurchaseAds = hasAccess;

      // Debugging logs
      print("Updated SharedPreferences: globalPurchaseSupport = ${prefs.getBool('globalPurchaseSupport')}");
      print("Updated SharedPreferences: globalPurchaseAds = ${prefs.getBool('globalPurchaseAds')}");
      print("GlobalVariables updated: globalPurchaseAds = ${GlobalVariables.globalPurchaseAds}");

      if (hasAccess) {
        print("Subscription is active.");
      } else {
        print("Subscription is inactive.");
      }

    } catch (e) {
      print("Failed to refresh purchase info: $e");
    }
  }

  // Helper function to get a unique user ID (locally generated UUID if no Firebase UID is available)
  static Future<String> _getUniqueUserID() async {
    final prefs = await SharedPreferences.getInstance();
    String? uniqueUserID = prefs.getString('uniqueUserID');
    if (uniqueUserID == null) {
      uniqueUserID = 'user_${DateTime.now().millisecondsSinceEpoch}';
      await prefs.setString('uniqueUserID', uniqueUserID);
    }
    return uniqueUserID;
  }
}
