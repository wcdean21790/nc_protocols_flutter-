import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/purchase_api.dart';
import '../provider/revenuecat.dart';
import '../utils.dart';
import '../widget/paywall_widget.dart';

class ConsumablesPage extends StatefulWidget {
  const ConsumablesPage({Key? key}) : super(key: key);

  @override
  _ConsumablesPageState createState() => _ConsumablesPageState();
}

class _ConsumablesPageState extends State<ConsumablesPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final coins = Provider.of<RevenueCatProvider>(context).coins;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildCoins(coins),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: isLoading ? null : fetchOffers,
              child: const Text(
                'Get More Coins',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: isLoading ? null : spendCoins,
              child: const Text(
                'Spend 10 Coins',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCoins(int coins) => Column(
        children: [
          Icon(
            Icons.monetization_on,
            color: Colors.yellow.shade800,
            size: 100,
          ),
          SizedBox(height: 8),
          Text(
            'You have $coins Coins',
            style: TextStyle(fontSize: 24),
          ),
        ],
      );

  Future fetchOffers() async {
    final offerings = await PurchaseApi.fetchOffersByIds(Coins.allIds);
    if (!mounted) return;

    if (offerings.isEmpty) {
      const snackBar = SnackBar(content: Text('No Plans Found'));

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final packages = offerings
          .map((offer) => offer.availablePackages)
          .expand((pair) => pair)
          .toList();

      Utils.showSheet(
        context,
        (context) => PaywallWidget(
          packages: packages,
          title: '⭐  Upgrade Your Plan',
          description: 'Upgrade to a new plan to enjoy more benefits',
          onClickedPackage: (package) async {
            final provider = context.read<RevenueCatProvider>();

            final isSuccess = await PurchaseApi.purchasePackage(package);
            if (!mounted) return;

            if (isSuccess) {
              provider.addCoinsPackage(package);
            }

            Navigator.pop(context);
          },
        ),
      );
    }
  }

  void spendCoins() {
    final provider = Provider.of<RevenueCatProvider>(context, listen: false);

    provider.spend10Coins();
  }
}
