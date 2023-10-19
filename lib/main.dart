import 'package:flutter/material.dart';
import 'package:lightbulb/screens/CheckAuthScreen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: FirebaseOptions(
      apiKey: "AIzaSyCKdft_mTWm87eJtdysQDL7AoxHJ1gnkjU",
      appId: "1:194400046349:web:760a46a4990771e781f444",
      messagingSenderId: "194400046349",
      projectId: "lightbulb-60abb",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      ///When the application start check first if user already signin
      home: CheckAuth(),
    );
  }
}
