  import 'package:n_c_protocols/globals.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Coins {
  static const idCoins10 = '10_coins';
  static const idCoins100 = '100_coins';

  static const allIds = [idCoins10, idCoins100];
}

class PurchaseApi {
  static final _configuration =
      PurchasesConfiguration('goog_ddKETmScjCJwnxZwxYBcwDoFhbH')
        ..appUserID = 'testUser3';

  static Future init() async {
    await Purchases.configure(_configuration);
  }

  static Future<List<Offering>> fetchOffersByIds(List<String> ids) async {
    final offers = await fetchOffers();

    return offers.where((offer) => ids.contains(offer.identifier)).toList();
  }

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
      return [];
    }
  }

  static Future<bool> purchasePackage(Package package) async {
    try {
      await Purchases.purchasePackage(package);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('globalPurchaseAds', "True" );
      GlobalVariables.globalPurchaseAds = "True";
      return true;
    } catch (e) {
      return false;
    }
  }
}
