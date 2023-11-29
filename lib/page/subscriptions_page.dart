import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../api/purchase_api.dart';
import '../model/entitlement.dart';
import '../provider/revenuecat.dart';
import '../utils.dart';
import '../widget/paywall_widget.dart';

class SubscriptionsPage extends StatefulWidget {
  const SubscriptionsPage({Key? key}) : super(key: key);

  @override
  _SubscriptionsPageState createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  bool isLoading = false;

  Widget build(BuildContext context) {
    final entitlement = context.watch<RevenueCatProvider>().entitlement;

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildEntitlement(entitlement),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: isLoading ? null : fetchOffers,
              child: const Text(
                'See Plans',
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildEntitlement(Entitlement entitlement) {
    switch (entitlement) {
      case Entitlement.allCourses:
        return buildEntitlementIcon(
          text: 'You are on Paid plan',
          icon: Icons.paid,
        );
      case Entitlement.free:
      default:
        return buildEntitlementIcon(
          text: 'You are on Free plan',
          icon: Icons.lock,
        );
    }
  }

  Widget buildEntitlementIcon({
    required String text,
    required IconData icon,
  }) =>
      Column(
        children: [
          Icon(icon, size: 100),
          const SizedBox(height: 8),
          Text(text, style: const TextStyle(fontSize: 24)),
        ],
      );

  Future fetchOffers() async {
    final offerings = await Purchases.getOfferings();
    if (!mounted) return;

    if (offerings.current == null) {
      const snackBar = SnackBar(content: Text('No Plans Found'));

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final packages = offerings.current!.availablePackages;

      Utils.showSheet(
        context,
        (context) => PaywallWidget(
          packages: packages,
          title: '⭐  Upgrade Your Plan',
          description: 'Upgrade to a new plan to enjoy more benefits',
          onClickedPackage: (package) async {
            await PurchaseApi.purchasePackage(package);
            if (!mounted) return;

            Navigator.pop(context);
          },
        ),
      );
    }
  }
}
