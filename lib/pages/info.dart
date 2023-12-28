import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../globals.dart';
import 'home_page/navigationbar.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../api/purchase_api.dart';
import '../model/entitlement.dart';
import '../utils.dart';
import '../widget/paywall_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../api/purchase_api.dart';
import '../model/entitlement.dart';
import '../provider/revenuecat.dart';
import '../utils.dart';
import '../widget/paywall_widget.dart';



class Info extends StatefulWidget {
  const Info({Key? key}) : super(key: key);

  @override
  InfoState createState() => InfoState();
}

class InfoState extends State<Info> {
  bool isLoading = false;



  @override
  Widget build(BuildContext context) {
    final commonButtonStyle = ButtonStyles.customButtonStyle(context).copyWith(
      // Set your common button style properties here
      // For example, you can set the background color
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
                    border: Border.all(color: Color(0xFF4D7DF5)), // Add black border
                    borderRadius: BorderRadius.circular(8), // Optional: Add border radius for rounded corners
                  ),
                  padding: EdgeInsets.all(8), // Optional: Add padding for space around the column
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Last download of protocols was at: ',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      FutureBuilder<String>(
                        future: getDownloadTime(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error loading download time');
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
                      ),
                    ],
                  ),
                ),

              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(25.0),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.0), // Padding for this text
                    child: Text(
                      "North Carolina EMS Protocol Hub is NOT intended for diagnosing or direct treatment orders, and is to be ONLY used as reference to the state or your local protocols.\n\n"
                          "This app has been designed to display every county's protocols if they are available. Please have an admin representative send an email through the app to discuss adding your county protocols to the app. You may now download protocols when an update is released through the 'Settings' icon on the top right of the homepage. Upon downloading, the specific protocols will be available to be accessed even when no internet is available.\n\n"
                          "Ads are in a few areas to help cover the fees to create and host the app, and they will never interfere when trying to view a protocol. Updates will continue to be made for this app to improve user interface. For questions, comments, or concerns, please email: ncprotocols@gmail.com or through the 'Contact' button in 'Info'.\n"
                          "\nVersion updated 12/27/23\n\n"
                          "\n(Privacy Policy: https://www.freeprivacypolicy.com/live/a056dab4-49f8-491e-85a1-1078cad34b8f) \n "
                          "\n(Terms of Use (EULA): https://www.apple.com/legal/internet-services/itunes/dev/stdeula/) \n "
                          "\nPayment will be charged to users Apple account at confirmation of purchase. The subscription automatically renews unless auto-renew is turned off at least 24 hours before the end of the current period.\n"
                          "Account will be charged for renewal within 24 hours prior to the end of the current period, and identify the cost of the renewal.\n"
                          'Subscriptions may be managed by the user and auto-renewal may be turned off or the subscription canceled by the user either through App Store or by opening up the Settings app -> click their name at the top above “Apple ID, iCloud+, Media & Purchases.” -> click the Subscriptions tab.'
                          "If the user needs to restore their subscription, they may reach out to customer support at ncprotocols@gmail.com",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        // Add more style properties as needed
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 25), // Spacing
            Center(
              child: Column (
                children: [
                  Padding(
                    padding: EdgeInsets.all(0), // Padding for "Contact" button
                    child: Container(
                      width: 250.0, // Set your desired width here
                      child: ElevatedButton(
                        style: commonButtonStyle,
                        onPressed: () {
                          _launchEmail(context); // Pass the context
                        },
                        child: Text(
                          'Contact',
                          style: TextStyle(color: Color(0xFF4D7DF5)), // Change text color here
                        ),
                      ),
                    ),
                  ), // 10 pixels of padding below "Contact" button// 10 pixels of padding below "Contact" button
                  Padding(
                    padding: EdgeInsets.all(10), // Padding for "Donate" button
                    child: Container(
                      width: 250.0, // Set your desired width here
                      child: ElevatedButton(
                        style: commonButtonStyle,
                        onPressed: isLoading ? null : fetchOffers,
                        child: Text(
                          'Support and remove ads',
                          style: TextStyle(color: Color(0xFF4D7DF5)), // Set the text color to red
                        ),
                      ),

                    ),

                  ),
                  Padding(
                    padding: EdgeInsets.only(left:10, right: 10, bottom: 10), // Padding for "Donate" button
                    child: Container(
                      width: 250.0, // Set your desired width here
                      child: ElevatedButton(
                        onPressed: () {
                          _showPopup(context);
                        },
                        style: commonButtonStyle,
                        child: Text(
                          'Restore ads',
                          style: TextStyle(color: Color(0xFF4D7DF5)), // Change text color here
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
          title: '⭐  Remove Ads ⭐',
          description: 'Payment will be charged to users Apple account at confirmation of purchase. Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period'
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


  _launchEmail(BuildContext context) async {
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'ncprotocols@gmail.com', // Replace with your email address
      queryParameters: {
        'subject': 'NC.Protocol.Hub',
        'body': '*-----Please.include.the.type.of.phone.you.have.(iOS/Android).in.your.reply-----*',
      },
    );

    if (await canLaunch(_emailLaunchUri.toString())) {
      await launch(_emailLaunchUri.toString());
    } else {
      // Handle error: Unable to launch the email
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Unable to open the email client.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator of;(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }



  final Email email = Email(
    body: '*-----Please.include.your.agency.and.the.type.of.phone.you.have.(iOS/Android).in.your.reply-----*',
    subject: 'NC.Protocol.Hub',
    recipients: ['ncprotocols@gmail.com.com'],
    isHTML: false,
  );







}
