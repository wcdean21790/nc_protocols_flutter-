import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:n_c_protocols/pages/category_listview.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../globals.dart';
import '../../service/ad_mob_service.dart';
import '../favorites.dart';
import '../info.dart';
import 'home_page_widget.dart';
import 'dart:io';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  @override
  void initState() {
    super.initState();
    _createInterstitialAd();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = 40.0; // Set the desired width and height for the icons

    return Container(
      width: double.infinity,
      height: 50.0,
      color: Color(0xFF242935),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomBottomButton(
            onPressed: () async {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      HomePageWidget(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const beginOpacity = 0.0;
                    const endOpacity = 1.0;
                    var opacityTween = Tween<double>(begin: beginOpacity, end: endOpacity);
                    var fadeAnimation = animation.drive(opacityTween);
                    return FadeTransition(
                      opacity: fadeAnimation,
                      child: child,
                    );
                  },
                ),
              );
            },
            iconPath: 'assets/images/homeicon.png',
            iconSize: iconSize,
          ),
          CustomBottomButton(
            onPressed: () async {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      CategoryListViewWidget(agencyName: GlobalVariables.globalAgencyName),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const beginOpacity = 0.0;
                    const endOpacity = 1.0;
                    var opacityTween = Tween<double>(begin: beginOpacity, end: endOpacity);
                    var fadeAnimation = animation.drive(opacityTween);
                    return FadeTransition(
                      opacity: fadeAnimation,
                      child: child,
                    );
                  },
                ),
              );
            },
            iconPath: 'assets/images/protocolsicon.png',
            iconSize: iconSize,
          ),
          CustomBottomButton(
            onPressed: () async {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      FavoriteProtocols(globalFavorites: []),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const beginOpacity = 0.0;
                    const endOpacity = 1.0;
                    var opacityTween = Tween<double>(begin: beginOpacity, end: endOpacity);
                    var fadeAnimation = animation.drive(opacityTween);
                    return FadeTransition(
                      opacity: fadeAnimation,
                      child: child,
                    );
                  },
                ),
              );
            },
            iconPath: 'assets/images/favicon.png',
            iconSize: iconSize,
          ),
          CustomBottomButton(
            onPressed: () async {
              _showInterstitialAd();
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      Info(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const beginOpacity = 0.0;
                    const endOpacity = 1.0;
                    var opacityTween = Tween<double>(begin: beginOpacity, end: endOpacity);
                    var fadeAnimation = animation.drive(opacityTween);
                    return FadeTransition(
                      opacity: fadeAnimation,
                      child: child,
                    );
                  },
                ),
              );
            },
            iconPath: 'assets/images/infoicon.png',
            iconSize: iconSize,
          ),
        ],
      ),
    );
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdMobService.interstitialAdUnitId!,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) => _interstitialAd = null,
      ),
    );
  }

  void _showInterstitialAd() {
    print("Ad Status: ${GlobalVariables.globalPurchaseAds}");
    if (GlobalVariables.globalPurchaseAds != "True") {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _createInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    }}
  }

}

class CustomBottomButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String iconPath;
  final double iconSize;

  CustomBottomButton({
    required this.onPressed,
    required this.iconPath,
    required this.iconSize,
  });

  @override
  _CustomBottomButtonState createState() => _CustomBottomButtonState();
}

class _CustomBottomButtonState extends State<CustomBottomButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _isPressed = !_isPressed;
        });
        widget.onPressed();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _isPressed ? Colors.grey : Colors.transparent,
        elevation: 0, // Remove the button elevation
      ),
      child: Image.asset(
        widget.iconPath,
        width: widget.iconSize,
        height: widget.iconSize,
      ),
    );
  }
}
