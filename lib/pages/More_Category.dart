import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_pdfview/flutter_pdfview.dart';

class MoreListViewWidget extends StatefulWidget {
  final String agencyName;

  const MoreListViewWidget({Key? key, required this.agencyName})
      : super(key: key);

  @override
  _MoreListViewWidgetState createState() => _MoreListViewWidgetState();
}

class _MoreListViewWidgetState extends State<MoreListViewWidget> {
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
    Directory('${appDocumentsDirectory.path}/${widget.agencyName}/More');

    if (await agencyDirectory.exists()) {
      final subdirectories = await agencyDirectory.list().toList();

      final sortedSubfolderNames = subdirectories
          .where((subdir) => subdir is Directory)
          .map((subdir) => p.basename(subdir.path))
          .toList()
        ..sort();

      setState(() {
        subfolderNames = sortedSubfolderNames;
        isFavoriteList =
            List.generate(subfolderNames.length, (index) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.grey],
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
                color: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: ListView.builder(
                    itemCount: subfolderNames.length,
                    itemBuilder: (context, index) {
                      final subfolderName = subfolderNames[index];
                      return Column(
                        children: [
                          SizedBox(
                            width: 250,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SubfolderContentsPage(
                                      agencyName: widget.agencyName,
                                      subfolderName: subfolderName,
                                    ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubfolderContentsPage extends StatefulWidget {
  final String agencyName;
  final String subfolderName;

  SubfolderContentsPage({
    required this.agencyName,
    required this.subfolderName,
  });

  @override
  _SubfolderContentsPageState createState() => _SubfolderContentsPageState();
}

class _SubfolderContentsPageState extends State<SubfolderContentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.subfolderName,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.grey],
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
                color: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: FutureBuilder<List<File>>(
                    future: fetchPDFFiles(widget.agencyName, widget.subfolderName),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No PDF files in this subfolder.'));
                      } else {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 25),
                          child: ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              final pdfFile = snapshot.data![index];
                              final fileName = pdfFile.path.split('/').last;

                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 25),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PDFViewerWidget(
                                            pdfFilePath: pdfFile.path,
                                            pdfFileName: fileName.replaceAll('.pdf', ''),
                                          ),
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
                                      minimumSize: MaterialStateProperty.all(Size(50, 40)),
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
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
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
          ],
        ),
      ),
    );
  }

  Future<List<File>> fetchPDFFiles(String agencyName, String subfolderName) async {
    final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    final subfolderDirectory = Directory('${appDocumentsDirectory.path}/$agencyName/More/$subfolderName');

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
          ),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: PDFView(
                filePath: pdfFilePath,
                enableSwipe: true,
                swipeHorizontal: false,
                autoSpacing: false,
                pageFling: false,
                onRender: (pages) {},
                onError: (error) {
                  print(error);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MoreListViewWidget(agencyName: 'YourAgencyName'), // Replace 'YourAgencyName' with your agency name
  ));
}
