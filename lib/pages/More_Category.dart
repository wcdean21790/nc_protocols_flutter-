import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../flutter_flow/flutter_flow_widgets.dart';
import '../globals.dart';
import '../service/ad_mob_service.dart';
import 'home_page/navigationbar.dart';
import 'hospitals.dart';

class MoreListViewWidget extends StatefulWidget {
  final String agencyName;

  const MoreListViewWidget({Key? key, required this.agencyName})
      : super(key: key);

  @override
  _MoreListViewWidgetState createState() => _MoreListViewWidgetState();
}

class _MoreListViewWidgetState extends State<MoreListViewWidget> {
  late List<String> subfolderNames = [];
  List<bool> isFavoriteList = [];
  late DatabaseReference _databaseReference;
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  BannerAd? _banner;


  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.reference();
    fetchDataFromLocalDirectory();
    _createBannerAd();
  }

  void fetchDataFromLocalDirectory() async {
    final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    final agencyDirectory =
    Directory('${appDocumentsDirectory.path}/More');

    if (await agencyDirectory.exists()) {
      final subdirectories = await agencyDirectory.list().toList();

      final sortedSubfolderNames = subdirectories
          .where((subdir) => subdir is Directory)
          .map((subdir) => p.basename(subdir.path))
          .toList()
        ..sort();

      setState(() {
        subfolderNames = sortedSubfolderNames;
        isFavoriteList =
            List.generate(subfolderNames.length, (index) => false);
      });
    }
  }

  Future fetchPhoneNumbers() async {
    print(GlobalVariables.globalAgencyName); // Print the agency name for debugging

    DatabaseReference ref = FirebaseDatabase.instance.ref();

    final snapshot = await ref.child('Agency_Information').child('${GlobalVariables.globalAgencyName}').child('Data').child('PhoneNumbers').get();

    if (snapshot.exists) {
      final data = snapshot.value!; // Get the data as a Map

      // Debugging: Print the data
      print("Data: $data");
    }
  }

  ButtonStyle customButtonStyle(BuildContext context) {
    return TextButton.styleFrom(
      backgroundColor: Color(0xFF242935), // Background color
      primary: Color(0xA510D3FA), // Text color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25), // Adjust the border radius as needed
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'More Categories',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            decoration: TextDecoration.underline,
            decorationColor: Colors.white, // Set the underline color to white
          ),

          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF242935), // Set the background color here
      ),

        body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF242935),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 25, right: 15, left: 15),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        itemCount: subfolderNames.length,
                        itemBuilder: (context, index) {
                          final subfolderName = subfolderNames[index];
                          return Column(
                            children: [
                              SizedBox(
                                width: 250,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) {
                                          return SubfolderContentsPage(
                                            agencyName: widget.agencyName,
                                            subfolderName: subfolderName,
                                          );
                                        },
                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  style: ButtonStyles.customButtonStyle(context),
                                  child: Text(
                                    subfolderName,
                                    style: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontSize: 18,
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

                    SizedBox(height: 10), // Add spacing after the ListView
                    Padding(
                      padding: EdgeInsets.only(bottom: 10), // Add bottom padding
                      child: SizedBox(
                        width: 250, // Set the button width
                        child: ElevatedButton(
                          onPressed: () {
                            fetchPhoneNumbers();
                            // Navigate to the PhoneNumbersListView when the button is clicked
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PhoneNumbersListView()),
                            );
                          },
                          style: ButtonStyles.customButtonStyle(context),
                          child: Text(
                            "Phone Numbers",
                            style: TextStyle(
                              color: Color(0xFFFFEA00),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 300), // Add bottom padding
                      child: SizedBox(
                        width: 250, // Set the button width
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return WarningDialog();
                              },
                            ).then((value) {
                              if (value != null && value) {
                                // User confirmed, you can proceed with your logic
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Hospitals()),
                                );
                              }
                            });
                          },

                          style: ButtonStyles.customButtonStyle(context),
                          child: Text(
                            "Directions",
                            style: TextStyle(
                              color: Color(0xFF36AD8D),
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: buildAdContainer(),
          ),

        ],

      ),



      // Bottom Navigation Bar
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
    _banner = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId!,
      listener: AdMobService.bannerListener,
      request: const AdRequest(),
    )..load();
  }







}

class SubfolderContentsPage extends StatefulWidget {
  final String agencyName;
  final String subfolderName;

  SubfolderContentsPage({
    required this.agencyName,
    required this.subfolderName,
  });

  @override
  _SubfolderContentsPageState createState() => _SubfolderContentsPageState();
}

class _SubfolderContentsPageState extends State<SubfolderContentsPage> {
  List<File>? pdfFiles;
  BannerAd? _banner;
  @override
  void initState() {
    super.initState();
    _createBannerAd();
    fetchPDFFiles(widget.agencyName);
  }


  @override
  Widget build(BuildContext context) {
    String currentFolderName = "DD"; // Get the current folder name

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.subfolderName, // Set the title to the current folder name
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            decoration: TextDecoration.underline,
            decorationColor: Colors.white, // Set the underline color to white
          ),

