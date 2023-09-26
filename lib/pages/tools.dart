import 'package:flutter/material.dart';
import 'package:n_c_protocols/pages/home_page/navigationbar.dart';
import 'package:url_launcher/url_launcher.dart';

class ToolsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tools',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.black], // Define your gradient colors here
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: ListView(
                  children: [
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _launchWebpage();
                          },
                          child: Text(
                            'Epocrates',
                            style: TextStyle(
                              color: Colors.black, // Set the text color to black
                            ),
                          ),
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.black), // Text color when the button is enabled
                          ),
                        )

                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Custom Navigation Row
            BottomBar()
          ],
        ),
      ),
    );
  }



  void _launchWebpage() async {
    const url = 'https://www.epocrates.com';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }



} //closes class
