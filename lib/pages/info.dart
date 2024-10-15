import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../globals.dart';
import 'home_page/navigationbar.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../api/purchase_api.dart';
import '../model/entitlement.dart';
import '../utils.dart';
import '../widget/paywall_widget.dart';
import 'package:provider/provider.dart';
import '../provider/revenuecat.dart';

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}


class Info extends StatefulWidget {
  const Info({Key? key}) : super(key: key);

  @override
  InfoState createState() => InfoState();
}

class InfoState extends State<Info> {

  bool isLoading = false;
  bool app_supporter = false;

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

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Please Email'),
          content: Text('Please email ncprotocols@gmail.com in regards to restoring previous ad purchases.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
  Future<String> getDownloadTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve the value associated with the key 'globalDownloadTime'
    return prefs.getString('globalDownloadTime') ?? 'No download time available';
  }




  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'ncprotocols@gmail.com',
    query: encodeQueryParameters(<String, String>{
      'subject': 'NC Protocol Hub',
      'body': 'Please include device type (Android, iOS, Desktop) and add questions, comments, or concerns below.'
    }),
  );

  final Email email = Email(
    body: '*-----Please.include.your.agency.and.the.type.of.phone.you.have.(iOS/Android).in.your.reply-----*',
    subject: 'NC.Protocol.Hub',
    recipients: ['ncprotocols@gmail.com.com'],
    isHTML: false,
  );

  void showInfoAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('App Information'),
          content: SingleChildScrollView(
            child: Text(
              "North Carolina EMS Protocol Hub is NOT intended for diagnosing or direct treatment orders, and is to be ONLY used as reference to the state or your local protocols.\n\n"
                  "Please ensure that every protocol correctly downloaded prior to using app, and please email any errors that need to be fixed.\n\n"
                  "This app has been designed to display every county's protocols if they are available. Please have an admin representative send an email through the app to discuss adding your county protocols to the app. You may now download protocols when an update is released through the 'Settings' icon on the top right of the homepage. Upon downloading, the specific protocols will be available to be accessed even when no internet is available.\n\n"
                  "Ads are in select areas to help cover the fees to create and host the app, and they will never interfere when trying to view a protocol. Updates with new features will continue to be made for this app to improve user interface."
                  "Joining and using this app's service is free. "
                  "For questions, comments, or concerns, please email: ncprotocols@gmail.com or through the 'Contact' button in 'Info'.\n"
                  "\nVersion updated 10/15/24\n\n"
                  "\n(Privacy Policy: https://www.freeprivacypolicy.com/live/a056dab4-49f8-491e-85a1-1078cad34b8f) \n "
                  "\n(Terms of Use (EULA): https://www.apple.com/legal/internet-services/itunes/dev/stdeula/) \n "
                  "\nPayment will be charged to users' Apple account at confirmation of purchase. The subscription automatically renews unless auto-renew is turned off at least 24 hours before the end of the current period.\n"
                  "Account will be charged for renewal within 24 hours prior to the end of the current period, and identify the cost of the renewal.\n"
                  "Subscriptions may be managed by the user and auto-renewal may be turned off or the subscription canceled by the user either through App Store or by opening up the Settings app -> click their name at the top above “Apple ID, iCloud+, Media & Purchases.” -> click the Subscriptions tab."
                  "If the user needs to restore their subscription, they may reach out to customer support at ncprotocols@gmail.com",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

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
              'Subscriptions may be managed by the user and auto-renewal may be turned off or the subscription canceled by the user either through App Store or by opening up the Settings app -> click their name at the top above “Apple ID, iCloud+, Media & Purchases.” -> click the Subscriptions tab.'
              'If user needs to restore their subscription, they may reach out to customer support at ncprotocols@gmail.com',
          onClickedPackage: (package) async {
            await PurchaseApi.purchasePackage(package);
            if (!mounted) return;

            Navigator.pop(context);
          },
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {

    final commonButtonStyle = ButtonStyles.customButtonStyle(context).copyWith(
      backgroundColor: MaterialStateProperty.all(Color(0xFF242935)),);
    final entitlement = context.watch<RevenueCatProvider>().entitlement;
    Future<String> getDownloadTime() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Retrieve the value associated with the key 'globalDownloadTime'
      return prefs.getString('globalDownloadTime') ?? 'No download time available';
    }

    return Scaffold(

      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Info',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold, // Make the title bold
            decoration: TextDecoration.underline, // Add underline to the title
          ),
        ),

        centerTitle: true,
        backgroundColor: Color(0xFF242935),
      ),

        body: Container(
          decoration: BoxDecoration(
            color: Color(0xFF242935),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF4D7DF5)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(16), // Increased padding for balance
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text(
                          'Protocols last downloaded:',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        SizedBox(height: 10),
                        FutureBuilder<String>(
                          future: getDownloadTime(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error loading download time', style: TextStyle(color: Colors.red));
                            } else {
                              String formattedTime = snapshot.data != null
                                  ? DateFormat('HH:mm on MM/dd.').format(DateTime.parse(snapshot.data!))
                                  : 'No download time available';

                              return Text(
                                formattedTime,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 50), // Even spacing between sections
              Center(
                child: ElevatedButton(
                  style: commonButtonStyle.copyWith(
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 50, vertical: 0)),
                  ),
                  onPressed: () {
                    showInfoAlert(context);
                  },
                  child: const Text('App Information',
                    style: TextStyle(color: Color(0xFF00FFFF)),
                  ),
                ),
              ),

              SizedBox(height: 50), // Increased spacing for visual separation
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0), // Consistent vertical padding for buttons
                      child: Container(
                        width: 250.0,
                        child: ElevatedButton(
                          style: commonButtonStyle.copyWith(
                            padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 10)),
                          ),
                          onPressed: () {
                            launchUrl(emailLaunchUri);
                          },
                          child: Text(
                            'Contact',
                            style: TextStyle(color: Color(0xFF639BDC)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10), // Consistent vertical padding for buttons
                      child: Container(
                        width: 250.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFFC0C0C0), // Gold border color
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFFD700).withOpacity(0.1), // Glowing effect
                              spreadRadius: 2,
                              blurRadius: 20,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ElevatedButton(
                          style: commonButtonStyle.copyWith(
                            padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 14)),
                          ),
                          onPressed: isLoading ? null : fetchOffers,
                          child: Text(
                            'Support Development',
                            style: TextStyle(color: Color(0xFFFFEA00)),
                          ),
                        ),
                      ),
                    ),


                    SizedBox(height: 50),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10), // Consistent vertical padding for buttons
                      child: Container(
                        width: 250.0,
                        child: ElevatedButton(
                          style: commonButtonStyle.copyWith(
                            padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 14)),
                          ),
                          onPressed: () {
                            _showPopup(context);
                          },
                          child: Text(
                            'Restore ads',
                            style: TextStyle(color: Color(0xFF4D7DF5)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),


        bottomNavigationBar: BottomBar(),

    );
  }


}
