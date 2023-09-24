import 'package:flutter/material.dart';
import 'package:n_c_protocols/globals.dart';
import 'package:n_c_protocols/pages/protocol_listview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:n_c_protocols/globals.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart'; // Import PDF viewer package




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
      });
    }
  }

  void _navigateToSubfolderContents(String subfolderName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SubfolderContentsPage(
          agencyName: widget.agencyName,
          subfolderName: subfolderName,
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
                      _navigateToSubfolderContents(subfolderName);
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
      ),
    );
  }
}




class SubfolderContentsPage extends StatelessWidget {
  final String agencyName;
  final String subfolderName;

  SubfolderContentsPage({
    required this.agencyName,
    required this.subfolderName,
  });

  Future<List<File>> fetchPDFFiles() async {
    final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    final subfolderDirectory =
    Directory('${appDocumentsDirectory.path}/$agencyName/$subfolderName');

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
        title: Text(subfolderName),
        centerTitle: true,
        backgroundColor: Colors.black, // Set app bar background color to black
      ),
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: EdgeInsets.all(15), // Add 15-point padding around the contents
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
                    final fileName = pdfFile.path.split('/').last; // Get file name
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 10), // Add vertical spacing
                      child: ElevatedButton(
                        onPressed: () {
                          // Open the selected PDF file in an image viewer widget
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PDFViewerWidget(
                                pdfFilePath: pdfFile.path,
                                pdfFileName: fileName.replaceAll('.pdf', ''), // Pass the file name
                              ),
                            ),
                          );

                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF639BDC), // Blue button color
                          padding: EdgeInsets.all(0), // Remove padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ), // Round the left edges
                          ),
                          minimumSize: Size(0, 40), // Set minimum button size (adjust the height as needed)
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 20), // Set horizontal padding
                          child: Text(
                            fileName.replaceAll('.pdf', ''), // Display file name without extension
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )


                    );
                  },
                );
              }
            },
          ),
        ),
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
      body: Container(
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
    );
  }


}

