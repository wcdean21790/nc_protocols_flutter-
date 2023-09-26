import 'package:flutter/material.dart';
import 'package:n_c_protocols/pages/protocol_listview.dart';
import 'package:n_c_protocols/pages/tools.dart';
import 'package:url_launcher/url_launcher.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../globals.dart';
import 'home_page/home_page_widget.dart';
import 'home_page/navigationbar.dart';


class Info extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Info',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(25.0),
                child: Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                      'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
                      'Ut enim ad minim veniam, quis nostrud exercitation ullamco '
                      'laboris nisi ut aliquip ex ea commodo consequat. '
                      'Duis aute irure dolor in reprehenderit in voluptate velit '
                      'esse cillum dolore eu fugiat nulla pariatur. '
                      'Excepteur sint occaecat cupidatat non proident, '
                      'sunt in culpa qui officia deserunt mollit anim id est laborum.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
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
      bottomNavigationBar: BottomBar()
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
        builder: (context) => AlertDialog(
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
    const url = 'https://www.buymeacoffee.com/wcdean217';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // Handle error: Unable to launch the website
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Unable to open the website.'),
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









} //closes class
