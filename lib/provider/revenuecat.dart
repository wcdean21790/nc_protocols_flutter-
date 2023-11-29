import 'package:flutter/cupertino.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../api/purchase_api.dart';
import '../model/entitlement.dart';

class RevenueCatProvider extends ChangeNotifier {
  RevenueCatProvider() {
    init();
  }

  int coins = 0;

  Entitlement _entitlement = Entitlement.free;
  Entitlement get entitlement => _entitlement;

  Future init() async {
    Purchases.addCustomerInfoUpdateListener((customerInfo) async {
      updatePurchaseStatus();
    });

    /// For hot restart etc.
    await updatePurchaseStatus();
  }

  Future updatePurchaseStatus() async {
    final customerInfo = await Purchases.getCustomerInfo();

    final entitlements = customerInfo.entitlements.active.values.toList();
    _entitlement =
        entitlements.isEmpty ? Entitlement.free : Entitlement.allCourses;

    notifyListeners();
  }

  void addCoinsPackage(Package package) {
    switch (package.offeringIdentifier) {
      case Coins.idCoins10:
        coins += 10;
        break;
      case Coins.idCoins100:
        coins += 100;
        break;
      default:
        break;
    }

    notifyListeners();
  }

  void spend10Coins() {
    coins -= 10;

    notifyListeners();
  }
}