          textAlign: TextAlign.center,
        ),
        backgroundColor: Color(0xFF242935),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF242935),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.transparent,
                child: FutureBuilder<List<File>>(
                  future: fetchPDFFiles(widget.agencyName),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No PDF files in this subfolder.'));
                    } else {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25), // Add padding here
                        child: ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            final pdfFile = snapshot.data![index];
                            final fileName = pdfFile.path.split('/').last;

                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) {
                                          return PDFViewerWidget(
                                            pdfFilePath: pdfFile.path,
                                            pdfFileName: fileName.replaceAll('.pdf', ''),
                                          );
                                        },
                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  style: ButtonStyles.customButtonStyle(context),
                                  child: Text(
                                    fileName.replaceAll('.pdf', ''),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFFFFFFFF), // Use the same text color
                                    ),
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
            buildAdContainer(),
          ],
        ),
      ),


      bottomNavigationBar: BottomBar(), // Use your custom BottomBar widget here
    );
  }



  Future<List<File>> fetchPDFFiles(String agencyName) async {
    final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    final subfolderDirectory =
    Directory('${appDocumentsDirectory.path}/More/${widget.subfolderName}');

    if (await subfolderDirectory.exists()) {
      final pdfFiles = subfolderDirectory
          .listSync()
          .where((file) => file is File && file.path.endsWith('.pdf'))
          .map((file) => File(file.path))
          .toList();

      return pdfFiles; // Return the list of files here
    } else {
      return []; // Return an empty list if no files found
    }
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





class PDFViewerWidget extends StatelessWidget {
  final String pdfFilePath;
  final String pdfFileName;

  PDFViewerWidget({required this.pdfFilePath, required this.pdfFileName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "$pdfFileName",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            decoration: TextDecoration.underline,
            decorationColor: Colors.white, // Set the underline color to white
          ),

        ),
        backgroundColor: Color(0xFF242935),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: PDFView(
                filePath: pdfFilePath,
                enableSwipe: true,
                swipeHorizontal: false,
                autoSpacing: false,
                pageFling: false,
                onRender: (pages) {},
                onError: (error) {
                  print(error);
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
void main() {
  runApp(MaterialApp(
    home: MoreListViewWidget(agencyName: 'YourAgencyName'), // Replace 'YourAgencyName' with your agency name
  ));
}





class PhoneNumbersListView extends StatefulWidget {
  @override
  _PhoneNumbersListViewState createState() => _PhoneNumbersListViewState();
}
class _PhoneNumbersListViewState extends State<PhoneNumbersListView> {
  BannerAd? _banner;
  Map<String, String> data = {}; // Declare data at the class level
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _createBannerAd();
    fetchPhoneNumbers().then((phoneData) {
      setState(() {
        data = phoneData;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF242935), // Make the app bar background transparent
        title: Text(
          "Phone Numbers",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            decoration: TextDecoration.underline,
            decorationColor: Colors.white, // Set the underline color to white
          ),
          // Set text color to white
        ),
        centerTitle: true, // Center the title horizontally
      ),

      body: data.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF242935),
              ),
              child: Scrollbar(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final sortedKeys = data.keys.toList()..sort(); // Sort the keys alphabetically
                    final key = sortedKeys[index];
                    final phoneNumber = data[key];

                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: SizedBox(
                        width: 50,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 75),
                          child: FFButtonWidget(
                            onPressed: () {
                              _makePhoneCall(phoneNumber!);
                            },
                            text: key,
                            options: FFButtonOptions(
                              alignment: Alignment.center,
                              height: 40.0,
                              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 0.0),
                              iconPadding: EdgeInsets.zero,
                              color: Colors.transparent,
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              elevation: 3.0,
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.25,
                              ),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          buildAdContainer(),
        ],
      ),






      bottomNavigationBar: BottomBar(),
    );
  }

  // Add a function to initiate a phone call
  _makePhoneCall(String phoneNumber) {
    final url = 'tel:$phoneNumber';
    launch(url);
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
    _banner = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId!,
      listener: AdMobService.bannerListener,
      request: const AdRequest(),
    )..load();
  }
  Future<Map<String, String>> fetchPhoneNumbers() async {
    // Replace with your Firebase Database reference path
    DatabaseEvent event = await FirebaseDatabase.instance
        .reference()
        .child('Agency_Information')
        .child(GlobalVariables.globalAgencyName)
        .child('Data')
        .child('PhoneNumbers')
        .once();
    DataSnapshot snapshot = event.snapshot;
    dynamic data = snapshot.value;

    // Process the data and extract phone numbers and titles
    Map<String, String> phoneNumbers = {};

    if (data is Map) {
      data.forEach((key, value) {
        if (value is String) {
          phoneNumbers[key] = value;
        }
      });
    }

    return phoneNumbers;
  }
}



class WarningDialog extends StatefulWidget {
  @override
  _WarningDialogState createState() => _WarningDialogState();
}

class _WarningDialogState extends State<WarningDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'This app is not to be used while operating a motor vehicle. By continuing you acknowledge you are not using this app while operating a motor vehicle.',
          ),
          SizedBox(height: 16), // Add some spacing between the text and buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Add your download logic here
                  // For example: downloadFile();
                  Navigator.of(context).pop(true); // Close the AlertDialog with success
                },
                child: Text('Confirm'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Close the AlertDialog with failure
                },
                child: Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
