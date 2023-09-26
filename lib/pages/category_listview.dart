import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
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
    print("SubfolderContentsPage initialized"); // Add this line
    fetchDataFromLocalDirectory();
  }


  void fetchDataFromLocalDirectory() async {
    final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    final agencyDirectory = Directory('${appDocumentsDirectory.path}/${widget.agencyName}/Protocols');

    if (await agencyDirectory.exists()) {
      final subdirectories = await agencyDirectory.list().toList();

      // Extract subfolder names and sort them alphabetically
      final sortedSubfolderNames = subdirectories
          .where((subdir) => subdir is Directory)
          .map((subdir) => p.basename(subdir.path))
          .toList()
        ..sort(); // Sort in alphabetical order

      setState(() {
        subfolderNames = sortedSubfolderNames;
        isFavoriteList = List.generate(subfolderNames.length, (index) => false);
      });
    }
  }





  @override
  Widget build(BuildContext context) {
    subfolderNames.sort(); // Sort the subfolderNames list alphabetically
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.blueAccent, // Set the app's background color to transparent
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent, // Set the app bar's background color to transparent
        ),
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold, // Make the title bold
            decoration: TextDecoration.underline, // Add underline to the title
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
            'Protocol Categories',
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
                    builder: (context) => FavoriteProtocols(favoritePDFs: []), // Pass your favorite PDFs list here
                  ),
                );
              },
            ),
          ],
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
          child: ListView.builder(
            itemCount: subfolderNames.length,
            itemBuilder: (context, index) {
              final subfolderName = subfolderNames[index];
              return Column(
                children: [
                  SizedBox(
                    width: 250, // Set the desired fixed width here
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) {
                              return SubfolderContentsPage(
                                agencyName: widget.agencyName,
                                subfolderName: subfolderName,
                                pdfIndex: index, // Pass the index to the SubfolderContentsPage
                                subfolderNames: subfolderNames, // Pass subfolderNames here
                                isFavoriteList: isFavoriteList, // Pass isFavoriteList here
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
                        primary: Color(0xFF0D78EF),
                      ),
                      child: Text(
                        subfolderName,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
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
  final List<String> subfolderNames; // Add subfolderNames as a parameter
  final List<bool> isFavoriteList; // Add isFavoriteList as a parameter

  SubfolderContentsPage({
    required this.agencyName,
    required this.subfolderName,
    required this.pdfIndex,
    required this.subfolderNames, // Add subfolderNames here
    required this.isFavoriteList, // Add isFavoriteList here
  });

  @override
  _SubfolderContentsPageState createState() => _SubfolderContentsPageState();
}


class _SubfolderContentsPageState extends State<SubfolderContentsPage> {
  bool isFavorite = false;


  Future<List<File>> fetchPDFFiles() async {
    final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    final subfolderDirectory = Directory(
        '${appDocumentsDirectory.path}/${widget.agencyName}/Protocols/${widget.subfolderName}');

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.subfolderName,
            style: TextStyle(
                color: Colors.white,
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
              child: Container(
                color: Colors.transparent, // Set the inner container's color to transparent
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
                        return Padding(
                          padding: EdgeInsets.only(bottom: 25), // Add spacing between ListView and BottomNavigationBar
                          child: ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              // Sort the PDF files numerically by extracting and comparing the numeric part of file names
                              final pdfFiles = snapshot.data!;
                              pdfFiles.sort((a, b) {
                                final aName = a.path.split('/').last.replaceAll('.pdf', '');
                                final bName = b.path.split('/').last.replaceAll('.pdf', '');
                                final aNumber = int.tryParse(aName.replaceAll(RegExp(r'[^0-9]'), ''));
                                final bNumber = int.tryParse(bName.replaceAll(RegExp(r'[^0-9]'), ''));
                                return aNumber != null && bNumber != null ? aNumber.compareTo(bNumber) : aName.compareTo(bName);
                              });

                              final pdfFile = pdfFiles[index];
                              final fileName = pdfFile.path.split('/').last;

                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 25), // Add horizontal padding
                                  child: ElevatedButton(
                                    onPressed: () {
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
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                    ).copyWith(
                                      minimumSize: MaterialStateProperty.all(Size(50, 40)), // Set the width to 100
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 40),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                fileName.replaceAll('.pdf', ''),
                                                style: TextStyle(
                                                  fontSize: 14, // Dynamic font size
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 25), // Add padding to the right of the "+"
                                          child: Text(
                                            '+',
                                            style: TextStyle(
                                              fontSize: 18, // Font size for "+"
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 10), // Add spacing between ListView and BottomNavigationBar
            BottomBar(), // You should replace this with your actual widget
          ],
        ),
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
        title: Text(
          'Favorite Protocols',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Make the title bold
            decoration: TextDecoration.underline, // Add underline to the title
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
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
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold, // Make the title bold
            decoration: TextDecoration.underline, // Add underline to the title
          ),
        ),
        backgroundColor: Colors.blue, // Set app bar background color to black
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

