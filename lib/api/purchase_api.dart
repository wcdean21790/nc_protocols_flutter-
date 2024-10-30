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
      await Purchases.syncPurchases(); // Force synchronization with server
      final purchaserInfo = await Purchases.getCustomerInfo();
      print("Customer info refreshed: ${purchaserInfo.toString()}");

      // Log each entitlement for debugging purposes
      purchaserInfo.entitlements.all.forEach((key, entitlement) {
        print("Entitlement ID: $key, Active: ${entitlement.isActive}");
      });

      // Correctly identify the entitlement to check ('No ads')
      final hasAccess = purchaserInfo.entitlements.all['No ads']?.isActive ?? false;
      print("Just checked for entitlement access: $hasAccess");

      // Update SharedPreferences with the new subscription status
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('globalPurchaseSupport', hasAccess);
      await prefs.setBool('globalPurchaseAds', hasAccess);  // Update ads status

      // Update global variables
      GlobalVariables.globalPurchaseAds = hasAccess;

      // Additional debug logs to verify changes
      print("Updated SharedPreferences: globalPurchaseSupport = ${prefs.getBool('globalPurchaseSupport')}");
      print("Updated SharedPreferences: globalPurchaseAds = ${prefs.getBool('globalPurchaseAds')}");
      print("GlobalVariables updated: globalPurchaseAds = ${GlobalVariables.globalPurchaseAds}");

      if (hasAccess) {
        print("Subscription is active.");
      } else {
        print("Subscription is inactive.");
      }

      // If using a provider, notify it about the subscription status change
      // Example if using ChangeNotifierProvider:
      // final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
      // subscriptionProvider.updateSubscriptionStatus(hasAccess);

    } catch (e) {
      print("Failed to refresh purchase info: $e");
    }
  }



}
