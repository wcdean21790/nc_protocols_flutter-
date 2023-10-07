import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:n_c_protocols/flutter_flow/flutter_flow_theme.dart';
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
  String downloadStatus = ''; // Define the downloadStatus variable
  String Moredata = "Data will be displayed here";

  late Directory appDocumentsDirectory;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
    initializeAppDocumentsDirectory();
    _databaseReference =
        FirebaseDatabase.instance.reference().child('Agency_Information');
    fetchDataFromFirebase();
    downloadMoreDataFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    EasyLoading.init(); // Initialize EasyLoading
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Padding(
            padding: EdgeInsets.only(right: 15.0), // Add 10 pixels of padding to the right
            child: Align(
              alignment: Alignment.centerRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Download Specific Agency Protocols',
                    style: GoogleFonts.poppins()
                        .override(
                      fontFamily: 'Work Sans',
                      color: Color(0xFF000000),
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 15.0), // Add 15 pixels of padding to the right
              child: IconButton(
                onPressed: () async {
                  _deleteAppData(context);
                },
                icon: ClipOval(
                  child: Image.asset(
                    'assets/images/reseticon.png',
                    width: 40.0,
                    height: 40.0,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),

        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.grey], // Define your gradient colors here
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
                        //print("Before calling downloadMoreDataFromFirebase()");
                        //downloadMoreDataFromFirebase();
                        //print("After calling downloadMoreDataFromFirebase()");

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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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

            if (agencyInfo != null &&
                (agencyInfo.containsKey("Protocols"))) {
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

  Future<void> downloadMoreDataFromFirebase() async {
    print("Starting downloadMoreDataFromFirebase()");

    // Ensure Firebase is initialized before using it.
    await Firebase.initializeApp();

    DatabaseReference databaseReference =
    FirebaseDatabase.instance.reference().child('More');

    try {
      DataSnapshot snapshot = await databaseReference.get();

      print("Fetched data: ${snapshot.value}");

      if (snapshot.value != null && snapshot.value is Map<dynamic, dynamic>) {
        final Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        // Call the _downloadData function to download the PDFs
        await _downloadData(data, "", "More", []);

        print("Download process completed successfully.");
      } else {
        print("Data in the 'More' node is not in the expected format.");
      }
    } catch (error) {
      print("Error fetching data: $error"); // Debug: Print error message
    }

    print("Finishing downloadMoreDataFromFirebase()");
  }







  Future<void> downloadProtocols(String agencyName) async {
    final downloadStatusList = <String>[];
    String downloadStatus = '';

    void updateStatus(String newStatus) {
      downloadStatus = newStatus;
      EasyLoading.show(status: downloadStatus);
    }

    updateStatus('Downloading $downloadStatus...do NOT close out of the app, as protocols are downloading in the background. May take several minutes depending on internet speed. Please report any bugs to ncprotocols@gmail.com (can be found in settings). Ads do not interfere with accessing any protocol and help fund hosting/development of the app.');

    final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    final directoryToDelete = Directory('${appDocumentsDirectory.path}/$agencyName');

    if (await directoryToDelete.exists()) {
      try {
        await directoryToDelete.delete(recursive: true);
        print("Deleted directory: ${directoryToDelete.path}");
      } catch (e) {
        print("Error deleting directory: $e");
      }
    }

    _updateGlobalVariables(agencyName);

    try {
      final protocolsEvent = await _databaseReference.child(agencyName).child('Protocols').once();


      final protocolsSnapshot = protocolsEvent.snapshot;

      dynamic protocolsData = protocolsSnapshot.value;

      if (protocolsData is Map<dynamic, dynamic>?) {
        if (protocolsData != null) {
          await _downloadData(protocolsData, agencyName, 'Protocols', downloadStatusList);
        } else {
          print("Data is null in Protocols");
        }
      } else {
        print("Invalid data structure in Protocols");
      }

      final downloadStatus = downloadStatusList.join('\n');

      EasyLoading.dismiss();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Download Complete'),
            content: Text(downloadStatus),
            actions: <Widget>[
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
    } catch (e) {
      print("Error downloading files: $e");
      EasyLoading.dismiss();
    }
  }










  void _deleteAppData(BuildContext context) async {
    final appDocumentsDirectory = await getApplicationDocumentsDirectory();

    // Show a confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete application directory data?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                // Close the dialog
                Navigator.of(context).pop();

                try {
                  final directoryToDelete = Directory(appDocumentsDirectory.path);
                  if (await directoryToDelete.exists()) {
                    await directoryToDelete.delete(recursive: true);
                    print("Deleted application directory data.");
                  }
                } catch (e) {
                  print("Error deleting application directory data: $e");
                }
              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
  }





  Future<void> _downloadData(Map<dynamic, dynamic> data, String agencyName, String node, List<String> downloadStatusList) async {
    await Future.forEach(data.entries, (entry) async {
      final categoryKey = entry.key.toString();
      final categoryData = entry.value as Map<dynamic, dynamic>;

      final filesToDownload = <MapEntry<String, String>>[];

      categoryData.forEach((entryKey, entryValue) {
        final childNodeKey = entryKey.toString();
        final childNodeData = entryValue.toString();
        filesToDownload.add(MapEntry(childNodeKey, childNodeData));
      });

      filesToDownload.sort((a, b) => a.key.compareTo(b.key));

      for (final entry in filesToDownload) {
        final childNodeKey = entry.key;
        final link = entry.value;

        try {
          final response = await http.get(Uri.parse(link));

          if (response.statusCode == 200) {
            final appDocumentsDirectory = await getApplicationDocumentsDirectory();
            final agencyDirectory = Directory(
              '${appDocumentsDirectory.path}/$agencyName/$node/$categoryKey',
            );

            if (!await agencyDirectory.exists()) {
              await agencyDirectory.create(recursive: true);
            }

            final fileName = '$childNodeKey.pdf';
            final filePath = '${agencyDirectory.path}/$fileName';
            final file = File(filePath);

            await file.writeAsBytes(response.bodyBytes);

            downloadStatusList.add('Downloaded: $childNodeKey');
            print('Downloaded $childNodeKey.pdf');
            print('Stored in: $filePath'); // Added for debugging
          } else {
            downloadStatusList.add('Failed to download: $childNodeKey');
            print('Failed to download $childNodeKey.pdf. Status code: ${response.statusCode}');
            // You can also print response.body for more details if needed.
          }
        } catch (e) {
          downloadStatusList.add('Error downloading $childNodeKey: $e');
          print('Error downloading $childNodeKey.pdf: $e');
        }
      }
    });
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
      downloadMoreDataFromFirebase();
      //downloadProtocols(agencyName);
      _getHomescreenPictureLink(agencyName);
    }
  }



}
