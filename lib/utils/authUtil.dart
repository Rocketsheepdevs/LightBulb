import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthFirebase {
  FirebaseAuth auth = FirebaseAuth.instance;

  // Example of signing in with email and password
  UserCredential userCredential = await auth.signInWithEmailAndPassword(
    email: 'email@example.com',
    password: 'password',
  );

  User user = userCredential.user;
  print('User signed in: ${user.uid}');
}
