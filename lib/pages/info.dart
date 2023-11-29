import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:go_router/go_router.dart';
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
  final Uri _url = Uri.parse('https://www.buymeacoffee.com/wcdean217');


  @override
  Widget build(BuildContext context) {
    final entitlement = context.watch<RevenueCatProvider>().entitlement;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Info',
          style: TextStyle(
            color: Colors.grey,
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
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(25.0),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.0), // Padding for this text
                    child: Text(
                      "North Carolina EMS Protocol Hub was designed and created by Wills Dean. This app is NOT intended for diagnosing or direct treatment orders, and is to be ONLY used as reference to the state or your local protocols.\n\n"
                          "This app has been designed to display every county's protocols if they are available. Please have an admin representative send an email through the app to discuss adding your county protocols to the app. You may now download protocols when an update is released through the 'Settings' icon on the top right of the homepage. Upon downloading, the specific protocols will be available to be accessed even when no internet is available.\n\n"
                          "For those interested, you may buy me a coffee to support the creation of this app through the donation button below. Ads are in a few areas to help cover the fees to create and host the app. They will never interfere when trying to view a protocol. Updates will continue to be made for this app to improve user interface. For questions, comments, or concerns, please email: ncprotocols@gmail.com or through the 'Contact' button in 'Info'.\n\n"
                          "Some features may not be included in all versions of the app currently. \n \n  Version updated 11/2/23",
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 25), // Spacing
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(0), // Padding for "Contact" button
                    child: Container(
                      width: 250.0, // Set your desired width here
                      child: ElevatedButton(
                        style: ButtonStyles.customButtonStyle(context),
                        onPressed: () {
                          _launchEmail(context); // Pass the context
                        },
                        child: Text('Contact'),
                      ),
                    ),
                  ), // 10 pixels of padding below "Contact" button
                  Padding(
                    padding: EdgeInsets.all(10), // Padding for "Donate" button
                    child: Container(
                      width: 250.0, // Set your desired width here
                      child: ElevatedButton(
                        style: ButtonStyles.customButtonStyle(context),
                        onPressed: () {
                          _launchUrl();// Pass the context
                        },
                        child: Text('Donate'),
                      ),
                    ),
                  ), // 10 pixels of padding below "Contact" button
                  Padding(
                    padding: EdgeInsets.all(10), // Padding for "Donate" button
                    child: Container(
                      width: 250.0, // Set your desired width here
                      child: ElevatedButton(
                        style: ButtonStyles.customButtonStyle(context),
                        onPressed: isLoading ? null : fetchOffers,
                        child: Text('Remove Ads'),
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
          description: 'Support app development by removing ads!',
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

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  final Email email = Email(
    body: '*-----Please.include.the.type.of.phone.you.have.(iOS/Android).in.your.reply-----*',
    subject: 'NC.Protocol.Hub',
    recipients: ['ncprotocols@gmail.com.com'],
    isHTML: false,
  );







}
