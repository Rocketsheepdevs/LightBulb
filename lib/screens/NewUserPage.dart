import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NewUserPage(),
    );
  }
}

class NewUserPage extends StatefulWidget {
  @override
  _NewUserPageState createState() => _NewUserPageState();
}

class _NewUserPageState extends State<NewUserPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String gender = 'Male'; // Default gender
  DateTime? selectedDate;
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ))!;
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _saveUser() async {
    if (usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        nameController.text.isNotEmpty) {
      try {
        // Create the user in Firebase Authentication
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: usernameController.text,
          password: passwordController.text,
        );

        // Generate a UID for the user
        String uid = userCredential.user?.uid ?? '';

        // Add user data to Firestore using the generated UID
        await _usersCollection.doc(uid).set({
          'username': usernameController.text,
          'name': nameController.text,
          'gender': gender,
          'birthday': selectedDate?.toIso8601String() ??
              DateTime.now().toIso8601String(),
          'uid': uid,
        });

        // Clear text controllers after user creation
        usernameController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
        nameController.clear();
      } catch (e) {
        // Handle registration errors
        print('Error during user registration: $e');
        // You can display an error message to the user here
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirm Password'),
            ),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            Row(
              children: [
                Text('Gender:'),
                Radio(
                  value: 'Male',
                  groupValue: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value.toString();
                    });
                  },
                ),
                Text('Male'),
                Radio(
                  value: 'Female',
                  groupValue: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value.toString();
                    });
                  },
                ),
                Text('Female'),
              ],
            ),
            Row(
              children: [
                Text('Birthday:'),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Select Date'),
                ),
                SizedBox(width: 10),
                Text(selectedDate != null
                    ? "${selectedDate!.toLocal()}".split(' ')[0]
                    : 'No Date Selected'),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUser,
              child: Text('Create User'),
            ),
          ],
        ),
      ),
    );
  }
}
