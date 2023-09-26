import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:n_c_protocols/pages/home_page/navigationbar.dart';
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

  late Directory appDocumentsDirectory;

  @override
  void initState() {
    super.initState();
    initializeAppDocumentsDirectory();
    _databaseReference =
        FirebaseDatabase.instance.reference().child('Agency_Information');
    fetchDataFromFirebase();
  }



  @override
  Widget build(BuildContext context) {
    EasyLoading.init(); // Initialize EasyLoading
    return MaterialApp(
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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.black], // Define your gradient colors here
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
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
                        primary: Colors.blue,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FutureBuilder<String?>(
                              future: _getHomescreenPictureLink(agencyName),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done &&
                                    snapshot.hasData) {
                                  final imageUrl = snapshot.data!;
                                  return Image.network(
                                    imageUrl,
                                    width: 80,
                                    height: 80,
                                    errorBuilder: (context, error, stackTrace) {
                                      // Handle any errors when loading the image
                                      return Icon(Icons.error); // You can display an error icon or message here
                                    },
                                  );
                                } else {
                                  // You can display a placeholder image while loading
                                  return Image.asset(
                                    'assets/images/favicon.png', // Replace with your placeholder image
                                    width: 80,
                                    height: 80,
                                  );
                                }
                              },
                            ),
                            Text(
                              agencyName,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(width: 8),
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
        bottomNavigationBar: BottomBar(),
      ),
    );
  }



  Future<void> initializeAppDocumentsDirectory() async {
    appDocumentsDirectory = await getApplicationDocumentsDirectory();
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

    _updateGlobalVariables(agencyName);

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
                final List<MapEntry<String, String>> filesToDownload = [];

                categoryData.forEach((entryKey, entryValue) {
                  final childNodeKey = entryKey as String?;
                  final childNodeData = entryValue as String?;

                  if (childNodeKey != null && childNodeData != null) {
                    filesToDownload.add(MapEntry(childNodeKey, childNodeData));
                  }
                });

                // Sort the files alphabetically by key (file name)
                filesToDownload.sort((a, b) => a.key.compareTo(b.key));

                for (final entry in filesToDownload) {
                  final childNodeKey = entry.key;
                  final link = entry.value;

                  try {
                    final response = await http.get(Uri.parse(link));

                    if (response.statusCode == 200) {
                      final appDocumentsDirectory =
                      await getApplicationDocumentsDirectory();
                      final agencyDirectory = Directory(
                          '${appDocumentsDirectory.path}/$agencyName/Protocols/$categoryName');

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
              } else {
                print("Data is null in Firebase for category $categoryName");
              }
            } else {
              print("Invalid data structure in Firebase for category $categoryName");
            }
          });

          // Download the Homescreen Picture
          await _getHomescreenPictureLink(agencyName);
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




  Future<void> _updateGlobalVariables(String agencyName) async {
    String? imageUrl = await _getHomescreenPictureLink(agencyName);
    if (imageUrl != null) {
      // Store the URL in the globalAgencyLogo variable
      GlobalVariables.globalAgencyLogo = imageUrl;
      print(GlobalVariables.globalAgencyLogo);

      // Save the updated global variables to SharedPreferences
      GlobalVariables.saveGlobalVariables();
    }
  }

  Future<String> _getHomescreenPictureLink(String agencyName) async {


    // Fetch the "Homescreen Picture" link for the selected agency under the "Data" node
    DatabaseEvent event =
    await _databaseReference.child(agencyName).child('Data').once();
    DataSnapshot snapshot = event.snapshot;
    dynamic data = snapshot.value;

    if (data is Map<dynamic, dynamic>?) {
      if (data != null && data.containsKey('Homescreen Picture')) {
        final imageUrl = data['Homescreen Picture'].toString();
        print('Image URL for $agencyName: $imageUrl'); // Print the URL to the console
        return imageUrl;
      }
    }

    // If the URL is not found or there's an error, you can return a default value or an empty string.
    return "";
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
      downloadProtocols(agencyName);
      _getHomescreenPictureLink(agencyName);
    }
  }



}
