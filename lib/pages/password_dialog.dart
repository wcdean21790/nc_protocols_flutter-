import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:n_c_protocols/globals.dart';

import '../service/ad_mob_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Enter password'),
        ),
        body: PasswordDialog(),
      ),
    );
  }
}

class PasswordDialog extends StatefulWidget {
  @override
  _PasswordDialogState createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.reference().child("NC_Protocols").child(GlobalVariables.globalAgencyName);

  Future<void> checkPasswordAndPrintData() async {
    final snapshot = await _databaseRef.get();

    if (snapshot.exists) {
      final data = snapshot.value.toString(); // Convert Firebase data to string
      final enteredPassword = _passwordController.text;

      if (enteredPassword == data) {
        // Passwords match, call the Downloadprotocols() function
        Navigator.of(context).pop(true); // Close dialog wi
      } else {
        // Passwords don't match
        print('Password does not match.');
      }
    } else {
      print('No data available.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enter password to download'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Password'),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  checkPasswordAndPrintData();
                },
                child: Text('Enter'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the AlertDialog
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



class ConfirmDialog extends StatelessWidget {
  InterstitialAd? _interstitialAd;
  int maxFailedLoadAttempts = 3;
// TODO: replace this test ad unit with your own ad unit.


  late DatabaseReference _databaseReference;
  List<String> agencyNames = [];
  String downloadStatus = ''; // Define the downloadStatus variable
  String Moredata = "Data will be displayed here";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirm download?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Total download size is <200 MB.'),
          SizedBox(height: 16),  // Add some spacing between the text and buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _showInterstitialAd();
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

}