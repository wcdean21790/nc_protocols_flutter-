import 'package:flutter/cupertino.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../api/purchase_api.dart';
import '../model/entitlement.dart';

class RevenueCatProvider extends ChangeNotifier {
  RevenueCatProvider() {
    init();
  }


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
    print("Revenucat.dart)");
    final customerInfo = await Purchases.getCustomerInfo();

    final entitlements = customerInfo.entitlements.active.values.toList();
    _entitlement =
        entitlements.isEmpty ? Entitlement.free : Entitlement.allCourses;

    notifyListeners();
  }
}
