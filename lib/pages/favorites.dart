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
            colors: [Colors.blue, Colors.black], // Define your gradient colors here
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

            return ElevatedButton(
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
                    padding: EdgeInsets.only(right: 25), // Add padding to the right of the IconButton
                    child: IconButton(
                      icon: Icon(
                        Icons.add,
                        size: 18,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        removeFromFavorites(pdfPath);
                      },
                    ),
                  ),
                ],
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
  Future<void> removeFromFavorites(String pdfPath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the current list of favorites or create an empty list if it doesn't exist
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    // Remove the item from the list if it exists
    favorites.remove(pdfPath);

    // Update SharedPreferences with the modified list
    await prefs.setStringList('favorites', favorites);
  }



} //closes class
