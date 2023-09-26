import 'dart:io';
import 'package:flutter/material.dart';

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
