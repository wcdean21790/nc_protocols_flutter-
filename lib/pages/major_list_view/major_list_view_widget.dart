import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../globals.dart';
import '../password_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MajorListViewWidget extends StatefulWidget {
  const MajorListViewWidget({Key? key}) : super(key: key);

  @override
  _MajorListViewWidgetState createState() => _MajorListViewWidgetState();
}

class _MajorListViewWidgetState extends State<MajorListViewWidget> {
  late DatabaseReference _databaseReference;
  List<String> agencyNames = [];

  @override
  void initState() {
    super.initState();
    _databaseReference =
        FirebaseDatabase.instance.reference().child('Agency_Information');
    fetchDataFromFirebase();
  }

  void fetchDataFromFirebase() {
    _databaseReference.once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value;
        List<String> newAgencyNames = [];

        if (data is Map<dynamic, dynamic>) {
          data.keys.forEach((dynamic agencyName) {
            final agencyInfo = data[agencyName] as Map<dynamic, dynamic>;

            if (agencyInfo != null && agencyInfo.containsKey("Protocols")) {
              if (agencyName is String) {
                newAgencyNames.add(agencyName);
              }
            }
          });
        }
        setState(() {
          agencyNames = newAgencyNames;
        });
      }
    }).catchError((error) {
      print('Error fetching data: $error');
    });
  }

  Future<void> downloadProtocols(String agencyName) async {
    EasyLoading.show(status: 'Downloading...');

    try {
      // Fetch the "Protocols" node for the selected agency
      DatabaseEvent event =
      await _databaseReference.child(agencyName).child('Protocols').once();
      DataSnapshot snapshot = event.snapshot;
      dynamic data = snapshot.value;

      if (data is Map<dynamic, dynamic>?) {
        if (data != null) {
          data.forEach((categoryKey, categoryData) async {
            final categoryName = categoryKey.toString();

            if (categoryData is Map<dynamic, dynamic>?) {
              if (categoryData != null) {
                categoryData.forEach((entryKey, entryValue) async {
                  final childNodeKey = entryKey as String?;
                  final childNodeData = entryValue as String?;

                  if (childNodeKey != null && childNodeData != null) {
                    final link = childNodeData.toString();

                    try {
                      final response = await http.get(Uri.parse(link));

                      if (response.statusCode == 200) {
                        final appDocumentsDirectory =
                        await getApplicationDocumentsDirectory();
                        final agencyDirectory = Directory(
                            '${appDocumentsDirectory.path}/$agencyName/$categoryName');

                        // Create the agency and category directories if they don't exist
                        if (!await agencyDirectory.exists()) {
                          await agencyDirectory.create(recursive: true);
                        }

                        final fileName = '$childNodeKey.pdf';
                        final filePath = '${agencyDirectory.path}/$fileName';
                        final file = File(filePath);

                        // Write the downloaded content to the file
                        await file.writeAsBytes(response.bodyBytes);

                        // Print the download status and file location to the terminal
                        print("Downloaded: $link");
                        print("Stored in: $filePath");
                      } else {
                        print("Failed to download: $link");
                      }
                    } catch (e) {
                      print("Error downloading $link: $e");
                    }
                  }
                });
              } else {
                print("Data is null in Firebase for category $categoryName");
              }
            } else {
              print("Invalid data structure in Firebase for category $categoryName");
            }
          });

          // Download the Homescreen Picture
          await downloadHomescreenPicture(agencyName);
        } else {
          print("Data is null in Firebase");
        }
      } else {
        print("Invalid data structure in Firebase");
      }

      EasyLoading.dismiss();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Download Complete'),
            content: Text('All files have been downloaded successfully.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("Error downloading files: $e");
      EasyLoading.dismiss();
    }
  }

  Future<void> downloadHomescreenPicture(String agencyName) async {
    EasyLoading.show(status: 'Downloading Homescreen Picture...');

    try {
      // Fetch the "Homescreen Picture" link for the selected agency
      String? homescreenPictureLink = await _getHomescreenPictureLink(agencyName);

      if (homescreenPictureLink != null) {
        final response = await http.get(Uri.parse(homescreenPictureLink));

        if (response.statusCode == 200) {
          final appDocumentsDirectory = await getApplicationDocumentsDirectory();
          final agencyDirectory = Directory('${appDocumentsDirectory.path}/$agencyName');

          // Create the agency directory if it doesn't exist
          if (!await agencyDirectory.exists()) {
            await agencyDirectory.create(recursive: true);
          }

          final fileName = '$agencyName.jpg'; // You can change the file name if needed
          final filePath = '${agencyDirectory.path}/$fileName';
          final file = File(filePath);

          // Write the downloaded content to the file
          await file.writeAsBytes(response.bodyBytes);

          // Print the download status and file location to the terminal
          print("Downloaded Homescreen Picture: $homescreenPictureLink");
          print("Stored in: $filePath");
        } else {
          print("Failed to download Homescreen Picture: $homescreenPictureLink");
        }
      }
    } catch (e) {
      print("Error downloading Homescreen Picture: $e");
    }

    EasyLoading.dismiss();
  }

  Future<String?> _getHomescreenPictureLink(String agencyName) async {
    // Fetch the "Homescreen Picture" link for the selected agency
    DatabaseEvent event =
    await _databaseReference.child(agencyName).child('data').once();
    DataSnapshot snapshot = event.snapshot;
    dynamic data = snapshot.value;

    if (data is Map<dynamic, dynamic>?) {
      if (data != null && data.containsKey('Homescreen Picture')) {
        return data['Homescreen Picture'].toString();
      }
    }

    return null;
  }

  Future<void> _showPasswordDialog(String agencyName) async {
    final success = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return PasswordDialog(); // Show the custom password dialog
      },
    );

    if (success != null && success) {
      // Password was entered correctly, proceed with the download
      downloadHomescreenPicture(agencyName);
      downloadProtocols(agencyName);
      downloadHomescreenPicture(agencyName);
    }
  }

  @override
  Widget build(BuildContext context) {
    EasyLoading.init(); // Initialize EasyLoading

    return MaterialApp(
      theme: ThemeData(
        backgroundColor: Colors.black, // Set the app's background color to black
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            'Download Specific Agency Protocols',
            style: TextStyle(
              color: Colors.white, // Set the text color to white
              fontSize: 18, // Adjust the font size as needed
            ),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Navigate back to the previous screen
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
          color: Colors.black, // Set the background color of the Container to black
          child: Padding(
            padding: EdgeInsets.all(10), // Add 10 pixels of padding around the ListView
            child: ListView.builder(
              itemCount: agencyNames.length,
              itemBuilder: (context, index) {
                final agencyName = agencyNames[index];
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        // Set the globalAgencyName first
                        GlobalVariables.globalAgencyName = agencyName;

                        // Save the changes to SharedPreferences
                        await GlobalVariables.saveGlobalVariables();

                        // Now, show the password dialog
                        _showPasswordDialog(agencyName);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue, // Change the button's background color as needed
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10), // Add 10 pixels of padding to the entire button
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align items at the start and end of the row
                          children: [
                            Image.asset(
                              'assets/images/favicon.png',  // Replace with the path to your image in the assets folder
                              width: 80, // Adjust the width as needed
                              height: 80, // Adjust the height as needed
                            ),
                            Text(
                              agencyName,
                              style: TextStyle(
                                color: Colors.black54, // Set the text color to white
                                fontSize: 18, // Adjust the font size as needed
                              ),
                            ),
                            SizedBox(width: 8), // Add spacing between the image and text
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 10), // Add spacing between buttons
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
