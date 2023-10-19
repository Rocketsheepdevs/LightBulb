import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lightbulb/screens/HomeScreen.dart';
import 'package:lightbulb/screens/LoginPage.dart';

class CheckAuth extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _auth.authStateChanges().first,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while checking auth status
        } else {
          if (snapshot.hasData) {
            // User is already authenticated
            return HomeScreen();
          } else {
            // User is not authenticated, show sign-in screen
            return LoginPage();
          }
        }
      },
    );
  }
}
