import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:n_c_protocols/pages/favorites.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../globals.dart';
import '../service/ad_mob_service.dart';
import 'home_page/navigationbar.dart';

class CategoryListViewWidget extends StatefulWidget {

  final String agencyName;

  const CategoryListViewWidget({Key? key, required this.agencyName})
      : super(key: key);

  @override
  _CategoryListViewWidgetState createState() =>
      _CategoryListViewWidgetState();
}

class _CategoryListViewWidgetState extends State<CategoryListViewWidget> {

  InterstitialAd? _interstitialAd;
  BannerAd? _banner;
// TODO: replace this test ad unit with your own ad unit.
  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-9944401739416572/7656349965'
      : 'ca-app-pub-9944401739416572/3035384613';

  late List<String> subfolderNames = [];
  List<bool> isFavoriteList = [];
  @override
  void initState() {
    super.initState();
    _createBannerAd();
    print("SubfolderContentsPage initialized"); // Add this line
    fetchDataFromLocalDirectory();
  }


  void fetchDataFromLocalDirectory() async {
    final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    final agencyDirectory = Directory('${appDocumentsDirectory.path}/${widget.agencyName}/Protocols');

    if (await agencyDirectory.exists()) {
      final subdirectories = await agencyDirectory.list().toList();

      // Extract subfolder names and sort them alphabetically
      final sortedSubfolderNames = subdirectories
          .where((subdir) => subdir is Directory)
          .map((subdir) => p.basename(subdir.path))
          .toList()
        ..sort(); // Sort in alphabetical order

      setState(() {
        subfolderNames = sortedSubfolderNames;
        isFavoriteList = List.generate(subfolderNames.length, (index) => false);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    subfolderNames.sort(); // Sort the subfolderNames list alphabetically

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF242935),
        title: Text(
          'Protocol Categories',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 24,
          ),

          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: ImageIcon(
                AssetImage('assets/images/favicon.png'), // Replace with your icon path
                color: Colors.red, // Icon colors
              ),
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
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF242935),
        ),
        child: Column(
          children: [
            Expanded(
        child: Padding(
        padding: EdgeInsets.only(top: 15.0),
              child: ListView.builder(
                itemCount: subfolderNames.length,
                itemBuilder: (context, index) {
                  final subfolderName = subfolderNames[index];
                  return Column(
                    children: [
                      SizedBox(
                        width: 250, // Set the desired fixed width here
                        child: Container(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) {
                                    return SubfolderContentsPage(
                                      agencyName: widget.agencyName,
                                      subfolderName: subfolderName,
                                      pdfIndex: index,
                                      subfolderNames: subfolderNames,
                                      isFavoriteList: isFavoriteList,
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
                            style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              onPrimary: Color(0xA510D3FA),
                              onSurface: Colors.transparent,
                              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 0.0),
                              elevation: 3.0,
                              side: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text(
                              subfolderName,
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  );
                },
              ),
            ),
            ),
            buildAdContainer(),
          ],
        ),
      ),




      bottomNavigationBar: BottomBar(),
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



}

class SubfolderContentsPage extends StatefulWidget {
  final String agencyName;
  final String subfolderName;
  final int pdfIndex;
  final List<String> subfolderNames; // Add subfolderNames as a parameter
  final List<bool> isFavoriteList; // Add isFavoriteList as a parameter

  SubfolderContentsPage({
    required this.agencyName,
    required this.subfolderName,
    required this.pdfIndex,
    required this.subfolderNames, // Add subfolderNames here
    required this.isFavoriteList, // Add isFavoriteList here
  });

  @override
  _SubfolderContentsPageState createState() => _SubfolderContentsPageState();
}




class _SubfolderContentsPageState extends State<SubfolderContentsPage> {
  bool isFavorite = false;
  ButtonStyles buttonStyles = ButtonStyles();
  BannerAd? _banner;
// TODO: replace this test ad unit with your own ad unit.
  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-9944401739416572/7656349965'
      : 'ca-app-pub-9944401739416572/3035384613';

  @override
  void initState() {
    super.initState();

    _createBannerAd();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.subfolderName,
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF242935),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 0.0), // Add padding to the right
            child: IconButton(
              icon: ImageIcon(
                AssetImage('assets/images/favicon.png'), // Replace with your icon path
                color: Colors.red, // Icon colors
              ),
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
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF242935),
        ),
        child: Column(
          children: [
            Expanded(
        child: Padding(
        padding: EdgeInsets.only(top: 16.0),
              child: Container(
                color: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: FutureBuilder<List<File>>(
                    future: fetchPDFFiles(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No PDF files in this subfolder.'));
                      } else {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 20), // Add spacing between ListView and BottomNavigationBar
                          child: ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              final pdfFiles = snapshot.data!;
                              pdfFiles.sort((a, b) {
                                final aName = a.path.split('/').last.replaceAll('.pdf', '');
                                final bName = b.path.split('/').last.replaceAll('.pdf', '');
                                final aNumber = int.tryParse(aName.replaceAll(RegExp(r'[^0-9]'), ''));
                                final bNumber = int.tryParse(bName.replaceAll(RegExp(r'[^0-9]'), ''));
                                return aNumber != null && bNumber != null ? aNumber.compareTo(bNumber) : aName.compareTo(bName);
                              });

                              final pdfFile = pdfFiles[index];
                              final fileName = pdfFile.path.split('/').last;

                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation, secondaryAnimation) {
                                            return PDFViewerWidget(
                                              pdfFilePath: pdfFile.path,
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
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.transparent,
                                      onPrimary: Color(0xFFFFFFFF),
                                      onSurface: Colors.transparent,
                                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                                      elevation: 3.0,
                                      side: BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 25),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                fileName.replaceAll('.pdf', ''),
                                                style: TextStyle(
                                                  color: Color(0xFFFFFFFF),
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 0),
                                          child: IconButton(
                                            icon: Icon(Icons.add, size: 18, color: Colors.red),
                                            onPressed: () {
                                              addToFavoritesAndShowDialog(pdfFile.path, context);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('Protocol added to favorites!'),
                                                  duration: Duration(seconds: 2),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
        ),
            ),
            SizedBox(height: 20),
            buildAdContainer(), // You should replace this with your actual widget
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
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






  // Define a globalFavorites list to store the PDF paths
  List<String> globalFavorites = [];

  // Function to add a PDF path to globalFavorites
  Future<void> addToFavoritesAndShowDialog(String pdfPath, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> currentFavorites = prefs.getStringList('favorites') ?? [];

    currentFavorites.add(pdfPath);

    await prefs.setStringList('favorites', currentFavorites);

    globalFavorites = currentFavorites;
    print(globalFavorites);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupDialog();
      },
    );
  }





  // Function to remove a PDF path from globalFavorites
  void removeFromFavorites(String pdfPath) {
    setState(() {
      globalFavorites.remove(pdfPath);
    });
  }





  Future<List<File>> fetchPDFFiles() async {
    final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    final subfolderDirectory = Directory(
        '${appDocumentsDirectory.path}/${widget.agencyName}/Protocols/${widget.subfolderName}');

    if (await subfolderDirectory.exists()) {
      final pdfFiles = subfolderDirectory
          .listSync()
          .where((file) => file is File && file.path.endsWith('.pdf'))
          .map((file) => File(file.path))
          .toList();

      return pdfFiles;
    } else {
      return [];
    }
  }










}

class IconButtonWithPopup extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add, size: 18, color: Colors.red),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return PopupDialog();
          },
        );
      },
    );
  }
}

class PopupDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Protocol added to favorites!',
        style: TextStyle(
          color: Colors.black, // Change text color to black
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(
            'Close',
            style: TextStyle(
              color: Colors.blue, // Change button text color to blue (iOS style)
            ),
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0), // Add rounded corners to the entire dialog
      ),
    );
  }

}








class PDFViewerWidget extends StatelessWidget {
  final String pdfFilePath;
  final String pdfFileName;




  PDFViewerWidget({required this.pdfFilePath, required this.pdfFileName});






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$pdfFileName",
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
        backgroundColor: Color(0xFF242935),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF242935),
              ),
              child: Padding(
                padding: EdgeInsets.all(10), // Add padding around the ListView
                child: PDFView(
                  filePath: pdfFilePath,
                  enableSwipe: true,
                  swipeHorizontal: false,
                  autoSpacing: true,
                  pageFling: true,
                  fitPolicy: FitPolicy.BOTH,
                  onRender: (pages) {
                    // PDF document is rendered
                  },
                  onError: (error) {
                    // Handle error while opening PDF
                    print(error);
                  },
                ),
              ),
            ),
          ),
          BottomBar(),
        ],
      ),
    );
  }

}

