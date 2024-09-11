import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:n_c_protocols/pages/Tools/More_Category.dart';
import 'package:n_c_protocols/pages/category_listview.dart';
import '../../globals.dart';
import '../../service/ad_mob_service.dart';
import '../favorites.dart';
import '../info.dart';
import 'home_page_widget.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  final ScrollController _scrollController = ScrollController();
  bool _showLeftArrow = false;
  bool _showRightArrow = true;

  @override
  void initState() {
    super.initState();
    _createInterstitialAd();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    setState(() {
      // Show left arrow if not at the beginning
      _showLeftArrow = _scrollController.offset > 0;

      // Show right arrow if not at the end
      _showRightArrow = _scrollController.offset < _scrollController.position.maxScrollExtent;
    });
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = 50.0; // Set icon size

    return Container(
      width: double.infinity,
      height: 60.0,
      color: Color(0xFF242935),
      child: Stack(
        children: [
          // Scrollable navigation bar with buttons
          Scrollbar(
            thickness: 4.0,
            thumbVisibility: true,
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
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
                            var fadeAnimation = animation.drive(Tween(begin: 0.0, end: 1.0));
                            return FadeTransition(opacity: fadeAnimation, child: child);
                          },
                        ),
                      );
                    },
                    iconPath: 'assets/images/homeicon.png',
                    iconSize: iconSize,
                  ), // Home button

                  CustomBottomButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              CategoryListViewWidget(agencyName: GlobalVariables.globalAgencyName),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            var fadeAnimation = animation.drive(Tween(begin: 0.0, end: 1.0));
                            return FadeTransition(opacity: fadeAnimation, child: child);
                          },
                        ),
                      );
                    },
                    iconPath: 'assets/images/protocolsicon.png',
                    iconSize: iconSize,
                  ), // Protocol button

                  CustomBottomButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              MoreListViewWidget(agencyName: GlobalVariables.globalAgencyName),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            var fadeAnimation = animation.drive(Tween(begin: 0.0, end: 1.0));
                            return FadeTransition(opacity: fadeAnimation, child: child);
                          },
                        ),
                      );
                    },
                    iconPath: 'assets/icon/more_icon.png',
                    iconSize: iconSize,
                  ), // More button

                  CustomBottomButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              FavoriteProtocols(globalFavorites: []),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            var fadeAnimation = animation.drive(Tween(begin: 0.0, end: 1.0));
                            return FadeTransition(opacity: fadeAnimation, child: child);
                          },
                        ),
                      );
                    },
                    iconPath: 'assets/images/favicon.png',
                    iconSize: iconSize,
                  ), // Favorite button

                  CustomBottomButton(
                    onPressed: () async {
                      _showInterstitialAd();
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              Info(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            var fadeAnimation = animation.drive(Tween(begin: 0.0, end: 1.0));
                            return FadeTransition(opacity: fadeAnimation, child: child);
                          },
                        ),
                      );
                    },
                    iconPath: 'assets/images/infoicon.png',
                    iconSize: iconSize,
                  ), // Info button
                ],
              ),
            ),
          ),

          // Left arrow indicator
          if (_showLeftArrow)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Icon(Icons.arrow_back_ios, color: Colors.white),
            ),

          // Right arrow indicator
          if (_showRightArrow)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Icon(Icons.arrow_forward_ios, color: Colors.white),
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
      }
    }
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
