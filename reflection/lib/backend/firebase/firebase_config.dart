import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBnBtUnRvudQb4ePTajgD3y-HxXOkhY3vQ",
            authDomain: "reflection-bda9a.firebaseapp.com",
            projectId: "reflection-bda9a",
            storageBucket: "reflection-bda9a.firebasestorage.app",
            messagingSenderId: "388271272219",
            appId: "1:388271272219:web:cbfab097265d6b3e72e3be",
            measurementId: "G-MCB184H742"));
  } else {
    await Firebase.initializeApp();
  }
}
