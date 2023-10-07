import 'package:flutter/material.dart';
import 'package:n_c_protocols/pages/home_page/navigationbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'category_listview.dart';

class FavoriteProtocols extends StatefulWidget {
  final List<String> globalFavorites;

  // Constructor that accepts globalFavorites as a parameter
  FavoriteProtocols({required this.globalFavorites});

  @override
  _FavoriteProtocolsState createState() => _FavoriteProtocolsState();
}

class _FavoriteProtocolsState extends State<FavoriteProtocols> {
  List<String> globalFavorites = [];


  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    setState(() {
      globalFavorites = favorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(globalFavorites);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorite Protocols',
          style: TextStyle(color: Colors.black), // Set app bar text color to black
        ),
        centerTitle: true,
        backgroundColor: Colors.blue, // Set app bar background color to white
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
        child: ListView.builder(
          itemCount: globalFavorites.length,
          itemBuilder: (context, index) {
            final pdfPath = globalFavorites[index];
            final fileName = pdfPath.split('/').last;

            return Padding(
              padding: const EdgeInsets.only(bottom: 15,
              top: 25,
              left: 35,
              right: 35),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return PDFViewerWidget(
                          pdfFilePath: pdfPath, // Pass the pdfPath here
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
                      padding: EdgeInsets.only(right: 15), // Add padding to the right of the IconButton
                      child: IconButton(
                        icon: ImageIcon(
                          AssetImage('assets/images/trashicon.png'), // Provide the path to your image
                          color: Colors.red, // Set the desired color
                          size: 35, // Set the desired size
                        ),
                        onPressed: () {
                          removeFromFavorites(pdfPath, context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white, // Set the navigation bar background color to white
        child: BottomBar(),
      ),
    );
  }

  Future<void> removeFromFavorites(String pdfPath, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the current list of favorites or create an empty list if it doesn't exist
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    // Remove the item from the list if it exists
    if (favorites.contains(pdfPath)) {
      favorites.remove(pdfPath);

      // Update SharedPreferences with the modified list
      await prefs.setStringList('favorites', favorites);

      // Show an AlertDialog to inform the user
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Protocol removed from favorites.'),
            actions: <Widget>[
              TextButton(
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
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }






} //closes class
