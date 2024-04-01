import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../globals.dart';
import '../home_page/navigationbar.dart';
import '../password_dialog.dart';

class MajorListViewWidget extends StatefulWidget {
  const MajorListViewWidget({Key? key}) : super(key: key);

  @override
  _MajorListViewWidgetState createState() => _MajorListViewWidgetState();
}

class _MajorListViewWidgetState extends State<MajorListViewWidget> {
  List<String> agencyNames = [];
  late Directory appDocumentsDirectory;

  @override
  void initState() {
    super.initState();
    initializeAppDocumentsDirectory();
    fetchDataFromHttps();
  }

  @override
  Widget build(BuildContext context) {
    EasyLoading.init(); // Initialize EasyLoading
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF242935),
          title: Align(
            alignment: Alignment.centerRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Download Protocols',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),

                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 15.0, left: 10),
              child: IconButton(
                onPressed: () async {
                  // Your delete function here
                },
                icon: Image.asset(
                  'assets/images/trashicon.png',
                  width: 25.0,
                  height: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Color(0xFF242935),
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: agencyNames.length,
                    itemBuilder: (context, index) {
                      agencyNames.sort();
                      final agencyName = agencyNames[index];
                      return Column(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              // Handle your button press here
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xD78EF),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(
                                    'assets/images/favicon.png',
                                    width: 80,
                                    height: 80,
                                  ),
                                  Text(
                                    agencyName,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Future<void> initializeAppDocumentsDirectory() async {
    appDocumentsDirectory = await getApplicationDocumentsDirectory();
  }

  Future<void> fetchDataFromHttps() async {
    const String baseUrl = 'https://ncprotocols-661da-default-rtdb.firebaseio.com/Agency_Information.json';
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          agencyNames = data.keys.toList();
        });
      } else {
        print('Failed to load agency names');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
}
