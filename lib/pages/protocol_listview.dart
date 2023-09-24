import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

class ProtocolListViewWidget extends StatefulWidget {
  final String agencyName;

  const ProtocolListViewWidget({Key? key, required this.agencyName})
      : super(key: key);

  @override
  _ProtocolListViewWidgetState createState() =>
      _ProtocolListViewWidgetState();
}

class _ProtocolListViewWidgetState extends State<ProtocolListViewWidget> {
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

  const SubfolderContentsPage({
    required this.agencyName,
    required this.subfolderName,
  });

  Future<List<File>> fetchPDFFiles() async {
    final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    final subfolderDirectory =
    Directory('${appDocumentsDirectory.path}/${agencyName}/$subfolderName');

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
        title: Text('Contents of $subfolderName'),
      ),
      body: FutureBuilder<List<File>>(
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
                return ListTile(
                  title: Text(pdfFile.path),
                  onTap: () {
                    // Open the selected PDF file
                    // You can navigate to a PDF viewer here
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
