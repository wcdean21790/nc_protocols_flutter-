import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../globals.dart';
import 'home_page/navigationbar.dart';


class Info extends StatelessWidget {

  final Uri _url = Uri.parse('https://www.buymeacoffee.com/wcdean217');


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
                  child: Padding(
                    padding: EdgeInsets.all(10.0), // Padding for this text
                    child: Text(
                      "North Carolina EMS Protocol Hub was designed and created by Wills Dean. This app is NOT intended for diagnosing or direct treatment orders, and is to be ONLY used as reference to the state or your local protocols.\n\n"
                          "This app has been designed to display every county's protocols if they are available. Please have an admin representative send an email through the app to discuss adding your county protocols to the app. You may now download protocols when an update is released through the 'Settings' icon on the top right of the homepage. Upon downloading, the specific protocols will be available to be accessed even when no internet is available.\n\n"
                          "For those interested, you may buy me a coffee to support the creation of this app through the donation button below. Ads are only on the general State protocols to help cover the fees to create and host the app. Updates will continue to be made for this app to improve user interface. For questions, comments, or concerns, please email: ncprotocols@gmail.com or through the 'Contact' button in 'Info'.\n\n"
                          "Some features may not be included in all versions of the app currently. \n \n  Version updated 10/17/23",
                      style: TextStyle(
                        color: Colors.black,
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
                    child: ElevatedButton(
                      onPressed: () {
                       // FlutterEmailSender.send(email);
                        _launchEmail(context); // Pass the context
                      },
                      child: Text('Contact'),
                    ),
                  ),
                  SizedBox(height: 10), // 10 pixels of padding below "Contact" button
                  Padding(
                    padding: EdgeInsets.all(20), // Padding for "Donate" button
                    child: ElevatedButton(
                      onPressed: () {
                        _launchUrl();// Pass the context
                      },
                      child: Text('Donate'),
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
