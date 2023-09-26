import 'package:flutter/material.dart';

class FavoriteProtocols extends StatelessWidget {
  final List<String> favoritePDFs; // Replace this with your data source

  FavoriteProtocols({required this.favoritePDFs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Protocols'),
      ),
      body: ListView.builder(
        itemCount: favoritePDFs.length,
        itemBuilder: (context, index) {
          final pdfName = favoritePDFs[index];

          return ListTile(
            title: Text(
              pdfName,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () {
              // Implement what should happen when a favorite PDF is tapped
              // For example, open the PDF viewer for this PDF
              _openPDFViewer(context, pdfName);
            },
          );
        },
      ),
    );
  }

  // Function to open the PDF viewer for a specific PDF
  void _openPDFViewer(BuildContext context, String pdfName) {
    // Implement this function to navigate to the PDF viewer or take any other action.
    // For example, you can use Navigator to navigate to the PDF viewer screen.
    // Replace this with your own logic.
  }
}
