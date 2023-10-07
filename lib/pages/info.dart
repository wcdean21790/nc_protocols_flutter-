import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../globals.dart';
import 'home_page/navigationbar.dart';


class Info extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Info',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold, // Make the title bold
            decoration: TextDecoration.underline, // Add underline to the title
          ),
        ),

        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: GlobalVariables.colorTheme,
            // Define your gradient colors here
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(25.0),
                child: Center(
                  child: Text(
                    "North Carolina EMS Protocol Hub was designed and created by Wills Dean. This app is NOT intended for diagnosing or direct treatment orders, and is to be ONLY used as reference to the state or your local protocols.\n\n"
                        "This app has been designed to display every county's protocols if they are available. Please have an admin representative send email through app to discuss adding your county protocols to app. You may now download protocols when an update is released through the 'Settings' icon on the top right of the homepage. Upon downloading, the specific protocols will be available to be accessed even when no internet is available.\n\n"
                        "For those interested, you may buy me a coffee to support the creation of this app through the donation button in button below. Ads are only on the general State protocols to help cover the fees to create and host the app. Updates will continue to be made for this app to improve user interface. For questions, comments, or concerns, please email: ncprotocols@gmail.com or through 'Contact' button in 'Info'.\n\n"
                        "Please allow notifications for future update alerts. \n \n  Version updated 10/7/23",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 25), // Spacing
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _launchEmail(context); // Pass the context
                    },
                    child: Text('Contact'),
                  ),
                  SizedBox(height: 25), // Spacing
                  ElevatedButton(
                    onPressed: () {
                      _launchWebsite(context); // Pass the context
                    },
                    child: Text('Donate'),
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


  _launchEmail(BuildContext context) async {
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'ncprotocols@gmail.com', // Replace with your email address
      queryParameters: {
        'subject': 'Contact via Flutter App', // Set the subject for the email
      },
    );

    if (await canLaunch(_emailLaunchUri.toString())) {
      await launch(_emailLaunchUri.toString());
    } else {
      // Handle error: Unable to launch the email
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Error'),
              content: Text('Unable to open email client.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            ),
      );
    }
  }

  _launchWebsite(BuildContext context) async {
    const url = 'https://flutter.dev';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
