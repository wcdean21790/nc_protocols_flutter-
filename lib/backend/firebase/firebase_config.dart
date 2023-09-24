import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAaXqubgz5bF_J3siUOPyPTgCiu9gDPkUE",
            authDomain: "ncprotocols-661da.firebaseapp.com",
            projectId: "ncprotocols-661da",
            storageBucket: "ncprotocols-661da.appspot.com",
            messagingSenderId: "860169251888",
            appId: "1:860169251888:web:7374eaa009528db2f251f5",
            measurementId: "G-7H7W80P128"));
  } else {
    await Firebase.initializeApp();
  }
}
