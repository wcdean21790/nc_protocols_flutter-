import 'package:flutter/material.dart';
import 'package:n_c_protocols/pages/favorites.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../globals.dart';
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
        scaffoldBackgroundColor: Colors.transparent, // Set the app's background color to transparent
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue, // Set the app bar's background color to transparent
        ),
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.black,
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
              color: Colors.black,
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10.0), // Add padding to the right
              child: IconButton(
                icon: ImageIcon(
                  AssetImage('assets/images/favicon.png'), // Replace with your icon path
                  color: Colors.red, // Icon colors
                ),
                onPressed: () async {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          FavoriteProtocols(globalFavorites: []),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const beginOpacity = 0.0;
                        const endOpacity = 1.0;
                        var opacityTween = Tween<double>(
                            begin: beginOpacity, end: endOpacity);
                        var fadeAnimation = animation.drive(opacityTween);
                        return FadeTransition(
                          opacity: fadeAnimation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),

        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: GlobalVariables.colorTheme, // Define your gradient colors here
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 10.0),
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
                      style: ButtonStyles.customButtonStyle(context),
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
  ButtonStyles buttonStyles = ButtonStyles();


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.subfolderName,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10.0), // Add padding to the right
            child: IconButton(
              icon: ImageIcon(
                AssetImage('assets/images/favicon.png'), // Replace with your icon path
                color: Colors.red, // Icon colors
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        FavoriteProtocols(globalFavorites: []),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const beginOpacity = 0.0;
                      const endOpacity = 1.0;
                      var opacityTween = Tween<double>(
                          begin: beginOpacity, end: endOpacity);
                      var fadeAnimation = animation.drive(opacityTween);
                      return FadeTransition(
                        opacity: fadeAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: GlobalVariables.colorTheme, // Define your gradient colors here
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
                                  padding: EdgeInsets.symmetric(horizontal: 15), // Add horizontal padding
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
                                    style: ButtonStyles.customButtonStyle(context), // Use the customButtonStyle
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 25),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                fileName.replaceAll('.pdf', ''),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18, // Adjust the font size here if needed
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 0), // Add padding to the right of the IconButton
                                          child: IconButton(
                                            icon: Icon(Icons.add, size: 18, color: Colors.red),
                                            onPressed: () {
                                              addToFavoritesAndShowDialog(pdfFile.path, context);
                                              // Show a snackbar when the "+" button is pressed
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('Protocol added to favorites!'),
                                                  duration: Duration(seconds: 2), // Adjust the duration as needed
                                                ),
                                              );
                                            },
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
            SizedBox(height: 20), // Add spacing between ListView and BottomNavigationBar
            BottomBar(), // You should replace this with your actual widget
          ],
        ),
      ),
    );
  }







  // Define a globalFavorites list to store the PDF paths
  List<String> globalFavorites = [];

  // Function to add a PDF path to globalFavorites
  Future<void> addToFavoritesAndShowDialog(String pdfPath, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> currentFavorites = prefs.getStringList('favorites') ?? [];

    currentFavorites.add(pdfPath);

    await prefs.setStringList('favorites', currentFavorites);

    globalFavorites = currentFavorites;
    print(globalFavorites);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupDialog();
      },
    );
  }





  // Function to remove a PDF path from globalFavorites
  void removeFromFavorites(String pdfPath) {
    setState(() {
      globalFavorites.remove(pdfPath);
    });
  }





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










}

class IconButtonWithPopup extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add, size: 18, color: Colors.red),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return PopupDialog();
          },
        );
      },
    );
  }
}

class PopupDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Protocol added to favorites!'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Close'),
        ),
      ],
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
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: GlobalVariables.colorTheme,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(10), // Add padding around the ListView
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
          ),
          BottomBar(),
        ],
      ),
    );
  }

}

