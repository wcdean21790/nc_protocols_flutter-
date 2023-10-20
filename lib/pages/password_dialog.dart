import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:n_c_protocols/globals.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Enter password'),
        ),
        body: PasswordDialog(),
      ),
    );
  }
}

class PasswordDialog extends StatefulWidget {
  @override
  _PasswordDialogState createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.reference().child("NC_Protocols").child(GlobalVariables.globalAgencyName);

  Future<void> checkPasswordAndPrintData() async {
    final snapshot = await _databaseRef.get();

    if (snapshot.exists) {
      final data = snapshot.value.toString(); // Convert Firebase data to string
      final enteredPassword = _passwordController.text;

      if (enteredPassword == data) {
        // Passwords match, call the Downloadprotocols() function
        Navigator.of(context).pop(true); // Close dialog wi
      } else {
        // Passwords don't match
        print('Password does not match.');
      }
    } else {
      print('No data available.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enter password to download'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Password'),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  checkPasswordAndPrintData();
                },
                child: Text('Enter'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the AlertDialog
                },
                child: Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
