import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:n_c_protocols/pages/Tools/TimeTempo.dart';
import 'package:n_c_protocols/pages/Tools/timestamp.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/purchase_api.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../globals.dart';
import '../../service/ad_mob_service.dart';
import '../../utils.dart';
import '../../widget/paywall_widget.dart';
import '../home_page/navigationbar.dart';
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
    _databaseReference = FirebaseDatabase.instance.ref();
    fetchDataFromLocalDirectory();
    _createBannerAd();
  }


  //Revenue cat offers
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
          title: '⭐  Support Development ⭐',
          description: 'Payment will be charged to users Apple/Google account at confirmation of purchase. Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period'
              'Account will be charged for renewal within 24-hours prior to the end of the current period, and identify the cost of the renewal'
              'Subscriptions are be managed by the user and auto-renewal may be turned off or the subscription canceled by the user either through App/Play Store or by opening up the device Settings -> Search for device subscriptions.'
              'If user needs to restore their subscription, go through device store first, then user may reach out to customer support at ncprotocols@gmail.com',
          onClickedPackage: (package) async {
            await PurchaseApi.purchasePackage(package);
            if (!mounted) return;

            Navigator.pop(context);
          },
        ),
      );
    }
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
      foregroundColor: Color(0xA510D3FA), backgroundColor: Color(0xFF242935), // Text color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25), // Adjust the border radius as needed
      ),
    );
  }

  Future<bool> showRestrictedFeatureDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Restricted Feature'),
          content: Text(
            'This feature requires an in-app purchase to be enabled. Please support development and purchase subscription to proceed.',
          ),
          actions: [
            // "OK" Button to close the dialog without proceeding
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false
              },
              child: Text('OK'),
            ),
            // "Support" Button to initiate the purchase
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Return true and proceed with purchase
                fetchOffers(); // Call fetchOffers to show purchase options
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent, // Button color
              ),
              child: Text(
                'Support',
                style: TextStyle(
                  color: Colors.white, // Set button text color
                ),
              ),
            ),
          ],
        );
      },
    );
    return result ?? false; // Default to false if dialog is dismissed
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF242935),

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

        body: Container(
          color: Color(0xFF242935), // Set the background color here
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // ListView wrapped in a constrained height
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 300), // Adjust height as needed
                  child: ListView.builder(
                    shrinkWrap: true, // Ensures the list view takes minimal height
                    physics: NeverScrollableScrollPhysics(), // Disable internal scrolling
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

                // Buttons section wrapped in Column with even spacing
          Column(
            children: [
              SizedBox(height: 10),

              // Button: Phone Numbers
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    bool? globalPurchaseSupport = prefs.getBool('globalPurchaseSupport');

                    // Prevent navigation if the user does not have a subscription
                    if (globalPurchaseSupport == null || globalPurchaseSupport == false) {
                      final proceed = await showRestrictedFeatureDialog(context);
                      if (!proceed) return; // Stop if user did not proceed
                    } else {
                      fetchPhoneNumbers();
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return PhoneNumbersListView();
                          },
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(0.0, 1.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;
                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            return FadeTransition(opacity: animation, child: child);
                          },
                        ),
                      );
                    }
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

              SizedBox(height: 10),

              // Button: Directions
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    bool? globalPurchaseSupport = prefs.getBool('globalPurchaseSupport');

                    // Prevent navigation if the user does not have a subscription
                    if (globalPurchaseSupport == null || globalPurchaseSupport == false) {
                      final proceed = await showRestrictedFeatureDialog(context);
                      if (!proceed) return; // Stop if user did not proceed
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return WarningDialog();
                        },
                      ).then((value) {
                        if (value != null && value) {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) {
                                return Hospitals();
                              },
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(0.0, 1.0);
                                const end = Offset.zero;
                                const curve = Curves.ease;
                                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                return FadeTransition(opacity: animation, child: child);
                              },
                            ),
                          );
                        }
                      });
                    }
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

              SizedBox(height: 10),

              // Button: Time Stamper
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    bool? globalPurchaseSupport = prefs.getBool('globalPurchaseSupport');

                    // Prevent navigation if the user does not have a subscription
                    if (globalPurchaseSupport == null || globalPurchaseSupport == false) {
                      final proceed = await showRestrictedFeatureDialog(context);
                      if (!proceed) return; // Stop if user did not proceed
                    } else {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return TimeStampWidget(); // Replace with actual page
                          },
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(0.0, 1.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;
                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            return FadeTransition(opacity: animation, child: child);
                          },
                        ),
                      );
                    }
                  },
                  style: ButtonStyles.customButtonStyle(context),
                  child: Text(
                    "Action Logger",
                    style: TextStyle(
                      color: Color(0xFF00FFFF),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),

              // Button: Tempo Tool
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    bool? globalPurchaseSupport = prefs.getBool('globalPurchaseSupport');

                    // Prevent navigation if the user does not have a subscription
                    if (globalPurchaseSupport == null || globalPurchaseSupport == false) {
                      final proceed = await showRestrictedFeatureDialog(context);
                      if (!proceed) return; // Stop if user did not proceed
                    } else {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return BPMCalculator(); // Replace with actual page
                          },
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(0.0, 1.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;
                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            return FadeTransition(opacity: animation, child: child);
                          },
                        ),
                      );
                    }
                  },
                  style: ButtonStyles.customButtonStyle(context),
                  child: Text(
                    "Tempo Tool",
                    style: TextStyle(
                      color: Color(0xFF8A2BE2),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 50), // Optional space at the bottom
            ],
          ),


          Align(
                  alignment: Alignment.center,
                  child: buildAdContainer(),
                ),
              ],
            ),
          ),

        ),







        // Bottom Navigation Bar

      bottomNavigationBar: BottomBar(),
    );
  }

  Widget buildAdContainer() {
    print("Ad Status: ${GlobalVariables.globalPurchaseAds}");
    if (GlobalVariables.globalPurchaseAds != true) {
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
    if (GlobalVariables.globalPurchaseAds != true) {
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
    if (GlobalVariables.globalPurchaseAds != true) {
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
    if (GlobalVariables.globalPurchaseAds != true) {
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
        .ref()
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