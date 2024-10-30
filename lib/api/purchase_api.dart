import 'package:n_c_protocols/globals.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class PurchaseApi {
  static PurchasesConfiguration _configuration = PurchasesConfiguration('')..appUserID = 'Oct2024';

  // Initialization function to configure Purchases
  static Future init() async {
    // Configure Purchases with the appropriate API key based on the platform
    if (Platform.isAndroid) {
      _configuration = PurchasesConfiguration('goog_ddKETmScjCJwnxZwxYBcwDoFhbH')..appUserID = 'Android_Oct2024';
    } else if (Platform.isIOS) {
      _configuration = PurchasesConfiguration('appl_TsgDckZzHJUlHVWMbVzrXgBAaba')..appUserID = 'ios_Oct2024';
    }
    await Purchases.configure(_configuration);

    // After initialization, you may want to check subscription status
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

      if (!all) {
        final current = offerings.current;
        return current == null ? [] : [current];
      } else {
        return offerings.all.values.toList();
      }
    } catch (e) {
      print("Failed to fetch offers: $e");
      return [];
    }
  }

  // Function to initiate a purchase of a specific package
  static Future<bool> purchasePackage(Package package) async {
    try {
      await Purchases.purchasePackage(package);
      final prefs = await SharedPreferences.getInstance();
      print("Successful purchase");

      // Update globalPurchaseAds to true, indicating the ads are disabled
      prefs.setBool('globalPurchaseAds', true);

      // Update globalPurchaseSupport to true, indicating the support feature is purchased
      prefs.setBool('globalPurchaseSupport', true);
      print("Successful app supporter");

      Future.delayed(1500 as Duration);
      // Refresh customer info after purchase
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
      final purchaserInfo = await Purchases.getCustomerInfo();
      final hasAccess = purchaserInfo.entitlements.all['entlf356705c4b']?.isActive ?? false;

      final prefs = await SharedPreferences.getInstance();
      if (hasAccess) {
        prefs.setBool('globalPurchaseSupport', true);
        GlobalVariables.globalPurchaseAds = true; // Corrected assignment to bool
        print("Subscription is active.");
      } else {
        prefs.setBool('globalPurchaseSupport', false);
        GlobalVariables.globalPurchaseAds = false; // Corrected assignment to bool
        print("Subscription has been cancelled or expired.");
      }
    } catch (e) {
      print("Failed to refresh purchase info: $e");
    }
  }

}
