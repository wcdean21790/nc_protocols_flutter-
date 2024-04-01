import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:n_c_protocols/pages/home_page/navigationbar.dart';
import 'package:n_c_protocols/pages/tools.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

import '../globals.dart';
import '../service/ad_mob_service.dart';
import 'home_page/home_page_widget.dart';
import 'info.dart';

// Define a common function for the custom page route with a fade-in transition.
PageRouteBuilder customPageRouteBuilder(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
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
  );
}

class ProtocolListViewWidget extends StatefulWidget {
  final String agencyName;

  const ProtocolListViewWidget({Key? key, required this.agencyName})
      : super(key: key);

  @override
  _ProtocolListViewWidgetState createState() =>
      _ProtocolListViewWidgetState();
}

class _ProtocolListViewWidgetState extends State<ProtocolListViewWidget> {
  late List<String> subfolderNames = [];
  InterstitialAd? _interstitialAd;
  BannerAd? _banner;
// TODO: replace this test ad unit with your own ad unit.
  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-9944401739416572/7656349965'
      : 'ca-app-pub-9944401739416572/3035384613';
  @override
  void initState() {
    super.initState();
    fetchDataFromLocalDirectory();
  }

  void fetchDataFromLocalDirectory() async {
    final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    final agencyDirectory =
    Directory('${appDocumentsDirectory.path}/${widget.agencyName}');

    if (await agencyDirectory.exists()) {
      final subdirectories = await agencyDirectory.list().toList();

      setState(() {
        subfolderNames = subdirectories
            .where((subdir) => subdir is Directory)
            .map((subdir) => p.basename(subdir.path))
            .toList();
      });
    }
  }

  void _navigateToSubfolderContents(String subfolderName) {
    Navigator.of(context).push(
      customPageRouteBuilder(
        SubfolderContentsPage(
          agencyName: widget.agencyName,
          subfolderName: subfolderName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
        ),
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Color(0xA510D3FA),
            fontSize: 24,
          ),
          button: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Protocol Categories for ${widget.agencyName}',
            style: TextStyle(
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: Container(
          color: Colors.black,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: subfolderNames.length,
                  itemBuilder: (context, index) {
                    final subfolderName = subfolderNames[index];
                    return Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _navigateToSubfolderContents(subfolderName);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF639BDC),
                          ),
                          child: Text(
                            subfolderName,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        if (index == subfolderNames.length - 1)
                          buildAdContainer(), // Add the ad container below the last button
                      ],
                    );
                  },
                ),

              ),
              buildAdContainer(),
            ],
          ),
        ),

        bottomNavigationBar: BottomBar(), // Include the bottom bar here
      ),
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


class SubfolderContentsPage extends StatelessWidget {
  final String agencyName;
  final String subfolderName;


  const SubfolderContentsPage({
    required this.agencyName,
    required this.subfolderName,
  });

  Future<List<File>> fetchPDFFiles() async {
    final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    final subfolderDirectory =
    Directory('${appDocumentsDirectory.path}/${agencyName}/$subfolderName');

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contents of $subfolderName'),
      ),
      body: FutureBuilder<List<File>>(
        future: fetchPDFFiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No PDF files in this subfolder.'));
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      final pdfFile = snapshot.data![index];
                      return ListTile(
                        title: Text(pdfFile.path),
                        onTap: () {
                          // Open the selected PDF file
                          // You can navigate to a PDF viewer here
                        },
                      );
                    },
                  ),
                ), // Add the ad container below the ListView.builder
              ],
            );
          }
        },
      ),

      bottomNavigationBar: BottomBar(), // Include the bottom bar here
    );
  }






}







void main() {
  runApp(MaterialApp(
    home: ProtocolListViewWidget(agencyName: 'YourAgencyName'),
  ));
}
