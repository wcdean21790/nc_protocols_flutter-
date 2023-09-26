import 'package:flutter/material.dart';
import 'package:n_c_protocols/globals.dart';
import 'package:n_c_protocols/pages/protocol_listview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:n_c_protocols/globals.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import 'home_page/navigationbar.dart';

class CategoryListViewWidget extends StatefulWidget {
  final String agencyName;

  const CategoryListViewWidget({Key? key, required this.agencyName})
      : super(key: key);

  @override
  _CategoryListViewWidgetState createState() =>
      _CategoryListViewWidgetState();
}

class _CategoryListViewWidgetState extends State<CategoryListViewWidget> {
  late List<String> subfolderNames = [];
  List<bool> isFavoriteList = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromLocalDirectory();
  }

  void fetchDataFromLocalDirectory() async {
    final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    final agencyDirectory =
    Directory('${appDocumentsDirectory.path}/${widget.agencyName}');

    if (await agencyDirectory.exists()) {
      final subdirectories = await agencyDirectory.list().toList();

      setState(() {
        subfolderNames = subdirectories
            .where((subdir) => subdir is Directory)
            .map((subdir) => p.basename(subdir.path))
            .toList();
        isFavoriteList = List.generate(subfolderNames.length, (index) => false);
      });
    }
  }

  void _navigateToSubfolderContents(String subfolderName, int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SubfolderContentsPage(
          agencyName: widget.agencyName,
          subfolderName: subfolderName,
          pdfIndex: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
        ),
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
          button: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Protocol Categories for ${widget.agencyName}',
            style: TextStyle(
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: ImageIcon(
                AssetImage('assets/images/favicon.png'), // Replace with your icon path
                color: Colors.white, // Icon color
              ),
              onPressed: () {
                // Open the favoriteProtocols class or navigate to it here
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FavoriteProtocols(favoritePDFs: [],),
                  ),
                );
              },
            ),
          ],
        ),
        body: Container(
          color: Colors.black,
          child: ListView.builder(
            itemCount: subfolderNames.length,
            itemBuilder: (context, index) {
              final subfolderName = subfolderNames[index];
              return Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _navigateToSubfolderContents(subfolderName, index);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF639BDC),
                    ),
                    child: Text(
                      subfolderName,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: BottomBar(),
      ),
    );
  }
}

class SubfolderContentsPage extends StatefulWidget {
  final String agencyName;
  final String subfolderName;
  final int pdfIndex;

  SubfolderContentsPage({
    required this.agencyName,
    required this.subfolderName,
    required this.pdfIndex,
  });

  @override
  _SubfolderContentsPageState createState() => _SubfolderContentsPageState();
}

class _SubfolderContentsPageState extends State<SubfolderContentsPage> {
  bool isFavorite = false;

  Future<List<File>> fetchPDFFiles() async {
    final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    final subfolderDirectory =
    Directory('${appDocumentsDirectory.path}/${widget.agencyName}/${widget.subfolderName}');

    if (await subfolderDirectory.exists()) {
      final pdfFiles = subfolderDirectory
          .listSync()
          .where((file) => file is File && file.path.endsWith('.pdf'))
          .map((file) => File(file.path))
          .toList();

      return pdfFiles;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subfolderName),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: FutureBuilder<List<File>>(
                  future: fetchPDFFiles(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No PDF files in this subfolder.'));
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          final pdfFile = snapshot.data![index];
                          final fileName = pdfFile.path.split('/').last;

                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                // Add a transition effect when opening a new widget
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) {
                                      return PDFViewerWidget(
                                        pdfFilePath: pdfFile.path,
                                        pdfFileName: fileName.replaceAll('.pdf', ''),
                                      );
                                    },
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      const beginOpacity = 0.0;
                                      const endOpacity = 1.0;
                                      var opacityTween = Tween<double>(begin: beginOpacity, end: endOpacity);
                                      var fadeAnimation = animation.drive(opacityTween);
                                      return FadeTransition(
                                        opacity: fadeAnimation,
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF639BDC),
                                padding: EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                minimumSize: Size(0, 40),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Text(
                                      fileName.replaceAll('.pdf', ''),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      isFavorite ? Icons.favorite : Icons.favorite_border,
                                      color: Colors.red, // Change the color based on whether it's a favorite
                                    ),
                                    onPressed: () {
                                      // Toggle the favorite status for the specific PDF
                                      setState(() {
                                        isFavorite = !isFavorite;
                                      });

                                      // Add logic to store or remove the PDF from favorites
                                      if (isFavorite) {
                                        // Add the PDF to favorites
                                        // You can implement your favorite PDF storage logic here
                                      } else {
                                        // Remove the PDF from favorites
                                        // You can implement your favorite PDF removal logic here
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          BottomBar(), // Include the bottom bar here
        ],
      ),
    );
  }
}

class FavoriteProtocols extends StatelessWidget {
  final List<File> favoritePDFs;

  FavoriteProtocols({required this.favoritePDFs});

  @override
  Widget build(BuildContext context) {
    // Implement your UI for displaying favorite PDFs here
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Protocols'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: favoritePDFs.length,
        itemBuilder: (context, index) {
          final pdfFile = favoritePDFs[index];
          final fileName = pdfFile.path.split('/').last;

          return ListTile(
            title: Text(fileName.replaceAll('.pdf', '')),
            // Add any other UI elements you want to display for favorite PDFs
          );
        },
      ),
    );
  }
}


class PDFViewerWidget extends StatelessWidget {
  final String pdfFilePath;
  final String pdfFileName;

  PDFViewerWidget({required this.pdfFilePath, required this.pdfFileName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$pdfFileName",
          style: TextStyle(color: Colors.blueAccent),
        ),
        backgroundColor: Colors.black, // Set app bar background color to black
        iconTheme: IconThemeData(color: Colors.black), // Set icon color to black
        centerTitle: true, // Center the title text
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black, // Set body background color to black
              child: PDFView(
                filePath: pdfFilePath,
                enableSwipe: true,
                swipeHorizontal: false,
                autoSpacing: false,
                pageFling: false,
                onRender: (pages) {
                  // PDF document is rendered
                },
                onError: (error) {
                  // Handle error while opening PDF
                  print(error);
                },
              ),
            ),
          ),
          BottomBar(), // Include the bottom bar here
        ],
      ),
    );
  }
}

