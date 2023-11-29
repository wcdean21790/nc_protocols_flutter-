import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:n_c_protocols/pages/home_page/navigationbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../globals.dart';
import '../service/ad_mob_service.dart';
import 'category_listview.dart';

class FavoriteProtocols extends StatefulWidget {
  final List<String> globalFavorites;

  // Constructor that accepts globalFavorites as a parameter
  FavoriteProtocols({required this.globalFavorites});

  @override
  _FavoriteProtocolsState createState() => _FavoriteProtocolsState();
}

class _FavoriteProtocolsState extends State<FavoriteProtocols> {
  List<String> globalFavorites = [];
  BannerAd? _banner;

  @override
  void initState() {
    super.initState();
    loadFavorites();
    _createBannerAd();
  }

  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    setState(() {
      globalFavorites = favorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(globalFavorites);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorite Protocols',
          style: TextStyle(color: Color(0xFFFFFFFF)), // Set app bar text color to black
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF242935), // Set app bar background color to white
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF242935),
        ),
        child:
        Column(
          children: [
        Expanded(
        child: ListView.builder(
          itemCount: globalFavorites.length,
          itemBuilder: (context, index) {
            final pdfPath = globalFavorites[index];
            final fileName = pdfPath.split('/').last;

            return Padding(
              padding: const EdgeInsets.only(
                bottom: 15,
                top: 25,
                left: 35,
                right: 35,
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return PDFViewerWidget(
                          pdfFilePath: pdfPath, // Pass the pdfPath here
                          pdfFileName: fileName.replaceAll('.pdf', ''),
                        );
                      },
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
                style: ButtonStyles.customButtonStyle(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            fileName.replaceAll('.pdf', ''),
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: GestureDetector(
                        onTap: () {
                          removeFromFavorites(pdfPath, context);
                        },
                        child: IconButton(
                          icon: Image.asset(
                            'assets/images/trashicon.png', // Replace with the path to your trash icon image
                            width: 25,
                            height: 25,
                            color: Colors.white
                          ),
                          onPressed: () {
                            removeFromFavorites(pdfPath, context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
        buildAdContainer(),
      ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget buildAdContainer() {
    print("Ad Status: ${GlobalVariables.globalPurchaseAds}");
    if (GlobalVariables.globalPurchaseAds != "True") {
      return _banner == null
          ? Container()
          : Container(
        margin: const EdgeInsets.only(bottom: 15),
        height: 52,
        child: AdWidget(ad: _banner!),
      );
    } else {
      // Return an empty container or another widget if ads are disabled
      return Container();
    }
  }
  void _createBannerAd() {
    if (GlobalVariables.globalPurchaseAds != "True") {
      _banner = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: AdMobService.bannerAdUnitId!,
        listener: AdMobService.bannerListener,
        request: const AdRequest(),
      )..load();
    } }



  Future<void> removeFromFavorites(String pdfPath, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the current list of favorites or create an empty list if it doesn't exist
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    // Remove the item from the list if it exists
    if (favorites.contains(pdfPath)) {
      favorites.remove(pdfPath);

      // Update SharedPreferences with the modified list
      await prefs.setStringList('favorites', favorites);

      // Show an AlertDialog to inform the user
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Protocol removed from favorites.'),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          FavoriteProtocols(globalFavorites: []),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const beginOpacity = 0.0;
                        const endOpacity = 1.0;
                        var opacityTween = Tween<double>(
                            begin: beginOpacity, end: endOpacity);
                        var fadeAnimation = animation.drive(opacityTween);
                        return FadeTransition(
                          opacity: fadeAnimation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }






} //closes class
